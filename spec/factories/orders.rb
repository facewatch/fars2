FactoryGirl.define do
  factory :order do
    isbn { Faker::Code.isbn }
    manager { Faker::Name.name }

    after(:create) do |order, evaluator|
      FactoryGirl.create_list(:product, 2, order: order)
    end
  end
end
