# frozen_string_literal: true

module KomponentHelper
  def component(component_name, locals = {}, options = {}, &block)
    capture_block = proc { capture(&block) } if block_given?

    Komponent::ComponentRenderer.new(
      controller,
    ).render(
      component_name,
      locals,
      options,
      &capture_block
    )
  end
  alias :c :component
end
