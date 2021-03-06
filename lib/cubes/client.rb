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
        config.use Cubes::Middleware::RaiseError
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
    # @return [Array[Cubes::Cube]]
    def cubes
      request.get('cubes').map do |cube|
        Cubes::Cube.new(cube['name'], @conn)
      end
    end

    # Instantiating a cube api
    #
    # @param name [String]
    # @return [Cubes::Cube]
    def cube(name)
      Cubes::Cube.new(name, @conn)
    end

    private

    # @return [Cubes::Request]
    def request
      Cubes::Request.new(@conn)
    end
  end
end
