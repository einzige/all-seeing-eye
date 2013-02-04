class CategoriesController < ApplicationController
  respond_to :js
  layout false

  def index
    render js: jsonp(items: Category.tree, name: 'Glossies')
  end
end
