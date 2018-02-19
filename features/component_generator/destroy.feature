Feature: `rails destroy component`

  Scenario: Clear component without namespace
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
    When I run `rails generate component button`
    Then the file named "index.js" should contain:
    """
    import "components/button/button";
    """
    When I run `rails destroy component button`
    Then the file named "index.js" should not contain:
    """
    import "components/button/button";
    """

  Scenario: Clear component with namespace
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
    When I run `rails generate component admin/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/button/admin_button";
    """
    When I run `rails destroy component admin/button`
    Then the file named "index.js" should not contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should not exist

  Scenario: Clear component with namespace
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
    When I run `rails generate component admin/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/button/admin_button";
    """
    When I run `rails generate component admin/tag`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/button/admin_button";
    import "components/admin/tag/admin_tag";
    """
    When I run `rails destroy component admin/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    Then the file named "admin/index.js" should contain:
    """
    import "components/admin/tag/admin_tag";
    """

  Scenario: Clear component with recursive namespaces
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
    When I run `rails generate component admin/super/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/super";
    """
    And a file named "admin/super/index.js" should exist
    And the file named "admin/super/index.js" should contain:
    """
    import "components/admin/super/button/admin_super_button";
    """
    When I run `rails generate component admin/super/tag`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And the file named "admin/index.js" should contain:
    """
    import "components/admin/super";
    """
    And a file named "admin/super/index.js" should exist
    And a file named "admin/super/index.js" should contain:
    """
    import "components/admin/super/button/admin_super_button";
    import "components/admin/super/tag/admin_super_tag";
    """
    When I run `rails destroy component admin/super/button`
    Then the file named "index.js" should contain:
    """
    import "components/admin";
    """
    And a file named "admin/index.js" should exist
    Then the file named "admin/index.js" should contain:
    """
    import "components/admin/super";
    """
    And a file named "admin/super/index.js" should exist
    Then the file named "admin/super/index.js" should contain:
    """
    import "components/admin/super/tag/admin_super_tag";
    """
    When I run `rails destroy component admin/super/tag`
    And a file named "admin/super/index.js" should not exist
    And a file named "admin/index.js" should not exist
    Then the file named "index.js" should not contain:
    """
    import "components/admin";
    """
