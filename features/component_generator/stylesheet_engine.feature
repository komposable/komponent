Feature: Component generator - Stylesheet engine

  Scenario: Component with `scss` stylesheet engine
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
    Then a file named "awesome_button.scss" should exist
    And the file named "awesome_button.js" should contain:
    """
    import "./awesome_button.scss";
    """

  Scenario: Component with `sass` stylesheet engine set in `generators.stylesheet_engine`
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'komponent', path: '../../..'
    """
    And a file named "config/initializers/custom_configuration.rb" with:
    """
    Rails.application.config.generators.stylesheet_engine = :sass
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "awesome_button.scss" should exist
    And the file named "awesome_button.js" should contain:
    """
    import "./awesome_button.scss";
    """

  Scenario: Component with `sass` stylesheet engine set in `sass.preferred syntax`
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'komponent', path: '../../..'
    """
    And a file named "config/initializers/custom_configuration.rb" with:
    """
    Rails.application.config.sass.preferred_syntax = :sass
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "awesome_button.sass" should exist
    And the file named "awesome_button.js" should contain:
    """
    import "./awesome_button.sass";
    """

  Scenario: Component with `css` stylesheet engine
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'komponent', path: '../../..'
    """
    And I remove "sass-rails" gem
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components/awesome_button"
    Then a file named "awesome_button.css" should exist
    And the file named "awesome_button.js" should contain:
    """
    import "./awesome_button.css";
    """
