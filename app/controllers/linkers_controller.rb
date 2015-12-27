class LinkersController < ApplicationController

	require 'capybara/poltergeist'

	include ApplicationHelper
	include Capybara::DSL

	def index
	end

	def ping

		respond_to do |format|

			format.json {

				# begin

					uri = URI(params[:url_string])
					res = Net::HTTP.get_response(uri)
					term_found = false

					case res
					when Net::HTTPRedirection
						# If redirected, find the final destination URL
						final_redir = get_final_redirect(res['location'])
						if params[:search_term] != ""

							term_found = check_for_search_term(params[:search_term], final_redir) if params[:include_dynamic_tags] == "true"
							term_found = true if res.body.downcase.include?(params[:search_term].downcase)

							render json: [res.code, res.message, final_redir, term_found.to_s].to_json
						else
							render json: [res.code, res.message, final_redir, ""].to_json
						end
					else
						if params[:search_term] != ""

							term_found = check_for_search_term(params[:search_term], params[:url_string]) if params[:include_dynamic_tags] == "true"
							term_found = true if res.body.downcase.include?(params[:search_term].downcase)

							render json: [res.code, res.message, "", term_found.to_s].to_json
						else
							render json: [res.code, res.message, "", ""].to_json
						end
					end

					# Un-comment the below "sleep" method in order to enable a 1-second pause between pings
					# sleep 1

				# In case of error...
				# rescue

					# render json: ["", "Couldn't ping", "", ""].to_json

				# end

			}

		end

	end

	private

	def check_for_search_term term, url_addr

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

		s3 = Aws::S3::Resource.new
		bucket = s3.bucket('jaypinho-frontpages')
		obj = bucket.object("example-#{ Time.now.to_i }.png")
		obj.put(body: Base64.decode64(session.driver.render_base64(:png, full: true)))
		obj.etag

		# session.save_screenshot("example#{ 1 + rand(1000)}.png", :full => true)
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

end
