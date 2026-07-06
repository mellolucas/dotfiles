-- Ghostty workspace layout.
--
-- Usage:
--   osascript workspace.applescript WORKSPACE_DIR EDITOR_CMD AGENT_CMD MIDDLE_TOP_CMD MIDDLE_BOTTOM_CMD
--
-- Layout:
--
--   ┌───────────────┬───────────────┬───────────────┐
--   │               │               │               │
--   │   editor      │   shell       │   agent       │
--   │               │               │               │
--   │               ├───────────────┤               │
--   │               │               │               │
--   │               │   shell       │               │
--   │               │               │               │
--   └───────────────┴───────────────┴───────────────┘

on run argv
	if (count of argv) < 3 then
		error "usage: workspace.applescript WORKSPACE_DIR EDITOR_CMD AGENT_CMD [MIDDLE_TOP_CMD] [MIDDLE_BOTTOM_CMD]"
	end if
	
	set workspaceDir to item 1 of argv
	set editorCmd to item 2 of argv
	set agentCmd to item 3 of argv
	
	set middleTopCmd to ""
	set middleBottomCmd to ""
	
	if (count of argv) ≥ 4 then
		set middleTopCmd to item 4 of argv
	end if
	
	if (count of argv) ≥ 5 then
		set middleBottomCmd to item 5 of argv
	end if
	
	tell application "Ghostty"
		activate
		
		set cfg to new surface configuration
		set initial working directory of cfg to workspaceDir
		
		set workspaceWindow to new window with configuration cfg
		set workspaceTab to selected tab of workspaceWindow
		
		set middleTop to focused terminal of workspaceTab
		set leftEditor to split middleTop direction left with configuration cfg
		set rightAgent to split middleTop direction right with configuration cfg
		set middleBottom to split middleTop direction down with configuration cfg
		
		input text editorCmd to leftEditor
		send key "enter" to leftEditor
		
		input text agentCmd to rightAgent
		send key "enter" to rightAgent
		
		if middleTopCmd is not "" then
			input text middleTopCmd to middleTop
			send key "enter" to middleTop
		end if
		
		if middleBottomCmd is not "" then
			input text middleBottomCmd to middleBottom
			send key "enter" to middleBottom
		end if
		
		perform action "equalize_splits" on middleTop
		focus middleTop
	end tell
end run

