# frozen_string_literal: true

class KeywordsQuery
  attr_reader :scope, :filter_params

  def initialize(scope, filter_params)
    @scope = scope
    @filter_params = filter_params
  end

  def call
    return unless filter_params[:adwords_url_contains]

    filter_ads_top_urls(filter_params[:adwords_url_contains])
  end

  private

  def filter_ads_top_urls(word)
    scope.where("array_to_string(ads_top_urls, '||') ILIKE ?", "%#{word}%")
  end
end
