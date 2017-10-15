#NoEnv
#Warn, LocalSameAsGlobal, Off
SetWorkingDir %A_ScriptDir% 
#Include <DBA>

class CSPShortCut
{
	static Results :=

	__New() {
		EnvGet, HomeDrive, HOMEDRIVE
		EnvGet, HomePath, HOMEPATH
		
		DBType = SQLite
		DBLoc = %HomeDrive%%HomePath%\Documents\CELSYS_EN\CLIPStudioPaintVer1_1_0\Shortcut\default.khc
		DB :=

		Query = 
		(
			select menucommand mc, shortcut sc, modifier mod
			from shortcutmenu
			where menucommandtype = 'advancedcommand'
			and menucommand in
			('layermergeselectedlayer',
			 'layerordertop',
			 'layervisiblelayer',
			 'layerchangedraftlayer',
			 'layerchangename')
		)

		try {
			DB := DBA.DataBaseFactory.OpenDataBase(DBType, DBLoc)			
		} catch e {
			this.ShowInstruction()
		}

		if (this.IsConnected(DB))
			this.Results := this.RunSQL(Query, DB)

		this.CloseDB(DB)

		HomeDrive :=
		HomePath :=
		DBType :=
		DBLoc :=
		DB :=
		Query :=
	}

	__Delete() {
		this.Results :=
	}

	IsReady() {
		Ready := (this.Results != null)

		return Ready
	}

	Copy() {
		Send ^c
	}

	Paste() {
		Send ^v
	}

	Undo() {
		Send ^z
	}

	CombineSelectedLayer() {
		this.Execute("layermergeselectedlayer")
	}	

	LayerOrderTop() {
		this.Execute("layerordertop")
	}

	ShowLayer() {
		this.Execute("layervisiblelayer")
	}

	SetAsDraftLayer() {
		this.Execute("layerchangedraftlayer")
	}

	ChangeLayerName() {
		SendBackSpace := this.Execute("layerchangename")

		if (SendBackSpace)
			Send {Backspace}
	}

	Execute(Key) {
		Executed := true
		
		try {
			SC := this.Results[Key]["sc"]
			Mod := this.Results[Key]["mod"]

			if (StrLen(SC) > 1) {	
				SC := Format("{:T}", SC)
				SC = {%SC%}

				StringReplace, SC, SC, PageUp, PgUp, All
				StringReplace, SC, SC, PageDown, PgDn, All
				StringReplace, SC, SC, Num-, NumpadSub, All
				StringReplace, SC, SC, Num+, NumpadAdd, All
				StringReplace, SC, SC, Num*, NumpadMult, All
				StringReplace, SC, SC, Num/, NumpadDiv, All
				StringReplace, SC, SC, Num0, Numpad0, All
				StringReplace, SC, SC, Num1, Numpad1, All
				StringReplace, SC, SC, Num2, Numpad2, All
				StringReplace, SC, SC, Num3, Numpad3, All
				StringReplace, SC, SC, Num4, Numpad4, All
				StringReplace, SC, SC, Num5, Numpad5, All
				StringReplace, SC, SC, Num6, Numpad6, All
				StringReplace, SC, SC, Num7, Numpad7, All
				StringReplace, SC, SC, Num8, Numpad8, All
				StringReplace, SC, SC, Num9, Numpad9, All

				SC := Trim(SC)
			}

			if (!SC)
				Executed := false
			else if (!Mod)
				Executed := false
			else if (SC <> "NULL" && Mod <> "0") {
				if (Mod = "1")
					Send !%sc%
				else if (Mod = "2")
					Send +%sc%
				else if (Mod = "3")
					Send !+%sc% 
				else if (Mod = "4")
					Send ^%sc%
				else if (Mod = "5")
					Send ^!%sc%
				else if (Mod = "6")
					Send ^+%sc%
				else if (Mod = "7")
					Send ^!+%sc%
				else
					Executed := false
			} else
				Executed := false

			SC :=
			Mod :=
		} catch e {
			Executed := false
		}

		return Executed
	}

	CloseDB(DB) {
		if (!DB)
			return
		else if (isObject(DB))
			DB.close()
	}

	IsConnected(DB) {
		Connected := (DB != null)

		return Connected
	}

	RunSQL(SQL, DB){
		Results :=

		if (IsObject(DB))
		{
			State := ""
			
			if (Trim(SQL) == "") {
			   SB_SetText("No SQL entered")
			   Return
			}

			try {
				RS := DB.OpenRecordSet(SQL)

				if (IsObject(RS))
					Results := this.GetResults(RS)
			} catch e {
				MsgBox, 16, Error, % "OpenRecordSet Failed.`n`n" ExceptionDetail(e)
				State := "!# " e.What " " e.Message
			}

			if(State != "")
				SB_SetText(State)
		} else
			MsgBox,16, Error, No Connection avaiable. Please connect to a Database first!
		
		return Results
	}

	GetResults(RS) {
		Results :=

		if (!is(RS, DBA.RecordSet))
			throw Exception("RecordSet Object expected! RS was of type: " typeof(RS) ,-1)
		
		; fetch new data
		Columns := RS.getColumnNames()

		if (!Columns)
			this.ShowInstruction()
		else {
			Results := {}

			ColumnCount := Columns.Count()

			for each, ColName in Columns {
				Results[A_index] := ColName
			}

			RowCount = 0

			while (!RS.EOF) {
				Key = ''
				Loop, % ColumnCount {
					ColName := Results[A_index]

					if (ColName = "mc") {
						Key := RS[A_index]
						Results[Key] := { sc: "", mod: "" }
					} else if (ColName = "sc") {
						Results[Key][ColName] := RS[A_index]
					} else if (ColName = "mod") {
						Results[Key][ColName] := RS[A_index]
					}
				}

				RowCount++
				RS.MoveNext()
			}

			ColumnCount :=
		}

		Columns :=

		return Results
	}

	ShowInstruction() {
		ErrorMsg = Clip Studio Paint's shortcuts have not been configured properly.`n`nTo fix the issue:`n`n1. Run Clip Studio Paint.`n2. Go to 'Shortcut Settings' and click OK.`n3. Restart Clip Studio Paint.`n4. Reload this script.

		MsgBox, 16, Error, %ErrorMsg%
	}
}