# frozen_string_literal: true

class SearchKeywordsForm < ApplicationForm
  attr_reader :keywords, :search_params, :pagination_params

  # rubocop:disable Lint/MissingSuper
  def initialize(keywords, search_params, pagination_params)
    @keywords = keywords
    @search_params = search_params
    @pagination_params = pagination_params
  end
  # rubocop:enable Lint/MissingSuper

  def search_keywords
    pagination_params[:page] ||= 1
    pagination_params[:items] ||= 10
    return empty_pagination unless search_params[:adwords_url_contains]

    keywords_has_ads_top_urls_contains_word
  end

  private

  def keywords_has_ads_top_urls_contains_word
    pagination, paginated_keywords = pagy(keywords_query.call, pagination_params)
    word_params = search_params[:adwords_url_contains]
    filtered_paginated_keywords = paginated_keywords.map { |item| filter_unmatched_adword_urls(item, word_params) }
    [pagination, filtered_paginated_keywords]
  end

  def filter_unmatched_adword_urls(keyword, word_params)
    unfiltered_urls = keyword.ads_top_urls
    keyword.ads_top_urls = unfiltered_urls.select { |item| item.downcase.include?(word_params.downcase) }
    keyword
  end

  def empty_pagination
    [
      Pagy.new(page: pagination_params[:page], items: pagination_params[:items], count: 0),
      []
    ]
  end

  def keywords_query
    @keywords_query ||= KeywordsQuery.new(keywords, search_params)
  end
end
