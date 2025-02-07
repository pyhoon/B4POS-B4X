B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=10
@EndOfDesignText@
'Static code module
Sub Process_Globals
	#If B4J
	Private fx As JFX
	#End If
End Sub

Public Sub ConvertDate3 (lngDateTime As Long) As String
	Dim DF As String = DateTime.DateFormat
	DateTime.DateFormat = "dd/MM/yyyy"
	Dim DT As String = DateTime.Date(lngDateTime)
	DateTime.DateFormat = DF
	Return DT
End Sub

Public Sub ConvertTime3 (lngDateTime As Long) As String
	Dim TF As String = DateTime.TimeFormat
	DateTime.TimeFormat = "hh:mm:ss a"
	Dim TM As String = DateTime.Time(lngDateTime)
	DateTime.TimeFormat = TF
	Return TM.ToUpperCase
End Sub

Public Sub ConvertDateTime3 (lngDateTime As Long) As String
	Dim DF As String = DateTime.DateFormat
	DateTime.DateFormat = "dd/MM/yyyy hh:mm:ss aaa"
	Dim DT As String = DateTime.Date(lngDateTime)
	DateTime.DateFormat = DF
	Return DT.ToUpperCase
End Sub

Public Sub SetRectangleClip (pnl As B4XView, CornersRadius As Double)
    pnl.SetColorAndBorder(0, 0, 0, CornersRadius)
    #If B4J
    Dim Rectangle As JavaObject
    Dim cx = pnl.Width, cy = pnl.Height As Double
    Rectangle.InitializeNewInstance("javafx.scene.shape.Rectangle", Array(cx, cy))
    If CornersRadius > 0 Then
        Rectangle.RunMethod("setArcHeight", Array(CornersRadius))
        Rectangle.RunMethod("setArcWidth", Array(CornersRadius))
    End If
    pnl.As(JavaObject).RunMethod("setClip", Array(Rectangle))
    #Else If B4A
    pnl.As(JavaObject).RunMethod("setClipToOutline", Array(CornersRadius > 0))
    #End If
End Sub