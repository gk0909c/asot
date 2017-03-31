require 'asot/version'
require 'asot/sfdc_helper'
require 'asot/rest/connector'

# module for Automate Salesforce Operation Test
module Asot
  def self.connect(config)
    Rest::Connector.new(config)
  end
end
