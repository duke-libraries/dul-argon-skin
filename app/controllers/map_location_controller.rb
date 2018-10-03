class MapLocationController < ApplicationController
  # frozen_string_literal: true
  def show
    @location_content = dul_location_service(params[:loc_n],
                                             params[:loc_b],
                                             params[:call_no])
    render layout: false
    params.permit(:loc_n, :loc_b, :title, :call_no)
  end

  private

  def dul_location_service(collection_code, sublibrary, callno)
    require 'net/http'
    require 'uri'
    uri = URI.parse('https://library.duke.edu/locguide/mapinfo')
    request = Net::HTTP::Post.new(uri)
    request['X-Requested-With'] = 'XMLHttpRequest'
    request.set_form_data(
      'collection_code' => collection_code,
      'sublibrary' => sublibrary,
      'callno' => callno
    )
    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    begin
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.read_timeout = 30 # Default is 60 seconds
        http.request(request)
      end
      if response['content-type'] == 'application/json'
        response.body
      else
        false
      end
    rescue Net::ReadTimeout => e
      Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
      false
    end
  end
end
