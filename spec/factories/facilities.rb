# frozen_string_literal: true

FactoryBot.define do
  factory :facility do
    association :company
    siret '44622002200227'
    city_code '59392'
  end
end
