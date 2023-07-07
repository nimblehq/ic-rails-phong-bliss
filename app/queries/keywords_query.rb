# frozen_string_literal: true

class KeywordsQuery
  attr_reader :keywords, :filter_params

  def initialize(keywords, filter_params)
    @keywords = keywords
    @filter_params = filter_params
  end

  def call
    return nil unless filter_params[:adwords_url_contains] || filter_params[:result_url_contains]

    get_filtered_keyword
  end

  private

  def get_filtered_keyword
    keywords = get_keywords_has_ads_top_urls_contains_word(@keywords, filter_params[:adwords_url_contains])
    get_keywords_has_result_urls_contains_word(keywords, filter_params[:result_url_contains])
  end

  def get_keywords_has_ads_top_urls_contains_word(keywords, word_params)
    return keywords unless word_params

    keywords.where("array_to_string(ads_top_urls, '||') ILIKE ?", "%#{word_params}%")
  end

  def get_keywords_has_result_urls_contains_word(keywords, word_params)
    return keywords unless word_params

    keywords.where("array_to_string(result_urls, '||') ILIKE ?", "%#{word_params}%")
  end
end
