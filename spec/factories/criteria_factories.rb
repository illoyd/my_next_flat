FactoryGirl.define do

  factory :buy_criteria do
    search
    
    trait :with_prices do
      min_price 250_000
      max_price 325_000
    end

    trait :with_beds do
      min_beds 2
      max_beds 4
    end
    
    trait :with_baths do
      min_baths 1
      max_baths 2
    end
    
    trait :with_random do
      min_price { (100..200).to_a.sample * 1_000 }
      max_price { ((min_price/1000)..450).to_a.sample * 1_000 }
      
      min_beds  { (0..2).to_a.sample }
      max_beds  { (min_beds..6).to_a.sample }
      
      min_baths { (0..1).to_a.sample }
      max_baths { (min_baths..3).to_a.sample }
    end
    
  end

  factory :let_criteria do
    search

    trait :with_beds do
      min_beds 2
      max_beds 4
    end
    
    trait :with_baths do
      min_baths 1
      max_baths 2
    end
    
    trait :with_prices do
      min_price 400
      max_price 800
    end

    trait :with_random do
      min_price { (400..600).to_a.sample }
      max_price { (min_price..1200).to_a.sample }
      
      min_beds  { (0..2).to_a.sample }
      max_beds  { (min_beds..6).to_a.sample }
      
      min_baths { (0..1).to_a.sample }
      max_baths { (min_baths..3).to_a.sample }
    end
    
  end

end
