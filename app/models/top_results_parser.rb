class TopResultsParser
  class << self
    def parse(search_entries, limit, results_field)
      result_counts = Hash.new(0)

      search_entries.each do |search|
        begin
          results = search.results["results"]
          results.each do |result|
            result_name = result[results_field]
            result_counts[result_name] += 1 if result_name
          end
        rescue => e
          Rails.logger.error("Error parsing results for search #{search.id}: #{e.message}")
          next
        end
      end

      top_results = result_counts
        .sort_by { |_, count| -count }
        .take(limit)
        .map { |name, _| name }
        .join(", ")

      top_results
    end
  end
end
