# frozen_string_literal: true

Fabricator(:keyword) do
  id { FFaker::Identification.ssn }
  name { FFaker::FreedomIpsum.word }
  user { Fabricate(:user) }
  source { Fabricate(:source) }
end

Fabricator(:keyword_parsed, from: :keyword) do
  status :parsed
  ads_top_count { FFaker.rand 9 }
  ads_page_count { FFaker.rand 9 }
  ads_top_urls(rand: 9) { FFaker::Internet.http_url }
  result_count { FFaker.rand 9 }
  result_urls(rand: 9) { FFaker::Internet.http_url }
  total_link_count { FFaker.rand 9 }
  html { FFaker::HTMLIpsum.body }

  source { Fabricate(:source) }
end
