# frozen_string_literal: true

require 'test_helper'

class KomponentHelperTest < ActionView::TestCase
  def test_helper_renders_makes_locals_available_as_instance_variables
    assert_equal %(<div class="world">🌎</div>), component('world', world: "🌎").chomp
  end

  def test_helper_makes_all_properties_accessible
    assert_equal \
      %(<div class="all">🌎 😎</div>),
      component('all', world: "🌎", sunglasses: "😎").chomp
  end
end
