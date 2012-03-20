require 'net/http'

module Bookstore

  class Fetch
    attr_accessor :response, :body, :isbn
    def initialize(opts)
      @year = opts[:year]
      @term = opts[:term]
      @ref_num = opts[:refnum]
      @origin = "J"
      @apppgm = "CL"
      setup
      fetch_isbn
    end

    def setup
      @http = Net::HTTP.new('cfprd.oti.fsu.edu',443)
      @http.use_ssl = true
      @path = "/anr/CourseSectionDetail/index.cfm?year=#{@year}&term=#{@term}&srchCourseRefNumber=#{@ref_num}&origin=#{@origin}&apppgm=#{@apppgm}"
      #/webapp/wcs/stores/servlet/OnlineRegistration?langId=-1&storeId=11003')

      @headers = {
        'Referer' => 'https://campus.fsu.edu/webapps/portal/frameset.jsp?tab_tab_group_id=_19_1',
        'Content-Type' => 'application/x-www-form-urlencoded',
        "User-Agent"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"
      }
    end

    def fetch_isbn
      @response, @data = @http.get(@path, @headers)
      @body = @response.body
      @webdoc = Hpricot(body)
      @isbn = ''
      p @path
        match = @body.match(/[0-9]{8,13}/).to_a.first

        unless match.nil?
          @isbn = match
        end

    end
  end

  class << self
    def fetch_all_isbn
      Course.all.each_with_index do |course, index|
        p "#{index} / #{Course.all.count}"
        options_hash = {:year => course.year, :term => course.term[-1], :refnum => course.reference_number.to_s} 
        isbn = Bookstore::Fetch.new(options_hash).isbn
        course.books.build(:isbn => isbn).save
      end
    end
  end
end

