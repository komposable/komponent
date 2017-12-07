module ComponentHelper
  def property(name, options = {})
    @properties[name] = options
  end

  attr_accessor :properties

  def self.extended(component)
    component.properties = {}
  end
end
