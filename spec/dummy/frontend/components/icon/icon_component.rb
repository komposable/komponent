module IconComponent
  extend ComponentHelper

  def icon_type
    case @type
    when :ampersand
      "&"
    end
  end
end
