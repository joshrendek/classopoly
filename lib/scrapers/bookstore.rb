require 'net/http'

module Bookstore

  class Fetch
    attr_accessor :response, :body, :isbn
    def initialize(opts)
      @year = opts[:year]
      @term = opts[:term]
      @refNum = opts[:refnum]
      @origin = opts[:origin]
      @apppgm = opts[:apppgm]
      setup
      fetch_isbn
    end

    def setup
      @http = Net::HTTP.new('cfprd.oti.fsu.edu',443)
      @http.use_ssl = true
      @path = '/anr/CourseSectionDetail/index.cfm?year=2012&term=1&srchCourseRefNumber=06526&origin=J&apppgm=CL'
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
      @webdoc.search('table tr td table tr td').each do |s|
        match = s.inner_html.match(/[0-9]{8,13}/).to_a.first
        unless match.blank?
          @isbn = match
        end
      end
    end
  end

  class << self
    def fetch_all_isbn

    end
  end
end

