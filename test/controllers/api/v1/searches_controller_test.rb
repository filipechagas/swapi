require "test_helper"

class Api::V1::SearchesControllerTest < ActionDispatch::IntegrationTest
  test "returns search results for valid parameters" do
    mock_response = {
      "count" => 1,
      "results" => [
        {
          "name" => "Luke Skywalker",
          "height" => "172"
        }
      ]
    }

    SwapiService.stub :search, mock_response do
      post api_v1_searches_url,
        params: { search: { query: "luke", type: "people" } },
        as: :json

      assert_response :success
      assert_equal mock_response, JSON.parse(response.body)
    end
  end

  test "returns error for missing parameters" do
    post api_v1_searches_url,
      params: { search: { query: "luke" } },
      as: :json

    assert_response :unprocessable_entity
    assert_equal "Query and type parameters are required", JSON.parse(response.body)["error"]

    post api_v1_searches_url,
      params: { search: { type: "people" } },
      as: :json

    assert_response :unprocessable_entity
    assert_equal "Query and type parameters are required", JSON.parse(response.body)["error"]

    post api_v1_searches_url,
      params: {},
      as: :json

    assert_response :unprocessable_entity
    assert_equal "param is missing or the value is empty or invalid: search", JSON.parse(response.body)["error"]
  end

  test "returns error when SWAPI service fails" do
    error_message = "API connection failed"

    SwapiService.stub :search, { error: error_message } do
      post api_v1_searches_url,
        params: { search: { query: "luke", type: "people" } },
        as: :json

      assert_response :unprocessable_entity
      assert_equal error_message, JSON.parse(response.body)["error"]
    end
  end

  test "handles unexpected exceptions" do
    SwapiService.stub :search, ->(*args) { raise StandardError, "Unexpected error" } do
      post api_v1_searches_url,
        params: { search: { query: "luke", type: "people" } },
        as: :json

      assert_response :unprocessable_entity
      assert_equal "Unexpected error", JSON.parse(response.body)["error"]
    end
  end
end
