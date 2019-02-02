# frozen_string_literal: true

require 'simplecov'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../fixtures/my_app/config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/pride'

class FakeController < ApplicationController
  def initialize(method_name = nil, &method_body)
    if method_name and block_given?
      self.class.send(:define_method, method_name, method_body)
      Rails.application.routes.draw do
        get method_name, to: "fake##{method_name}"
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
