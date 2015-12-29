class SnapshotsController < ApplicationController

	respond_to :json

	def index

		@snapshots = Snapshot.all
		render json: @snapshots

	end

end
