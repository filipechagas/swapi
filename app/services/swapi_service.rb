class SwapiService
  class InvalidSearchType < StandardError; end
  include HTTParty

  BASE_URI = "https://swapi.py4e.com/api"
  VALID_TYPES = %w[people films].freeze
  base_uri BASE_URI

  class << self
    def search(type, query, page = nil)
      validate_search_type!(type)
      start_time = Time.current

      cached_result = find_cached_result(type, query, page)
      return cached_result if cached_result.present?

      response = fetch_results(type, query, page)
      processed_response = process_response(response)

      cache_response(type, query, page, processed_response, calculate_response_time(start_time))
      processed_response
    rescue *NETWORK_ERRORS => e
      handle_network_error(e)
    rescue StandardError => e
      handle_generic_error(e)
    end

    private

    NETWORK_ERRORS = [
      Socket::ResolutionError,
      SocketError,
      Timeout::Error,
      Errno::ECONNREFUSED
    ].freeze

    def validate_search_type!(type)
      return if VALID_TYPES.include?(type)
      raise InvalidSearchType, "Invalid search type: #{type}. Valid types are: #{VALID_TYPES.join(', ')}"
    end

    def find_cached_result(type, query, page)
      search = Search.valid.find_by(
        search_type: type,
        query: query,
        page: page
      )

      search.update(hits: search.hits + 1) if search

      search ? search.results : nil
    end

    def cache_response(type, query, page, response, response_time)
      Search.create!(
        search_type: type,
        query: query,
        page: page,
        results: response,
        response_time: response_time,
        expires_at: 24.hours.from_now
      )
    end

    def fetch_results(type, query, page)
      endpoint = build_endpoint(type, query, page)
      get(endpoint)
    end

    def build_endpoint(type, query, page)
      endpoint = "/#{type}/?search=#{URI.encode_www_form_component(query)}"
      endpoint += "&page=#{page}" if page
      endpoint
    end

    def process_response(response)
      return unless response&.parsed_response
      parsed = response.parsed_response
      parsed["next"] = extract_page_number(parsed["next"])
      parsed
    end

    def extract_page_number(next_url)
      return unless next_url
      page_match = next_url.match(/page=(\d+)/)
      page_match[1] if page_match
    end

    def calculate_response_time(start_time)
      ((Time.current - start_time) * 1000).round(2)
    end

    def handle_network_error(error)
      Rails.logger.error(error) { "SWAPI service is currently unavailable" }
      { error: "SWAPI appears to be unaccessible at the moment. Please try again later." }
    end

    def handle_generic_error(error)
      Rails.logger.error(error) { "Unexpected error occurred while fetching SWAPI data" }
      { error: error.message }
    end
  end
end
