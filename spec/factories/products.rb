FactoryGirl.define do
  factory :product do
    order
    isbn { Faker::Code.isbn }
    product_name { Faker::Commerce.product_name }
    price { Faker::Commerce.price }
  end
end
