Given /^I visit the home page from a invite link$/ do
  @pending_invite = PendingInvite.create(:uid => 123, :user_id => 1)
  visit root_path(:refid => @pending_invite.uid)
end

Then /^the pending invite should no longer exist$/ do
  PendingInvite.count.should eq(0)
end
