Feature: Component generator

  Background:
    Given I use a fixture named "my_app"

  Scenario: Generate component
    When I run `rails generate component AwesomeButton`
    And I cd to "frontend/components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.erb     |
      | awesome_button/awesome_button.css           |
      | awesome_button/awesome_button.js            |
      | awesome_button/awesome_button_component.rb  |
      | awesome_button/_examples.html.erb           |
    And the file named "index.js" should contain:
    """
    import "components/awesome_button/awesome_button";
    """
    And the file named "awesome_button/awesome_button_component.rb" should contain:
    """
    # frozen_string_literal: true
    """

  Scenario: Generate namespaced component
    When I run `rails generate component admin/sub_admin/AwesomeButton`
    And I cd to "frontend/components"
    Then the following files should exist:
      | admin/index.js                                                             |
      | admin/sub_admin/index.js                                                   |
      | admin/sub_admin/awesome_button/_admin_sub_admin_awesome_button.html.erb    |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.css          |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.js           |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_component.rb |
      | admin/sub_admin/awesome_button/_examples.html.erb                          |
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
    When I cd to "frontend/components"
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

  Scenario: `imports` in JavaScript files support single quotes
    When I cd to "frontend/components"
    And a file named "index.js" with:
    """
    import 'components/all/all';
    import 'components/bar/bar';
    import 'components/foo_bar/foo_bar';
    import 'components/genius_button/genius_button';
    import 'components/namespaced';
    import 'components/required/required';
    import 'components/world/world';
    """
    Then the file named "index.js" should contain:
    """
    import 'components/all/all';
    import 'components/bar/bar';
    import 'components/foo_bar/foo_bar';
    import 'components/genius_button/genius_button';
    import 'components/namespaced';
    import 'components/required/required';
    import 'components/world/world';
    """
    When I run `rails generate component button`
    Then the file named "index.js" should contain:
    """
    import "components/button/button";
    import 'components/all/all';
    import 'components/bar/bar';
    import 'components/foo_bar/foo_bar';
    import 'components/genius_button/genius_button';
    import 'components/namespaced';
    import 'components/required/required';
    import 'components/world/world';
    """

  Scenario: `imports` in JavaScript files are sorted and without duplicates
    When I cd to "frontend/components"
    When I run `rails generate component some_example`
    When I run `rails generate component some_example`
    Then the file named "index.js" should contain:
    """
    import "components/all/all";
    import "components/bar/bar";
    import "components/foo_bar/foo_bar";
    import "components/genius_button/genius_button";
    import "components/namespaced";
    import "components/partial";
    import "components/required/required";
    import "components/some_example/some_example";
    import "components/world/world";
    """

  Scenario: relative `imports` in JavaScript files kept at the end when generating a component
    When I cd to "frontend/components"
    And a file named "index.js" with:
    """
    import "../a_relative_file.js";
    import "../other_relative_file.js";
    """
    Then the file named "index.js" should contain:
    """
    import "../a_relative_file.js";
    import "../other_relative_file.js";
    """
    When I run `rails generate component button`
    Then the file named "index.js" should contain:
    """
    import "components/button/button";
    import "../a_relative_file.js";
    import "../other_relative_file.js";
    """
    When I run `rails generate component awesome_button`
    Then the file named "index.js" should contain:
    """
    import "components/awesome_button/awesome_button";
    import "components/button/button";
    import "../a_relative_file.js";
    import "../other_relative_file.js";
    """

  Scenario: Generate component with `erb` template engine
    When I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "_awesome_button.html.erb" should exist
    And a file named "_examples.html.erb" should exist

  Scenario: Generate component with custom template engine defined to `haml`
    Given a file named "config/initializers/custom_configuration.rb" with:
    """
      Rails.application.config.generators.template_engine = :haml
    """
    When I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "_awesome_button.html.haml" should exist
    And a file named "_examples.html.haml" should exist

  Scenario: Generate component with custom template engine defined to `slim`
    Given a file named "config/initializers/custom_configuration.rb" with:
    """
      Rails.application.config.generators.template_engine = :slim
    """
    When I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "_awesome_button.html.slim" should exist
    And a file named "_examples.html.slim" should exist

  Scenario: Generate component with custom stylesheet engine defined to `scss`
    Given a file named "config/initializers/custom_configuration.rb" with:
    """
      Rails.application.config.komponent.stylesheet_engine = :scss
    """
    When I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "awesome_button.scss" should exist

  Scenario: Generate component with custom template engine defined to `sass`
    Given a file named "config/initializers/custom_configuration.rb" with:
    """
      Rails.application.config.komponent.stylesheet_engine = :sass
    """
    When I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "awesome_button.sass" should exist

  Scenario: Generate component with `--locale` option
    When I run `rails generate component AwesomeButton --locale`
    And I cd to "frontend/components"
    Then a file named "awesome_button/awesome_button.en.yml" should exist

  Scenario: Generate component with `--locale` option and additional `fr` locale
    Given a file named "config/initializers/custom_configuration.rb" with:
    """
    Rails.application.config.i18n.available_locales = [:en, :fr]
    """
    When I run `rails generate component AwesomeButton --locale`
    And I cd to "frontend/components/awesome_button"
    Then the following files should exist:
      | awesome_button.en.yml |
      | awesome_button.fr.yml |

  Scenario: Generate component with `--stimulus` option
    When I run `rails generate komponent:install --stimulus`
    And I cd to "frontend"
    Then the following files should exist:
      | stimulus_application.js |
    And I run `rails generate component AwesomeButton --stimulus`
    And I cd to "components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.erb     |
      | awesome_button/awesome_button.css           |
      | awesome_button/awesome_button.js            |
      | awesome_button/awesome_button_controller.js |
      | awesome_button/awesome_button_component.rb  |
    And the file named "awesome_button/awesome_button_controller.js" should contain:
    """
    import { Controller } from "stimulus";
    """

  Scenario: Component with namespaces and stimulus
    When I run `rails generate komponent:install --stimulus`
    And I cd to "frontend"
    Then the following files should exist:
      | stimulus_application.js |
    And I run `rails generate component admin/sub_admin/AwesomeButton --stimulus`
    And I cd to "components"
    Then the following files should exist:
      | admin/sub_admin/awesome_button/_admin_sub_admin_awesome_button.html.erb     |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.css           |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.js            |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_controller.js |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_component.rb  |
    And the file named "admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_controller.js" should contain:
    """
    import { Controller } from "stimulus";
    """

  Scenario: Destroy component
    When I cd to "frontend/components"
    And I run `rails generate component button`
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
    When I cd to "frontend/components"
    And I run `rails generate component admin/button`
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
    When I cd to "frontend/components"
    And I run `rails generate component admin/button`
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
    When I cd to "frontend/components"
    And I run `rails generate component admin/super/button`
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
