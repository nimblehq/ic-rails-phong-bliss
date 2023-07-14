# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob
  attr_reader :keyword

  def perform(keyword_id)
    @keyword = Keyword.includes(:source).find(keyword_id)
    search_result = call_search_service
    update_keyword(search_result)
  end

  private

  def call_search_service
    source_name = keyword.source.name.downcase

    return Bing::SearchService.new(keyword.name).call if source_name == 'bing'

    Google::SearchService.new(keyword.name).call
  end

  def update_keyword(search_result)
    return keyword.update search_result.merge(status: :parsed) if search_result

    keyword.update({ status: :failed })
    raise Errors::SearchKeywordError
  end
end
