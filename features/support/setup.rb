require 'aruba/cucumber'
require 'capybara/cucumber'

Aruba.configure do |config|
  config.io_wait_timeout = 5
end

Before('@with_rails_app') do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../../fixtures/my_app/config/environment.rb", __FILE__)
  ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "../../fixtures/my_app"
  Capybara.app = Rails.application
end

After('@with_rails_app') do
  ENV["RAILS_ENV"] = nil
  ENV["RAILS_ROOT"] = nil
end
