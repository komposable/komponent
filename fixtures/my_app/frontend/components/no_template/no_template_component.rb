module NoTemplateComponent
  extend ComponentHelper

  render do |block|
    content_tag :div, class: "no-template #{@additional_class}" do
      block.call
    end
  end
end
