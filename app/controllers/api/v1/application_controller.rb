# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include ErrorRenderable
      include Rescuable
      include Pagy::Backend
      include Pundit::Authorization

      before_action :doorkeeper_authorize!

      rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

      private

      def handle_parameter_missing(exception)
        render json: { error: exception.message }, status: :bad_request
      end

      def current_user
        @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
      end

      def paginated_authorized(klass)
        pagy(policy_scope(klass), pagination_params)
      end

      def meta_from_pagination(pagination)
        {
          page: pagination.page,
          per_page: pagination.items,
          total_items: pagination.count
        }
      end

      def pagination_params
        {
          page: params[:page],
          items: params[:per_page]
        }
      end

      def authorized_resources(klass, policy_scope_klass = nil)
        resolve_policy_scope(klass, policy_scope_klass)
      end

      def resolve_policy_scope(scope, policy_scope_klass)
        return policy_scope(scope) unless policy_scope_klass

        policy_scope_klass.new(current_user, scope).resolve
      end
    end
  end
end
