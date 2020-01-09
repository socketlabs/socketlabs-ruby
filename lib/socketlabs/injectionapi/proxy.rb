module SocketLabs
  module InjectionApi

    # Represents a http proxy.
    class Proxy

      # The name of the proxy hostname
      attr_accessor :host
      # The value of the proxy port
      attr_accessor :port

      def initialize (
          host= nil,
          port= nil
      )
        @host = host
        @port = port
      end

      # Returns the Proxy as a string.
      # @return [String]
      def to_s
        "#{@host}:#{@port}"
      end

    end

  end
end