# frozen_string_literal: true

class KeywordsQuery
  attr_reader :keywords, :filter_params

  def initialize(keywords, filter_params)
    @keywords = keywords
    @filter_params = filter_params
  end

  def call
    return nil unless filter_params[:adwords_url_contains]

    get_keywords_has_ads_top_urls_contains_word(filter_params[:adwords_url_contains])
  end

  private

  def get_keywords_has_ads_top_urls_contains_word(word_params)
    keywords.where("array_to_string(ads_top_urls, '||') ILIKE ?", "%#{word_params}%")
  end
end
