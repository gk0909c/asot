require 'asot/version'
require 'asot/sfdc_helper'
require 'asot/rest/connector'

module Asot
  def self.connect(config)
    Rest::Connector.new(config)
  end
end
