# frozen_string_literal: true

module SubmissionEvents
  TRACKING_PARAM_LENGTH = 6

  module_function

  def build_tracking_param(submitter, event_type = 'click_email')
    Base64.urlsafe_encode64(
      [submitter.slug, event_type, Rails.application.secrets.secret_key_base].join(':')
    ).first(TRACKING_PARAM_LENGTH)
  end

  def create_with_tracking_data(submitter, event_type, request)
    SubmissionEvent.create!(submitter:, event_type:, data: {
      ip: request.remote_ip,
      ua: request.user_agent,
      sid: request.session.id.to_s,
      uid: request.env['warden'].user(:user)&.id
    }.compact_blank)
  end
end
