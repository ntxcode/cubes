require 'faraday'

module Cubes
  class Client
    DEFAULT_BASE_URL = 'http://localhost:5000'

    # Initializes a new Client
    #
    # @param options [Hash]
    # @return [Cubes::Client]
    def initialize(options = {})
      @base_url = options[:base_url] || DEFAULT_BASE_URL
      @conn = Faraday.new(url: @base_url, headers: { 'Content-Type' => 'application/json' }) do |config|
        config.adapter :net_http_persistent
      end
    end

    # Return server information
    #
    # @return [Hash]
    def info
      request.get('info')
    end

    # Return server version
    #
    # @return [Hash]
    def version
      request.get('version')
    end

    # List all cubes
    #
    # @return [Array]
    def cubes
      request.get('cubes')
    end

    private

    # @return [Cubes::Request]
    def request
      Cubes::Request.new(@conn)
    end
  end
end
