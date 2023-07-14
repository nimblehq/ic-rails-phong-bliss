# frozen_string_literal: true

module Api
  module V1
    class DownloadsController < ApplicationController
      before_action :authorize!

      def index
        keyword = policy_scope(Keyword).find(keyword_id_param[:keyword_id])
        grover = Grover.new(keyword.html).to_pdf

        send_data(grover, filename: "#{keyword.name}.pdf", type: 'application/pdf', disposition: 'attachment')
      end

      private

      def authorize!
        authorize :keyword
      end

      def keyword_id_param
        params.permit(:keyword_id)
      end
    end
  end
end
