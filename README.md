# Asot
help to Automate Salesforce Operation Test.

## require
+ rspec
+ capybara
+ selenium-webdriver

## setup
config at your spec_spec_helpers.rb
```ruby
require 'asot'

RSpec.configure do |config|
  # your settings 

  # asot setting
  config.include Asot::SfdcHelper

  config.add_setting :sfdc
  config.before(:suite) do
    config = {
      endpoint: 'https://login.salesforce.com/services/Soap/u/38.0',
      username: 'your salesforce user name',
      password: 'your salesforce password',
      security_token: 'your salesforce security token'

    }
    connector = Asot.connect(config)
    RSpec.configuration.sfdc = connector
  end

  config.after(:suite) do
    sfdc = RSpec.configuration.sfdc
    break unless sfdc.do_clean?

    res = JSON.parse(sfdc.clean_testdata)
    if res['hasErrors']
      res['results'].select { |r| !r['statusCode'].to_s.start_with?('2') }. each do |r|
        puts r['result']
      end
    end
  end
end
```
