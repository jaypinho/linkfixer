class Snapshot < ActiveRecord::Base
  belongs_to :site
  has_many :headlines
end
