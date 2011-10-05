require 'spec_helper'

module TimeSchedule
  class Schedule
    def self.weekday_to_arbitrary_date(day)
      date_array = (Date.today.at_beginning_of_month..Date.today.at_beginning_of_month.advance(:weeks => 1))
      date_hash = {}
      date_array.each do |d|
        date_hash.store(d.strftime("%A"), d) # store the date objects in a hash with the date as a key
      end
      return date_hash[day.capitalize]
    end
  end
end

describe User do

  user1 = {"work_times" => "wednesday,12:30,14:30|friday,9:30,12:45", :lunch_time => "1:30"}
  days = Date::DAYNAMES
  describe "Parsing the work_times" do
    it "should convert work_times to DateTimes" do
      work_times = []
      user1["work_times"].split('|').each do |day_string|
        tmp = day_string.split(',')
        day = tmp[0]
        p "#{day} is at " + TimeSchedule::Schedule.weekday_to_arbitrary_date_time_array(day, tmp[1..2]).to_s
      end
    end
  end

  pending "add some examples to (or delete) #{__FILE__}"

end
