# frozen_string_literal: true

module CachingHelper
  def with_caching
    cache_store_type_origin = Rails.application.config.cache_store
    cache_store_origin = Rails.cache
    Rails.application.config.cache_store = [
      :memory_store, { :size => 64.megabytes }
    ]
    Rails.cache = ActiveSupport::Cache::MemoryStore.new(
      :expires_in => 1.minute
    )
    yield
  ensure
    Rails.cache.clear
    Rails.cache = cache_store_origin
    Rails.application.config.cache_store = cache_store_type_origin
  end
end
