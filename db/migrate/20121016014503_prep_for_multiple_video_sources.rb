class PrepForMultipleVideoSources < ActiveRecord::Migration
   def up
   	remove_column :videos, :kind
   	add_column :videos, :source, :string
   	add_column :videos, :hosted, :boolean

   	# videos created before this time need to be updated
   	# to follow the new db schema
   	cutoff_date = Time.utc(2012, "oct", 11)
  	Video.all.each do |v|
      if v.created_at < cutoff_date
				v.hosted ||= true
				v.source ||= "vimeo"
				v.save
      end
  	end

  end

  def down

  	remove_column :videos, :hosted
		remove_column :videos, :source
  	add_column :videos, :kind, :string

  end
end
