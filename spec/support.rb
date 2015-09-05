def ruby_version
  RUBY_VERSION.match(/\d+\.\d+/)[0].to_f
end
