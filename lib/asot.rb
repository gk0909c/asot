require 'asot/version'
require 'asot/rest/connector'

module Asot
  def self.connect(config)
    Connector.new(config)
  end
end
