# <img alt="Komponent" src="https://raw.github.com/ouvrages/komponent/master/logo.svg?sanitize=true" width="200" height="40" />
[![Build Status](https://travis-ci.org/komposable/komponent.svg?branch=master)](https://travis-ci.org/komposable/komponent)
[![Gem](https://img.shields.io/gem/v/komponent.svg)](https://github.com/komposable/komponent)

**Komponent** implements an opinionated way of organizing front-end code in Ruby on Rails, based on _components_.

Each component has its own folder, containing a Ruby module, a partial, a stylesheet and a JavaScript file.

Komponent relies heavily on webpacker to manage dependencies and generate the production JS and CSS files.

This README examples are written in Slim, but Komponent is compatible with:

- your preferred templating language (Slim, Haml, erb)
- your stylesheet language of choice (Sass, SCSS, CSS, PostCSS)

This gem has been inspired by our Rails development practices at [Ouvrages](https://ouvrages-web.fr) and [Etamin Studio](https://etaminstudio.com), and the (excellent) [_Modern Front-end in Rails_](https://evilmartians.com/chronicles/evil-front-part-1) article from Evil Martians.

## Table of contents

- [Getting started](#getting-started)
- [Usage](#usage)
  - [Passing variables](#passing-variables)
  - [Passing a block](#passing-a-block)
  - [Properties](#properties)
  - [Helpers](#helpers)
  - [Component partials](#component-partials)
  - [Namespacing components](#namespacing-components)
  - [Stimulus integration](#stimulus-integration)
  - [Internationalization](#internationalization)
  - [Configuration](#configuration)
    - [Change default root path](#change-default-root-path)
    - [Default options for the generators](#default-options-for-the-generators)
    - [Additional paths](#additional-paths)
- [Contributing](#contributing)
- [License](#license)

## Getting started

```ruby
# Gemfile

gem "komponent"
```

Run the following command to set up your project instantly:

```sh
rails generate komponent:install
```

This command will:

* check that the dependencies (currently, webpacker) are installed
* rename the `app/javascript` folder to `frontend` and modify webpacker config accordingly
* create the `frontend/components` folder where you will put your component
* create the `frontend/components/index.js` file that will list your components and `import` it in `frontend/packs/application.js`

## Usage

Generate a new component with the `component` generator:

```sh
rails generate component button
```

Then, render it in your views with the `component` helper (or its alias `c`).

```slim
/ app/views/pages/home.html.slim

= component "button"
= c "button"
```

Make sure to include javascript pack tag and stylesheet pack tag in your application layout file, for instance:

```slim
/ app/views/layouts/application.html.slim

doctype html
html
  head
    = stylesheet_pack_tag "application"

  body
    = yield
    = javascript_pack_tag "application"
```

Check [Webpacker documentation](https://github.com/rails/webpacker) for further information.

### Passing variables

You can pass `locals` to the helper. They are accessible within the component partial, as instance variables.

```slim
/ app/views/pages/home.html.slim

= component "button", text: "My button"
```

```slim
/ frontend/components/button/_button.html.slim

.button
  = @text
```

### Passing a block

The component also accepts a `block`. To render the block, just use the standard `yield`.

```slim
/ app/views/pages/home.html.slim

= component "button"
  span= "My button"
```

```slim
/ frontend/components/button/_button.html.slim

.button
  = yield
```

### Properties

Each component comes with a Ruby `module`. You can use it to set properties:

```ruby
# frontend/components/button/button_component.rb

module ButtonComponent
  property :href, required: true
  property :text, default: "My button"
end
```

```slim
/ frontend/components/button/_button.html.slim

a.button(href=@href)
  = @text
```

### Helpers

If your partial becomes too complex and you want to extract logic from it, you may want to define custom helpers in the `ButtonComponent` module:

```ruby
# frontend/components/button/button_component.rb

module ButtonComponent
  property :href, required: true
  property :text, default: "My button"

  def external_link?
    @href.starts_with? "http"
  end
end
```

```slim
/ frontend/components/button/_button.html.slim

a.button(href=@href)
  = @text
  = " (external link)" if external_link?
```

```slim
/ app/views/pages/home.html.slim

= component "button", text: "My button", href: "http://github.com"
```

### Component partials

You can also choose to split your component into partials. In this case, we can use the default `render` helper to render a partial, stored inside the component directory.

```slim
/ frontend/components/button/_button.html.slim

= a.button(href=@href)
  = @text
  = render("suffix", text: "external link") if external_link?
```

```slim
/ frontend/components/button/_suffix.html.slim

= " (#{text})"
```

### Namespacing components

To organize different types of components, you can group them in namespaces when you use the generator:

```sh
rails generate component admin/header
```

This will create the component in an `admin` folder, and name its Ruby module `AdminHeaderComponent`.


### Stimulus integration

Komponent supports [stimulus](https://github.com/stimulusjs/stimulus) 1.0.

You can pass `--stimulus` to both generators to use Stimulus in your components.

```sh
rails generate komponent:install --stimulus
```

This will yarn `stimulus` package, and create a `stimulus_application.js` in the `frontend` folder.

```sh
rails generate component button --stimulus
```

This will create a component with an additional `button_controller.js` file, and define a `data-controller` in the generated view.

### Internationalization

In case your component will contain text strings you want to localize, you can pass the `--locale` option to generate localization files in your component directory.

```sh
rails generate component button --locale
```

This will create a `yml` file for each locale (using `I18n.available_locales`). In your component, the `t` helper will use the same ["lazy" lookup](http://guides.rubyonrails.org/i18n.html#lazy-lookup) as Rails.

```slim
/ frontend/components/button/_button.html.slim

= a.button(href=@href)
  = @text
  = render("suffix", text: t(".external_link")) if external_link?
```

```yml
# frontend/components/button/button.en.yml

en:
  button_component:
    external_link: "external link"
```

```yml
# frontend/components/button/button.fr.yml

fr:
  button_component:
    external_link: "lien externe"
```

### Configuration

#### Default options for the generators

You can configure the generators in an initializer or in `application.rb`, so you don't have to add `--locale` and/or `--stimulus` flags every time you generate a fresh component.

```rb
config.generators do |g|
  g.komponent stimulus: true, locale: true # both are false by default
end
```

#### Change default root path

You can change the default root path (`frontend`) to another path where Komponent should be installed and components generated. You need to change `komponent.root` in an initializer.

```rb
Rails.application.config.komponent.root = Rails.root.join("app/frontend")
```

#### Additional paths

You may want to use components in a gem, or a Rails engine, and expose them to the main app. In order to do that, you just have to configure the paths where Komponent will look for components.

From a gem:

```rb
module MyGem
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      app.config.komponent.component_paths.append(MyGem.root.join("frontend/components"))
    end

    initializer "my_gem.action_dispatch" do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.prepend_view_path MyGem.root.join("frontend")
      end
    end

    initializer 'my_gem.autoload', before: :set_autoload_paths do |app|
      app.config.autoload_paths << MyGem.root.join("frontend")
    end
  end

  private

  def self.root
    Pathname.new(File.dirname(__dir__))
  end
end
```

or from an engine:


```rb
module MyEngine
  class Engine < Rails::Engine
    isolate_namespace MyEngine

    config.after_initialize do |app|
      app.config.komponent.component_paths.append(MyEngine::Engine.root.join("frontend/components"))
    end

    initializer "my_engine.action_dispatch" do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.prepend_view_path MyEngine::Engine.root.join("frontend")
      end
    end

    initializer 'my_engine.autoload', before: :set_autoload_paths do |app|
      app.config.autoload_paths << MyEngine::Engine.root.join("frontend")
    end
  end
end
```

Make sure you add `komponent` to the runtime dependencies in your `gemspec`.

In order to compile packs from engine, and to use `javascript_pack_tag 'engine'`, you need to:

- Create a pack file in main app

```js
// frontend/packs/engine.js

import 'packs/engine';
```

- Append engine frontend folder to `resolved_paths` in `config/webpacker.yml` from your main app

```yml
resolved_paths:
  - engine/frontend
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/komposable/komponent.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
