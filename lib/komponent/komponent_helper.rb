# frozen_string_literal: true

module KomponentHelper
  def component(component_name, locals = {}, options = {}, &block)
    captured_block = proc { |args| capture(args, &block) } if block_given?
    Komponent::ComponentRenderer.new(
      controller,
      view_flow,
    ).render(
      component_name,
      locals,
      options,
      &captured_block
    )
  end
  alias :c :component
end
