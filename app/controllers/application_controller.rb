class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def jsonp(resp)
    params[:callback].to_s + '(' + resp.merge(success: true).to_json + ');'
  end
end
