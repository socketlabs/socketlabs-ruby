require 'net/https'
require 'net/http'

require_relative '../../version.rb'
require_relative 'injection_response_parser'

module SocketLabs
  module InjectionApi
    module Core
      class HttpRequest

        public
        # Hash enumeration of HTTP Request Methods
        def self.http_request_method
          {
              :Get => { :method => "GET" },
              :Post => { :method => "POST" },
              :Put => { :method => "PUT" },
              :Delete => { :method => "DELETE" }
          }
        end

        # The HTTP Request Method to use
        attr_reader :request_method
        # The SocketLabs Injection API endpoint
        attr_reader :endpoint
        # The Proxy to use when making the HTTP request
        attr_reader :proxy
        # The Net::HTTP used when making the HTTP request
        attr_reader :http

        # @param [Hash] http_request_method
        # @param [Hash] arguments:
        #       http_endpoint = The SocketLabs Injection API endpoint
        #       proxy = hash of proxy settings. ex: { host: '127.0.0.1', port: 8080 }
        def initialize(
            http_request_method,
            arguments = nil
        )
          @request_method = http_request_method
          @endpoint = "https://inject.socketlabs.com/api/v1/email"
          @proxy = Array.new

          unless arguments.nil? || arguments.empty?

            unless arguments[:http_endpoint].nil? || arguments[:http_endpoint].empty?
              @endpoint = arguments[:http_endpoint]
            end

            unless arguments[:proxy].nil? || arguments[:proxy].empty?
              @proxy = arguments[:proxy]
            end

          end

          @http = nil
          @request = build_request
        end

        # Send the HTTP Request
        # @param [InjectionRequest]
        def send_request(request)

          factory_hash = request.to_hash
          @request.body = factory_hash.to_json

          # send request
          response = @http.request(@request)
          http_response = HttpResponse.new(response)

          parser = InjectionResponseParser.new
          parser.parse(http_response)

        end

        private
        # The User-Agent request header added to the Injection API Http request.
        # Used to identify the source of the request.
        # @return [String] the SocketLabs User-Agent
        def user_agent
          "SocketLabs-ruby/#{VERSION};ruby(#{RUBY_VERSION})"
        end

        # headers to add to the request
        def headers
          [
              { :key => "User-Agent", :value => user_agent},
              { :key => "Content-Type", :value => "application/json; charset=utf-8" },
              { :key => "Accept", :value => "application/json"}
          ]
        end

         # add request headers
        # @param [HTTP::NET] request: the request object
        # @return [HTTP::NET] the resulting request
        def add_request_headers(request)

          request.add_field('Content-Type', 'application/json')
          headers.each do |item|
            request[item[:key]] = item[:value]
          end
          request
        end

        # Build the API request for HTTP::NET
        def build_request

          uri = URI.parse(@endpoint)
          # add uri
          params = [uri.host, uri.port]
          # add proxy
          params += @proxy.values_at(:host, :port, :user, :pass) unless @proxy.empty?

          @http = Net::HTTP.new(*params)
          # add ssl
          if @endpoint.start_with?('https')
            @http.use_ssl = true
            @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          end

          net_http = Kernel.const_get('Net::HTTP::' + @request_method[:method].capitalize)
          @request = add_request_headers(net_http.new(uri.request_uri))

        end

      end






    end
  end
end