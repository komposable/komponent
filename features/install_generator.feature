Feature: Install generator

  Scenario: Default root path
    Given I use a fixture named "app_with_webpacker"
    When I run `rails generate komponent:install`
    Then the following files should exist:
    | frontend/packs/application.js     |
    And the file named "frontend/packs/application.js" should contain:
    """
    Hello World from Webpacker
    """
    And the file named "config/application.rb" should contain:
    """
    config.i18n.load_path += Dir[config.root.join('frontend/components/**/*.*.yml')]
    """
    And the file named "config/application.rb" should contain:
    """
    config.autoload_paths << config.root.join('frontend/components')
    """
    And I run `rails generate component AwesomeButton`
    And I cd to "frontend/components"
    Then the following files should exist:
      | awesome_button/_awesome_button.html.erb     |
      | awesome_button/awesome_button.css           |
      | awesome_button/awesome_button.js            |
      | awesome_button/awesome_button_component.rb  |
    And the file named "index.js" should contain:
    """
    import "components/awesome_button/awesome_button";
    """
    When I run `rails generate komponent:install --stimulus`
    And I cd to "../.."
    Then the file named "frontend/stimulus_application.js" should exist
