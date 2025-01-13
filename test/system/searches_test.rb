require "application_system_test_case"

class SearchesTest < ApplicationSystemTestCase
  def setup
    @luke_response = {
      "count" => 1,
      "next" => nil,
      "previous" => nil,
      "results" => [
        {
          "name" => "Luke Skywalker",
          "height" => "172",
          "mass" => "77",
          "hair_color" => "blond",
          "skin_color" => "fair",
          "eye_color" => "blue",
          "birth_year" => "19BBY",
          "gender" => "male"
        }
      ]
    }

    @multiple_results_response = {
      "count" => 3,
      "next" => nil,
      "previous" => nil,
      "results" => [
        { "name" => "Luke Skywalker" },
        { "name" => "Leia Organa" },
        { "name" => "Obi-Wan Kenobi" }
      ]
    }
  end

  test "searching for a specific character" do
    visit root_path

    SwapiService.stub :search, @luke_response do
      find(".search-type-radio[value='people']").click
      fill_in class: "search-input", with: "luke"
      click_button class: "search-button"

      within ".results-section" do
        assert_selector ".result-item", count: 1
        assert_text "Luke Skywalker"
        assert_selector ".action-button", text: "SEE DETAILS"
      end
    end
  end

  test "searching shows multiple results" do
    visit root_path

    SwapiService.stub :search, @multiple_results_response do
      find(".search-type-radio[value='people']").click
      fill_in class: "search-input", with: "a"
      click_button class: "search-button"

      within ".results-section" do
        assert_selector ".result-item", count: 3
        assert_text "Luke Skywalker"
        assert_text "Leia Organa"
        assert_text "Obi-Wan Kenobi"
      end
    end
  end

  test "handles no results" do
    visit root_path

    empty_response = { "count" => 0, "next" => nil, "previous" => nil, "results" => [] }

    SwapiService.stub :search, empty_response do
      find(".search-type-radio[value='people']").click
      fill_in class: "search-input", with: "nonexistent"
      click_button class: "search-button"

      assert_text "There are zero matches"
      assert_no_selector ".result-item"
    end
  end

  test "handles API error" do
    visit root_path

    SwapiService.stub :search, { error: "API error" } do
      find(".search-type-radio[value='people']").click
      fill_in class: "search-input", with: "error"
      click_button class: "search-button"

      assert_text "API error"
      assert_no_selector ".result-item"
    end
  end
end
