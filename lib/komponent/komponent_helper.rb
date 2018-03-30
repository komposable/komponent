# frozen_string_literal: true

module KomponentHelper
  def component(component, locals = {}, &block)
    Komponent::ComponentRenderer.new(
      controller,
    ).render(
      component,
      locals,
      &block
    )
  end
  alias :c :component

  # :nocov:
  def render_partial(partial_name, locals = {}, &block)
    warn "[DEPRECATION WARNING] `render_partial` is deprecated. Please use default `render` instead."

    context = controller.view_context
    view_paths = context.lookup_context.view_paths.dup
    components_path = Rails.root.join "frontend/components"

    capture_block = proc { capture(&block) } if block

    current_dir = Pathname.new(@virtual_path).dirname

    context.lookup_context.prefixes.prepend current_dir
    context.lookup_context.view_paths.unshift components_path

    rendered_partial = capture do
      context.render partial_name, locals, &capture_block
    end

    context.lookup_context.prefixes.delete current_dir
    context.lookup_context.view_paths = view_paths

    rendered_partial
  end
  # :nocov:
end
