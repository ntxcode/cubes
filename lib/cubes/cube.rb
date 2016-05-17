module Cubes
  class Cube
    def initialize(name, conn)
      @name = name
      @conn = conn

      # preload the model
      model
    end

    def aggregate(params = {})
      request.get('aggregate', params)
    end

    def model
      @model ||= request.get('model')
    end

    def facts(params = {})
      request.get('facts', params)
    end

    def fact(id)
      request.get("fact/#{id}")
    end

    def members(dim, params = {})
      request.get("members/#{dim}", params)
    end

    def report(data = {}, params = {})
      request.post('report', { queries: data }, params)
    end

    private

    def request
      Cubes::Request.new(@conn, prefix: "/cube/#{@name}")
    end
  end
end
