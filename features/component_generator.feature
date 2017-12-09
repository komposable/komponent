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
