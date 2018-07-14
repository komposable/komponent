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
    captured_block = proc { |args| capture(args, &block) } if block_given?
    captured_output = capture do
      Komponent::ComponentRenderer.new(
        controller,
      ).render(
        component_name,
        locals,
        options,
        &captured_block
      )
    end

    captured_doc = capture do
      content_tag :pre, class: "komponent-code" do
        content_tag :code do
          "= component \"#{component_name}\", #{locals.to_s.gsub(/(:(\w+)\s?=>\s?)/, "\\2: ")}"
        end
      end
    end

    captured_output + captured_doc
  end
  alias :cdoc :component_with_doc
end
