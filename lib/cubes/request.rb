require 'json'

module Cubes
  class Request
    # Initialize a Request
    #
    # @param conn [Faraday::Connection]
    # @param options [Hash]
    # @return [Cubes::Request]
    def initialize(conn, options = {})
      @conn = conn
      @prefix = options.fetch(:prefix, '/')
    end

    # Send a get request
    #
    # @param path [String]
    # @param params [Hash]
    # @return [JSON]
    def get(path, params = {})
      path = File.join(@prefix, path)
      JSON.parse @conn.get(path, params).body
    end

    # Send a post request
    #
    # @param path [String]
    # @param data [Hash]
    # @param params [Hash]
    # @return [JSON]
    def post(path, data = {}, params = {})
      body = data.to_json
      path = File.join(@prefix, path)

      response = @conn.post(path, body) do |req|
        req.params = params
        req.headers['Content-Type'] = 'application/json'
      end

      JSON.parse response.body
    end
  end
end