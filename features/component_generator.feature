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
      | awesome_button/_awesome_button.html.erb    |
      | awesome_button/awesome_button.css          |
      | awesome_button/awesome_button.js           |
      | awesome_button/awesome_button_component.rb |
      | awesome_button/awesome_button.en.yml       |
    And the file named "index.js" should contain:
    """
    import "components/awesome_button/awesome_button";
    """

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
      | awesome_button/_awesome_button.html.slim    |
      | awesome_button/awesome_button.css           |
      | awesome_button/awesome_button.js            |
      | awesome_button/awesome_button_component.rb  |

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
      | awesome_button/_awesome_button.html.haml    |
      | awesome_button/awesome_button.css           |
      | awesome_button/awesome_button.js            |
      | awesome_button/awesome_button_component.rb  |
