Given("I remove {string} gem") do |gem_name|
  file_name = "Gemfile"
  file_name = expand_path(file_name)

  tmp = Tempfile.new

  File.foreach(file_name) do |line|
    tmp.puts(line) unless /#{gem_name}/ =~ line
  end

  tmp.close
  FileUtils.mv(tmp.path, file_name)
  tmp.unlink
end
