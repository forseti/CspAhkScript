#Include .\CSPShortCut.ahk
#Include .\PSD2PNG.ahk

SC := new CSPShortCut()

; Reload
^!+r::
	MsgBox, 4, Confirmation, Reload this script?
    IfMsgBox, Yes
        Reload
    return

; Help
^!+h::
	Run notepad %A_WorkingDir%\README.txt
	return

; Exit
OnExit, ExitSub
return

ExitSub:
	SC :=
	Gui, Destroy
	ExitApp

; Gui Close/Escape
GuiClose:
GuiEscape:
	Gui, Destroy
	return

#IfWinNotActive, CLIP STUDIO PAINT
	; Set Clip Studio Paint to Active Window
	^!+a:: 
		WinActivate CLIP STUDIO PAINT
		return
#IfWinNotActive

#IfWinActive, CLIP STUDIO PAINT
	; Merging Layers as a New Layer
	^!+m::
		if (SC.IsReady()) {
			SC.CombineSelectedLayer()
			SC.Copy()
			SC.Undo()
			SC.Paste()
			SC.LayerOrderTop() ; [Optional] - Send Merged Layer to Top. Very Useful!
			SC.ShowLayer() ; [Optional] - This Action will Hide Merged Layer! Very Useful when converting PSD Layers to PNGs.
			SC.SetAsDraftLayer() ; [Optional] - Draft or Un-Draft Merged Layer. Very Useful when 'Selected Layers' are Drafts.
			SC.ChangeLayerName() ; [Optional] - Rename Merged Layer. Very Useful!
		}
		return
#IfWinActive

#IfWinActive ahk_class CabinetWClass
	^!+c:: PSD2PNG()
#IfWinActive