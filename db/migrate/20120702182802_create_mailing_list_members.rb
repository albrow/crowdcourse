class CreateMailingListMembers < ActiveRecord::Migration
  def change
    create_table :mailing_list_members do |t|
			t.string :email
			t.date :last_sent
      t.timestamps
    end
  end
end
