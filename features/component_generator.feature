Feature: Generating component
  Scenario: Component
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'webpacker', '~> 3.0'
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.erb    |
      | awesome_button/awesome_button.css          |
      | awesome_button/awesome_button.js           |
      | awesome_button/awesome_button_component.rb |
    And the file named "index.js" should contain:
    """
    import "components/awesome_button/awesome_button";
    """

  Scenario: Component with namespaces and stimulus
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'webpacker', '~> 3.0'
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install --stimulus`
    And I run `rails generate component admin/sub_admin/AwesomeButton --stimulus`
    And I cd to "frontend/components"
    Then the following files should exist:
      | admin/sub_admin/awesome_button/_admin_sub_admin_awesome_button.html.erb    |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.css          |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_controller.js|
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_component.rb |

  Scenario: Component with namespaces
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'webpacker', '~> 3.0'
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component admin/sub_admin/AwesomeButton`
    And I cd to "frontend/components"
    Then the following files should exist:
      | admin/index.js                                                             |
      | admin/sub_admin/index.js                                                   |
      | admin/sub_admin/awesome_button/_admin_sub_admin_awesome_button.html.erb    |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.css          |
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

  Scenario: Component with `--locale` option
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'webpacker', '~> 3.0'
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton --locale`
    And I cd to "frontend/components"
    Then the following files should exist:
      | awesome_button/awesome_button.en.yml |

  Scenario: Component with `slim` template
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'slim-rails'
    gem 'webpacker', '~> 3.0'
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.slim |

  Scenario: Component with `haml` template
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'haml-rails'
    gem 'webpacker', '~> 3.0'
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.haml |
