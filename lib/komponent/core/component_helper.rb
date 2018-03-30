# frozen_string_literal: true

module ComponentHelper
  def property(name, options = {})
    @properties[name] = options
  end

  attr_accessor :properties

  def self.extended(component)
    component.properties = {}
    component.class_eval do
      def block_given_to_component?
        @block_given_to_component.present?
      end
    end
  end
end
