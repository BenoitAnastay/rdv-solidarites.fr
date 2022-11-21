# frozen_string_literal: true

require "redis"

class Admin::UserInWaitingRoomsController < AgentAuthController
  redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379")
  REDIS = Redis.new(url: redis_url)

  def create
    rdv = Rdv.includes(:agents).find(params[:rdv_id])
    authorize(rdv)

    if rdv.status == "unknown" && rdv.deleted_at.nil?

      if current_organisation.territory.enable_waiting_room_mail_field
        rdv.agents.map do |agent|
          Agents::WaitingRoomMailer.with(agent: agent, rdv: rdv).user_in_waiting_room.deliver_later
        end
      end

      if current_organisation.territory.enable_waiting_room_color_field
        REDIS.set("user_in_waiting_rdv_id:#{rdv.id}", true)
      end

    end
    redirect_to admin_organisation_rdv_user_in_waiting_room_path(rdv.organisation, rdv)
  end
end
