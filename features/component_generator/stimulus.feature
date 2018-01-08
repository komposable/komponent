Feature: Component generator - Stimulus
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
    And I run `rails generate component AwesomeButton --stimulus`
    And I cd to "frontend/components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.erb     |
      | awesome_button/awesome_button.scss          |
      | awesome_button/awesome_button_controller.js |
      | awesome_button/awesome_button_component.rb  |

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
      | admin/sub_admin/awesome_button/_admin_sub_admin_awesome_button.html.erb     |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button.scss          |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_controller.js |
      | admin/sub_admin/awesome_button/admin_sub_admin_awesome_button_component.rb  |
