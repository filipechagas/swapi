require "test_helper"

class Api::V1::StatisticsControllerTest < ActionDispatch::IntegrationTest
  test "returns popular searches by type for people" do
    get popular_searches_by_type_api_v1_statistics_url

    assert_response :success
    response_body = JSON.parse(response.body)

    assert_includes response_body["people"].downcase, "chew"
  end

  test "returns popular searches by type for movies" do
    get popular_searches_by_type_api_v1_statistics_url

    assert_response :success
    response_body = JSON.parse(response.body)

    assert_includes response_body["movies"].downcase, "new hope"
  end

  test "returns fallback values when no searches exist" do
    Search.delete_all

    get popular_searches_by_type_api_v1_statistics_url

    assert_response :success
    response_body = JSON.parse(response.body)

    assert_equal "Chewbacca, Yoda, Boba Fett", response_body["people"]
    assert_equal "A New Hope, Empire Strikes Back", response_body["movies"]
  end

  test "returns correct format for popular searches response" do
    get popular_searches_by_type_api_v1_statistics_url

    assert_response :success
    response_body = JSON.parse(response.body)

    assert_equal [ "movies", "people" ].sort, response_body.keys.sort

    assert_match(/^[\w\s,]+$/, response_body["people"])
    assert_match(/^[\w\s,]+$/, response_body["movies"])
  end
end
