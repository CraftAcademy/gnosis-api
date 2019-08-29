FactoryBot.define do
  factory :article do
    title { "MyString" }
    body { "MyText" }
    city { "Jokkmokk" }
    association :author, factory: :user
  end
end
