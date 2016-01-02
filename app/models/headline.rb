class Headline < ActiveRecord::Base
  belongs_to :snapshot
  belongs_to :story
end
