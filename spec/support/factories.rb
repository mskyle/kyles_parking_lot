FactoryGirl.define do
  factory :registration do
    first_name "Joey"
    last_name "Parker"
    email "joey@parking.com"
    spot_number 42
    parked_on { Date.today }
  end
end