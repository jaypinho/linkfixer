desc "This task takes screenshots of newspaper front pages and saves them to S3"
task :create_screenshots => :environment do

  sites_list = {
  #  'wapo' => 'https://www.washingtonpost.com/',
  #  'nyt' => 'http://www.nytimes.com/'
  #  'usatoday' => 'http://www.usatoday.com/',
  #  'wsj' => 'http://www.wsj.com/',
  'guardian' => 'http://www.theguardian.com/us'
  }

  Automator.create_screenshot sites_list, true

end

desc "This task outputs all headlines currently on the NYT home page"
task :get_nyt_headlines => :environment do
  # Automator.aggregate_headlines 'http://www.nytimes.com', '.story-heading'
  # Automator.aggregate_headlines 'http://www.wsj.com/', 'a.wsj-headline-link'
  Automator.aggregate_headlines 'https://www.washingtonpost.com/', 'a[data-pb-field="web_headline"]'
end

desc "This task saves all headlines and takes a snapshot on all the site home pages"
task :save_headlines_and_take_snapshot => :environment do

  sites = Site.all

  sites.each do |site|
    Automator.aggregate_headlines_and_take_snapshot site, true
  end

end

desc "This task tests thumbnail creation"
task :create_thumbnail => :environment do

  Automator.create_thumbnail "#{Rails.root.to_s}/capture.png"

end

desc "This task creates thumbnails for all screenshots without them"
task :generate_thumbnails => :environment do

  require 'rmagick'

  needs_thumbnails = Snapshot.where(:thumbnail => nil)

  needs_thumbnails.each do |pic|

    puts (ENV['S3_FILE_PREFIX'] + pic.filename)
    thumb = Magick::Image.read((ENV['S3_FILE_PREFIX'] + pic.filename.gsub("+", "%2B"))).first.resize_to_fill(300,300,Magick::NorthWestGravity).to_blob

    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(ENV['S3_BUCKET'])
    obj = bucket.object(("thumb-" + pic.filename))
    obj.put(body: thumb)
    obj.etag

    pic.thumbnail = ("thumb-" + pic.filename)
    pic.save

  end

end
