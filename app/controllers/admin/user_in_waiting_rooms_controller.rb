# frozen_string_literal: true

class Admin::UserInWaitingRoomsController < AgentAuthController
  def create
    rdv = Rdv.includes(:agents).find(params[:rdv_id])
    authorize(rdv)

    # TODO

    if current_organisation.territory.enable_waiting_room_mail_field
      rdv.agents.map do |agent|
        Agents::WaitingRoomMailer.with(agent: agent, rdv: rdv).user_in_waiting_room.deliver_later
      end
    end

    if current_organisation.territory.enable_waiting_room_color_field
      # change la couleur du rdv



      puts "*" *100
      puts "passe par la mofication de la couleur du rdv"
      puts "*" *100

      require 'redis'
      redis = Redis.new(host: "localhost")

      redis.set("user_in_waiting_room", rdv)

      puts "#" *100
      puts redis.get("user_in_waiting_room")
      puts "#" *100


    end
  end
end
