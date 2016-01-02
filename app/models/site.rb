class Site < ActiveRecord::Base
  has_many :snapshots
  has_many :headlines
  has_many :stories
end
