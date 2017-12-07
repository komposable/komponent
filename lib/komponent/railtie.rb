require 'komponent/komponent_helper'
require 'komponent/core/component_helper'

module Komponent
  class Railtie < Rails::Railtie
    initializer "komponent.helper" do |app|
      ActionView::Base.send :include, KomponentHelper
    end

    initializer 'komponent.autoload', before: :set_autoload_paths do |app|
      app.config.autoload_paths << "#{app.config.root}/frontend"
    end
  end
end
