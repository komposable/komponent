# frozen_string_literal: true

require 'webpacker'
require 'komponent/core/component_helper'
require 'komponent/core/translation'
require 'komponent/core/component_path_resolver'

module Komponent
  class Railtie < Rails::Railtie
    config.komponent = ActiveSupport::OrderedOptions.new
    config.komponent.root = nil
    config.komponent.component_paths = []

    config.before_configuration do |app|
      app.config.komponent.root = app.config.root.join("frontend")
      app.config.komponent = config.komponent
    end

    config.after_initialize do |app|
      app.config.komponent.component_paths.prepend(
        app.config.komponent.root.join("components")
      )

      ActiveSupport.on_load :action_view do
        require 'komponent/komponent_helper'
        include KomponentHelper
      end

      ActiveSupport.on_load :action_controller do
        ActionController::Base.prepend_view_path(
          app.config.komponent.root
        )
      end
    end
  end
end
