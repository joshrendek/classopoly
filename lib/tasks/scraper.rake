namespace :scrapers do
  require 'hpricot'
  require 'net/http'
  require 'rainbow'

  desc 'Import FSU courses'
  task :fsu => :environment do
    importer = CollegeImporter::FSU::Import.new
    importer.run
  end

  task :fsu_books => :environment do
    Bookstore.fetch_all_isbn
  end
end
