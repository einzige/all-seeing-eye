class ReviewRequestsController < ApplicationController

  def index
    @requests = ReviewRequest.all
  end

  def show
    @request = RequestPresenter.new(ReviewRequest.find(params[:id]))
  end
end