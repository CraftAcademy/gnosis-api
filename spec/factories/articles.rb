FactoryBot.define do
  factory :article do
    title { "MyString" }
    body { "MyText" }
    city_id { "Jokkmokk" }
    association :author, factory: :user
  end
end
