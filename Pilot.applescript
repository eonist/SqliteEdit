property SQLiteParser : load script alias ((path to scripts folder from user domain as text) & "sqlite:SQLiteParser.scpt")
property SQLiteModifier : load script alias ((path to scripts folder from user domain as text) & "sqlite:SQLiteModifier.scpt")
property SQLiteUtil : load script alias ((path to scripts folder from user domain as text) & "sqlite:SQLiteUtil.scpt")
property SQLiteHelper : load script alias ((path to scripts folder from user domain as text) & "sqlite:SQLiteHelper.scpt")
property ListParser : load script alias ((path to scripts folder from user domain as text) & "list:ListParser.scpt")
property ListModifier : load script alias ((path to scripts folder from user domain as text) & "list:ListModifier.scpt")
property FileModifier : load script alias ((path to scripts folder from user domain as text) & "file:FileModifier.scpt")
property FileParser : load script alias ((path to scripts folder from user domain as text) & "file:FileParser.scpt")
property TextParser : load script alias ((path to scripts folder from user domain as text) & "text:TextParser.scpt")
--
property _db_file_path : missing value --POSIX path of (alias ((path to sites folder from user domain as text) & "database.db")) --missing value---- --this value should be missing value, but its hardcoded for now--TODO rename to _selectedDBFilePath

on open file_list
	log "open()"
	set first_file to (first item in file_list)
	set file_path to FileParser's file_URL(first_file)
	set file_extension to FileParser's file_extension(first item in file_list)
	if file_extension = "db" then
		my MainDialog's set_db_file_path(file_path)
		my MainDialog's show()
	else
		display alert "wrong file type: " & file_extension & " must be of type .db"
	end if
end open

MainDialog's show()

script MainDialog
	log "MainDialog()"
	property _last_selected_action : "Create"
	--
	on show()
		if my MainDialog's get_db_file_path() = missing value then
			promt_config_dialog()
		end if
		set db_file_name to FileParser's file_name_by_url(my MainDialog's get_db_file_path())
		set the_action to choose from list {"Create", "Read", "Update", "Delete"} with title "" with prompt "Actions:" default items {_last_selected_action} cancel button name "Exit"
		handle_action_choice(the_action)
	end show
	--
	on promt_config_dialog()
		set the_choice to choose from list {"Choose database", "Create new database"} with title "" with prompt "Actions:" default items {"Choose database"} cancel button name "exit"
		if the_choice is false then --exit
			--error number -128 -- User canceled
		else
			set selected_item to item 1 of the_choice
			set file_path to missing value
			if selected_item = "Choose database" then
				set file_path to SQLiteHelper's choose_database_file()
			else if selected_item = "Create new database" then
				set file_path to SQLiteHelper's create_new_database()
			end if
			log file_path
			if file_path = missing value then
				promt_config_dialog()
			else
				set_db_file_path(file_path)
			end if
		end if
	end promt_config_dialog
	--Handles action choice
	on handle_action_choice(action)
		log "handleActionChoice"
		if action is false then --exit
			--error number -128 -- User canceled
		else
			set selected_item to item 1 of action
			set _last_selected_action to selected_item
			if selected_item = "Create" then
				log "create"
				my CreateDialog's show()
			else if selected_item = "Read" then
				log "read"
				my ReadDialog's show()
			else if selected_item = "Update" then
				log "update"
				my UpdateDialog's show()
			else if selected_item = "Delete" then
				log "delete"
				my DeleteDialog's show()
			end if
		end if
	end handle_action_choice
	--
	on set_db_file_path(db_file_path) --td move to global value
		set _db_file_path to db_file_path
	end set_db_file_path
	--
	on get_db_file_path()
		return _db_file_path
	end get_db_file_path
end script
--
script CreateDialog
	property _last_selected_action : "Database"
	on show()
		log "displayCreateActions() "
		set the_selection to choose from list {"Database", "Table", "Columns", "Row"} with title "" with prompt "Create:" default items {_last_selected_action} cancel button name "back"
		if the_selection is false then --aka user canceled
			--set action_dialog to ActionsDialog
			MainDialog's show()
			--error number -128 -- User canceled
		else
			set selected_action to (item 1 of the_selection)
			log "selected_action: " & selected_action
			handle_create_action(selected_action)
		end if
	end show
	--
	on create_database()
		log "create_database()"
		set file_path to SQLiteHelper's create_new_database()
		log file_path
		--TODO some sort of promt witht he path + name of the newly created database
		show()
	end create_database
	--
	on create_column()
		log "create_column()"
		set chosen_table_name to SQLiteHelper's choose_table_name(_db_file_path)
		set new_column_keys to promt_for_column_keys({})
		SQLiteModifier's add_columns(_db_file_path, chosen_table_name, new_column_keys) --create the table
		show()
	end create_column
	--
	--TODO this promt could be better if we did a while loop and has "another key", "done" and "cancel" as buttons
	on create_table()
		log "create_table()"
		log "_db_file_path: " & _db_file_path
		set ret_val to display dialog "Table name:" default answer "" with title "Create table name:" buttons {"Ok"} default button "Ok"
		set new_table_name to text returned of ret_val
		log "new_table_name: " & new_table_name
		set new_column_keys to promt_for_column_keys({})
		log "new_column_keys: " & new_column_keys
		SQLiteModifier's create_table(_db_file_path, new_table_name, new_column_keys) --create the table
		show()
	end create_table
	--NOTE this method can be used to create new column keys and also update existing ones
	--TODO maybe seperate creating new and updating old col_keys into two methods?
	on promt_for_column_keys(column_keys)
		log "promt_for_column_keys()"
		set ordinal to TextParser's ordinal((length of column_keys) + 1) --first, second, third, fourth etc
		set column_key_result to display dialog "The " & ordinal & " Column key: " default answer "" with title "Columnt keys: " buttons {"Add another key", "All done", "Cancel"} default button "Add another key" cancel button "Cancel" --maybe we should have a back button ? we could replace cancel with back
		set column_key_input to text returned of column_key_result --TODO create an if else clause here if user did not input correct data then go back to previous dialog box
		log "length of column_key_input: " & (length of column_key_input)
		if length of column_key_input > 0 then --makes sure that only input that has chars is added as a key
			set column_keys to column_keys & column_key_input
		end if
		set selected_button to button returned of column_key_result
		if selected_button = "All done" then
			return column_keys
		else if selected_button = "Add another key" then
			return promt_for_column_keys(column_keys) --repeat the same querry again
		else if selected_button = "Cancel" then
			return column_keys
		end if
	end promt_for_column_keys
	--Sequental input
	on create_row()
		log "create_row()"
		set chosen_table_name to SQLiteHelper's choose_table_name(_db_file_path)
		set column_names to SQLiteParser's column_names(_db_file_path, chosen_table_name)
		log "columnNames: " & column_names
		set table_names to words of SQLiteParser's table_names(_db_file_path)
		set row_values to {}
		repeat with i from 1 to (length of column_names)
			set column_name to item i of column_names
			log "column_name: " & column_name
			if table_names contains column_name then --table_names contains the column_name
				set chosen_row_id to SQLiteHelper's choose_row_id(_db_file_path, column_name)
				log "chosen_row_id: " & chosen_row_id
				set row_values to row_values & chosen_row_id --add to the list
			else --regular input of value
				set ret_val to display dialog column_name & ":" default answer "" with title "Row value for column key: " & column_name buttons {"Ok", "Choose value", "back"} default button "Ok" cancel button "back"
				set button_returned to button returned of ret_val
				if button_returned = "Ok" then
					set the_input to text returned of ret_val --extract the input text
					set row_values to row_values & the_input --add to the list
				else if button_returned = "Choose value" then --choose the row_value from a table -> row -> column
					set temp_row_value to SQLiteHelper's choose_value(_db_file_path)
					set row_values to row_values & temp_row_value --add to the list
				else if button_returned = "back" then
					show() --return to begining of the process
				end if
			end if
		end repeat
		log "row_values: " & row_values
		SQLiteModifier's insert_row(_db_file_path, chosen_table_name, column_names, row_values) --TODO promt a success or fail popup after this I guess
		show()
	end create_row
	--
	on handle_create_action(selected_action) --TODO rename to handleActionChoice
		log "handle_create_action"
		set _last_selected_action to selected_action
		if selected_action = "Database" then
			create_database()
		else if selected_action = "Table" then
			create_table()
		else if selected_action = "Columns" then
			create_column()
		else if selected_action = "Row" then
			create_row() --promt value input for each column key
		end if
	end handle_create_action
end script
--
--TODO we should have 2 methods one named read row which would just display the entire row, and one for reading a row value
script ReadDialog
	property _last_selected_action : "Database"
	--Display list of actions
	on show()
		log "displayReadActions() "
		set the_selection to choose from list {"Database", "Table", "Columns", "Row", "Value"} with title "" with prompt "Read:" default items {_last_selected_action} cancel button name "back"
		if the_selection is false then --aka user canceled
			--error number -128 -- User canceled
			my MainDialog's show()
		else
			set selected_action to (item 1 of the_selection)
			handle_read_action(selected_action)
		end if
	end show
	--
	on read_db()
		log "read_database()"
		log "_db_file_path: " & _db_file_path
		set table_names to words of SQLiteParser's table_names(_db_file_path)
		log "table_names: " & table_names
		set table_names_as_paragraphs to TextParser's to_paragraphs(table_names)
		set ret_val to (display dialog table_names_as_paragraphs buttons {"OK"} default button "OK") --"Add to clipboard", "Export"
		show()
	end read_db
	--TODO add commas between rows
	--TODO add the columns in the first line
	on read_table() --TODO rename to readRows
		log "read_table() "
		set table_name to SQLiteHelper's choose_table_name(_db_file_path)
		if table_name = missing value then
			show()
			return
		end if
		log "table_name: " & table_name
		log "_db_file_path: " & _db_file_path
		--set selected_table_name to my MainDialog's get_selected_table_name()
		--log "selected_table_name: " & selected_table_name
		set column_keys to {"id"} & SQLiteParser's column_names(_db_file_path, table_name)
		log "column_keys: " & column_keys
		set the_column_keys to TextParser's delimited_text(column_keys, "|")
		log "the_column_keys: " & the_column_keys
		set table_rows to SQLiteParser's read_table(_db_file_path, table_name, {"_rowid_", "*"})
		log "table_rows: " & table_rows
		set table_rows to SQLiteUtil's cap_row_values(table_rows, 16) --caps each row item to 16 chars
		log "capped table_rows: " & table_rows
		set the_result to the_column_keys & return & return & table_rows
		set ret_val to (display dialog the_result buttons {"OK"} default button "OK") --, "Add to clipboard", "Export"
		read_table() --why is this called again?
	end read_table
	--
	on read_column_keys()
		log "read_column_keys() "
		set table_name to SQLiteHelper's choose_table_name(_db_file_path)
		if table_name = missing value then
			show()
			return
		end if
		log "table_name: " & table_name
		set column_names to SQLiteParser's column_names(_db_file_path, table_name)
		log "column_names: " & column_names
		log "length of column_names: " & (length of column_names)
		set column_names_as_paragraphs to TextParser's to_paragraphs(column_names)
		set ret_val to (display dialog column_names_as_paragraphs buttons {"OK"} default button "OK") --, "Add to clipboard", "Export"
		read_column_keys()
	end read_column_keys
	--TODO the column key should be infront of each row value with a ":" char in between, you can do this if you create a for-loop and loop through both rowItems and columnKeys arrays
	on read_row()
		log "read_row() "
		set table_name to SQLiteHelper's choose_table_name(_db_file_path)
		if table_name = missing value then
			show()
			return
		end if
		log "table_name: " & table_name
		set the_row to SQLiteHelper's choose_row(_db_file_path, table_name)
		log "the_row: " & the_row
		set row_items to items of TextParser's split(the_row as text, "|")
		set row_items_as_paragraphs to TextParser's to_paragraphs(row_items)
		--get the column_keys
		set column_keys to {"id"} & SQLiteParser's column_names(_db_file_path, table_name)
		log "column_keys: " & column_keys
		log "length of column_keys: " & (length of column_keys)
		set the_result to ""
		repeat with i from 1 to (length of column_keys)
			set the_result to the_result & (item i of column_keys) & space & ":" & space & (item i of row_items) & return
		end repeat
		log "the_result: " & the_result
		set ret_val to (display dialog the_result buttons {"OK"} default button "OK")
		read_row()
	end read_row
	--this may not be in use??!?
	on read_row_value()
		log "read_row_value()"
		set table_name to SQLiteHelper's choose_table_name(_db_file_path)
		if table_name = missing value then
			show()
			return
		end if
		log "table_name: " & table_name
		set the_row to SQLiteHelper's choose_row(_db_file_path, table_name)
		if the_row = missing value then
			read_row_value()
			return
		end if
		log "the_row: " & the_row
		--set selected_row to SQLiteHelper's choose_row_value(the_row)
		set column_keys to SQLiteParser's column_names(_db_file_path, table_name)
		set column_keys to {"id"} & column_keys
		set row_value_index to SQLiteHelper's choose_row_value_index(the_row, column_keys)
		log "row_value_index" & row_value_index
		
		if row_value_index = null then --was missing value
			read_row_value()
			return
		end if
		set row_items to items of TextParser's split(the_row as text, "|")
		log "row_items: " & row_items
		set selected_row to item row_value_index of row_items
		log "selected_row: " & selected_row
		set ret_val to (display dialog selected_row buttons {"OK"} default button "OK") --, "Add to clipboard", "Export"
		read_row_value()
	end read_row_value
	--Displays a list of the tables in the database	
	--Handle read action
	on handle_read_action(selected_action)
		log "handle_read_action()"
		log "selected_action: " & selected_action
		set _last_selected_action to selected_action
		if selected_action = "Database" then
			read_db()
		else if selected_action = "Table" then --Displays all table names
			read_table()
		else if selected_action = "Columns" then
			read_column_keys()
		else if selected_action = "Row" then
			read_row()
		else if selected_action = "Value" then
			read_row_value()
		end if
	end handle_read_action
end script
--
script UpdateDialog
	property _last_selected_action : "Table name"
	on show()
		set the_selection to choose from list {"Table name", "Column keys", "Row values", "Swap columns"} with title "" with prompt "Update:" default items {_last_selected_action} cancel button name "back"
		if the_selection is false then --aka user canceled
			--error number -128 -- User canceled
			my MainDialog's show()
		else
			--my MainDialog's set_selected_action(item 1 of the_selection)
			--log "selectedAction: " & my MainDialog's get_selected_action()
			handle_update_action(item 1 of the_selection)
		end if
	end show
	--
	on update_table_name() --TODO use the editValue dialog instead of this, and move out the sqlitemodifier code
		log "updateTableName()"
		set chosen_table_name to SQLiteHelper's choose_table_name(_db_file_path)
		log "chosen_table_name: " & chosen_table_name
		set ret_val to display dialog "Table name:" default answer chosen_table_name with title "Update table name:" buttons {"Ok"} default button "Ok"
		set new_table_name to text returned of ret_val
		SQLiteModifier's rename_table(_db_file_path, chosen_table_name, new_table_name)
		show()
	end update_table_name
	--
	on update_column_keys()
		set chosen_table_name to SQLiteHelper's choose_table_name(_db_file_path)
		log "chosen_table_name: " & chosen_table_name
		set chosen_column_keys to SQLiteHelper's choose_column_keys(_db_file_path, chosen_table_name)
		set new_column_keys to edit_column_keys(chosen_column_keys, {})
		SQLiteModifier's rename_columns(_db_file_path, chosen_table_name, chosen_column_keys, new_column_keys)
		show()
	end update_column_keys
	--
	on edit_column_keys(old_column_keys, new_column_keys)
		log "edit_column_keys"
		log "_db_file_path: " & my _db_file_path
		set current_index to (length of new_column_keys) + 1
		log "current_index: " & current_index
		set current_selected_column_key to item current_index of old_column_keys
		log "current_selected_column_key: " & current_selected_column_key
		if current_index = length of old_column_keys then
			set the_buttons to {"All done", "Cancel"}
			set the_default_button to "All done"
		else
			set the_buttons to {"Edit next key", "Cancel"}
			set the_default_button to "Edit next key"
		end if
		set column_key_result to display dialog "Edit column key: " default answer "" & current_selected_column_key with title "Edit column key: " buttons the_buttons default button the_default_button cancel button "Cancel" --maybe we should have a back button ? we could replace cancel with back
		log column_key_result
		set column_key_input to text returned of column_key_result --TODO create an if else clause here if user did not input correct data then go back to previous dialog box
		log "column_key_input: " & column_key_input
		log "length of column_key_input: " & (length of column_key_input)
		if length of column_key_input > 0 then --makes sure that only input that has chars is added as a key
			set new_column_keys to new_column_keys & column_key_input
		end if
		set button_returned to button returned of column_key_result
		if button_returned = "All done" then
			log "All done"
			log "old_column_keys: " & old_column_keys
			log "new_column_keys: " & new_column_keys
			log "_db_file_path: " & _db_file_path
			return new_column_keys
		else if button_returned = "Edit next key" then
			return edit_column_keys(old_column_keys, new_column_keys)
		else if button_returned = "Cancel" then
			return old_column_keys
		end if
	end edit_column_keys
	--TODO you should select the columns not the row values them self, this is the only thing that makes sense
	--Note this method can edit many row ids in a sequence, thats why its a little complex
	on update_row_values()
		log "update_row_values()"
		set chosen_table_name to SQLiteHelper's choose_table_name(_db_file_path)
		log "chosen_table_name: " & chosen_table_name
		set chosen_row to SQLiteHelper's choose_row(_db_file_path, chosen_table_name) --select the row to manipulate
		--log "chosen_row: " & chosen_row
		--set row_values to SQLiteHelper's choose_row_values(chosen_row)
		
		set table_column_keys to SQLiteParser's column_names(_db_file_path, chosen_table_name) --select the values to manipulate
		--set table_column_keys to {"id"} & table_column_keys
		log "table_column_keys: " & table_column_keys
		
		set row_value_indices to SQLiteHelper's choose_row_value_indices(chosen_row, table_column_keys)
		log "row_value_indices: " & row_value_indices
		set row_values_list to items of TextParser's split(chosen_row as text, "|") --TODO make this simpler
		set row_values_list to ((items 2 thru (length of row_values_list) of row_values_list))
		--log "row_values_list: " & row_values_list
		set row_values to ListParser's items_at(row_values_list, row_value_indices)
		set the_column_keys to ListParser's items_at(table_column_keys, row_value_indices)
		log "the_column_keys: " & the_column_keys
		--log "row_values: " & row_values
		--set the_column_keys to SQLiteHelper's column_keys(_db_file_path, chosen_table_name, chosen_row, row_values)
		set table_names to words of SQLiteParser's table_names(_db_file_path)
		log "table_names: " & table_names
		set the_input to {}
		repeat with i from 1 to (length of the_column_keys)
			set column_key to item i of the_column_keys
			log "column_key: " & column_key
			set the_row_value to item i of row_values
			set the_description to "Update the value of " & column_key & ": "
			set res_val to display dialog the_description default answer the_row_value with title "Row value for column key:" buttons {"Ok", "Choose value", "back"} default button "Ok" cancel button "back"
			set button_returned to button returned of res_val
			if button_returned = "Ok" then
				set input_text to text returned of res_val
				log "input_text: " & input_text
				set the_input to the_input & {{column_key, input_text}}
			else if button_returned = "Choose value" then --choose the row_value from a table -> row -> column
				set temp_row_value to SQLiteHelper's choose_value(_db_file_path)
				set the_input to the_input & {{column_key, temp_row_value}}
			else if button_returned = "back" then
				show()
			end if
		end repeat
		log "length of the_input: " & (length of the_input)
		log "the_input: " & the_input
		set row_id to SQLiteHelper's row_id(chosen_row)
		log "row_id: " & row_id
		SQLiteModifier's update_rows(_db_file_path, chosen_table_name, {{"_rowid_", row_id}}, the_input)
		show()
	end update_row_values
	--
	on swap_columns()
		set chosen_table_name to SQLiteHelper's choose_table_name(_db_file_path)
		log "chosen_table_name: " & chosen_table_name
		set column_key_A to SQLiteHelper's choose_column_key(_db_file_path, chosen_table_name)
		log "column_key_A: " & column_key_A
		set column_key_B to SQLiteHelper's choose_column_key(_db_file_path, chosen_table_name)
		log "column_key_B: " & column_key_B
		SQLiteModifier's swap_columns(_db_file_path, chosen_table_name, column_key_A, column_key_B)
		show()
	end swap_columns
	--handle update actions
	--TODO create methods for each if clause
	on handle_update_action(selected_action)
		log "handle_update_action: " & selected_action
		set _last_selected_action to selected_action
		if selected_action = "Table name" then
			update_table_name()
		else if selected_action = "Column keys" then --Displays all table names
			update_column_keys()
		else if selected_action = "Row values" then
			update_row_values()
		else if selected_action = "Swap columns" then
			swap_columns()
		end if
	end handle_update_action
end script
--
script DeleteDialog
	property _last_selected_action : "Database"
	on show()
		log "displayCreateActions() "
		set the_selection to choose from list {"Database", "Table", "Columns", "Row"} with title "" with prompt "Delete:" default items _last_selected_action cancel button name "back"
		if the_selection is false then --aka user canceled
			--error number -128 -- User canceled
			my MainDialog's show()
		else
			set selected_action to item 1 of the_selection
			log "selected_action: " & selected_action
			handle_delete_action(selected_action)
		end if
	end show
	--
	on delete_database()
		set db_file_path to SQLiteHelper's choose_database_file() --select the database
		log "db_file_path: " & db_file_path
		FileModifier's delete_file(POSIX file db_file_path as alias)
		show()
	end delete_database
	--
	on delete_table()
		set table_name to SQLiteHelper's choose_table_name(_db_file_path)
		SQLiteModifier's remove_table(_db_file_path, table_name)
		show()
	end delete_table
	--
	on delete_column()
		set table_name to SQLiteHelper's choose_table_name(_db_file_path)
		set column_keys to SQLiteHelper's choose_column_keys(_db_file_path, table_name)
		SQLiteModifier's remove_columns(_db_file_path, table_name, column_keys) --call the sql remove columns method, 
		show()
	end delete_column
	--
	on delete_row()
		set table_name to SQLiteHelper's choose_table_name(_db_file_path)
		set rows to SQLiteHelper's choose_rows(_db_file_path, table_name)
		log "rows: " & rows
		repeat with i from 1 to (length of rows)
			set row_id to first item of (item i of rows)
			log "row_id: " & row_id
			SQLiteModifier's remove_row(_db_file_path, table_name, {{"_rowid_", row_id}})
		end repeat
		show()
	end delete_row
	--
	on handle_delete_action(selected_action)
		log "handle_delete_action"
		set _last_selected_action to selected_action
		if selected_action = "Database" then
			delete_database()
		else if selected_action = "Table" then
			delete_table()
		else if selected_action = "Columns" then
			delete_column()
		else if selected_action = "Row" then
			delete_row()
		end if
	end handle_delete_action
end script

--else if _selectedAction = "Update column key" then
--				log "error del this line"
--SQLiteModifier's renameColumns(_dbFilePath, _selectedTableName, _selectedColumnKeys, _columnKeys)
--			end if
