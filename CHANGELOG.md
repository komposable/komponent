# Changelog

## Upcoming release

**Enhancements:**

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
