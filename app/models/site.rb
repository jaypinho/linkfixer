class Site < ActiveRecord::Base
  has_many :snapshots
  has_many :headlines

  def as_json(options={})
      super(:root => true)
  end

end
