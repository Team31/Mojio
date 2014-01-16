When(/^I type "(.*?)" into the "(.*?)" text field$/) do |arg1, arg2|
	text_field_selector = "view marked:'#{arg2}'"
	touch(text_field_selector)
end
