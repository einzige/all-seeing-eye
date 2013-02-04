class Ad

  def self.page
    10.times.map { self.new }
  end

  def as_json(*params)
    {text: text, tel: tel, date: date.to_s(:short), ordering: ordering}.as_json(*params)
  end

  def ordering
    rand(10)
  end

  def text
    Faker::Lorem.sentence(4 + rand(14))
  end

  def tel
    '2' + 6.times.map { rand(10) }.each_slice(2).to_a.map(&:join).join('-')
  end

  def date
    (Time.zone.now - rand(10).days).to_date
  end
end
