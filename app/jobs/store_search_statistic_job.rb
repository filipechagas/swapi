class StoreSearchStatisticJob < ApplicationJob
  queue_adapter = :solid_queue

  def perform(query:, search_type:, response_time:)
    SearchStatistic.create!(
      query: query,
      search_type: search_type,
      response_time: response_time
    )
  end
end
