# frozen_string_literal: true

require "komponent/version"

module Komponent
  require 'komponent/railtie' if defined?(Rails)
end
