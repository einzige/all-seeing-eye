#-*- encoding: utf-8 -*-
class HomesController < ApplicationController
  respond_to :js
  layout false

  def show
    render js: jsonp(html: render_to_string('show'))
  end

end
