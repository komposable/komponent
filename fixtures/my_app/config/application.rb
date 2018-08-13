require_relative 'boot'

# require 'rails/all'
require "active_model/railtie"
require "active_job/railtie"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module MyApp
  class Application < Rails::Application
    config.i18n.load_path += Dir[config.root.join('frontend/components/**/*.*.yml')]
  end
end
