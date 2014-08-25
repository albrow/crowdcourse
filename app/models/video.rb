# == Schema Information
#
# Table name: videos
#
#  id              :integer         not null, primary key
#  component_id    :integer
#  creator_id      :integer
#  flags_count     :integer
#  duration        :integer
#  avg_quiz_score  :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  visible         :boolean         default(TRUE)
#  embed_url       :string(255)
#  ready           :boolean         default(FALSE)
#  s3_key          :string(255)
#  thumbnail_ready :boolean         default(FALSE)
#  avg_rating      :float
#  source          :string(255)
#  hosted          :boolean
#

class Video < ActiveRecord::Base
  attr_accessible :source, :hosted, :creator, :embed_url, :ready, :duration, :avg_rating
  attr_accessible :avg_quiz_score, :visible, :created_at, :updated_at, :thumbnail_ready
  attr_accessible :s3_key
  attr_accessible :component_id, :creator_id

  ## Associations
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  belongs_to :component
  has_many :comments
  has_many :users_commented, through: :comments, source: :user
  has_many :views, class_name: "VideoView"
  has_many :viewers, through: :views, source: :viewer, class_name: "User"
  has_many :ratings, class_name: "VideoRating"
  has_many :raters, through: :ratings, class_name: "User", source: :rater
  has_many :flags
  has_many :quiz_scores # used to help with rating

  scope :visible, where(:visible => true)
  scope :ready, where(:ready => true)
  
  def self.top_rated (limit=5)
    ## ideally this could be better...
    top = where(:visible => true, :ready => true).where("avg_rating IS NOT NULL").order("avg_rating DESC, num_ratings DESC").limit(limit)
    top += where(:visible => true, :ready => true).where("avg_rating IS NULL").limit(limit - top.size)
  end

  def self.newest (limit=5)
    where(:visible => true, :ready => true).order("created_at DESC").limit(limit)
  end

  def youtube_id

    raise "tried to get youtube id of a non-youtube video" if source != "youtube"

    # we assume that the url is one of two forms
    # http://www.youtube.com/watch?v=YW8p8JO2hQw
    # or 
    # http://youtu.be/YW8p8JO2hQw
    # there might also be other paramaters
    # like http://www.youtube.com/watch?v=gaWvjcwigTg&feature=b-vrec
    # this code adn the regex (hopefully) covers all those cases

    # remove extra parameters
    yt_id = embed_url.split("&").first;
    # get the string that comes after the last / or =
    yt_id.split(/=|\//).last;
  end

  def vimeo_id
    raise "tried to get vimeo id of a non-vimeo video" if source != "vimeo"

    # we assume that the url is one of two forms
    # https://vimeo.com/51216254
    # or 
    # http://player.vimeo.com/video/51216254
    # there might also be paramaters appended to the url
    # this code (hopefully) covers all those cases
    
    # remove any parameters
    vim_id = embed_url.split("?").first
    # get the string that represents the id
    vim_id = embed_url.split("/").last
  end

  def self.create_from_url params
    vid = Video.new params
  end

  def upload
    
    puts "--- --- Beginning video upload to vimeo! --- ---\n
          --- video_id: #{self.id}"

    user = self.creator

    if !self.has_been_uploaded?
      
    
      # Access config vars defined in config/config.yml: APP_CONFIG['key']
      c_key = APP_CONFIG['vimeo_consumer_key']
      c_sec = APP_CONFIG['vimeo_consumer_secret']
      a_key = APP_CONFIG['vimeo_access_token']
      a_secret = APP_CONFIG['vimeo_access_secret']

      # initialize some Vimeo classes (these are defined in the gem)
      begin
        vimeo_upload = Vimeo::Advanced::Upload.new(c_key, c_sec, :token => a_key, :secret => a_secret)
        vimeo_video = Vimeo::Advanced::Video.new(c_key, c_sec, :token => a_key, :secret => a_secret)
      rescue
        # TODO: respond to an error
        raise "something went wrong"
        return
      end

      # do the upload

      # retrieve the file from s3 and store it in a temp
      s3_config = YAML::load(File.open("#{Rails.root}/config/amazon_s3.yml"))
      bucket_name = s3_config[Rails.env]["bucket"]
      s3 = AWS::S3.new
      bucket = s3.buckets[bucket_name]
      s3_object = bucket.objects[self.s3_key]
      temp = Tempfile.new("temp")
      temp.binmode
      temp.write(s3_object.read)

      begin
        response = vimeo_upload.upload(temp)
      rescue
        # TODO: respond to an error
        raise "something went wrong."
        return
      end

      # remove the tempfile to save memory
      temp.close!

      # remove the file from s3 to save storage space
      s3_object.delete

      # If we've reached this point, the video was uploaded to vimeo. So, continue...
      
      
      vimeo_video_id = response['ticket']['video_id']

      # change the title
      vimeo_video.set_title(vimeo_video_id, "#{self.component.name} ##{self.id} by #{user.username}")

      self.embed_url = "http://player.vimeo.com/video/#{vimeo_video_id}"
      self.save
    else
      puts "WARNING: the video was already on vimeo. Continuing..."
    end

    # Update some statistics in the database...
    user.videos_made << self

    # !! TODO: add other information to the video object.
    # !! TODO: get the thumbnail from vimeo and save it on our database

    self.save
  
    # # add to the user's points
    user.points += 25
    user.save

    # # create an activity for the user's page
    act = user.activities.build
    act.kind = "created_video"
    act.data = {:video_id => self.id}
    act.save


    puts "--- --- Finished uploading video to vimeo!\n
          --- video.id = #{self.id}\n
          --- vimeo_id = #{self.vimeo_id}"

  end

  def has_been_uploaded?
    # if the embed_url is non-nil, then that means its already been uploaded to vimeo
    return !self.embed_url.blank?
  end

  def is_ready? ## so named in order to keep it separate from the ready attribute

    if self.ready || !hosted
      return true
    elsif !self.visible?
      return false
    else
      result = self.check_ready
      if result
        self.update_attributes :ready => true
        ## send a message to the creator
        VideoMailer.video_ready(self.id).deliver
        return true
      else
        return false
      end
    end
  end

  def delayed_check_ready

    raise "ERROR: attempted to check readiness of non-hosted video!" if !hosted
    
    puts "-- -- Checking if video ##{self.id} is ready..."

    return false if !self.visible?

    if self.ready
      puts "-- video ##{self.id} WAS ALREADY ready."
    else

      result = self.check_ready

      if result
        self.ready = true
        self.save
        ## send a message to the creator
        VideoMailer.video_ready(self.id).deliver

        puts "-- video ##{self.id} IS now ready. Message sent!"
      else
        self.ready = false
        self.save
        puts "-- video ##{self.id} is NOT ready. Trying again in 3 min."
        self.delayed_check_ready
      end
    end
    
  end

  def check_ready
    
    raise "ERROR: attempted to check readiness of non-hosted video!" if !hosted

    return false if !self.visible?
    return false if !self.has_been_uploaded?

    return true if self.ready

    # Access config vars defined in config/config.yml: APP_CONFIG['key']
    c_key = APP_CONFIG['vimeo_consumer_key']
    c_sec = APP_CONFIG['vimeo_consumer_secret']
    a_key = APP_CONFIG['vimeo_access_token']
    a_secret = APP_CONFIG['vimeo_access_secret']
    
    begin
      vimeo_video = Vimeo::Advanced::Video.new(c_key, c_sec, :token => a_key, :secret => a_secret)
    rescue
      puts "WARNING: could not connect to vimeo servers!"
    end

    vimeo_video_id = self.vimeo_id
    video_info = vimeo_video.get_info(vimeo_video_id)
    transcoding_val = video_info['video'][0]['is_transcoding']

    # if the video is not transcoding (val=0), then it is ready
    if transcoding_val == "0"
      # set the duration in our database
      puts "---- setting duration of video #{self.id}"
      self.duration = video_info["video"][0]["duration"].to_i
      self.save

      # call an update to the thumbnails
      self.update_thumbnails

      return true
    else 
      return false
    end
      
  end

  def update_duration

    puts "--- --- updating duration for video #{self.id} "

    if source == "vimeo"

      c_key = APP_CONFIG['vimeo_consumer_key']
      c_sec = APP_CONFIG['vimeo_consumer_secret']
      a_key = APP_CONFIG['vimeo_access_token']
      a_secret = APP_CONFIG['vimeo_access_secret']
      
      begin
        vimeo_video = Vimeo::Advanced::Video.new(c_key, c_sec, :token => a_key, :secret => a_secret)
      rescue
        puts "WARNING: could not connect to vimeo servers!"
      end

      vimeo_video_id = self.vimeo_id
      video_info = vimeo_video.get_info(vimeo_video_id)
      self.duration = video_info['video'][0]['duration'].to_i
      self.save

       puts "--- --- FINISHED updating duration for video #{self.id} "

    elsif source == "youtube"
      
      puts "TODO: get duration of youtube video"
      require "open-uri"
      # check out the url if you're curious about what the response looks like
      js = open("https://gdata.youtube.com/feeds/api/videos/#{self.youtube_id}?v=2.1&alt=json")
      response = ActiveSupport::JSON.decode(js)
      self.duration = response["entry"]["media$group"]["media$content"][0]["duration"]
      self.save

       puts "--- --- FINISHED updating duration for video #{self.id} "

    end


  end

  def update_thumbnails

    if source == "vimeo"

      # retrieve the thumbnails from vimeo and put them on s3
      # there are three thumbnail sizes: small, medium, and large
      
      puts "---- ----- --- Updating thumbnails for video ##{self.id}"
    
      # set up some config vars
      c_key = APP_CONFIG['vimeo_consumer_key']
      c_sec = APP_CONFIG['vimeo_consumer_secret']
      a_key = APP_CONFIG['vimeo_access_token']
      a_secret = APP_CONFIG['vimeo_access_secret']

      # initialize the vimeo class...
      vimeo_video = Vimeo::Advanced::Video.new(c_key, c_sec, :token => a_key, :secret => a_secret)

      vimeo_id = self.vimeo_id
      if vimeo_id.blank?
          raise "ERROR: there was a problem obtaining the vimeo_id of video ##{self.id}\n
                the embed_url is: #{self.embed_url}"
      end

      begin 
        result = vimeo_video.get_thumbnail_urls(vimeo_id)
      rescue
        if self.visible
          # we expected this to work, so throw an error and delayed_jobs will try it again
          raise "ERROR: could not get thumbnails from vimeo for video ##{self.id}.\n
              Will try again later."
        else
          # if the video is not visible, it has probably been removed from vimeo.
          # we wouldn't expect to be able to get the thumbnails, so we throw a warning
          # and move on.
          puts "WARNING: could not get thumbnails from vimeo for video ##{self.id}.\n
              Skipping thumbnail update for this video."
          return
        end
      end

      thumbnails = result["thumbnails"] # this is a hash of different-sized thumbnails

      small_url = thumbnails["thumbnail"][0]["_content"]
      medium_url = thumbnails["thumbnail"][1]["_content"]
      large_url = thumbnails["thumbnail"][2]["_content"]

      s3_config = YAML::load(File.open("#{Rails.root}/config/amazon_s3.yml"))
      bucket_name = s3_config[Rails.env]["bucket"]
      s3 = AWS::S3.new
      bucket = s3.buckets[bucket_name]

      small_key = "thumbnails/#{self.id}/small_75x100.jpg"
      medium_key = "thumbnails/#{self.id}/medium_150x200.jpg"
      large_key = "thumbnails/#{self.id}/large_360x640.jpg"


      ## one by one: download file. upload it to s3. close file.

      require "open-uri"

      begin
        small_file = open(small_url)
        small_s3_object = bucket.objects[small_key]
        small_s3_object.write(small_file.read, :acl => :public_read)
        small_file.close

        medium_file = open(medium_url)
        medium_s3_object = bucket.objects[medium_key]
        medium_s3_object.write(medium_file.read, :acl => :public_read)
        medium_file.close

        large_file = open(large_url)
        large_s3_object = bucket.objects[large_key]
        large_s3_object.write(large_file.read, :acl => :public_read)
        large_file.close
      rescue
        raise "ERROR: there was a problem connecting to Amazon S3.\n
                Could not upload thumbnails for video ##{self.id}.\n
                Will try again later."
      end
      
      puts "---- Finished updating thumbnails for video ##{self.id}"
      self.update_attributes :thumbnail_ready => true
    

    elsif source == "youtube"
      
      ## TODO: update thumbnails of the youtube video
      puts "TODO: update thumbnails of youtube video"

    end

  end


  def thumbnail (size = :medium)

    if source == "vimeo" && self.thumbnail_ready

      ## returns a cloudfront url for the thumbnail stored on s3
      # if the thumb isn't ready, returns the url for a placeholder image

      small_key = "thumbnails/#{self.id}/small_75x100.jpg"
      medium_key = "thumbnails/#{self.id}/medium_150x200.jpg"
      large_key = "thumbnails/#{self.id}/large_360x640.jpg"

      thumb = {}

      if size == :small
        url = APP_CONFIG['cloudfront_url'] + '/' + small_key
        thumb = {:url => url, :width => 100, :height => 75}
      elsif size == :medium
        url = APP_CONFIG['cloudfront_url'] + '/' + medium_key
        thumb = {:url => url, :width => 200, :height => 150}
      elsif size == :large
        url = APP_CONFIG['cloudfront_url'] + '/' + large_key
        thumb = {:url => url, :width => 640, :height => 360}
      end

      return thumb
    
    elsif source == "youtube"

      if size == :small
        url = "https://i.ytimg.com/vi/#{self.youtube_id}/default.jpg"
        thumb = {:url => url, :width => 100, :height => 75}
      elsif size == :medium
        url = "https://i.ytimg.com/vi/#{self.youtube_id}/mqdefault.jpg"
        thumb = {:url => url, :width => 200, :height => 150}
      elsif size == :large
        url = "https://i.ytimg.com/vi/#{self.youtube_id}/hqdefault.jpg"
        thumb = {:url => url, :width => 640, :height => 360}
      end

      return thumb

    else
      key = "thumbnails/placeholders/#{size}.png"
      url = APP_CONFIG['cloudfront_url'] + '/' + key

      width = 0
      height = 0

      if size == :small
        width = 100
        height = 75
      elsif size == :medium
        width = 200
        height = 150
      elsif size == :large
        width = 640
        height = 360
      end

      return thumb = {:url => url, :width => width, :height => height}
    
    end



    if source == "youtube"

      ## TODO: get thumbnails of the youtube video
      puts "TODO: get thumbnails of youtube video"

    end


  end

  def update_rating
    # update the avg_rating of the video (for speed this value is stored in db)
    self.update_attributes :avg_rating => VideoRating.where(:video_id => self.id).average("value")
  end



  #-----  Some methods should run asynchronously (via delayed_jobs)
  handle_asynchronously :update_thumbnails
  handle_asynchronously :update_duration
  handle_asynchronously :upload
  handle_asynchronously :delayed_check_ready, :run_at => Proc.new { 3.minutes.from_now }
  
end
