# Changelog

## Upcoming release

**Breaking changes:**
- Dropped support for Ruby 2.3 and 2.4
- It's now recommended to use eager loading to prevent `uninitialized component` issues
  (see [#121](https://github.com/komposable/komponent/issues/121) for background).

  The install generator has been updated. When upgrading, please make sure you replace:

      config.autoload_paths << config.root.join("app/frontend/components")

  with

      config.paths.add "frontend/components", eager_load: true

**Enhancements:**
- Support for Rails 6
- Refactoring to use `Utils` in `InstallGenerator` and prevent code duplication

**Bug fixes:**
- Fixed empty `h1` in generated `_examples.html.*` file

## v3.0.0.beta1 (2019-02-28)

**Breaking changes:**
- Dropped support for Rails 4.2
- Dropped support for Ruby 2.2

**Enhancements:**
- Komponent now reports component stats when you run `bin/rails stats`
- Komponent now includes a styleguide engine that you can mount to your project
  to document your components, and 2 new generators:
  - `rails g komponent:styleguide` to set it up
  - `rails g komponent:examples` to generate an `examples` file for each existing component

**Bug fixes:**
- Removed redundant `class` attribute in HAML templates
- Fix `content_for` / `yield` which was no longer working across components, since `v2.0.0`
- Fix translation key lookup in partials (helper method `t`)

## v2.2.0 (2018-07-03)

**Enhancements:**
- Component generator: use `component_name` instead of `module_name` in templates,
  so when we create a `button` component, by default it contains `button` instead
  of `button_component`

**Bug fixes:**
- Component generator: fix error when the single-quotes are used in `import`s

## v2.1.0 (2018-05-31)

**Enhancements:**
- Block given to component now pass return values

## v2.0.0 (2018-04-22)

**Enhancements:**
- Use lazy lookup for translations in all generator templates

## v2.0.0.pre.1 (2018-04-12)

**Breaking changes:**
- Removed deprecated `render_partial` method
- Removed rendering of namespaced component with the old naming convention

**Enhancements:**
- Changed `@block_given_to_component` from an instance variable to a method `block_given_to_component` available in the view context
- Implemented component caching with the `cached: true` option
- Added a `stylesheet_engine` option to Komponent configuration
- When generating a new component, the `frozen_string_literal: true` magic comment is prepended to Ruby files

## v1.1.4 (2018-03-05)

**Enhancements:**
- Added `frozen_string_literal` option to optimize performance
- Removed useless `autoload_paths` config definition (it was not taken into account)
- Install generator can be ran several times in order to enable features
- Autoloading is now appended to `config/application.rb` when you run `rails g komponent:install`
- Make all locals passed to `component` helper available through `properties` helper method

## v1.1.3 (2018-02-22)

**Enhancements:**
- Custom destroy for the component generator: you can now safely run `rails d component button`

**Bug fixes:**
- Fix crash when `nil` is passed to a component

## v1.1.2 (2018-02-13)

**Enhancements:**
- Support for Stimulus 1.0
- `import`s are now sorted alphabetically every time you run the component generator
- Added the `block_given_to_component?` helper to components

## v1.1.1 (2018-01-20)

**Enhancements:**
- Add an option to change default root path where Komponent is installed, and components are generated

## v1.1.0 (2018-01-12)

**Enhancements:**
- [stimulus](https://github.com/stimulusjs/stimulus) integration
- Component generator supports `css`, `scss`, `sass` stylesheet engine
- Add a component path resolver

**Bug fixes**
- Make `content_for` work in component
- Fix issue with wrong stylesheet extension being used when
imported in JavaScript files

**Deprecation**
- `render_partial` is deprecated in favor of default `render`
- The file naming convention will be changed in the next major version, for namespaced components, to include the namespace:
  - `frontend/components/admin/button/_button.html.slim` -> `frontend/components/admin/button/_admin_button.html.slim`
  - `frontend/components/admin/button/button.js` -> `frontend/components/admin/button/admin_button.js`
  - `frontend/components/admin/button/button.css` -> `frontend/components/admin/button/admin_button.css`

## v1.0.0 (2018-01-01)

**Enhancements:**
- Components namespacing
- Implement basic features
- Implement `render_partial` helper

## v1.0.0.pre.2 (2017-12-09)

**Enhancements:**
- Lazy-load helpers and configuration
- Add an install generator (`rails g komponent:install`)
- Standardize components name (underscore for all except css classes are dasherized)
- Support `erb`, `slim`, and `haml` template engines
- Add an `--locale` option to component generator
- Documentation improvements

## v1.0.0.pre.1 (2017-12-09)

First pre-release
