# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  full_name              :string(255)
#  points                 :integer         default(0)
#  avg_quiz_score         :integer
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  email                  :string(255)     default(""), not null
#  username               :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  description            :text
#  provider               :string(255)
#  uid                    :string(255)
#  oauth_token            :string(255)
#  oauth_expires_at       :datetime
#  user_id                :integer
#  accept_donations       :boolean         default(FALSE)
#  show_email             :boolean         default(FALSE)
#  show_full_name         :boolean         default(FALSE)
#  show_profile           :boolean         default(TRUE)
#  show_activity          :boolean         default(TRUE)
#  show_videos_made       :boolean         default(TRUE)
#  show_stats             :boolean         default(TRUE)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable, :authentication_keys => [:login]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :full_name, :points, :avg_quiz_score, :description
  attr_accessible :created_at, :updated_at
  attr_accessible :enrollments_attributes, :badge_earnings_attributes
  attr_accessible :oauth_token, :oauth_expires_at, :uid, :provider
  attr_accessible :is_bot

  # Accsessibles for boolean settings
  attr_accessible :accept_donations, :show_email, :show_full_name, :show_profile
  attr_accessible :show_activity, :show_videos_made, :show_stats

  attr_accessor :login
  attr_accessible :login

  attr_accessor :email_changed
  attr_accessible :email_changed



  # -------- Associations ---------
  has_many :videos_made, class_name: "Video", foreign_key: "creator_id"
  has_many :video_views, foreign_key: "viewer_id"
  has_many :videos_viewed, through: :video_views, source: :video, foreign_key: "viewer_id"
  has_many :quiz_scores
  has_many :quizzes_taken, :through => :quiz_scores, :source => :quiz
  has_many :enrollments
  has_many :courses, :through => :enrollments
  has_many :badge_earnings
  has_many :badges, :through => :badge_earnings
  has_many :comments
  has_many :videos_commented_on, :through => :comments, :source => :video
  has_many :quizzes_commented_on, :through => :comments, :source => :quiz
  has_many :video_ratings, foreign_key: "rater_id"
  has_many :videos_rated, through: :video_ratings, source: :video, foreign_key: "rater_id"
  has_many :flags
  has_many :activities
  has_one  :settings

  has_and_belongs_to_many :courses_maintained,
          :join_table => "courses_maintainers", :foreign_key => "maintainer_id", :class_name => "Course" 

  accepts_nested_attributes_for :enrollments, :badge_earnings, :settings

	# to ensure emails are truly unique 
	# (emails are not case sensitive, so Foo@bar.com should = foo@bar.com)
  #before_save { |user| user.email = email.downcase }

	## validations...
  validates :username, presence: true, length: {maximum: 25}, uniqueness: true
  validates_format_of :username, :with => /^[A-Za-z\d_.*]+$/, :message => "can only contain a-z, 0-9, dots ( . ), or underscores ( _ )"
  # validates :full_name, length: {maximum: 50}
  # validates :password_confirmation, presence: true
  
  # called after the account is first created
  def account_created
    
    # check if this activiy has already been created
    if !self.activities.where(:kind => "created_account").blank?
      puts "WARNING: user ##{self.id} already has a created account activity!"
      return
    end

    # update points
    self.points += 50
    self.save

    # create activity
    act = self.activities.new
    act.kind = "created_account"
    act.created_at = self.created_at
    act.save

  end

  def confirm!
    super
    account_created
  end

  ## override devise's method to allow username or email login
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.bots
    self.where(:is_bot => true)
  end

  ## ---- search and scopes
  include PgSearch
  multisearchable :against => [:username]

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.full_name = auth.info.name
      user.username = auth.info.nickname
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.top_users limit=5
    order("points DESC").limit(limit)
  end

  def self.all_usernames
    all.collect do |u|
      u.username
    end
  end

  def password_required?
    super && self.standard_account?
  end

  def confirmation_required?
    if self.facebook_account?
      account_created
    end
    super && (self.standard_account? || self.email_changed)
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def facebook_account?
    return !self.provider.blank?
  end

  def standard_account?
    return !self.encrypted_password.blank?
  end

  def merged_account?
    # merged accounts can login either with facebook or email
    return (!self.provider.blank? && !self.encrypted_password.blank?)
  end

  def update_oauth_token(auth)
    self.oauth_token = auth.credentials.token
    self.oauth_expires_at = Time.at(auth.credentials.expires_at)
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(self.oauth_token)
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end

  def facebook_picture_url(options = {:size => "square"})
    raise "User did not sign in with facebook!" if !self.facebook_account?
    self.facebook.get_picture(self.uid, :type => options[:size])
  end

  def recent_activity limit=15
    self.activities.find(:all, :order => "created_at DESC", :limit => limit)
  end

  def shortened_email desired_length = 22
    # if needed we want to truncate the email but leave the host name
    # e.g.: stephena...@gmail.com
    return "" if email.nil?
    if email.length > desired_length
      # split the email into two parts
      parts = email.split("@")
      name = parts.first
      host = parts.last
      name = name.truncate(desired_length - host.length - 1) # 1 extra spaces for @ symbol
      return name + "@" + host
    else
      return email
    end
  end

  def shortened_full_name desired_length = 22
    # we want to truncate the name if needed
    # we'll get the first initial and full last name
    # if that's still to long, we truncate the last name
    # e.g.: A. Browne    or   J. Bumgardn...
    return "" if full_name.nil?
    if full_name.length > desired_length
      # split the name by empty spaces
      parts = full_name.split(" ")
      first_name = parts.first
      last_name = parts.last
      first_name = first_name[0] + "."
      last_name = last_name.truncate(desired_length - 2)
      return first_name + " " + last_name
    else
      return full_name
    end
  end

  # a simple test method 
  # (currently I'm using it to test the worker dyno and delayed_job)
  def scream
    puts "MY NAME IS #{self.username}!"
  end

  def has_watched?(video_id)
    result = self.video_views.where(:video_id => video_id, :finished => true).limit(1)
    return false if result.blank?
    return true
  end


  #########

  # ---- TRANSFERS -----

  # There are four types:

  #   1. current* -> facebook = transfer_to_facebook_account
  #   2. current* -> standard = transfer_to_standard_account
  #   3. facebook* -> current = transfer_from_facebook_account
  #   4. standard* -> current = transfer_from_standard_account

  #           (*) = old user, i.e. will be destroyed

  # In any instance, the account which is being merged into will be retained
  # The account which will be retained is called the new_user
  # The account which will be destroyed is called the old_user

  #########

  def transfer_to_facebook_account(facebook_user_id)

    # current account (old) -> facebook account (new)
    # current is destroyed
    # current account must be standard account

    old_user = self
    new_user = User.find(facebook_user_id)

    # the current user (old_user) should be a standard account (log in with email/password)
    raise "Current user (the one which will be destroyed) is not a standard account!" if !old_user.standard_account?

    # the new user should be a facebook-authenticated account
    raise "New user (the one to be merged to and retained) is not a facebook account!" if !new_user.facebook_account?

    transfer_account :old => old_user, :new => new_user

  end

  def transfer_to_standard_account(standard_user_id)

    # current account (old) -> standard account (new)
    # current is destroyed
    # current account must be facebook account

    old_user = self
    new_user = User.find(standard_user_id)

    # the current user (old_user) should be a facebook-authenticated account
    raise "Current user (the one which will be destroyed) is not a facebook account!" if !old_user.facebook_account?

    # the new user (one to be transfered to and retained) should be a standard account
    raise "New user (the one to transfer to) is not a standard account!" if !new_user.standard_account?

    transfer_account :old => old_user, :new => new_user

  end

  def transfer_from_facebook_account(facebook_user_id)

    # facebook account (old) -> current account (new)
    # old facebook account will be destroyed
    # current account must be standard account
    
    old_user = User.find(facebook_user_id)
    new_user = self

    # old_user should be a facebook account
    raise "Old user (the one which will be destroyed) is not a facebook account!" if !old_user.facebook_account?

    # check if the old user is a standard account
    raise "Current user (new_user, will be retained) is not a standard account!" if !new_user.standard_account?

    transfer_account :old => old_user, :new => new_user

  end

  def transfer_from_standard_account(standard_user_id)

    # standard account (old) -> current account (new)
    # old standard account will be destroyed
    # current account must be facebook account

    old_user = User.find(standard_user_id)
    new_user = self

    # check if the old user is a standard account (log in with email/password)
    raise "Old user (will be destroyed) is not a standard account!" if !old_user.standard_account?

    # check if the new user signed in with a facebook account
    raise "Current user (new user; will be retained) is not a facebook account!" if !new_user.facebook_account?

    transfer_account :old => old_user, :new => new_user

  end

  def transfer_account(hash)

    old_user = hash[:old]
    new_user = hash[:new]

    # update attributes
    new_user.provider ||= old_user.provider
    new_user.uid ||= old_user.uid
    new_user.email ||= old_user.email
    new_user.username ||= old_user.username
    new_user.full_name = old_user.full_name if (new_user.full_name.nil? || new_user.full_name.blank?)
    new_user.description = old_user.description if (new_user.description.nil? || new_user.description.blank?)
    new_user.points += old_user.points
    new_user.created_at = old_user.created_at

    # update associations
    new_user.videos_made << old_user.videos_made
    new_user.video_views << old_user.video_views
    new_user.quiz_scores << old_user.quiz_scores
    new_user.quizzes_taken << old_user.quizzes_taken
    new_user.enrollments << old_user.enrollments
    new_user.enrollments.uniq! # remove duplicates
    new_user.courses << old_user.courses
    new_user.courses.uniq! # remove duplicates
    new_user.badge_earnings << old_user.badge_earnings
    new_user.badge_earnings.uniq! # remove duplicates
    new_user.badges << old_user.badges
    new_user.badges.uniq! # remove duplicates
    new_user.comments << old_user.comments
    new_user.videos_commented_on << old_user.videos_commented_on
    new_user.videos_commented_on.uniq!
    new_user.quizzes_commented_on << old_user.quizzes_commented_on
    new_user.quizzes_commented_on.uniq!
    new_user.video_ratings << old_user.video_ratings
    new_user.video_ratings.uniq!
    new_user.videos_rated << old_user.videos_rated
    new_user.videos_rated.uniq!
    new_user.flags << old_user.flags

    old_user.activities.each do |old_act|
      new_act = Activity.new
      new_act.data = old_act.decoded_data
      new_act.kind = old_act.kind
      new_act.created_at = old_act.created_at
      new_act.updated_at = old_act.updated_at
      new_user.activities << new_act
      new_act.save
    end

    # destroy old user
    old_user.destroy

    # save new_user
    new_user.save

  end
    
end








