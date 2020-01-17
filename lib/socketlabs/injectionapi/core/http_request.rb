class HttpClient
  attr_reader :host, :request_headers, :url_path, :request, :http
  # * *Args*    :
  #   - +host+ -> Base URL for the api. (e.g. https://api.sendgrid.com)
  #   - +request_headers+ -> A hash of the headers you want applied on
  #                          all calls
  #   - +version+ -> The version number of the API.
  #                  Subclass add_version for custom behavior.
  #                  Or just pass the version as part of the URL
  #                  (e.g. client._("/v3"))
  #   - +url_path+ -> A list of the url path segments
  #   - +proxy_options+ -> A hash of proxy settings.
  #                        (e.g. { host: '127.0.0.1', port: 8080 })
  #
  def initialize(host: nil,  url_path: nil, http_options: {}, proxy_options: {}) # rubocop:disable Metrics/ParameterLists
    @host = host
    @request_headers = request_headers || {}
    @version = version
    @url_path = url_path || []
    @methods = %w[delete get patch post put]
    @query_params = nil
    @request_body = nil
    @http_options = http_options
    @proxy_options = proxy_options
  end



  # Build the API request for HTTP::NET
  #
  # * *Args*    :
  #   - +name+ -> method name, received from method_missing
  #   - +args+ -> args passed to the method
  # * *Returns* :
  #   - A Response object from make_request
  #
  def build_request(name, args)
    build_args(args) if args
    uri = build_url(query_params: @query_params)
    @http = build_http(uri.host, uri.port)
    net_http = Kernel.const_get('Net::HTTP::' + name.to_s.capitalize)
    @request = build_request_headers(net_http.new(uri.request_uri))
    if @request_body &&
        (!@request_headers.key?('Content-Type') ||
            @request_headers['Content-Type'] == 'application/json')

      @request.body = @request_body.to_json
      @request['Content-Type'] = 'application/json'
    elsif !@request_body && (name.to_s == 'post')
      @request['Content-Type'] = ''
    else
      @request.body = @request_body
    end
    @http_options.each do |attribute, value|
      @http.send("#{attribute}=", value)
    end
    make_request(@http, @request)
  end

  # Make the API call and return the response. This is separated into
  # it's own function, so we can mock it easily for testing.
  #
  # * *Args*    :
  #   - +http+ -> NET:HTTP request object
  #   - +request+ -> NET::HTTP request object
  # * *Returns* :
  #   - Response object
  #
  def make_request(http, request)
    response = http.request(request)
    Response.new(response)
  end

  # Build HTTP request object
  #
  # * *Returns* :
  #   - Request object
  def build_http(host, port)
    params = [host, port]
    params += @proxy_options.values_at(:host, :port, :user, :pass) unless @proxy_options.empty?
    add_ssl(Net::HTTP.new(*params))
  end

end