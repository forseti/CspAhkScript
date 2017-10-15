PSD2PNG() {
	global

	Gui, Destroy
	Gui, Add, Text,, Pick a PSD file to convert from the list below.`n(To cancel, press ESCAPE or close this window.)
	Gui, Add, ListBox, vFileListBox gFileListBox w500 r10

	ButtonSize = 90
	WindowSize = 500
	ButtonPos = %WindowSize% 
	ButtonPos -= %ButtonSize%
	
	Gui, Add, Button, xm x%ButtonPos% w90 h30, Convert

	ControlGetText, ExplorerPath, toolbarwindow323, ahk_class CabinetWClass

	StringReplace, ExplorerPath, ExplorerPath, % "Address: ",% ""

	Loop, %ExplorerPath%\*.psd, 0, 0 
	{ 
		GuiControl,, FileListBox, %A_LoopFileFullPath%						
	}

	Gui, Show,, PSD Layers to PNG Files Converter
	
	return

	FileListBox:
		if A_GuiEvent <> DoubleClick
			return
		; Otherwise, the user double-clicked a list item, so treat that the same as pressing OK.
		; So fall through to the next label.
	ButtonConvert:
		GuiControlGet, FileListBox  ; Retrieve the ListBox's current selection.
			
		if !FileListBox 
			MsgBox, 16, Error, No file is selected.
		else {
			MsgBox, 4, Confirmation, Would you like to convert the following PSD file?`n`n%FileListBox%
				
			IfMsgBox, No
				return
				
			; Otherwise, convert the PSD file.

			Run, convert,, UseErrorLevel
			
			if ErrorLevel = ERROR
				MsgBox, 16, Error, ImageMagick is not installed on your system.
			else {

				; Create 'out' directory if it does not exist
				IfNotExist, %ExplorerPath%\out
  					FileCreateDir, %ExplorerPath%\out
				
				Run, %ComSpec% /c convert "%FileListBox%" -delete 0 -set filename:layers `%l %ExplorerPath%/out/`%[filename:layers].png && del %ExplorerPath%\out\Paper.png,, UseErrorLevel Hide
			}
		}
			
		return
}