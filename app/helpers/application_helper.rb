module ApplicationHelper

	require 'net/http'

	# This method gets the final redirect of a given URL, up to a maximum of 5 successive redirects (which can be changed to any other number)
	def get_final_redirect(page_url, limit = 5)

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

end
