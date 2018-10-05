class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout 'blacklight'

  protect_from_forgery with: :exception
  helper TrlnArgon::Engine.helpers

  def default_url_options
    Rails.env.production? ? { protocol: :https } : {}
  end
end
