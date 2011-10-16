Given /^the following homepages:$/ do |homepages|
  Homepage.create!(homepages.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) homepage$/ do |pos|
  visit homepages_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following homepages:$/ do |expected_homepages_table|
  expected_homepages_table.diff!(tableish('table tr', 'td,th'))
end
