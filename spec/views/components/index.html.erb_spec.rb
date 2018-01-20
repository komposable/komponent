require "rails_helper"

RSpec.describe "components/index.html.erb" do
  it "renders button component" do
    render
    expect(rendered).to include("button_component")
  end

  context "with defined locales" do
    it "renders button" do
      render
      expect(rendered).to include("https://github.com/komposable/komponent")
    end
  end

  context "with defined properties" do
    it "renders button" do
      render
      expect(rendered).to include("MyText")
    end
  end

  context "with block given" do
    it "renders button" do
      render
      expect(rendered).to include("&")
    end
  end
end
