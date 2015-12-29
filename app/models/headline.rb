class Headline < ActiveRecord::Base
  belongs_to :site
  belongs_to :snapshot
end
