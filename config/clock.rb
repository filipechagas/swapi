require "clockwork"
require "./config/boot"
require "./config/environment"

module Clockwork
  every(4.hours, "cleanup.expired_searches") do
    CleanupExpiredSearchesJob.perform_later
  end
end
