class Snapshot < ActiveRecord::Base
  belongs_to :site
  has_many :headlines

  def file_path
    # gsub is required due to Amazon S3 encoding glitch: https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1003633
    ENV['S3_FILE_PREFIX'] + filename.gsub("+", "%2B")
  end

  def as_json(options={})
      super(:methods => [:file_path],
            :include => {
              :site => {:only => [:name]}
            },
            :except => [:filename]
      )
    end

end
