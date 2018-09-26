module DulArgonHelper

  def dul_location_service (collection_code,sublibrary,callno)

    require 'net/http'
    require 'uri'

    uri = URI.parse("https://library.duke.edu/locguide/mapinfo")
    request = Net::HTTP::Post.new(uri)
    request["X-Requested-With"] = "XMLHttpRequest"
    request.set_form_data(
      "collection_code" => collection_code,
      "sublibrary" => sublibrary,
      "callno" => callno,
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    @item_location = JSON.parse(response.body)

  end

end
