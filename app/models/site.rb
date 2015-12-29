class Site < ActiveRecord::Base
  has_many :snapshots, :headlines
end
