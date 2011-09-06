#!/usr/bin/ruby
require 'rubygems'
require 'active_record'
require 'hpricot'
require 'net/http'
require 'timeout'
require 'rainbow'

# set debug flag
!ARGV[0].nil? && ARGV[0].downcase == "debug" ? DEBUG = true : DEBUG = false


# pretend we're a real browser
HDRS = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3", "Accept-Charset"=>"utf-8", "Accept"=>"text/html", 
   "Host" => "apps.oti.fsu.edu", "Referer" => "http://apps.oti.fsu.edu/RegistrarCourseLookup/SearchResults",
 }
  
TABLE_HEADERS = %w{ course_number section course_ref_num title instructor seats seats_left building room days begin end  }

# page timeout when loading
TIMEOUT = 2

uri = URI.parse("http://apps.oti.fsu.edu/RegistrarCourseLookup/SearchResults")

# Get Cookie first
http = Net::HTTP.new(uri.host, uri.port)
response = http.request(Net::HTTP::Get.new(uri.request_uri))
@webdoc = Hpricot(response.body)
@departments = []

# Find all departments and store them
javascript = @webdoc.search('script').first.to_s.split(/\n/)
javascript.each do |l|
  if l =~ /departments\[[0-9]{0,}\]/
    begin
      x = l.split('=')[1].split('",')[0].gsub('["', '').gsub('"', '').strip
      @departments << x unless x.size == 0

      if DEBUG
        print "\n Department -> #{x} \n"
      end

    rescue Exception => e
      p "Eception occured while parsing classes: #{e.to_s}"
    end
  end
end

p "[ Found #{@departments.size} departments ]"

@pretty_departments = []
@departments.each do |d|
  p d.gsub(/[0-9]{0,}/, '')
end

if DEBUG
  @departments.each do |d|
    print "\t #{d} \n"
  end
end

Kernel.exit

cookie = response.header["set-cookie"]
p "Cookie => " + cookie.to_s

# Add additional headers once cookie has been retrieved
HDRS["Connection"] = "keep-alive"
HDRS["cookie"] = cookie

@classes = []

i = 0


@departments.each do |d|

  print "\n\t [ Parsing #{d} ]\n"
  tmp = "requestType=PUBLIC&courseNumber=&term=20119&department=#{d}&level=&location=0100FSU+Main+Campus&specialProgram=-9999&beginningTime=&endingTime=&searchCriteria=-9999&criteriaDesc="
  tmp_hash = {}
  tmp.split('&').each do |s|
    tmp_x = s.split('=')
    tmp_hash[tmp_x[0]] = tmp_x[1]
  end

  # Request needs to kept being made until you get the keyword Course Sections....
  # for some reason (even when using a regular browser) it will sometimes fail to 
  # load the class display list
  # Solution: loop till it does
  begin
    scrape_count = 0
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(tmp_hash)
      HDRS.each do |k,v|
        request.add_field(k, v)
      end
      response = http.request(request)
      scrape_count += 1
      if scrape_count > 3
        raise "ClassParserTimeout"
      end
    end while not response.body.include?('Course Sections Offered For')
    classes = []
    
    if DEBUG
      print response.body
    end

    @web_doc= Hpricot(response.body)
    url = ""
    is_class_row = false
    for x in @web_doc.search('tr')
      content = ""
      xhash = {}
      x.search('td').each_with_index do |xx, i|
        # assumption is that its ABC1234 -- 3 letter class prefix followed by 4 digits
        if (i == 0 && xx.inner_html =~ /[a-zA-Z]{3}[0-9]{4}/)
          is_class_row = true
        end

        if is_class_row || (i > 0 && is_class_row)
          # the gsub to strip out html will break on invalid html, but since its just hyperlinks not worried
          xhash[TABLE_HEADERS[i]] = xx.inner_html.gsub(%r{</?[^>]+?>}, '').gsub('&nbsp;', '').strip
        end
        if i >= 11 
          is_class_row = false
        end
      end

      classes << xhash unless xhash.size == 0
    end
    classes = classes.drop(1)
    @classes += classes


  rescue Exception => e
    print "\t\t -> [ ** Timeout parsing: #{d} ( #{e.to_s} ) ** ] \n".color(:red)
  end
  i += 1

  sleep 2
  if i == 10
    #break
  end

  print "\t\t\t[ Found and parsed #{@classes.size} so far... ]\n"
  #print classes.to_yaml
end
p "[ Found and parsed #{@classes.size} classes ]"
