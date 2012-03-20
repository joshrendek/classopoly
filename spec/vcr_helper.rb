VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/cassettes'
  c.hook_into :fakeweb
end

