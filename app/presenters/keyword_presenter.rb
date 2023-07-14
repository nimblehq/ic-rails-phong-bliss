# frozen_string_literal: true

class KeywordPresenter
  delegate :id, :name, :ads_top_urls, :created_at, :updated_at, to: :keyword

  def initialize(keyword, filter_params)
    @keyword = keyword
    @filter_params = filter_params
  end

  def matching_adword_urls
    return unless filter_params[:adwords_url_contains]

    keyword.ads_top_urls.select { |item| item.downcase.include?(filter_params[:adwords_url_contains].downcase) }
  end

  private

  attr_reader :keyword, :filter_params
end
