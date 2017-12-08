class ComponentGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :component, required: true, desc: "Component name, e.g: button"

  def create_view_file
    template "view.html.slim.erb", component_path + "_#{component_name}.html.slim"
  end

  def create_css_file
    template "css.erb", component_path + "#{component_name}.css"
  end

  def create_js_file
    template "js.erb", component_path + "#{component_name}.js"
  end

  def create_rb_file
    template "rb.erb", component_path + "#{component_name}_component.rb"
  end

  def append_frontend_packs
    append_to_file "frontend/components/index.js" do
      "import \"components/#{component_name}/#{component_name}\";"
    end
  end

  protected

  def component_path
    "frontend/components/#{component_name}/"
  end

  def module_name
    "#{component_name}_component".camelize
  end
  
  def component_name
    component.underscore
  end
end
