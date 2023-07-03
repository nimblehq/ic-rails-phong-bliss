# frozen_string_literal: true

class KeywordSerializer < ApplicationSerializer
  attributes :name,
             :created_at,
             :updated_at,
             :ads_top_urls
end
