# frozen_string_literal: true

module KomponentHelper
  def component(component_name, locals = {}, options = {}, &block)
    captured_block = proc { |args| capture(args, &block) } if block_given?
    Komponent::ComponentRenderer.new(
      controller,
    ).render(
      component_name,
      locals,
      options,
      &captured_block
    )
  end
  alias :c :component

  def komponent_components
    Komponent::Component.all
  end

  def component_with_doc(component_name, locals = {}, options = {}, &block)
    captured_output = component(component_name, locals, options, &block)

    if locals.present?
      pretty_locals = JSON.pretty_generate(locals).gsub(/^(\s+)"(\w+)":/, "\\1\\2:")
    end

    captured_doc = capture do
      content_tag :pre, class: "komponent-code" do
        content_tag :code do
          "= component \"#{component_name}\"" + (pretty_locals ? ", #{pretty_locals}" : "")
        end
      end
    end

    captured_output + captured_doc
  end
  alias :cdoc :component_with_doc
end
