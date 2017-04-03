module Asot
  # used capybara spec to salseforce
  module SfdcHelper
    def login_to_production(username, password)
      login('login', username, password)
    end

    def login_to_sandbox(username, password)
      login('test', username, password)
    end

    def select_application(app_name)
      within 'div#tsidButton' do
        return if find('#tsidLabel').text.eql?(app_name)
      end

      find('div#tsidButton').click
      within 'div#tsid-menuItems' do
        click_link app_name
      end
    end

    def select_tab(tab_name)
      within(:xpath, '//ul[@id="tabBar"]') do
        find(:xpath, %(.//a[text()=\"#{tab_name}\"])).trigger('click')
      end
    end

    def standard_save
      within(:xpath, '//div[@class="pbHeader"]') do
        find(:xpath, './/input[@title="保存"]').click
      end
    end

    def current_url_id
      a = current_url.split('/')
      a.last
    end

    private

      def login(env, username, password)
        visit "https://#{env}.salesforce.com/?locale=jp"
        fill_in 'ユーザ名', with: username
        fill_in 'パスワード', with: password
        click_button 'ログイン'
      end
  end
end
