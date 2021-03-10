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
  let(:kingston) { FactoryBot.create(:public_body, name: "Kingston Hospital NHS Trust") }
  let(:kent) { FactoryBot.create(:public_body, name: "Kent Police") }
  let(:defence) { FactoryBot.create(:public_body, name: "Ministry of Defence") }
  let(:stirling) { FactoryBot.create(:public_body, name: "Stirling Council") }

  it "Pro dashboard" do
    using_pro_session(pro_user_session) do
      Timecop.freeze(5.days.ago) do
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
        5.times do
          FactoryBot.create(:info_request, :embargoed, :with_incoming, :successful, user: pro_user)
        end
        6.times do
          FactoryBot.create(:info_request, :embargo_expiring, :with_incoming, :successful, user: pro_user)
        end
        5.times do
          FactoryBot.create(:info_request, :embargoed, :with_incoming, :attention_requested, user: pro_user)
        end
        15.times do
          FactoryBot.create(:draft_info_request, user: pro_user)
        end
        5.times do
          r = FactoryBot.create(:info_request, :embargoed, user: pro_user)
          r.info_request_events.first.update(created_at: 2.days.ago)
        end
      end

      Timecop.freeze(190.minutes.ago) do
        FactoryBot.create(:info_request, :embargoed, user: pro_user, title: "Refugee housing provision 2016", public_body: stirling)
      end
      Timecop.freeze(130.minutes.ago) do
        FactoryBot.create(:info_request, :embargoed, user: pro_user, title: "Meeting details", public_body: defence)
      end
      Timecop.freeze(70.minutes.ago) do
        FactoryBot.create(:info_request, :embargoed, user: pro_user, title: "Arrest and cautions 2016", public_body: kent)
        FactoryBot.create(:info_request, :embargoed, user: pro_user, title: "Bed provision", public_body: kingston)
      end

      visit "/"

      path = page.save_screenshot("screenshot.png")
      i = Magick::ImageList.new(path)
      cropped = i.crop(55, 155, 1159, 784)
      cropped.write(File.join(Rails.root, "app", "assets", "images", "alaveteli-pro", "screenshot-dashboard.jpg"))
    end
  end
end
