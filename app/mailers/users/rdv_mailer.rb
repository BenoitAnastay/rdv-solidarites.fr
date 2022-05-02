# frozen_string_literal: true

class Users::RdvMailer < ApplicationMailer
  include DateHelper
  helper UsersHelper
  helper RdvsHelper
  helper DateHelper

  def rdv_created(rdv, user, token)
    @rdv = rdv
    @user = user
    @token = token

    self.ics_payload = @rdv.payload(:create, user)
    mail(
      to: user.email,
      subject: "RDV confirmé le #{l(@rdv.starts_at, format: :human)}"
    )
    save_receipt(:rdv_created)
  end

  def rdv_date_updated(rdv, user, token, old_starts_at)
    @rdv = rdv
    @user = user
    @token = token
    @old_starts_at = old_starts_at

    self.ics_payload = @rdv.payload(:update, user)
    mail(
      to: user.email,
      subject: "RDV #{relative_date old_starts_at} déplacé"
    )
    save_receipt(:rdv_date_updated)
  end

  def rdv_upcoming_reminder(rdv, user, token)
    @rdv = rdv
    @user = user
    @token = token

    self.ics_payload = @rdv.payload(nil, user)
    mail(
      to: user.email,
      subject: "[Rappel] RDV le #{l(@rdv.starts_at, format: :human)}"
    )
    save_receipt(:rdv_upcoming_reminder)
  end

  def rdv_cancelled(rdv, user, token)
    @rdv = rdv
    @user = user
    @token = token

    self.ics_payload = @rdv.payload(:destroy, user)
    mail(
      to: user.email,
      subject: "RDV annulé le #{l(@rdv.starts_at, format: :human)} avec #{@rdv.organisation.name}"
    )
    save_receipt(:rdv_cancelled)
  end

  def save_receipt(event)
    params = {
      rdv: @rdv,
      user: @user,
      event: event,
      channel: :mail,
      result: :processed,
      email_address: @user.email
    }
    Receipt.create!(params)
  end
end
