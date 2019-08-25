FactoryBot.define do
  factory :article do
    title { "MyString" }
    body { "MyText" }
    country { "Uganda" }
    city { "Kampala" }
    association :author, factory: :user
  end
end
