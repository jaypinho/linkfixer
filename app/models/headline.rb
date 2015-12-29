class Headline < ActiveRecord::Base
  belongs_to :site, :snapshot
end
