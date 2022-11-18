# frozen_string_literal: true

require "redis"

redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379")
REDIS = Redis.new(url: redis_url)

module Rdv::UsingWaitingRoom
  extend ActiveSupport::Concern

  def user_in_waiting_room?
    REDIS.get("user_in_waiting_rdv_id:#{id}").to_bool
  end
end
