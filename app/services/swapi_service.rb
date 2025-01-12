class SwapiService
  include HTTParty
  base_uri "https://swapi.py4e.com/api"

  def self.search(type, query)
    start_time = Time.current

    response = fetch_results(type, query)

    end_time = Time.current
    response_time = (end_time - start_time) * 1000

    StoreSearchStatisticJob.perform_later(
      query: query,
      search_type: type,
      response_time: response_time
    )

    response.parsed_response
  rescue => e
    { error: e.message }
  end

  private

  def self.fetch_results(type, query)
    response = case type
    when "people"
      get("/people/?search=#{query}")
    when "films"
      get("/films/?search=#{query}")
    else
      raise ArgumentError, "Invalid search type: #{type}"
    end

    response
  end
end
