#-*- encoding: utf-8 -*-
class PagesController < ApplicationController
  respond_to :js
  layout false

  def show
    render js: jsonp(html: render_to_string(params[:id]))
  end
end
