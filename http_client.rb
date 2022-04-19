require 'net/http'
require 'json'

class HTTPClient
  def put(url, headers)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Put.new(uri)

    headers.each do |key, value|
      request[key] = value
    end

    http.request(request)
  end

  def post(url, body)
    uri = URI(url)
    Net::HTTP.post_form(uri, body)
  end
end
