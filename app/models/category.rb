class Category < Struct.new(:level)

  attr_accessor :name, :leaf

  def as_json *opts
    {name: name, id: id, items: items, slug: name.parameterize, leaf: leaf?}.as_json(*opts)
  end

  def items
    if leaf?
      []
    else
      10.times.map do
        self.class.new(level + 1).as_json
      end
    end
  end

  def self.tree
    items = []

    rtest = self.new(1)
    rtest.name = 'suka'
    rtest.leaf = true
    items << rtest.as_json

    10.times do
      items << self.new(1).as_json
    end

    items
  end

  def leaf?
    @leaf || level > 2
  end

  def id
    rand(100000)
  end

  def name
    @name ||= Faker::Company.name
  end
end
