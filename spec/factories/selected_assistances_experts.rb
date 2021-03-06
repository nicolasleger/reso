# frozen_string_literal: true

FactoryBot.define do
  factory :selected_assistance_expert do
    association :diagnosed_need

    trait :with_assistance_expert do
      association :assistance_expert
    end

    trait :with_territory_user do
      association :territory_user
    end
  end
end
