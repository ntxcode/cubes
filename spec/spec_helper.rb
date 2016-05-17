$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'cubes'
require 'webmock/rspec'
require 'byebug'
WebMock.disable_net_connect!
