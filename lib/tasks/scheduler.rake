desc "This task takes regular screenshots and saves them to S3"
task :create_screenshot => :environment do

  require 'capybara/poltergeist'
  include Capybara::DSL

  sites_list = [['wapo', 'https://www.washingtonpost.com/'],['nyt','http://www.nytimes.com/']]

  sites_list.each do |page|

    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist

    Capybara.register_driver :poltergeist do |app|
      options = {
        :js_errors => false,
        :timeout => 60,
        :debug => false,
        :window_size => [1024,768]
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    session = Capybara::Session.new(:poltergeist)

		session.driver.headers = { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' }
		session.visit page[1]       # go to a web page (first request will take a bit)

    session.execute_script('function loopWithDelay() { setTimeout(function () { if (document.body.scrollTop > 1024) { window.scrollBy(0,-1024); loopWithDelay(); } else { window.scrollTo(0,0); return; } },1000); }; window.scrollTo(0,document.body.scrollHeight); loopWithDelay();')

    sleep 10

		s3 = Aws::S3::Resource.new
		bucket = s3.bucket('jaypinho-frontpages')
		obj = bucket.object("#{page[0]}-#{ Time.now.to_i }.png")
		obj.put(body: Base64.decode64(session.driver.render_base64(:png, full: true)))
		obj.etag

    session.driver.quit

  end

end
