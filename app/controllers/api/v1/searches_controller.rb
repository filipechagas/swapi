module Api
  module V1
    class SearchesController < Api::V1::BaseController
      def create
        query = search_params[:query]
        type = search_params[:type]

        if query.blank? || type.blank?
          render_error("Query and type parameters are required")
          return
        end

        results = SwapiService.search(type, query)
        if results.fetch(:error, nil)
          render_error(results[:error])
          return
        end

        render json: results
      rescue ActionController::ParameterMissing => e
        render_error(e.message)
      rescue => e
        render_error(e.message)
      end

      private

      def search_params
        params.require(:search).permit(:query, :type)
      end
    end
  end
end
