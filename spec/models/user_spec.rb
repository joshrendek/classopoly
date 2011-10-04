require 'spec_helper'

describe User do
  
  user1 = {"work_times" => "wednesday,12:30,14:30|friday,9:30,12:45", :lunch_time => "1:30"}
  
  describe "Parsing the work_times" do
    it "should convert work_times to DateTimes" do
      work_times = []
      user1["work_times"].split('|').each do |day|
        p "Storing #{day}"
      end
    end
  end

  pending "add some examples to (or delete) #{__FILE__}"
  
end
