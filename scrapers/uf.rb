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
HDRS = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"
 }
  
TABLE_HEADERS = %w{ course course_fee emp_edu_prog write_math general_ed section credits days period building room exam course_title instructor  }

# page timeout when loading
TIMEOUT = 2

uri = URI.parse("http://registrar.ufl.edu/soc/201108/all/")

# Get Cookie first
http = Net::HTTP.new(uri.host, uri.port)
response = http.request(Net::HTTP::Get.new(uri.request_uri))
@webdoc = Hpricot(response.body)
@departments = []

@webdoc.search('.soc_menu select option').each do |o|
  tmp = {:url => o.attributes['value'], :department => o.inner_html}
  @departments << tmp unless o.attributes['value'].size == 0
end


cookie = response.header["set-cookie"]

if DEBUG
  p "Cookie => " + cookie.to_s
end

# Add additional headers once cookie has been retrieved
HDRS["Connection"] = "keep-alive"
HDRS["cookie"] = cookie

@classes = []

i = 0


@departments.each do |d|
  p d

  print "\n\t [ Parsing #{d['department']} ]\n"
    Kernel.exit

  # Request needs to kept being made until you get the keyword Course Sections....
  # for some reason (even when using a regular browser) it will sometimes fail to 
  # load the class display list
  # Solution: loop till it does
  begin
    uri = URI.parse("http://registrar.ufl.edu/soc/201108/all/#{d['url']}")      
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(tmp_hash)
    HDRS.each do |k,v|
      request.add_field(k, v)
    end
    response = http.request(request)
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
