Feature: Component generator

  Scenario: Generate component
    Given I use a fixture named "my_app"
    When I run `rails generate component AwesomeButton`
    And I cd to "frontend/components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.erb     |
      | awesome_button/awesome_button.scss          |
      | awesome_button/awesome_button.js            |
      | awesome_button/awesome_button_component.rb  |
    And the file named "index.js" should contain:
    """
    import "components/awesome_button/awesome_button";
    """

  Scenario: Generate namespaced component
    Given I use a fixture named "my_app"
    When I run `rails generate component admin/sub_admin/AwesomeButton`
    And I cd to "frontend/components"
    Then the following files should exist:
      | admin/index.js                                                             |
      | admin/sub_admin/index.js                                                   |
      | admin/sub_admin/awesome_button/_admin_sub_admin_awesome_button.html.erb    |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.scss         |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.js           |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_component.rb |
    And the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/sub_admin";
    """
    And the file named "admin/sub_admin/index.js" should contain:
    """
    import "components/admin/sub_admin/awesome_button/admin_sub_admin_awesome_button";
    """

  Scenario: `imports` in JavaScript files are sorted alphabetically when generating component
    Given I use a fixture named "my_app"
    And I cd to "frontend/components"
    And a file named "index.js" with:
    """
    console.log("HELLO WORLD");
    """
    Then the file named "index.js" should contain:
    """
    console.log("HELLO WORLD");
    """
    When I run `rails generate component button`
    Then the file named "index.js" should contain:
    """
    import "components/button/button";
    """
    When I run `rails generate component awesome_button`
    Then the file named "index.js" should contain:
    """
    import "components/awesome_button/awesome_button";
    import "components/button/button";
    """
  Scenario: Generate component with `erb` template engine
    Given I use a fixture named "my_app"
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "_awesome_button.html.erb" should exist

  Scenario: Generate component with custom template engine defined to `haml`
    Given I use a fixture named "my_app"
    And I append to "Gemfile" with:
    """

    gem 'haml-rails'
    """
    When I run `bundle install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "_awesome_button.html.haml" should exist

  Scenario: Generate component with custom template engine defined to `slim`
    Given I use a fixture named "my_app"
    And I append to "Gemfile" with:
    """

    gem 'slim-rails'
    """
    When I run `bundle install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "_awesome_button.html.slim" should exist

  Scenario: Generate component with `scss` stylesheet engine
    Given I use a fixture named "my_app"
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "awesome_button.scss" should exist
    And the file named "awesome_button.js" should contain:
    """
    import "./awesome_button.scss";
    """

  Scenario: Generate component with custom stylesheet engine defined to `scss`
    Given I use a fixture named "my_app"
    And a file named "config/initializers/custom_configuration.rb" with:
    """
    Rails.application.config.generators.stylesheet_engine = :sass
    """
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "awesome_button.scss" should exist
    And the file named "awesome_button.js" should contain:
    """
    import "./awesome_button.scss";
    """

  Scenario: Generate component with custom stylesheet engine defined to `sass`
    Given I use a fixture named "my_app"
    And a file named "config/initializers/custom_configuration.rb" with:
    """
    Rails.application.config.sass.preferred_syntax = :sass
    """
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "awesome_button.sass" should exist
    And the file named "awesome_button.js" should contain:
    """
    import "./awesome_button.sass";
    """

  Scenario: Generate component with custom stylesheet engine defined to `css`
    Given I use a fixture named "my_app"
    And I remove "sass-rails" gem
    When I run `bundle install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "awesome_button.css" should exist
    And the file named "awesome_button.js" should contain:
    """
    import "./awesome_button.css";
    """

  Scenario: Generate component with `--locale` option
    Given I use a fixture named "my_app"
    And I run `rails generate component AwesomeButton --locale`
    And I cd to "frontend/components"
    Then a file named "awesome_button/awesome_button.en.yml" should exist

  Scenario: Generate component with `--locale` option and additional `fr` locale
    Given I use a fixture named "my_app"
    And a file named "config/initializers/custom_configuration.rb" with:
    """
    Rails.application.config.i18n.available_locales = [:en, :fr]
    """
    And I run `rails generate component AwesomeButton --locale`
    And I cd to "frontend/components/awesome_button"
    Then the following files should exist:
      | awesome_button.en.yml |
      | awesome_button.fr.yml |

  Scenario: Generate component with `--stimulus` option
    Given I use a fixture named "my_app"
    And I run `rails generate komponent:install --stimulus`
    And I cd to "frontend"
    Then the following files should exist:
      | stimulus_application.js |
    And I run `rails generate component AwesomeButton --stimulus`
    And I cd to "components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.erb     |
      | awesome_button/awesome_button.scss          |
      | awesome_button/awesome_button.js            |
      | awesome_button/awesome_button_controller.js |
      | awesome_button/awesome_button_component.rb  |
    And the file named "awesome_button/awesome_button_controller.js" should contain:
    """
    import { Controller } from "stimulus";
    """

  Scenario: Component with namespaces and stimulus
    Given I use a fixture named "my_app"
    And I run `rails generate komponent:install --stimulus`
    And I cd to "frontend"
    Then the following files should exist:
      | stimulus_application.js |
    And I run `rails generate component admin/sub_admin/AwesomeButton --stimulus`
    And I cd to "components"
    Then the following files should exist:
      | admin/sub_admin/awesome_button/_admin_sub_admin_awesome_button.html.erb     |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.scss          |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.js            |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_controller.js |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_component.rb  |
    And the file named "admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_controller.js" should contain:
    """
    import { Controller } from "stimulus";
    """

  Scenario: Destroy component
    Given I use a fixture named "my_app"
    And I cd to "frontend/components"
    When I run `rails generate component button`
    Then the file named "index.js" should contain:
    """
    import "components/button/button";
    """
    When I run `rails destroy component button`
    Then the file named "index.js" should not contain:
    """
    import "components/button/button";
    """

  Scenario: Destroy namespaced component
    Given I use a fixture named "my_app"
    And I cd to "frontend/components"
    When I run `rails generate component admin/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/button/admin_button";
    """
    When I run `rails destroy component admin/button`
    Then the file named "index.js" should not contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should not exist

  Scenario: Destroy namespaced components
    Given I use a fixture named "my_app"
    And I cd to "frontend/components"
    When I run `rails generate component admin/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/button/admin_button";
    """
    When I run `rails generate component admin/tag`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/button/admin_button";
    import "components/admin/tag/admin_tag";
    """
    When I run `rails destroy component admin/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    Then the file named "admin/index.js" should contain:
    """
    import "components/admin/tag/admin_tag";
    """
    And the file named "admin/index.js" should not contain:
    """
    import "components/admin/button/admin_button";
    """

  Scenario: Destroy complex namespaced components
    Given I use a fixture named "my_app"
    And I cd to "frontend/components"
    When I run `rails generate component admin/super/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/super";
    """
    And a file named "admin/super/index.js" should exist
    And the file named "admin/super/index.js" should contain:
    """
    import "components/admin/super/button/admin_super_button";
    """
    When I run `rails generate component admin/super/tag`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/super";
    """
    And a file named "admin/super/index.js" should exist
    And a file named "admin/super/index.js" should contain:
    """
    import "components/admin/super/button/admin_super_button";
    import "components/admin/super/tag/admin_super_tag";
    """
    When I run `rails destroy component admin/super/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    Then the file named "admin/index.js" should contain:
    """
    import "components/admin/super";
    """
    And a file named "admin/super/index.js" should exist
    Then the file named "admin/super/index.js" should contain:
    """
    import "components/admin/super/tag/admin_super_tag";
    """
    When I run `rails destroy component admin/super/tag`
    And a file named "admin/super/index.js" should not exist
    And a file named "admin/index.js" should not exist
    Then the file named "index.js" should not contain:
    """
    import "components/admin";
    """
