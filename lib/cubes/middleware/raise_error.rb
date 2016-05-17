module Cubes
  module Middleware
    class RaiseError < Faraday::Response::Middleware
      # Handle client errors
      #
      # @param env [Env]
      def on_complete(env)
        response = JSON.parse env.body

        if response.is_a?(Hash) && response['error'] == 'not_found'
          raise Cubes::Error::ResourceNotFound.new(response[:message])
        end

        if env[:status] == 404
          raise Cubes::Error::RouteNotFound.new('Route not found.')
        end
      end
    end
  end
end