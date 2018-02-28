require_relative 'boot'

# require 'rails/all'
require "active_model/railtie" 
require "active_job/railtie"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require "action_view/railtie" 
require "sprockets/railtie" 

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
