# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout 'blacklight'

  protect_from_forgery with: :exception
  helper TrlnArgon::Engine.helpers

  skip_after_action :discard_flash_if_xhr

  def default_url_options
    Rails.env.production? ? { protocol: :https } : {}
  end

  def not_found
    render file: 'public/404.html',
           status: :not_found,
           layout: false
  end
end
