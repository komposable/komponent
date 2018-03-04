# frozen_string_literal: true

require 'aruba/cucumber'

Aruba.configure do |config|
  config.io_wait_timeout = 15
end
