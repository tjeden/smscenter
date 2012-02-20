require 'net/http'
require 'mobitex/connection_errors'

module Mobitex

  class Connection
    attr_reader :endpoint

    def initialize(endpoint)
      raise ArgumentError, 'Missing endpoint URI' unless endpoint

      self.endpoint = endpoint
    end

    # Executes a GET request.
    # Used to get (find) resources.
    def get(path, params = {})
      request(:get, path, params)
    end

    # Executes a POST request.
    # Used to create new resources.
    def post(path, params = {})
      request(:post, path, params)
    end

    private

    # Set URI for remote service.
    def endpoint=(endpoint)
      @endpoint = endpoint.is_a?(URI) ? endpoint : URI.parse(endpoint)
    end

    # Makes a request to the remote service.
    def request(method, path, params = {})
      response = http.send(method, path, query(params))
      handle_response(response)
    rescue Timeout::Error => e
      raise TimeoutError.new(e.message)
    end

    def query(params)
      require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
      params.map{ |k, v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join('&')
    end

    # Handles response and error codes from the remote service.
    def handle_response(response)
      case response.code.to_i
        when 301, 302  then raise(Redirection.new(response))
        when 200...400 then response
        when 400...500 then raise(ClientError.new(response))
        when 500...600 then raise(ServerError.new(response))
        else                raise(ConnectionError.new(response, "Unknown response code: #{response.code}"))
      end
    end

    # Creates new Net::HTTP instance for communication with the remote service.
    def http
      configure_http(new_http)
    end

    def new_http
      Net::HTTP.new(@endpoint.host, @endpoint.port)
    end

    def configure_http(http)
      # Net::HTTP timeouts default to 60 seconds.
      if @timeout
        http.open_timeout = @timeout
        http.read_timeout = @timeout
      end

      http
    end

  end

end
