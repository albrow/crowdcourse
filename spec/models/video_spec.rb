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

require 'spec_helper'

describe Video do
  pending "add some examples to (or delete) #{__FILE__}"
end
