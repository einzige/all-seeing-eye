class AdsController < ApplicationController
  respond_to :js

  before_filter :load_category

  def index
    render js: jsonp(total_count: @category.ads.count,
                     ads:         @category.ads.paginate(page: params[:page], per_page: params[:limit].to_i))
  end

  private

  def load_category
    @category = Category.where(slug: params[:category_id]).first
  end
end
