FactoryGirl.define do

  factory :location do
    search

    area   { Faker::Address.city }
    radius 0.5
    
    trait :with_random do
    end
  end

end
