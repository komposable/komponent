# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  def test_view_only
    post(:view_only)
    assert_response :ok
    assert_select '#view_only', "hello from view"
  end

  def test_partial_render
    post(:partial_render)
    assert_response :ok
    assert_select '#some_partial', "hello from partial"
  end

  def test_komponent_render
    post(:komponent_render)
    assert_response :ok
    assert_select '.bar', "hello from bar"
  end

  def test_komponent_partial_render
    post(:komponent_partial_render)
    assert_response :ok
    assert_select '.bar', "hello from bar"
    assert_select '#some_partial', "hello from partial"
  end
end
