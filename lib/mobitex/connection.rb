module Mobitex

  class Connection
    attr_reader :site, :user, :pass

    def initialize(site, user = nil, pass = nil)
      raise ArgumentError, 'Missing site URI' unless site

      self.site = site
      self.user = user
      self.pass = pass
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

    attr_writer :user, :pass

    # Set URI for remote service.
    def site=(site)
      @site = site.is_a?(URI) ? site : URI.parse(site)
    end

    # Makes a request to the remote service.
    def request(method, path, params = {})
      params = {:user => user, :pass => pass}.merge(params)
      response = http.send(method, path, query(params))
      handle_response(response)
    rescue Net::HTTP::Timeout::Error => e
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
      Net::HTTP.new(@site.host, @site.port)
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
