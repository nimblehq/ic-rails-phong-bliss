# frozen_string_literal: true

module Api
  module V1
    class SearchResultsController < ApplicationController
      before_action :authorize!

      def index
        word = search_params[:adwords_url_contains]
        pagination, keywords = get_keywords_has_ads_top_urls_contains_word(word)

        render json: KeywordSerializer.new(keywords, meta: meta_from_pagination(pagination))
      end

      private

      def authorize!
        authorize :keyword
      end

      def search_params
        params.require(:filter).permit(:adwords_url_contains)
      end

      def get_keywords_has_ads_top_urls_contains_word(word)
        keywords = policy_scope(Keyword).where("array_to_string(ads_top_urls, '||') ILIKE ?", "%#{word}%")
        pagination, paginated_keywords = pagy(keywords, pagination_params)
        filtered_paginated_keywords = paginated_keywords.map { |item| filter_ads_top_urls(item, word) }

        [pagination, filtered_paginated_keywords]
      end

      def filter_ads_top_urls(keyword, word)
        unfiltered_urls = keyword.ads_top_urls
        keyword.ads_top_urls = unfiltered_urls.select { |item| item.downcase.include?(word.downcase) }
        keyword
      end
    end
  end
end
