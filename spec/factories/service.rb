FactoryBot.define do
  sequence(:service_name) { |n| "Service #{n}" }

  factory :service do
    name { generate(:service_name) }
    trait :secretariat do
      name { 'Secrétariat' }
    end
  end
end
