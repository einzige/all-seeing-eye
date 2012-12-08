FactoryGirl.define do
=begin EXAMPLE
  factory :category do |category|
    category.name { Faker::Name.name }
  end

  factory :event do |event|
    event.description { Faker::Company.catch_phrase }
    event.category    { Category.factory(['Sports', 'Festivals', 'Carnivals', 'Concerts'].shuffle.first) }
    event.location    { Time.now + (rand*10).to_i.days }
  end

  factory :target do |target|
  end

  factory :tv_category, class: Tv::Category do |c|
    c.name { Faker::Name.name }
  end

  factory :tv_channel, class: Tv::Channel do |c|
    c.name { Faker::Name.name }
  end

  factory :tv_e_category, class: Tv::ECategory do |c|
    category.name { Faker::Name.name }
  end

  factory :tv_event, class: Tv::Event do |s|
    s.name        { Faker::Name.name }
    s.duration    { 1 }
    s.description { Faker::Company.catch_phrase }
    s.location    { Time.now + (rand*10).to_i.days }
  end

  factory :tv_program, class: Tv::Program do |program|
    program.name { Faker::Name.name }
  end

  factory :user do |u|
    u.first_name { Faker::Name.name }
  end
=end
end
