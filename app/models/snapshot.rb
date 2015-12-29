class Snapshot < ActiveRecord::Base
  belongs_to :site
  has_many :headlines

  def file_path
    ENV['S3_FILE_PREFIX'] + filename
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
