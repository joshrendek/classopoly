require 'net/http'
module ISBN 
  module API
    class Price
      attr_accessor :price
      def initialize(isbn)
        @access_key = APP_CONFIG["isbndb"]["key"]
        @isbn = isbn 
        setup
        fetch
      end

      private 
      def setup 
        @http = Net::HTTP.new('isbndb.com', 443)
        @http.use_ssl = true
        @path = "/api/books.xml?access_key=#{@access_key}"
        @path << "&results=prices&index1=isbn&value1=#{@isbn}"
      end

      def fetch 
        @response, @data = @http.get(@path)
        @body = @response.body
        @xml = Hpricot.XML(@body)
        @price = (@xml/:Prices/:Price).collect {|p| p["price"].to_f }

      end

    end
  end
end
