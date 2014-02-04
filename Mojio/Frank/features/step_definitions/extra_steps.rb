When(/^I type "(.*?)" into the "(.*?)" text field$/) do |arg1, arg2|
	text_field_selector = "view marked:'#{arg2}'"
	check_element_exists(text_field_selector)
	touch(text_field_selector)
	frankly_map(text_field_selector, 'setText:', arg1)
	frankly_map(text_field_selector, 'endEditing:', true)	
end

When(/^I select (\d+)nd row in picker "(.*?)"$/) do|
	row_ordinal, theview|
		selector = "view 'UIPickerView' marked:'#{theview}'"
		row_index = row_ordinal.to_i - 1
		views_switched = frankly_map( selector, 'selectRow:inComponent:animated:',row_index, 0, false)
		raise "could not find anything matching [#{row_ordinal}] to switch" if views_switched.empty?
end

When(/^I select (\d+)nd row and lebel "(.*?)" in picker "(.*?)"$/) do | row_ordinal, label, theview|
		selector = "view marked:'#{theview}'"

		row_index = row_ordinal.to_i - 2
		if row_index == -1
			row_index = 1
		end
		views_switched = frankly_map( selector, 'selectRow:inComponent:animated:',row_index, 0, false)
		forced_touch("view marked:'#{label}'")
end

Then(/^I wait to see "(.*?)" in the "(.*?)" text field$/) do |arg1, arg2|
	text_field_selector = "view marked:'#{arg2}'"
	check_element_exists( text_field_selector )
end

def forced_touch(selector)
	touch_success = frankly_map(selector, 'FEX_forcedTouch')
end
