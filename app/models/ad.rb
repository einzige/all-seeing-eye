class Ad
  include Mongoid::Document

  belongs_to :category

  field :name
  field :text
  field :tel
  field :date, type: Date
  field :ordering, type: Integer

  def self.page
    10.times.map { self.new }
  end

  def as_json(*params)
    {id: id, text: text, tel: tel, date: date.to_s(:short), ordering: ordering}.as_json(*params)
  end

  def self.def_tel
    '2' + 6.times.map { rand(10) }.each_slice(2).to_a.map(&:join).join('-')
  end

  def self.def_date
    (Time.zone.now - rand(10).days).to_date
  end

  def self.factory
    Category.all.each do |c|
      100.times do
        self.create(text: Faker::Lorem.sentence(4 + rand(14)), tel: def_tel, ordering: rand(10), date: def_date, category: c)
      end
    end
  end
end
