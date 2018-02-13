Feature: Install generator

  Scenario: Configure a default root path in komponent's configuration before installing component
    Given I run `rails new my_app --skip-spring`
    When I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'komponent', path: '../../..'
    """
    And a file named "config/initializers/custom_configuration.rb" with:
    """
    Rails.application.config.komponent.root = Rails.root.join("app/frontend")
    """
    And I run `bundle install --jobs=3 --retry=3`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And the file named "config/application.rb" should contain:
    """
    config.i18n.load_path += Dir[config.root.join('app/frontend/components/**/*.yml')]
    """
    And the file named "config/application.rb" should contain:
    """
    config.autoload_paths << config.root.join('app/frontend/components')
    """
    And I run `rails generate component AwesomeButton`
    And I cd to "app/frontend/components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.erb     |
      | awesome_button/awesome_button.scss          |
      | awesome_button/awesome_button.js            |
      | awesome_button/awesome_button_component.rb  |
    And the file named "index.js" should contain:
    """
    import "components/awesome_button/awesome_button";
    """
    When I run `rails generate komponent:install --stimulus`
    And I cd to "../.."
    Then the file named "frontend/stimulus_application.js" should exist

