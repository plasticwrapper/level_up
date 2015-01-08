def category
  @category ||= Category.find_by!(handle: "faux")
end

def skill
  @skill ||= category.skills.last
end

Given(/^I completed a skill( recently)?$/) do |_|
  FactoryGirl.create(:completion, user: current_user, skill: skill)
end

Given(/^I completed a skill a long time ago$/) do
  FactoryGirl.create(:completion, user: current_user, created_at: 1.week.ago)
end

Given(/^I visit a course page$/) do
  visit "/#{category.handle}.html"
end

When(/^I click on a completion checkbox$/) do
  find("##{skill.handle} .completion .btn").click
end

Then(/^I should have completed that skill$/) do
  expect(Completion.where(skill: skill, user: current_user)).not_to be_empty
end

Then(/^I should not have completed that skill$/) do
  expect(Completion.where(skill: skill, user: current_user)).to be_empty
end

Then(/^I should see a friendly help message$/) do
  expect(page).to have_css(".dropoff_help_message")
end

Then(/^I shouldn't see any help message because I'm not stuck$/) do
  expect(page).not_to have_css(".dropoff_help_message")
end
