require 'capybara/rspec'
require 'selenium-webdriver'
require 'capybara/poltergeist'
require 'spec_helper'

Capybara.default_driver = :selenium
Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 5

RSpec.describe Asot::SfdcHelper, type: feature, js: true do
  include Capybara::DSL
  include Asot::SfdcHelper

  subject { Capybara.current_session }

  before do
    allow(subject).to receive(:visit)
    allow(subject).to receive(:within) { |_, &block| block.call }
    allow(subject).to receive(:fill_in)
    allow(subject).to receive(:click)
    allow(subject).to receive(:click_button)
    allow(subject).to receive(:click_link)
  end

  describe 'login_to_production' do
    it 'is visit login.salesforce.com' do
      login_to_production('', '')

      expect(subject).to have_received(:visit).with('https://login.salesforce.com/?locale=jp').once
      expect(subject).to have_received(:fill_in).with('ユーザ名', with: '').once
      expect(subject).to have_received(:fill_in).with('パスワード', with: '').once
      expect(subject).to have_received(:click_button).with('ログイン').once
    end
  end

  describe 'login_to_sandbox' do
    it 'is visit test.salesforce.com' do
      login_to_sandbox('', '')

      expect(subject).to have_received(:visit).with('https://test.salesforce.com/?locale=jp').once
      expect(subject).to have_received(:fill_in).with('ユーザ名', with: '').once
      expect(subject).to have_received(:fill_in).with('パスワード', with: '').once
      expect(subject).to have_received(:click_button).with('ログイン').once
    end
  end

  describe 'select_application' do
    let(:tsidLabel) { Object.new }
    before do
      def tsidLabel.text() 'App2' end
      allow(subject).to receive(:find).with('#tsidLabel').and_return(tsidLabel)
      allow(subject).to receive(:find).with('div#tsidButton').and_return(subject)
    end

    context 'app is not selected' do
      it 'click app name' do
        select_application('App1')
        expect(subject).to have_received(:find).with('div#tsidButton').at_least(:once)
        expect(subject).to have_received(:click_link)
      end
    end

    context 'app is not selected' do
      it 'click app name' do
        select_application('App2')
        expect(subject).not_to have_received(:find).with('div#tsidButton')
        expect(subject).not_to have_received(:click_link)
      end
    end
  end

  describe 'select_tab' do
    let(:tab) { Object.new }
    before do
      allow(subject).to receive(:find).and_return(tab)
      allow(tab).to receive(:trigger)
    end

    it 'trigger element click' do
      select_tab('Tab1')
      expect(subject).to have_received(:find).with(:xpath, './/a[text()="Tab1"]')
      expect(tab).to have_received(:trigger).with('click')
    end
  end

  describe 'standard_save' do
    let(:button) { Object.new }
    before do
      allow(subject).to receive(:find).and_return(button)
      allow(button).to receive(:click)
    end

    it 'trigger element click' do
      standard_save
      expect(button).to have_received(:click)
    end
  end

  describe 'current_url_id' do
    before do
      allow(subject).to receive(:current_url).and_return('https://test.com/abc/someId')
    end
    let!(:id) { current_url_id }

    it 'trigger element click' do
      expect(subject).to have_received(:current_url)
      expect(id).to eq('someId')
    end
  end
end
