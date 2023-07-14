# frozen_string_literal: true

class KeywordSerializer < ApplicationSerializer
  attributes :name,
             :created_at,
             :updated_at,
             :ads_top_urls

  attribute :matching_adword_urls, if: proc { |record|
    defined?(record.matching_adword_urls)
  }
end
