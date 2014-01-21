When(/^I type "(.*?)" into the "(.*?)" text field$/) do |arg1, arg2|
	text_field_selector = "view marked:'#{arg2}'"
	check_element_exists(text_field_selector)
	touch(text_field_selector)
	frankly_map(text_field_selector, 'setText:', arg1)
	frankly_map(text_field_selector, 'endEditing:', true)	
end
