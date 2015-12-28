module Automator

  require 'net/http'

  def self.create_screenshot sites_list

    sites_list.each do |title, url|

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
  		session.visit url       # go to a web page (first request will take a bit)

      session.execute_script('function loopWithDelay() { setTimeout(function () { if (document.body.scrollTop > 1024) { window.scrollBy(0,-1024); loopWithDelay(); } else { window.scrollTo(0,0); return; } },1000); }; window.scrollTo(0,document.body.scrollHeight); loopWithDelay();')

      sleep 10

  		s3 = Aws::S3::Resource.new
  		bucket = s3.bucket(ENV['S3_BUCKET'])
  		obj = bucket.object("#{title}-#{ Time.now.to_i }.png")
  		obj.put(body: Base64.decode64(session.driver.render_base64(:png, full: true)))
  		obj.etag

      session.driver.quit

    end


  end

  def self.check_for_tag_fires term, url_addr

    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist

    Capybara.register_driver :poltergeist do |app|
      options = {
        :js_errors => false,
        :timeout => 30,
        :debug => false,
        :window_size => [1024,768]
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    session = Capybara::Session.new(:poltergeist)

    session.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" }
    session.visit url_addr       # go to a web page (first request will take a bit)

    session.driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
        if response.url.downcase.include?(term.downcase)
          session.driver.quit
          return true
        end
      end
    end

    session.driver.quit
    return false

  end

  # This method gets the final redirect of a given URL, up to a maximum of 5 successive redirects (which can be changed to any other number)
	def self.get_final_redirect(page_url, limit = 5)

		raise ArgumentError, 'Too many HTTP redirects' if limit == 0

		begin

			res = Net::HTTP.get_response(URI(page_url))

			case res
			when Net::HTTPRedirection
				# Recursively calls the same method until we hit a non-redirected URL or reach 5 redirects
				get_final_redirect(res['location'], limit - 1)
			else
				page_url
			end

			# sleep 1

		rescue

			page_url

		end
	end

  def self.aggregate_headlines url_addr, selector

    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist

    Capybara.register_driver :poltergeist do |app|
      options = {
        :js_errors => false,
        :timeout => 30,
        :debug => false,
        :window_size => [1024,768]
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    session = Capybara::Session.new(:poltergeist)

    session.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" }
    session.visit url_addr       # go to a web page (first request will take a bit)

    headlines = session.all(:css, selector)

    headlines.each do |headline|
      puts headline.text
    end

    session.driver.quit

  end

end
