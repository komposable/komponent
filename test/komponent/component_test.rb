# frozen_string_literal: true

require 'test_helper'

class ComponentTest < ActionView::TestCase
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

  def test_returns_example_view
    assert_equal \
      "components/foo/example",
      Komponent::Component.new("foo").example_view
  end
end
