FactoryGirl.define do
  factory :customer do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    city { Faker::Address.city }
    street_name { Faker::Address.street_name }
    building_number { Faker::Address.building_number }
    zip_code { Faker::Address.zip_code }
    credit_card_number { Faker::Business.credit_card_number }
    credit_card_expiry_date { Faker::Business.credit_card_expiry_date }
    credit_card_type { Faker::Business.credit_card_type }

    after(:create) do |customer, evaluator|
      FactoryGirl.create(:order, customer: customer)
    end
  end
end
