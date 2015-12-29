class SnapshotsController < ApplicationController

	respond_to :json

	def index

		@snapshots = Snapshot.all
		render :json => @snapshots, :include => {:site => {:only => :name}}

	end

end
