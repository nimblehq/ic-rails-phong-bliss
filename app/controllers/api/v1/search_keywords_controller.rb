# frozen_string_literal: true

module Api
  module V1
    class SearchKeywordsController < ApplicationController
      before_action :authorize!

      def index
        pagination, keywords = search_keywords_form.search_keywords

        render json: KeywordSerializer.new(keywords, meta: meta_from_pagination(pagination))
      end

      private

      def search_keywords_form
        @search_keywords_form ||= SearchKeywordsForm.new(current_user.keywords, search_params, pagination_params)
      end

      def authorize!
        authorize :keyword
      end

      def search_params
        params.require(:filter).permit(:adwords_url_contains)
      end
    end
  end
end
