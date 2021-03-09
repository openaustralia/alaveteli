require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Take Pro marketing screenshots', js: true do
  # Allow connections to selenium
  before do
    WebMock.disable_net_connect!(allow_localhost: true)
    Capybara.server = :webrick
  end

  it "home page" do
    visit "/"
    page.save_screenshot(File.join(Rails.root, "home.png"))
  end
end
