desc "This task takes screenshots of newspaper front pages and saves them to S3"
task :create_screenshots => :environment do

  sites_list = {
  #  'wapo' => 'https://www.washingtonpost.com/',
  'nyt' => 'http://www.nytimes.com/'
  #  'usatoday' => 'http://www.usatoday.com/',
  #  'wsj' => 'http://www.wsj.com/'
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
    Automator.aggregate_headlines_and_take_snapshot site
  end

end
