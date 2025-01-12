module Api
  module V1
    class StatisticsController < Api::V1::BaseController
      def index
        render json: {
          top_queries: top_queries,
          average_response_time: average_response_time,
          popular_hours: popular_hours
        }
      end

      private

      def top_queries
        SearchStatistic
          .group(:query)
          .select("query, COUNT(*) as count")
          .order("count DESC")
          .limit(5)
          .map do |stat|
            {
              query: stat.query,
              percentage: (stat.count.to_f / SearchStatistic.count * 100).round(2)
            }
          end
      end

      def average_response_time
        SearchStatistic.average(:response_time).to_f.round(2)
      end

      def popular_hours
        SearchStatistic
          .group("strftime('%H', created_at)")
          .select("strftime('%H', created_at) as hour, COUNT(*) as count")
          .order("count DESC")
          .first
          &.hour
      end
    end
  end
end
