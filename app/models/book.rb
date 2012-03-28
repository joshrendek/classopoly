require './lib/isbndb'
class Book < ActiveRecord::Base
  validates_presence_of :course_id
  belongs_to :course

  def self.fetch_missing
    Book.where(:min_price => nil).where("isbn is not null and isbn != ''").limit(450).each do |b|
      p "Fetching pricing information for #{b.isbn}"
      isbndb = ISBN::API::Price.new(b.isbn)
      begin 
        b.min_price = isbndb.min 
        b.max_price = isbndb.max 
        b.average_price = isbndb.average
        b.save
      rescue; end;
    end
  end
end
