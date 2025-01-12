require "test_helper"

class Api::V1::StatisticsControllerTest < ActionDispatch::IntegrationTest
  test "returns statistics in correct format" do
    get api_v1_statistics_url

    assert_response :success

    response_body = JSON.parse(response.body)
    assert_includes response_body.keys, "top_queries"
    assert_includes response_body.keys, "average_response_time"
    assert_includes response_body.keys, "popular_hours"
  end

  test "calculates top queries correctly" do
    get api_v1_statistics_url

    response_body = JSON.parse(response.body)
    top_queries = response_body["top_queries"]

    assert top_queries.length <= 5

    luke_query = top_queries.find { |q| q["query"] == "luke" }
    assert_not_nil luke_query

    assert_equal 40.0, luke_query["percentage"]
  end

  test "calculates average response time correctly" do
    get api_v1_statistics_url

    response_body = JSON.parse(response.body)
    avg_time = response_body["average_response_time"]

    expected_average = 145.5

    assert_equal expected_average, avg_time
  end

  test "identifies popular hours correctly" do
    get api_v1_statistics_url

    response_body = JSON.parse(response.body)
    popular_hour = response_body["popular_hours"]

    assert_equal "14", popular_hour
  end

  test "handles empty database gracefully" do
    SearchStatistic.delete_all

    get api_v1_statistics_url

    assert_response :success
    response_body = JSON.parse(response.body)

    assert_empty response_body["top_queries"]
    assert_equal response_body["average_response_time"], 0.0
    assert_nil response_body["popular_hours"]
  end
end
