B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region
'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
	#If B4J
	Private fx As JFX
	#End If
	Public DB As MiniORM
	Public CON As DatabaseConnector
	Private xui As XUI
	Private Timer1 As Timer
	Private Root As B4XView
	Private PnlLeft As B4XView
	Private PnlRight As B4XView
	Private Pane1 As B4XView
	Private PnlMain As B4XView
	Private LblCategory As B4XView
	Private LblInfo As B4XView
	Private Button100 As B4XView
	Private TxtLeft As B4XView
	Private TxtCenter As B4XView
	Private TxtRight As B4XView	
	Private LblName1 As B4XView
	Private LblName2 As B4XView
	Private LblName3 As B4XView
	Private LblName4 As B4XView
	Private LblPrice1 As B4XView
	Private LblPrice2 As B4XView
	Private LblPrice3 As B4XView
	Private LblPrice4 As B4XView
	Private ClvLeft As CustomListView
	Private ClvRight As CustomListView
	Private ClvSales As CustomListView
	Private ClvItems As CustomListView
	Private Img1 As B4XImageView
	Private Img2 As B4XImageView
	Private Img3 As B4XImageView
	Private Img4 As B4XImageView
	#If B4J
	Public sp1 As ScrollPane
	Public pnbuttons As Pane
	Private Pnl1 As Pane
	Private Pnl2 As Pane
	Private Pnl3 As Pane
	Private Pnl4 As Pane
	Private PnlName1 As Pane
	Private PnlName2 As Pane
	Private PnlName3 As Pane
	Private PnlName4 As Pane	
	#Else
	Public sp1 As ScrollView
	Public pnbuttons As Panel
	Private Pnl1 As Panel
	Private Pnl2 As Panel
	Private Pnl3 As Panel
	Private Pnl4 As Panel
	Private PnlName1 As Panel
	Private PnlName2 As Panel
	Private PnlName3 As Panel
	Private PnlName4 As Panel
	#End If
	Public BtnTotal As Button
	Private Items As List
	Private SalesItems As List
	Private TenderItems As List
	'Private TempNum As String
	'Private SalesNum As String
	#If B4J
	Private tooltipstyle As String
	Public sp1dragged As Boolean
	#End If
	Private dblTotalAmount As Double
	Private LoginPage1 As LoginPage
	Private TempSalesItem As SalesItem
	'Private Const LEFT As String = "LEFT"
	'Private Const RIGHT As String = "RIGHT"
	Private Const CENTER As String = "CENTER"
	Private Const Title As String = "B4POS"
	Private Const COLOR_RED As Int = -65536			'ignore
	Private Const COLOR_BLUE As Int = -16776961		'ignore
	Private Const COLOR_MAGENTA As Int = -65281		'ignore
	Private Categories As List
	Type Category (Id As Int, Name As String)
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
	Categories.Initialize
	TempSalesItem.Initialize
	TempSalesItem.Promo.Initialize
	SalesItems.Initialize
	TenderItems.Initialize
	Timer1.Initialize("Timer1", 1000)
	Timer1.Enabled = True
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
	PnlLeft.LoadLayout("LeftPanel")
	PnlRight.LoadLayout("RightPanel")
	B4XPages.SetTitle(Me, Title)
	B4XPages.AddPage("LoginPage", LoginPage1.Initialize)
	LblInfo.Text = Utils.ConvertDateTime3(DateTime.Now)
	
	#If B4J
	sp1.Initialize("")
	sp1.Pannable = True
	sp1.SetHScrollVisibility("NEVER")
	sp1.SetVScrollVisibility("NEVER")
	sp1.FitToHeight = True			' no vertical dragging or mouse wheel scrolling!
	pnbuttons.Initialize("pnbuttons")
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvLeft, xui.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvRight, xui.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvSales, xui.Color_Transparent)
	CallSubDelayed3(Me, "SetScrollPaneBackgroundColor", ClvItems, xui.Color_Transparent)
	#Else
	Dim sp1 As ScrollView
	sp1.Initialize(60dip)
	pnbuttons.Initialize("pnbuttons")
	#End If
	Items.Initialize
	
	'TempNum = ""
	InitFonts
	DBInit
	#If B4J
	BtnTotal.MouseCursor = fx.Cursors.HAND
	#End If
End Sub

#If B4J
Private Sub SetScrollPaneBackgroundColor(View As CustomListView, Color As Int)
	Dim SP As JavaObject = View.GetBase.GetView(0)
	Dim V As B4XView = SP
	V.Color = Color
	Dim V As B4XView = SP.RunMethod("lookup", Array(".viewport"))
	V.Color = Color
End Sub
#End If

Sub Timer1_Tick
	'Handle tick events
	LblInfo.Text = Utils.ConvertDateTime3(DateTime.Now)
End Sub

Private Sub InitFonts
	'Main.FontBold = CreateB4XFont("NotoSansSC-Bold.ttf", 18, 18)
	'Main.FontRegular = CreateB4XFont("NotoSansSC-Regular.ttf", 18, 	18)
End Sub

'NativeFontSize is needed only for B4J or B4I.
Sub CreateB4XFont (FontFileName As String, FontSize As Float, NativeFontSize As Float) As B4XFont 'ignore
    #If B4A
       Return xui.CreateFont(Typeface.LoadFromAssets(FontFileName), FontSize)
    #Else If B4i
	'Return xui.CreateFont(Font.CreateNew2(FontFileName, NativeFontSize), FontSize)
	Return Font.CreateNew2(FontFileName.Replace(".ttf", "").Replace(".otf", ""), NativeFontSize)
    #Else    ' B4J
	If FontFileName.EqualsIgnoreCase("Trebuchet MS") Then
		Return fx.CreateFont("Trebuchet MS", FontSize, True, False)
	Else
		Return xui.CreateFont(fx.LoadFont(File.DirAssets, FontFileName, NativeFontSize), FontSize)
	End If
    #End If
End Sub

Public Sub DBInit
	Dim CNN As Conn
	CNN.Initialize
	CNN.DBType = "SQLite"
	CNN.DBFile = "data.sqlite"
	
	#If B4J
	CNN.DBDir = File.DirApp
	'xui.SetDataFolder(con.DBName)
	'CNN.DBDir = File.Combine(xui.DefaultFolder, CNN.DBDir)
	#Else
	CNN.DBDir = xui.DefaultFolder 
	#End If

	Try
		CON.Initialize(CNN)
		Dim DBFound As Boolean = CON.DBExist
		If DBFound Then
			LogColor($"${CON.DBEngine} database found!"$, COLOR_BLUE)
			DB.Initialize(DBOpen, DBEngine)
			'DB.ShowExtraLogs = True
			LoadCategories
			LoadButtons
			LoadLineItems
			LoadCardItems
		Else
			LogColor($"${CON.DBEngine} database not found!"$, COLOR_RED)
			CreateDatabase
		End If
	Catch
		Log(LastException.Message)
		LogColor("Error checking database!", COLOR_RED)
		Log("Application is terminated.")
		#If B4J
		ExitApplication
		#End If
	End Try
End Sub

Private Sub DBEngine As String
	Return CON.DBEngine
End Sub

Private Sub DBOpen As SQL
	Return CON.DBOpen
End Sub

Private Sub DBClose
	CON.DBClose
End Sub

Private Sub CreateDatabase
	LogColor("Creating database...", COLOR_MAGENTA)
	Wait For (CON.DBCreate) Complete (Success As Boolean)
	If Not(Success) Then
		Log("Database creation failed!")
		Return
	End If
	
	DBClose
	DB.Initialize(DBOpen, DBEngine)
	'DB.ShowExtraLogs = True
	DB.UseTimestamps = True
	'DB.ExecuteAfterCreate = True
	'DB.ExecuteAfterInsert = True
	DB.AddAfterCreate = True
	DB.AddAfterInsert = True
	
	DB.Table = "categories"
	DB.Columns.Add(DB.CreateORMColumn2(CreateMap("Name": "name")))
	DB.Create
	DB.Columns = Array("name")
	DB.Insert2(Array As String("Drinks"))
	DB.Insert2(Array As String("Rice"))
	DB.Insert2(Array As String("Noodles"))
	DB.Insert2(Array As String("Dim Sum"))
	DB.Insert2(Array As String("Smoothies"))
	DB.Insert2(Array As String("Side Dish"))
	DB.Insert2(Array As String("Snack & Etc"))

	DB.Table = "products"
	DB.Columns.Add(DB.CreateORMColumn2(CreateMap("Name": "cat_id", "Type": DB.INTEGER)))
	DB.Columns.Add(DB.CreateORMColumn2(CreateMap("Name": "code", "Type": DB.VARCHAR, "Size": 12)))
	DB.Columns.Add(DB.CreateORMColumn2(CreateMap("Name": "name")))
	DB.Columns.Add(DB.CreateORMColumn2(CreateMap("Name": "price", "Type": DB.DECIMAL, "Size": "10,2", "Default": 0.0)))
	DB.Foreign("cat_id", "id", "categories", "", "")
	DB.Create
	
	DB.Columns = Array("cat_id", "code", "name", "price")
	DB.Insert2(Array As String(1, "D001", "Coffee", 2.5))
	DB.Insert2(Array As String(1, "D002", "Tea", 2.5))
	
	Wait For (DB.ExecuteBatch) Complete (Success As Boolean)
	If Success Then
		LogColor("Database is created successfully!", COLOR_BLUE)
	Else
		LogColor("Database creation failed!", COLOR_RED)
		Log(LastException)
		Return
	End If
	DB.Close
	DB.Initialize(DBOpen, DBEngine)
	LoadCategories
	LoadButtons
	LoadLineItems
	LoadCardItems
End Sub

Private Sub LoadCategories
	Try
		DB.Table = "categories"
		DB.Query
		Dim Items As List = DB.Results
		For Each Item As Map In Items
			Categories.Add(Item.Get("name"))
		Next
	Catch
		xui.MsgboxAsync(LastException.Message, "Error")
	End Try
	DBClose
End Sub

Public Sub LoadButtons
	For i = 0 To Categories.Size - 1 '.Length - 1
		#If B4J
		Dim pn As Pane = CreateButtonCategory(Categories.Get(i))
		pnbuttons.AddNode(pn, 1 + (152*i), 0, 150, 60)
		#Else
		Dim pn As B4XView = CreateButtonCategory(Categories.Get(i))
		pnbuttons.AddView(pn, 1dip + (152*i), 0, 150dip, 60dip)
		#End If
	Next
	#If B4J
	pnbuttons.PrefWidth = 152 * Categories.Size
	sp1.InnerNode = pnbuttons
	PnlMain.AddView(sp1, 5, 50, Pane1.Width, 60)	' Pane1 in the design reserves the place for the sp1
	'sp1.TooltipText = "Click or drag to select." & CRLF & _
	'				  "Move the mouse after dragging to click."
	'sp1.TooltipText = ""
	tooltipstyle = File.ReadString(File.DirAssets, "tooltipstyle.css")
	set_tooltip_style(sp1)
	#Else
	pnbuttons.Width = 152 * Categories.Size
	PnlMain.AddView(sp1, 5dip, 50dip, Pane1.Width, 60dip)	' Pane1 in the design reserves the place for the sp1
	#End If
	
	Dim Width As Double = ClvLeft.AsView.Width
	ClvLeft.Clear
	For i = 1 To 9
		ClvLeft.Add(CreateButton100("Test " & i, Width, CENTER), 0)
	Next
		
	Dim Width As Double = ClvRight.AsView.Width
	ClvRight.Clear
	For i = 1 To 9
		ClvRight.Add(CreateButton100("Test " & i, Width, CENTER), 0)
	Next
End Sub

Sub CalculateTotalAmount
	dblTotalAmount = 0
	For Each item1 As SalesItem In SalesItems
		dblTotalAmount = dblTotalAmount + item1.Price
	Next
	BtnTotal.Text = "RM " & NumberFormat2(dblTotalAmount, 1, 2, 2, False)
End Sub

Sub LoadLineItems
	ClvSales.Clear
	ClvSales.Add(CreateLineItem(Null, Title, Null), 0)
	ClvSales.Add(CreateLineItem(Null, "Cashier: BOSS", Null), 0)
	ClvSales.Add(CreateLineItem(Null, "Date: " & Utils.ConvertDate3(DateTime.Now), Null), 0)
	ClvSales.Add(CreateLineItem(Null, "Time: " & Utils.ConvertTime3(DateTime.Now), Null), 0)
	ClvSales.Add(CreateLineItem(Null, TAB, Null), 0)
	
	Dim item1 As SalesItem
	item1.Initialize
	item1.Name = "Coffee"
	item1.Price = 3
	ClvSales.Add(CreateLineItem(item1.Name, Null, NumberFormat2(item1.Price, 1, 2, 2, False)), 1)
	SalesItems.Add(item1)
	
	Dim item1 As SalesItem
	item1.Initialize
	item1.Name = "Teh"
	item1.Price = 3
	ClvSales.Add(CreateLineItem(item1.Name, Null, NumberFormat2(item1.Price, 1, 2, 2, False)), 2)
	SalesItems.Add(item1)
	CalculateTotalAmount
End Sub

Sub LoadCardItems
	ClvItems.Clear
	
	Dim item1 As CardItem
	item1.Initialize
	item1.Index = 1
	item1.Image = "C001.png"
	item1.Name = "Coffee"
	item1.Price = "RM 3.00"
	item1.PriceTextColor = xui.Color_DarkGray
	
	Dim item2 As CardItem
	item2.Initialize
	item2.Index = 2
	item2.Image = "B001.png"
	item2.Name = "Coffee Latte"
	item2.Price = "RM 5.00"
	item2.PriceTextColor = xui.Color_White
	
	Dim item3 As CardItem
	item3.Initialize
	item3.Index = 3
	item3.Image = "B002.png"
	item3.Name = "Cham"
	item3.Price = "RM 4.50"
	item3.PriceTextColor = xui.Color_White
	
	Dim item4 As CardItem
	item4.Initialize
	item4.Index = 4
	item4.Image = "B003.png"
	item4.Name = "Teh"
	item4.Price = "RM 3.00"
	item4.PriceTextColor = xui.Color_White
	
	ClvItems.Add(CreateCardItem(item1, item2, item3, item4), 1)
	
	Dim item1 As CardItem
	item1.Initialize
	item1.Index = 1
	item1.Image = "B004.png"
	item1.Name = "Nescafe"
	item1.Price = "RM 3.00"
	item1.PriceTextColor = xui.Color_DarkGray
	
	Dim item2 As CardItem
	item2.Initialize
	item2.Index = 2
	item2.Image = "B005.png"
	item2.Name = "Neslo"
	item2.Price = "RM 5.00"
	item2.PriceTextColor = xui.Color_DarkGray
	
	Dim item3 As CardItem
	item3.Initialize
	item3.Index = 3
	item3.Image = "B006.png"
	item3.Name = "White Coffee"
	item3.Price = "RM 4.50"
	item3.PriceTextColor = xui.Color_White
	
	Dim item4 As CardItem
	item4.Initialize
	item4.Index = 4
	item4.Image = "B007.png"
	item4.Name = "Milo"
	item4.Price = "RM 4.50"
	item4.PriceTextColor = xui.Color_DarkGray
	
	ClvItems.Add(CreateCardItem(item1, item2, item3, item4), 2)
End Sub

Private Sub CreateButton100 (ButtonText As String, Width As Double, HorizontalAlignment As String) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	Dim Height As Double = Width
	'If GetDeviceLayoutValues.ApproximateScreenSize < 4.5 Then Height = 350dip
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	#If B4J
	p.Color = xui.Color_Transparent
	#End If	
	p.LoadLayout("Button100")
	#If B4A
	Button100.TextSize = 15
	#End If	
	Button100.Text = ButtonText
	Button100.SetTextAlignment(CENTER, HorizontalAlignment)
	#If B4J
	Button100.As(Button).MouseCursor = fx.Cursors.HAND
	#End If
	Return p
End Sub

Private Sub CreateButtonCategory (ButtonText As String) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.Color = xui.Color_Transparent
	p.LoadLayout("BtnCategory")
	p.SetLayoutAnimated(0, 0, 0, 150dip, pnbuttons.Height)
	'p.Color = xui.Color_White
	#If B4J
	'p.Color = XUI.Color_Transparent
	#End If	
	LblCategory.Text = ButtonText
	'LblCategory.Font = Main.FontBold
	#If B4J
	CSSUtils.SetStyleProperty(LblCategory, "-fx-text-alignment", "CENTER")
	#End If
	'BBCategory.TextEngine = TextEngine
	'BBCategory.Text = "[Alignment=Center]" & ButtonText & "[/Alignment]"
	#If B4J
	LblCategory.As(Label).MouseCursor = fx.Cursors.HAND
	#End If
	Return p
End Sub

Private Sub CreateLineItem (TextLeft As Object, TextCenter As Object, TextRight As Object) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	Dim Height As Int = 20dip
	Dim Width As Int = ClvSales.AsView.Width
	'If GetDeviceLayoutValues.ApproximateScreenSize < 4.5 Then Height = 350dip
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	#If B4J
	p.Color = xui.Color_Transparent
	#End If	
	p.LoadLayout("LineItem")
	#If B4A
	TxtLeft.TextSize = 15
	TxtCenter.TextSize = 15
	TxtRight.TextSize = 15
	#End If
	If TextLeft <> Null Then TxtLeft.Text = TextLeft
	If TextCenter <> Null Then TxtCenter.Text = TextCenter
	If TextRight <> Null Then TxtRight.Text = TextRight
	Return p
End Sub

Private Sub CreateCardItem (Item1 As CardItem, Item2 As CardItem, Item3 As CardItem, Item4 As CardItem) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	Dim Height As Int = 210dip
	Dim Width As Int = ClvItems.AsView.Width
	'If GetDeviceLayoutValues.ApproximateScreenSize < 4.5 Then Height = 350dip
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	#If B4J
	p.Color = xui.Color_Transparent
	#End If	
	p.LoadLayout("CardItem")
	#If B4A
	LblName1.TextSize = 15
	LblName2.TextSize = 15
	LblName3.TextSize = 15
	LblName4.TextSize = 15
	#End If

	If Item1.IsInitialized Then
		If Item1.Image <> Null Then Img1.Bitmap = xui.LoadBitmapResize(File.DirAssets, Item1.Image, 400dip, 300dip, True)
		If Item1.Name <> Null Then LblName1.Text = Item1.Name
		If Item1.Price <> Null Then LblPrice1.Text= Item1.Price
		LblPrice1.TextColor = Item1.PriceTextColor
		LblPrice1.SetTextAlignment("CENTER", "LEFT")
		'Utils.SetRectangleClip(Pnl1, 9)
		#If B4J
		Pnl1.MouseCursor = fx.Cursors.HAND
		#End If
	Else
		Pnl1.Visible = False
	End If

	If Item2.IsInitialized Then
		If Item2.Image <> Null Then Img2.Bitmap = xui.LoadBitmapResize(File.DirAssets, Item2.Image, 400dip, 300dip, True)
		If Item2.Name <> Null Then LblName2.Text = Item2.Name
		If Item2.Price <> Null Then LblPrice2.Text= Item2.Price
		LblPrice2.TextColor = Item2.PriceTextColor
		LblPrice2.SetTextAlignment("CENTER", "LEFT")
		'Utils.SetRectangleClip(Pnl2, 12)
		#If B4J
		Pnl2.MouseCursor = fx.Cursors.HAND
		#End If
	Else
		Pnl2.Visible = False
	End If

	If Item3.IsInitialized Then
		If Item3.Image <> Null Then Img3.Bitmap = xui.LoadBitmapResize(File.DirAssets, Item3.Image, 400dip, 300dip, True)
		If Item3.Name <> Null Then LblName3.Text = Item3.Name
		If Item3.Price <> Null Then LblPrice3.Text= Item3.Price
		LblPrice3.TextColor = Item3.PriceTextColor
		LblPrice3.SetTextAlignment("CENTER", "LEFT")
		#If B4J
		Pnl3.MouseCursor = fx.Cursors.HAND
		#End If
	Else
		Pnl3.Visible = False
	End If

	If Item4.IsInitialized Then
		If Item4.Image <> Null Then Img4.Bitmap = xui.LoadBitmapResize(File.DirAssets, Item4.Image, 400dip, 300dip, True)
		If Item4.Name <> Null Then LblName4.Text = Item4.Name Else LblName4.Visible = False
		If Item4.Price <> Null Then LblPrice4.Text= Item4.Price Else LblPrice4.Visible = False
		LblPrice4.TextColor = Item4.PriceTextColor
		LblPrice4.SetTextAlignment("CENTER", "LEFT")
		#If B4J
		Pnl4.MouseCursor = fx.Cursors.HAND
		#End If
	Else
		Pnl4.Visible = False
	End If

	Return p
End Sub

Public Sub NewSales
	
End Sub

Public Sub ReadSales
	
End Sub

Public Sub WriteSales
	
End Sub

Private Sub BtnClose_Click
	#If B4A
	ToastMessageShow("Close", False)
	#End If
End Sub

#If B4J
'Public Sub GetSystemProp As Map
'	Dim jo As JavaObject
'	jo.InitializeStatic("java.lang.System")
'	Dim Prop As Map = jo.RunMethod("getProperties", Null)
'	Return Prop
'End Sub
'
'Public Sub GetSystemEnvironment As Map
'	Dim jo As JavaObject
'	jo.InitializeStatic("java.lang.System")
'	Dim Env As Map = jo.RunMethod("getenv", Null)
'	Return Env
'End Sub
#End If

Private Sub ClvItems_ItemClick (Index As Int, Value As Object)
	'Log(Index & " : " & Value)
End Sub

#If B4J
Private Sub lbl01_MouseClicked (EventData As MouseEvent)
	B4XPages.ShowPageAndRemovePreviousPages("LoginPage")
#Else
Private Sub lbl01_Click
	'B4XPages.ClosePage(Me)
	B4XPages.ShowPage("LoginPage")
#End If
End Sub

#If B4J
Private Sub Pnl1_MouseClicked (EventData As MouseEvent)
#Else
Private Sub Pnl1_Click
#End If
	Dim pnl As B4XView = Sender
	Dim lbl As B4XView = pnl.GetView(1)
	Dim pan As B4XView = pnl.GetView(2)
	Dim lbl2 As B4XView = pan.GetView(0)
	Dim item1 As SalesItem
	item1.Initialize
	item1.Name = lbl2.Text
	item1.Price = lbl.Text.SubString(2)
	ClvSales.Add(CreateLineItem(item1.Name, Null, NumberFormat2(item1.Price, 1, 2, 2, False)), 2)
	SalesItems.Add(item1)
	CalculateTotalAmount
End Sub

#If B4J
Private Sub Pnl2_MouseClicked (EventData As MouseEvent)
#Else
Private Sub Pnl2_Click
#End If
	Dim pnl As B4XView = Sender
	Dim lbl As B4XView = pnl.GetView(1)
	Dim pan As B4XView = pnl.GetView(2)
	Dim lbl2 As B4XView = pan.GetView(0)
	Dim item1 As SalesItem
	item1.Initialize
	item1.Name = lbl2.Text
	item1.Price = lbl.Text.SubString(2)
	ClvSales.Add(CreateLineItem(item1.Name, Null, NumberFormat2(item1.Price, 1, 2, 2, False)), 2)
	SalesItems.Add(item1)
	CalculateTotalAmount
End Sub

#If B4J
Private Sub Pnl3_MouseClicked (EventData As MouseEvent)
#Else
Private Sub Pnl3_Click
#End If
	Dim pnl As B4XView = Sender
	Dim lbl As B4XView = pnl.GetView(1)
	Dim pan As B4XView = pnl.GetView(2)
	Dim lbl2 As B4XView = pan.GetView(0)

	Dim item1 As SalesItem
	item1.Initialize
	item1.Name = lbl2.Text
	item1.Price = lbl.Text.SubString(2)
	ClvSales.Add(CreateLineItem(item1.Name, Null, NumberFormat2(item1.Price, 1, 2, 2, False)), 2)
	SalesItems.Add(item1)
	CalculateTotalAmount
End Sub

#If B4J
Private Sub Pnl4_MouseClicked (EventData As MouseEvent)
#Else
Private Sub Pnl4_Click
#End If
	Dim pnl As B4XView = Sender
	Dim lbl As B4XView = pnl.GetView(1)
	Dim pan As B4XView = pnl.GetView(2)
	Dim lbl2 As B4XView = pan.GetView(0)

	Dim item1 As SalesItem
	item1.Initialize
	item1.Name = lbl2.Text
	item1.Price = lbl.Text.SubString(2)
	ClvSales.Add(CreateLineItem(item1.Name, Null, NumberFormat2(item1.Price, 1, 2, 2, False)), 2)
	SalesItems.Add(item1)
	CalculateTotalAmount
End Sub

#If B4J
Private Sub set_tooltip_style (vw As B4XView)
	If vw.As(ScrollPane).TooltipText = "" Then Return
	Dim jo As JavaObject = vw
	Dim tooltip As JavaObject = jo.RunMethodJO("getTooltip", Null)
	tooltip.RunMethod("setStyle", Array As Object(tooltipstyle))
End Sub
#End If

#If B4J
Private Sub PnlCategory_MouseClicked (EventData As MouseEvent)
	If sp1dragged = True Then Return
	'Dim pnl As B4XView = Sender
	'Log(pnl)
	'Log(GetType(pnl.GetView(0)))
	EventData.Consume
#Else
Private Sub PnlCategory_Click

#End If
End Sub

#If B4J
Private Sub PnlCategory_MouseMoved (EventData As MouseEvent)
	sp1dragged = False
	EventData.Consume
#Else
Private Sub PnlCategory_Touch (Action As Int, X As Float, Y As Float)

#End If
End Sub

#If B4J
Private Sub PnlCategory_MouseDragged (EventData As MouseEvent)
	sp1dragged = True
End Sub
#End If