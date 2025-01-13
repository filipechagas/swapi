class Search < ApplicationRecord
  validates :search_type, :query, :results, :expires_at, presence: true
  validates :search_type, inclusion: { in: %w[people films] }

  scope :valid, -> { where("expires_at > ?", Time.current) }
  scope :by_search_type, ->(type) { where(search_type: type) }

  def self.invalidate_all!
    update_all(expires_at: Time.current)
  end

  def self.invalidate_type!(type)
    where(search_type: type).update_all(expires_at: Time.current)
  end


  scope :group_by_query, -> {
    group(:query)
    .select("query, hits")
    .order(Arel.sql("COUNT(*) DESC"))  # Use COUNT(*) directly in ORDER BY
  }

  scope :top_queries, ->(limit = 5) {
    group_by_query
    .limit(limit)
  }

  scope :top_queries_by_type, ->(type, limit = 3) {
    by_search_type(type)
    .order("hits DESC")
    .group_by_query
    .limit(limit)
  }

  scope :group_by_hour, -> {
    group("strftime('%H', created_at)")
    .select("strftime('%H', created_at) as hour, hits")
    .order(Arel.sql("COUNT(*) DESC"))
  }

  def self.popular_queries_percentage(limit = 5)
    total_count = count.to_f

    top_queries(limit).map do |stat|
      {
        query: stat.query,
        percentage: (stat.hits.to_f / total_count * 100).round(2)
      }
    end
  end

  def self.format_popular_searches_by_type(type, limit = 3)
    results_field = type == "people" ? "name" : "title"

    searches = by_search_type(type).valid

    top_results = TopResultsParser.parse(searches, limit, results_field)

    top_results.presence || "No results found"
  end

  def self.average_response_duration
    average(:response_time).to_f.round(2)
  end
end
