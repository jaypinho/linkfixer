class SitesController < ApplicationController

	respond_to :json

	def index

		@sites = Site.all
		render json: {sites: @sites}

	end

end
