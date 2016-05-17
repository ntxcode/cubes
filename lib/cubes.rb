require_relative 'cubes/version'
require_relative 'cubes/client'
require_relative 'cubes/request'
require_relative 'cubes/cube'
require_relative 'cubes/error'
require_relative 'cubes/middleware/raise_error'

module Cubes
  class << self
    attr_writer :client

    def client
      @client ||= Cubes::Client.new
    end

    def cube(name)
      @client.cube(name)
    end
  end
end