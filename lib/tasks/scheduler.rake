desc "This task takes screenshots of newspaper front pages and saves them to S3"
task :create_screenshots => :environment do

  sites_list = {
    'wapo' => 'https://www.washingtonpost.com/',
    'nyt' => 'http://www.nytimes.com/',
    'usatoday' => 'http://www.usatoday.com/',
    'wsj' => 'http://www.wsj.com/'
  }

  Automator.create_screenshot sites_list

end
