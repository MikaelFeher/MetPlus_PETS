Then(/^I should verify the change of title "(.*?)", shift "(.*?)" and jobId "(.*?)"$/) do |title, shift, jobId|
	
	@job = Job.find_by_title(title)
	expect(@job.shift).to eql shift
	expect(@job.company_job_id).to eql jobId 

end

Then(/^I should see a popup with the following job information$/) do
 	expect(page).to have_content("Are you sure you want 
 		         to delete the following job: 
                 job title:  #{@job.title}
                 job id: #{@job.company_job_id}")
end 

Given(/^the Widgets, Inc\. company name with address exist in the record$/) do
	FactoryGirl.create(:company)
end

Then(/^I (?:visit the |return to )jobs page$/) do 
	@job = nil
	visit jobs_path
end

Then(/^I should( not)? see "Revoked" next to "([^"]*)"$/) do |negate, job_title|
	@job ||= Job.find_by(title: job_title)
	if negate
		expect(page).not_to have_css("#job-#{@job.id} span", text: "Revoked")
	else
		expect(page).to have_css("#job-#{@job.id} span", text: "Revoked")
	end
end

Then(/^I should( not)? see "revoke" button for "([^"]*)"$/) do |negate, job_title|
	@job ||= Job.find_by(title: job_title)
	if negate
		expect(page).not_to have_css("#job-#{@job.id} button", text: "revoke")
	else
		expect(page).to have_css("#job-#{@job.id} button", text: "revoke")
	end
end

Then(/^I should see the job status is "([^"]*)"$/) do |status|
	within('#job-status') { expect(page).to have_content("#{status}") }
end

Then(/^I should see a "([^"]*)" confirmation$/) do |action|
	expect(page).to have_content("Are you sure you want 
 		         to #{action} the following job: 
                 job title:  #{@job.title}
                 company job id: #{@job.company_job_id}")
end 

Then(/^I should( not)? see "Revoke" link on the page$/) do |negate|
	if negate
		expect(page).not_to have_css('a#revoke_link', text: 'Revoke')
	else
		expect(page).to have_css('a#revoke_link', text: 'Revoke')
	end
end

Then(/^I click the "revoke" button for "hr manager"/) do
	job = Job.find_by(title: "hr manager")
	find("#job-#{job.id} > button[data-action='revoke']").click 
end

Then(/^I click the Revoke confirmation for "([^"]*)"$/) do |job_title|
	@job ||= Job.find_by(title: job_title)
	find("#confirm_revoke").click
end

Then(/^I click the "([^"]*)" link to job show page$/) do |job_title|
	@job ||= Job.find_by(title: job_title)
	find("a[href='/jobs/#{@job.id}']").click
end

Then(/^I apply to "([^"]*)" from Jobs link(?: again)?$/) do |job_title|
  step %{I click the "Jobs" link}
  step %{I click the "#{job_title}" link}
  step %{I click the "Click Here To Apply Online" link}
  step %{I wait for 1 second}
  step %{I should see "Application process"}
  step %{I click the "Apply Now" link}
end

Then(/^I want to apply to "([^"]*)" for "(?:[^"]*)"$/) do |job_title|
  step %{I visit the jobs page}
  step %{I click the "#{job_title}" link}
  step %{I click the "Click Here to Submit an Application for Job Seeker" link}
end

And(/^I find "([^"]*)" from my job seekers list and proceed with the application$/) do |job_seeker|
  step %{I select2 "#{job_seeker}" from "jd_apply_job_select"}
  step %{I press "Proceed"}
end

Then(/^I apply to "([^"]*)" for my job seeker: "([^"]*)"$/) do |job_title, job_seeker|
  step %{I want to apply to "#{job_title}" for "#{job_seeker}"}
  step %{I find "#{job_seeker}" from my job seekers list and proceed with the application}
  step %{I wait 1 second}
  step %{I press "Apply Now"}
end

But(/^I cannot find "([^"]*)" from my job seekers list$/) do |job_seeker|
  step %{I cannot select2 "#{job_seeker}" from "jd_apply_job_select"}
end

Then(/^I update my profile to not permit job developer to apply a job for me$/) do
  step %{I uncheck "job_seeker_consent"}
  step %{I click the "Update Job seeker" button}
  step %{I should see "Jobseeker was updated successfully."}
end

