FactoryGirl.define do

  factory :search do
  
    ignore do
      location_count 1
      criteria_count 1
      random         false
    end
  
    user
    name { Faker::Company.catch_phrase }
    
    after(:build) do |search, evaluator|
      if evaluator.random
        search.locations = build_list(:location, evaluator.location_count, :with_random, search: search)     if search.locations.empty?
        search.criterias = build_list(:buy_criteria, evaluator.criteria_count, :with_random, search: search) if search.criterias.empty?
      else
        search.locations = build_list(:location, evaluator.location_count, search: search)     if search.locations.empty?
        search.criterias = build_list(:buy_criteria, evaluator.criteria_count, search: search) if search.criterias.empty?
      end
    end

    trait :active do
      active true
    end
    
    trait :inactive do
      active false
    end
    
    trait :with_daily_schedule do
      active
      schedule { IceCube::Schedule.new { |s| s.add_recurrence_rule(IceCube::Rule.daily) } }
    end
    
    trait :random do
      random true
    end
    
  end

end
