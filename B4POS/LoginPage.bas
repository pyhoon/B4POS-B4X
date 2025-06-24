B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	#If B4J
	Private txtStaffID As TextField
	Private txtPinCode As TextField
	#Else If B4i
	Private txtStaffID As TextField
	Private txtPinCode As TextField
	#Else
	Private txtStaffID As EditText
	Private txtPinCode As EditText
	#End If
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("LoginPanel")
	B4XPages.SetTitle(Me, "Login")
	#If B4J
	CSSUtils.SetStyleProperty(txtStaffID, "-fx-focus-color", "transparent") '"ARGB(0, 128, 128, 128)")
	CSSUtils.SetStyleProperty(txtPinCode, "-fx-focus-color", "transparent") '"ARGB(0, 128, 128, 128)")
	'txtStaffID.TextField.As(Node).StyleClasses.Add("centered-text")'.As(TextField).Style = "-fx-text-alignment: center"
	#End If
End Sub

'Private Sub B4XPage_CloseRequest As ResumableSub
'	
'End Sub

#If B4J
Private Sub B4XPage_Disappear
	B4XPages.ShowPage("MainPage")
End Sub
#End If