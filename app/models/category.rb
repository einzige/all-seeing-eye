class Category
  include Mongoid::Document
  include Mongoid::Tree

  field :name
  field :slug

  has_many :ads

  before_save :update_slug

  def as_json *opts
    {name: name, id: id, items: children, slug: slug, leaf: leaf?}.as_json(*opts)
  end


  def build_children
    if depth > 1
      []
    else
      5.times do
        self.class.factory(parent: self)
      end
    end
  end

  def self.factory(opts = {})
    node = self.create(opts.merge(name: Faker::Company.name))
    node.build_children
    node
  end

  def self.build_tree
    items = []

    items << self.create(name: 'One leaf')

    10.times do
      items << self.factory
    end

    items
  end

  def self.tree
    self.roots.as_json
  end

  private

  def update_slug
    self[:slug] = name.parameterize
    true
  end
end
