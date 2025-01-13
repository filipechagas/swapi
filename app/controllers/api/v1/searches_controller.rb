module Api
  module V1
    class SearchesController < Api::V1::BaseController
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from SwapiService::InvalidSearchType, with: :invalid_search_type

      def create
        search_result = perform_search

        if search_result[:error].present?
          render_error(search_result[:error], :unprocessable_entity)
          return
        end

        render json: search_result, status: :ok
      rescue StandardError => e
        render_error(e.message, :internal_server_error)
      end

      private

      def perform_search
        validate_required_params!

        SwapiService.search(
          search_params[:type],
          search_params[:query],
          search_params[:fetch_next]
        )
      end

      def validate_required_params!
        return if search_params[:query].present? && search_params[:type].present?

        missing_params = []
        missing_params << "query" if search_params[:query].blank?
        missing_params << "type" if search_params[:type].blank?

        raise "Missing required parameters: #{missing_params.join(', ')}"
      end

      def search_params
        @search_params ||= params.require(:search).permit(:query, :type, :fetch_next)
      end

      def parameter_missing(exception)
        render_error("Parameter missing: #{exception.param}", :bad_request)
      end

      def invalid_search_type(exception)
        render_error(exception.message, :unprocessable_entity)
      end

      def render_error(message, status = :unprocessable_entity)
        render json: { error: message }, status: status
      end
    end
  end
end
