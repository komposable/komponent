Feature: Sort alphabetically import in javascript files

  Scenario: Sort imports
    Given I run `rails new my_app --skip-spring`
    And I cd to "my_app"
    And I append to "Gemfile" with:
    """
    gem 'komponent', path: '../../..'
    """
    When I run `bundle install`
    And I run `rails webpacker:install`
    And I run `rails generate komponent:install`
    And I cd to "frontend/components"
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
