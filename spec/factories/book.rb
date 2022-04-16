FactoryBot.define do
    factory :book do
        title {Factory::Lorem.characters(number:10)}
        body { Factory::Lorem.characters(number:20)}
    end
end