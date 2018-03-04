SimpleCov.minimum_coverage 90

SimpleCov.start do
  add_filter "/fixtures/"
  add_filter "/test/"
  add_filter "/features/"
end
