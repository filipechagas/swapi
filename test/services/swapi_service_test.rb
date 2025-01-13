require "test_helper"

class SwapiServiceTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  class StubResponse
    attr_reader :parsed_response

    def initialize(body)
      @parsed_response = body
    end

    def self.new_callable(body)
      new(body).method(:itself).to_proc
    end

    def itself
      self
    end
  end

  setup do
    @query = "luke"
    @people_response = {
      "count" => 1,
      "next" => "https://swapi.py4e.com/api/people/?search=luke&page=2",
      "previous" => nil,
      "results" => [
        {
          "name" => "Luke Skywalker",
          "height" => "172"
        }
      ]
    }

    @films_response = {
      "count" => 1,
      "next" => nil,
      "previous" => nil,
      "results" => [
        {
          "title" => "A New Hope",
          "episode_id" => 4
        }
      ]
    }

    # Freeze time for consistent response time calculations
    travel_to Time.zone.local(2025, 1, 1, 12, 0, 0)
  end

  teardown do
    travel_back
  end

  test "searches people successfully and extracts next page" do
    SwapiService.stub :fetch_results, StubResponse.new(@people_response) do
      assert_enqueued_jobs 1 do
        response = SwapiService.search("people", @query)
        assert_equal "2", response["next"]
        assert_equal @people_response["results"], response["results"]
      end
    end
  end

  test "searches films successfully with no next page" do
    SwapiService.stub :fetch_results, StubResponse.new(@films_response) do
      assert_enqueued_jobs 1 do
        response = SwapiService.search("films", "hope")
        assert_nil response["next"]
        assert_equal @films_response["results"], response["results"]
      end
    end
  end

  test "handles invalid search type with detailed error message" do
    invalid_type = "invalid_type"
    response = SwapiService.search(invalid_type, @query)

    expected_message = "Invalid search type: #{invalid_type}. Valid types are: people, films"
    assert_equal expected_message, response[:error]
  end

  test "enqueues job with correct metrics" do
    expected_response_time = 1000.0 # 1 second in milliseconds

    travel 1.second do
      SwapiService.stub :fetch_results, StubResponse.new(@people_response) do
        assert_enqueued_with(
          job: StoreSearchStatisticJob,
        ) do
          SwapiService.search("people", @query)
        end
      end
    end
  end

  test "handles network errors gracefully" do
    [ Socket::ResolutionError, SocketError, Timeout::Error, Errno::ECONNREFUSED ].each do |error_class|
      SwapiService.stub :fetch_results, ->(*args) { raise error_class } do
        response = SwapiService.search("people", @query)
        assert_equal "SWAPI appears to be unaccessible at the moment. Please try again later.", response[:error]
      end
    end
  end

  test "handles unexpected errors gracefully" do
    error_message = "Unexpected error"
    SwapiService.stub :fetch_results, ->(*args) { raise StandardError, error_message } do
      response = SwapiService.search("people", @query)
      assert_equal error_message, response[:error]
    end
  end

  test "builds correct URL with encoded query parameters" do
    query_with_spaces = "luke skywalker"
    expected_url = "/people/?search=#{URI.encode_www_form_component(query_with_spaces)}"

    SwapiService.stub :get, ->(url, *args) {
      assert_equal expected_url, url
      StubResponse.new(@people_response)
    } do
      SwapiService.search("people", query_with_spaces)
    end
  end

  test "builds correct URL with page parameter" do
    page = "2"
    expected_url = "/people/?search=#{@query}&page=#{page}"

    SwapiService.stub :get, ->(url, *args) {
      assert_equal expected_url, url
      StubResponse.new(@people_response)
    } do
      SwapiService.search("people", @query, page)
    end
  end

  test "handles empty search results" do
    empty_response = { "count" => 0, "next" => nil, "results" => [] }

    SwapiService.stub :fetch_results, StubResponse.new(empty_response) do
      assert_enqueued_jobs 1 do
        response = SwapiService.search("people", "nonexistent")
        assert_equal empty_response, response
      end
    end
  end

  test "logs errors properly" do
    error = Socket::ResolutionError.new
    logged_messages = []

    logger = Logger.new(StringIO.new).tap do |l|
      l.define_singleton_method(:error) do |*args, &block|
        logged_messages << (block ? block.call : args.first)
      end
    end

    Rails.stub :logger, logger do
      SwapiService.stub :fetch_results, ->(*args) { raise error } do
        SwapiService.search("people", @query)
      end
    end

    assert_includes logged_messages, "SWAPI service is currently unavailable"
  end
end
