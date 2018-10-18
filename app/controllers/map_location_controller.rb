# frozen_string_literal: true

require 'net/http'
require 'uri'

class MapLocationController < ApplicationController
  def show
    @location_content = dul_location_service(params[:loc_n],
                                             params[:loc_b],
                                             params[:call_no])
    render layout: false
    params.permit(:loc_n, :loc_b, :title, :call_no)
  end

  private

  def dul_location_service(collection_code, sublibrary, callno)
    response = map_response(collection_code, sublibrary, callno)
    response['content-type'] == 'application/json' ? response.body : false
  rescue Net::ReadTimeout => e
    Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
    false
  end

  def map_uri
    @map_uri ||= URI.parse(DulArgonSkin.map_location_service_url)
  end

  def map_request(collection_code, sublibrary, callno)
    request = Net::HTTP::Post.new(map_uri)
    request['X-Requested-With'] = 'XMLHttpRequest'
    request.set_form_data(
      'collection_code' => collection_code,
      'sublibrary' => sublibrary,
      'callno' => callno
    )
    request
  end

  def request_options
    { use_ssl: map_uri.scheme == 'https' }
  end

  def map_response(collection_code, sublibrary, callno)
    request = map_request(collection_code, sublibrary, callno)
    Net::HTTP.start(map_uri.hostname, map_uri.port, request_options) do |http|
      http.read_timeout = 30 # Default is 60 seconds
      http.request(request)
    end
  end
end
