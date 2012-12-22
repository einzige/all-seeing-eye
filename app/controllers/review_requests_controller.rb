class ReviewRequestsController < ApplicationController

  def index
    @requests = ReviewRequest.all
  end

  def show
    @request = ReviewRequest.find(params[:id])
  end
end