class Headline < ActiveRecord::Base
  belongs_to :site, through: :story
  belongs_to :snapshot
  belongs_to :story
end
