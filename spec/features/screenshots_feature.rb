# This tells config/initializers/theme_loader.rb to load the standard alavetelitheme
ALAVETELI_TEST_THEME = 'alavetelitheme'

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../integration/alaveteli_dsl')

describe 'Take Pro marketing screenshots', js: true do
  # Allow connections to selenium
  before do
    WebMock.disable_net_connect!(allow_localhost: true)
    Capybara.server = :webrick
  end

  let(:pro_user) { FactoryBot.create(:pro_user) }
  let!(:pro_user_session) { login(pro_user) }
  let!(:public_body) { FactoryBot.create(:public_body, :name => 'example') }

  it "Pro dashboard" do
    using_pro_session(pro_user_session) do
      9.times do
        FactoryBot.create(:info_request, :embargoed, user: pro_user)
      end
      1.times do
        FactoryBot.create(:info_request, :embargoed, :overdue, user: pro_user)
      end
      45.times do
        FactoryBot.create(:info_request, :embargoed, :very_overdue, user: pro_user)
      end
      6.times do
        FactoryBot.create(:info_request, :embargoed, :with_incoming, :awaiting_description, user: pro_user)
      end
      4.times do
        FactoryBot.create(:info_request, :embargoed, :with_incoming, :waiting_clarification, user: pro_user)
      end
      11.times do
        FactoryBot.create(:info_request, :embargoed, :with_incoming, :successful, user: pro_user)
      end
      5.times do
        FactoryBot.create(:info_request, :embargoed, :with_incoming, :attention_requested, user: pro_user)
      end
      15.times do
        FactoryBot.create(:draft_info_request, user: pro_user)
      end

      visit "/"
      page.save_screenshot(File.join(Rails.root, "dashboard.png"))
    end
  end
end
