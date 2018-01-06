Feature: Component generator - Locale option

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
    Then a file named "awesome_button/awesome_button.en.yml" should exist

  Scenario: Component with `--locale` option and additional `fr` locale
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'webpacker', '~> 3.0'
    gem 'komponent', path: '../../..'
    """
    And a file named "config/initializers/custom_configuration.rb" with:
    """
    Rails.application.config.i18n.available_locales = [:en, :fr]
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton --locale`
    And I cd to "frontend/components/awesome_button"
    Then the following files should exist:
      | awesome_button.en.yml |
      | awesome_button.fr.yml |

