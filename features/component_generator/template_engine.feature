Feature: Component generator - Template engine

  Scenario: Component with `erb` template engine
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "_awesome_button.html.erb" should exist

  Scenario: Component with `haml` template engine
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'haml-rails'
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "_awesome_button.html.haml" should exist

  Scenario: Component with `slim` template engine
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'slim-rails'
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "_awesome_button.html.slim" should exist
