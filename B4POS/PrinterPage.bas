B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PrinterPage")
	B4XPages.SetTitle(Me, "Printer")
	
End Sub

#If B4J
Private Sub B4XPage_Disappear
	B4XPages.ShowPage("MainPage")
End Sub
#End If