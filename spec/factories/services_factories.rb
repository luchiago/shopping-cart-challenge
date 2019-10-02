# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    user_token { 'token' }
    apple { 3 }
    banana { 1 }
    orange { 4 }
  end

  factory :coupon do
    name { 'A' }
  end
end
