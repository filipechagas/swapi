module Api
  module V1
    class SearchesController < Api::V1::BaseController
      def create
        query = search_params[:query]
        type = search_params[:type]

        assert_params_are_present(query, type)

        results = SwapiService.search(type, query)

        if results.fetch(:error, nil)
          render_error(results[:error])
          return
        end

        render json: results
      rescue => e
        render_error(e.message)
      end

      private

      def assert_params_are_present(query, type)
        if query.blank? || type.blank?
          raise "Query and type parameters are required"
        end
      end

      def search_params
        params.require(:search).permit(:query, :type)
      end
    end
  end
end
