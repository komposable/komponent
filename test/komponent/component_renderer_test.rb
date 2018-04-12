# frozen_string_literal: true

require 'test_helper'

class ComponentRendererTest < ActionController::TestCase
  include CachingHelper

  def setup
    controller = FakeController.new
    @renderer = Komponent::ComponentRenderer.new(controller)
  end

  def test_methods_are_accessible_in_context
    @renderer.render('all', text: 'hello world')

    @context = @renderer.context
    assert_respond_to @context, :block_given_to_component?
    assert_respond_to @context, :block_given_to_component
    assert_respond_to @context, :properties
    assert_respond_to @context, :translate
  end

  def test_instance_variables_are_accessible_in_context
    @renderer.render('all', text: 'hello world')

    @context = @renderer.context
    assert_equal @context.instance_variable_get(:'@text'), 'hello world'
  end

  def test_rendering_component_with_block_given
    @renderer.render('all') do
      "<p>HELLO</p>"
    end

    @context = @renderer.context
    assert_equal @context.block_given_to_component?, true
    assert_equal @context.block_given_to_component.class, Proc
    assert_equal @context.block_given_to_component.call, "<p>HELLO</p>"
  end

  def test_rendering_component_without_block_given
    @renderer.render('all')

    @context = @renderer.context
    assert_equal @context.block_given_to_component?, false
    assert_nil @context.block_given_to_component
  end

  def test_rendering_with_cache_enabled
    with_caching do
      @renderer.render('all', {}, cached: true)

      key = ['all', {}, {}, nil].to_s
      cache_key = Digest::SHA1.hexdigest(key)

      @context = @renderer.context
      assert_equal \
        %(<div class="all"></div>),
        Rails.cache.fetch(cache_key).chomp
    end
  end
end
