module Api
  module V1
    class StatisticsController < Api::V1::BaseController
      def index
        render json: {
          top_queries: Search.popular_queries_percentage,
          average_response_time: Search.average_response_duration,
          popular_hours: Search.group_by_hour.first&.hour
        }
      end

      def popular_searches_by_type
        render json: {
          people: Search.format_popular_searches_by_type("people")
                    .presence || "Chewbacca, Yoda, Boba Fett",
          movies: Search.format_popular_searches_by_type("films")
                    .presence || "A New Hope, Empire Strikes Back"
        }
      end
    end
  end
end
