require 'komponent/komponent_helper'
require 'komponent/core/component_helper'

module Komponent
  class Railtie < Rails::Railtie
    initializer "komponent.helper" do |app|
      ActionView::Base.send :include, KomponentHelper
    end
  end
end
