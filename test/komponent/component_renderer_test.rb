# frozen_string_literal: true

require 'test_helper'

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

class ComponentRendererTest < ActionController::TestCase
  def test_methods_are_accessible_in_context
    @controller = FakeController.new

    renderer = Komponent::ComponentRenderer.new(@controller)
    renderer.render('all', text: 'hello world')
    @context = renderer.context

    assert_respond_to @context, :block_given_to_component?
    assert_respond_to @context, :properties
    assert_respond_to @context, :translate

    assert_equal @context.instance_variable_get(:'@text'), 'hello world'
  end

  def test_block
    @controller = FakeController.new

    renderer = Komponent::ComponentRenderer.new(@controller)
    renderer.render('all') do
      "<p>HELLO</p>"
    end
    @context = renderer.context

    assert_equal @context.block_given_to_component?, true

    assert_equal @context.block_given_to_component.class, Proc
    assert_equal @context.block_given_to_component.call, "<p>HELLO</p>"
  end

  def test_without_block
    @controller = FakeController.new

    renderer = Komponent::ComponentRenderer.new(@controller)
    renderer.render('all')
    @context = renderer.context

    assert_equal @context.block_given_to_component?, false
    assert_nil @context.block_given_to_component
  end
end
