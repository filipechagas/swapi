class CleanupExpiredSearchesJob < ApplicationJob
  queue_as :default

  def perform
    Search.where("expires_at < ?", Time.current).delete_all
  end
end
