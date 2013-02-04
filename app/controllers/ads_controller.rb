class AdsController < ApplicationController
  respond_to :js

  def index
    render js: jsonp(ads: Ad.page, total_count: 100)
  end
end
