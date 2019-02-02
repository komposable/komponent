# frozen_string_literal: true

require 'komponent/component'

module KomponentHelper
  def component(component_name, locals = {}, options = {}, &block)
    captured_block = proc { |args| capture(args, &block) } if block_given?
    Komponent::ComponentRenderer.new(
      controller,
      view_flow || (view && view.view_flow),
    ).render(
      component_name,
      locals,
      options,
      &captured_block
    )
  end
  alias :c :component

  def components
    Komponent::Component.all
  end

  def component_with_doc(component_name, locals = {}, options = {}, &block)
    captured_output = component(component_name, locals, options, &block)

    captured_doc = capture do
      content_tag :pre, class: "komponent-code" do
        content_tag :code do
          "= component \"#{component_name}\"" + (locals.present? ? ", #{pretty_locals(locals)}" : "")
        end
      end
    end

    captured_output + captured_doc
  end
  alias :cdoc :component_with_doc

  private

  def pretty_locals(locals)
    return nil if locals.blank?
    JSON.pretty_generate(locals).gsub(/^(\s+)"(\w+)":/, "\\1\\2:")
  end
end
