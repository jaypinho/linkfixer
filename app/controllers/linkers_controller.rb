class LinkersController < ApplicationController

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
						final_redir = Automator.get_final_redirect(res['location'])
						if params[:search_term] != ""

							uri = URI(final_redir)
							res = Net::HTTP.get_response(uri)

							term_found = Automator.check_for_tag_fires(params[:search_term], final_redir) if params[:include_dynamic_tags] == "true"
							term_found = true if res.body.downcase.include?(params[:search_term].downcase)

							render json: [res.code, res.message, final_redir, term_found.to_s].to_json
						else
							render json: [res.code, res.message, final_redir, ""].to_json
						end
					else
						if params[:search_term] != ""

							term_found = Automator.check_for_tag_fires(params[:search_term], params[:url_string]) if params[:include_dynamic_tags] == "true"
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

end
