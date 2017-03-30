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

## spec sample
```ruby
require 'spec_helper'

describe 'Account', type: feature, js: true do
  let(:sfdc) { RSpec.configuration.sfdc }
  let(:test_obj) { 'Account' }

  it 'is created via new page' do
    login_to_production('your username', 'your password')

    select_application 'Sales'
    select_tab 'Accounts'
    expect(page).to have_content('Recent Accounts')

    click_button 'New'
    expect(page).to have_content('New Account')

    fill_in 'Account Name', with: 'Asot Company'
    standard_save
    expect(page).to have_content('Account Detail')

    # asot can clean data on sfdc after spec suite.
    # you can add it with object reference name and record id.
    sfdc.add_clean_data(test_obj, current_url_id)
  end
end


```
