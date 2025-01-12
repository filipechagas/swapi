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
    @people_response = {
      "count" => 1,
      "results" => [
        {
          "name" => "Luke Skywalker",
          "height" => "172"
        }
      ]
    }

    @films_response = {
      "count" => 1,
      "results" => [
        {
          "title" => "A New Hope",
          "episode_id" => 4
        }
      ]
    }
  end

  test "searches people successfully" do
    SwapiService.stub :fetch_results, StubResponse.new(@people_response) do
      assert_enqueued_jobs 1 do
        response = SwapiService.search("people", "luke")
        assert_equal @people_response, response
      end
    end
  end

  test "searches films successfully" do
    SwapiService.stub :fetch_results, StubResponse.new(@films_response) do
      assert_enqueued_jobs 1 do
        response = SwapiService.search("films", "hope")
        assert_equal @films_response, response
      end
    end
  end

  test "handles invalid search type" do
    response = SwapiService.search("invalid_type", "query")
    assert_equal "Invalid search type: invalid_type", response[:error]
  end

  test "enqueues job with correct parameters" do
    SwapiService.stub :fetch_results, StubResponse.new(@people_response) do
      assert_enqueued_with(
        job: StoreSearchStatisticJob,
      ) do
        SwapiService.search("people", "luke")
      end
    end
  end

  test "handles HTTP request failure" do
    SwapiService.stub :fetch_results, ->(*args) { raise HTTParty::Error } do
      response = SwapiService.search("people", "luke")
      assert response.key?(:error)
      assert_not_nil response[:error]
    end
  end

  test "builds correct URL for people search" do
    expected_url = "/people/?search=luke"

    SwapiService.stub :get, ->(url, *args) {
      assert_equal expected_url, url
      StubResponse.new(@people_response)
    } do
      SwapiService.search("people", "luke")
    end
  end

  test "builds correct URL for films search" do
    expected_url = "/films/?search=hope"

    SwapiService.stub :get, ->(url, *args) {
      assert_equal expected_url, url
      StubResponse.new(@films_response)
    } do
      SwapiService.search("films", "hope")
    end
  end

  test "handles empty search results" do
    empty_response = { "count" => 0, "results" => [] }

    SwapiService.stub :fetch_results, StubResponse.new(empty_response) do
      assert_enqueued_jobs 1 do
        response = SwapiService.search("people", "nonexistent")
        assert_equal empty_response, response
      end
    end
  end
end
