FactoryBot.define do
  factory :url, class: Url do
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    full_url { 'www.google.com' }
    short_url { 'DsdlfFSDF' }
  end
end
