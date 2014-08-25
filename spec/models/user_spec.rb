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

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
