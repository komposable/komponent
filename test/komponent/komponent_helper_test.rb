# frozen_string_literal: true

require 'test_helper'

class KomponentHelperTest < ActionView::TestCase
  def test_helper_raises_component_missing_error
    assert_raise Komponent::ComponentPathResolver::MissingComponentError do
      component('missing')
    end
  end

  def test_helper_renders_namespaced_component
    assert_equal \
      %(<div class="namespaced-button">namespaced_button_component</div>),
      component('namespaced/button').chomp
  end

  def test_helper_renders_makes_locals_available_as_instance_variables
    assert_equal \
      %(<div class="world">🌎</div>),
      component('world', world: "🌎").chomp
  end

  def test_helper_makes_all_properties_accessible
    assert_equal \
      %(<div class="all">🌎 😎</div>),
      component('all', world: "🌎", sunglasses: "😎").chomp
  end

  def test_helper_renders_localized_keys
    I18n.locale = :en
    assert_equal \
      %(<div class="hello">Hello</div>),
      component('hello').chomp

    I18n.locale = :fr
    assert_equal \
      %(<div class="hello">Bonjour</div>),
      component('hello').chomp
  end

  def test_helper_renders_default_property
    assert_equal \
      %(<div class="foo">Foobar</div>),
      component('foo').chomp
  end

  def test_helper_raises_error_with_property_required_not_provided
    assert_raise 'Missing required component parameter: required' do
      component('required')
    end
  end

  def test_helper_renders_with_block
    assert_equal \
      %(<div class="bar">Bar</div>),
      component('bar') { "Bar" }.chomp
  end

  def test_helper_renders_yield_args
    assert_equal \
      %(<div class="foo-bar">Foo Bar</div>),
      component('foo_bar') { |x| x }.chomp
  end

  def test_helper_lists_components
    assert_equal(
      [
        'all',
        'bar',
        'foo',
        'foo_bar',
        'hello',
        'required',
        'world',
      ],
      komponent_components.keys
    )
  end

  def test_helper_renders_with_doc
    assert_equal \
      %(<div class="all">🌎 😎</div>
<pre class="komponent-code"><code>= component &quot;all&quot;, {
  world: &quot;🌎&quot;,
  sunglasses: &quot;😎&quot;
}</code></pre>),
      component_with_doc('all', world: "🌎", sunglasses: "😎").chomp
  end
end
