# frozen_string_literal: true

require 'test_helper'

class ComponentTest < ActionView::TestCase
  def test_all_returns_components
    all = Komponent::Component.all

    assert all.is_a?(Hash)
    assert_equal all.count, 13
    assert all["foo"].is_a?(Komponent::Component)
  end

  def test_find_raises_exception_when_missing
    assert_raise Exception do
      Komponent::Component.find("missing")
    end
  end

  def test_find_returns_component
    assert \
      Komponent::Component.find("foo").is_a?(Komponent::Component)
    assert_equal \
      "foo",
      Komponent::Component.find("foo").id
  end

  def test_returns_title
    assert_equal \
      "Foo Bar",
      Komponent::Component.new("foo_bar").title
  end

  def test_returns_examples_view
    assert_equal \
      "components/foo/examples",
      Komponent::Component.new("foo").examples_view
  end

  def test_returns_path
    path = Komponent::Component.new("foo").path

    assert path.is_a?(Pathname)
    assert path.to_s.include?("frontend/components/foo")
  end
end
