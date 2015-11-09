class LinkersController < ApplicationController

	include ApplicationHelper

	def index
	end

	def ping

		respond_to do |format|

			format.json {

				begin

					uri = URI(params[:url_string])
					res = Net::HTTP.get_response(uri)

					case res
					when Net::HTTPRedirection
						# If redirected, find the final destination URL
						final_redir = get_final_redirect(res['location'])
						if params[:search_term] != ""
							render json: [res.code, res.message, final_redir, res.body.include?(params[:search_term]).to_s].to_json
						else
							render json: [res.code, res.message, final_redir, ""].to_json
						end
					else
						if params[:search_term] != ""
							render json: [res.code, res.message, "", res.body.include?(params[:search_term]).to_s].to_json
						else
							render json: [res.code, res.message, "", ""].to_json
						end
					end

					# Un-comment the below "sleep" method in order to enable a 1-second pause between pings
					# sleep 1

				# In case of error...
				rescue

					render json: ["", "Couldn't ping", "", ""].to_json

				end

			}

		end

	end

end
