module ButtonComponent
  extend ComponentHelper

  property :text, required: true

  def link?
    @href.present?
  end
end
