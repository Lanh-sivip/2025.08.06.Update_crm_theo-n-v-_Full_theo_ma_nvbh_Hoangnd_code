Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Imports System.Diagnostics
Imports System.Linq
Imports System.Runtime.CompilerServices
Imports System.Text.RegularExpressions
Imports System.Web
Imports System.Web.Configuration
Imports System.Web.Script.Services
Imports System.Web.Services
Imports System.Xml.Linq

Namespace CrmViewPanel
    <ScriptService(), WebService([Namespace]:="http://Sthink.com/"), WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
    Public Class CrmViewPanel
        Inherits WebService

        Private Class Field
            Private lcName As String

            Private lcDefaultValue As String

            Private lcReference As String

            Private lcKey As String

            Private lcType As String

            Private lcRow As String

            Private lcAliasName As String

            Private lcDataFormatString As String

            Private lcHeader As String

            Private lcFooter As String

            Private lcInformation As String

            Public Property Name() As String
                Get
                    Return Me.lcName
                End Get
                Set(ByVal value As String)
                    Me.lcName = value
                End Set
            End Property

            Public Property Reference() As String
                Get
                    Return Me.lcReference
                End Get
                Set(ByVal value As String)
                    Me.lcReference = value
                End Set
            End Property

            Public Property Key() As String
                Get
                    Return Me.lcKey
                End Get
                Set(ByVal value As String)
                    Me.lcKey = value
                End Set
            End Property

            Public Property Row() As String
                Get
                    Return Me.lcRow
                End Get
                Set(ByVal value As String)
                    Me.lcRow = value
                End Set
            End Property

            Public Property Type() As String
                Get
                    Return Me.lcType
                End Get
                Set(ByVal value As String)
                    Me.lcType = value
                End Set
            End Property

            Public Property AliasName() As String
                Get
                    Return Me.lcAliasName
                End Get
                Set(ByVal value As String)
                    Me.lcAliasName = value
                End Set
            End Property

            Public Property DefaultValue() As String
                Get
                    Return Me.lcDefaultValue
                End Get
                Set(ByVal value As String)
                    Me.lcDefaultValue = value
                End Set
            End Property

            Public Property DataFormatString() As String
                Get
                    Return Me.lcDataFormatString
                End Get
                Set(ByVal value As String)
                    Me.lcDataFormatString = value
                End Set
            End Property

            Public Property Information() As String
                Get
                    Return Me.lcInformation
                End Get
                Set(ByVal value As String)
                    Me.lcInformation = value
                End Set
            End Property

            Public Property Header() As String
                Get
                    Return Me.lcHeader
                End Get
                Set(ByVal value As String)
                    Me.lcHeader = value
                End Set
            End Property

            Public Property Footer() As String
                Get
                    Return Me.lcFooter
                End Get
                Set(ByVal value As String)
                    Me.lcFooter = value
                End Set
            End Property

            Public Sub New()
                Me.lcName = ""
                Me.lcDefaultValue = ""
                Me.lcReference = ""
                Me.lcKey = ""
                Me.lcType = ""
                Me.lcRow = ""
                Me.lcAliasName = ""
                Me.lcDataFormatString = ""
                Me.lcHeader = ""
                Me.lcFooter = ""
                Me.lcInformation = ""
            End Sub
        End Class

        Private Class Common
            <CompilerGenerated()>
            Friend Class _Closure__1
                <CompilerGenerated()>
                Friend Class _Closure__2
                    Public VBLocal_l As String

                    Public VBLocal_views As String

                    Public VBLocal_xns As XNamespace

                    Public VBNonLocal_VBClosure_ClosureVariable_CD_10 As CrmViewPanel.Common._Closure__1

                    <DebuggerNonUserCode()>
                    Public Sub New()
                    End Sub

                    <DebuggerStepThrough(), CompilerGenerated()>
                    Public Function _Lambda__2(ByVal e As XElement) As Boolean
                        Return CrmViewPanel.Common.CheckInlist(CStr(e.Attribute("name")), Me.VBLocal_views) Or CrmViewPanel.Common.CheckInlist(CrmViewPanel.Common.GetAttribute(e, "reference"), Me.VBLocal_views)
                    End Function

                    <DebuggerStepThrough(), CompilerGenerated()>
                    Public Function _Lambda__3(ByVal e As XElement) As CrmViewPanel.Field
                        Dim f As CrmViewPanel.Field = New CrmViewPanel.Field
                        f.Name = e.Attribute("name").Value.Replace("%l", Me.VBLocal_l)
                        f.Reference = CrmViewPanel.Common.GetAttribute(e, "reference").Replace("%l", Me.VBLocal_l)
                        f.Key = CrmViewPanel.Common.GetAttribute(e, "key")
                        f.Row = CrmViewPanel.Common.GetAttribute(e, "row")
                        f.Type = CrmViewPanel.Common.GetAttribute(e, "type")
                        f.AliasName = CrmViewPanel.Common.GetAttribute(e, "aliasName")
                        f.DefaultValue = CrmViewPanel.Common.GetAttribute(e, "defaultValue")
                        f.DataFormatString = CrmViewPanel.Common.GetAttribute(e, "dataFormatString")
                        f.Information = CrmViewPanel.Common.GetAttribute(e, "information").Replace("%l", Me.VBLocal_l)
                        f.Header = e.Element(Me.VBLocal_xns + "header").Attribute(Me.VBNonLocal_VBClosure_ClosureVariable_CD_10.VBLocal_language).Value
                        f.Footer = CrmViewPanel.Common.GetAttribute(e.Element(Me.VBLocal_xns + "footer"), Me.VBNonLocal_VBClosure_ClosureVariable_CD_10.VBLocal_language)
                        Return f
                    End Function

                    <DebuggerStepThrough(), CompilerGenerated()>
                    Public Function _Lambda__4(ByVal e As XElement) As Boolean
                        Return e.Attribute("reference") IsNot Nothing AndAlso CrmViewPanel.Common.CheckInlist(e.Attribute("reference").Value, Me.VBLocal_views)
                    End Function

                    <DebuggerStepThrough(), CompilerGenerated()>
                    Public Function _Lambda__5(ByVal e As XElement) As String
                        Return e.Attribute("reference").Value.Replace("%l", Me.VBLocal_l)
                    End Function
                End Class

                Public VBLocal_language As String

                <DebuggerNonUserCode()>
                Public Sub New()
                End Sub
            End Class

            <CompilerGenerated()>
            Friend Class _Closure__3
                Public VBLocal_type As String

                <DebuggerNonUserCode()>
                Public Sub New()
                End Sub

                <DebuggerStepThrough(), CompilerGenerated()>
                Public Function _Lambda__6(ByVal e As XElement) As Boolean
                    Return CStr(e.Attribute("event")) = Me.VBLocal_type
                End Function
            End Class

            Private Shared lcNameType As String = "0"

            Private Shared lcLabelType As String = "1"

            Private Shared lcViewController As String = "~/App_Data/Controllers/View/"

            Private Shared lcImageUrl As String = "../AppHandler/Image.ashx?t=show&k={0}&d={1}&r={2}"

            <DebuggerNonUserCode()>
            Public Sub New()
            End Sub

            Public Shared Function GetTreeData(ByVal commandText As String, ByVal userID As Integer) As Object
                Dim result As Object
                Try
                    Dim dataSet As DataSet = New DataSet()
                    Dim dataTable As DataTable = New DataTable()
                    Dim list As List(Of ArrayList) = New List(Of ArrayList)()
                    dataSet = CrmViewPanel.Common.RetrieveData(commandText, "sysConnectionString", "", userID)
                    dataTable = dataSet.Tables(0)
                    Dim enumerator As IEnumerator = Nothing
                    Try
                        enumerator = dataTable.Rows.GetEnumerator()
                        While enumerator.MoveNext()
                            Dim objectValue As Object = RuntimeHelpers.GetObjectValue(enumerator.Current)
                            Dim arrayList As ArrayList = New ArrayList()
                            Dim enumerator2 As IEnumerator = Nothing
                            Try
                                enumerator2 = dataTable.Columns.GetEnumerator()
                                While enumerator2.MoveNext()
                                    Dim objectValue2 As Object = RuntimeHelpers.GetObjectValue(enumerator2.Current)
                                    arrayList.Add(RuntimeHelpers.GetObjectValue(NewLateBinding.LateIndexGet(objectValue, New Object() {RuntimeHelpers.GetObjectValue(objectValue2)}, Nothing)))
                                End While
                            Finally
                                If TypeOf enumerator2 Is IDisposable Then
                                    TryCast(enumerator2, IDisposable).Dispose()
                                End If
                            End Try
                            list.Add(arrayList)
                        End While
                    Finally
                        If TypeOf enumerator Is IDisposable Then
                            TryCast(enumerator, IDisposable).Dispose()
                        End If
                    End Try
                    result = list.ToArray()
                Catch ex As Exception
                    result = Nothing
                End Try
                Return result
            End Function

            Public Shared Function GatherInformation(ByVal xmlController As String, ByVal recordID As String, ByVal requestCount As Integer, ByVal database As String, ByVal userID As Integer, ByVal admin As Boolean, ByVal language As String, ByVal unit As String) As Object
                recordID = recordID.Replace("'", "")
                If recordID.Length > 32 Then
                    Return Nothing
                End If
                xmlController = xmlController.Replace("'", "")
                If xmlController.Length > 128 Then
                    Return Nothing
                End If
                Dim result As Object
                Try
                    Dim arrayList As ArrayList = New ArrayList()
                    Dim arrayList2 As ArrayList = New ArrayList()
                    Dim views As String = ""
                    Dim dictionary As Dictionary(Of String, Object) = New Dictionary(Of String, Object)()
                    Dim parentheses As String = CrmViewPanel.Common.GetParentheses("(")
                    Dim text As String = parentheses.Replace("(", ")")
                    Dim text2 As String = ""
                    Dim l As String = Conversions.ToString(Interaction.IIf(Operators.CompareString(language.ToLower(), "v", False) = 0, "", "2"))
                    Dim text3 As String = ""
                    Dim value As String = ""
                    Dim text4 As String = ""
                    Dim dictionary2 As Dictionary(Of String, String) = New Dictionary(Of String, String)()
                    Dim dictionary3 As Dictionary(Of String, ArrayList) = New Dictionary(Of String, ArrayList)()
                    Dim text5 As String = ""
                    Dim text6 As String = ""
                    Dim xns As XNamespace = "urn:schemas-Sthink-company:data-view"
                    Dim uri As String = HttpContext.Current.Server.MapPath(CrmViewPanel.Common.lcViewController + xmlController + ".xml")
                    Dim xDocument As XDocument = XDocument.Load(uri)
                    views = String.Join(";", xDocument.Descendants(xns + "item").[Select](Function(e As XElement) e.Attribute("value").Value).ToArray())
                    Dim list As List(Of CrmViewPanel.Field) = xDocument.Descendants(xns + "field").Where(Function(e As XElement) CrmViewPanel.Common.CheckInlist(CStr(e.Attribute("name")), views) Or CrmViewPanel.Common.CheckInlist(CrmViewPanel.Common.GetAttribute(e, "reference"), views)).[Select](Function(e As XElement) New CrmViewPanel.Field() With {.Name = e.Attribute("name").Value.Replace("%l", l), .Reference = CrmViewPanel.Common.GetAttribute(e, "reference").Replace("%l", l), .Key = CrmViewPanel.Common.GetAttribute(e, "key"), .Row = CrmViewPanel.Common.GetAttribute(e, "row"), .Type = CrmViewPanel.Common.GetAttribute(e, "type"), .AliasName = CrmViewPanel.Common.GetAttribute(e, "aliasName"), .DefaultValue = CrmViewPanel.Common.GetAttribute(e, "defaultValue"), .DataFormatString = CrmViewPanel.Common.GetAttribute(e, "dataFormatString"), .Information = CrmViewPanel.Common.GetAttribute(e, "information").Replace("%l", l), .Header = e.Element(xns + "header").Attribute(language).Value, .Footer = CrmViewPanel.Common.GetAttribute(e.Element(xns + "footer"), language)}).ToList()
                    Dim text7 As String = String.Join(",", xDocument.Descendants(xns + "field").Where(Function(e As XElement) e.Attribute("reference") IsNot Nothing AndAlso CrmViewPanel.Common.CheckInlist(e.Attribute("reference").Value, views)).[Select](Function(e As XElement) e.Attribute("reference").Value.Replace("%l", l)).ToArray())
                    If requestCount = 0 Then
                        views = views.Replace("[", "").Replace("]", "").Replace(" ", "").Replace("%l", l)
                        If admin Then
                            value = "1"
                        Else
                            value = CrmViewPanel.Common.GetEditRight(xmlController, userID)
                        End If
                    Else
                        views = ""
                        value = ""
                    End If
                    text2 = xDocument.Descendants(xns + "view").Attributes("table").First().Value
                    Dim value2 As String = xDocument.Descendants(xns + "view").Attributes("code").First().Value
                    text6 = String.Concat(New String() {parentheses, value2, " = '", recordID, "'", text})
                    text4 = CrmViewPanel.Common.GetWhenLoadingQuery(xDocument, xns, "Loading")
                    text4 = text4.Replace("@@unit", String.Format("'{0}'", unit))
                    Dim enumerator As List(Of CrmViewPanel.Field).Enumerator = Nothing
                    Try
                        enumerator = list.GetEnumerator()
                        While enumerator.MoveNext()
                            Dim current As CrmViewPanel.Field = enumerator.Current
                            Dim name As String = current.Name
                            Dim type As String = current.Type
                            Dim reference As String = current.Reference
                            Dim information As String = current.Information
                            Dim arrayList3 As ArrayList = New ArrayList()
                            If requestCount = 0 Then
                                Dim arrayList4 As ArrayList = New ArrayList()
                                arrayList4.Add(name)
                                arrayList4.Add(current.Header)
                                If Not String.IsNullOrEmpty(type) Then
                                    arrayList4.Add(type)
                                End If
                                If Not String.IsNullOrEmpty(current.DataFormatString) Then
                                    arrayList4.Add(current.DataFormatString)
                                End If
                                arrayList2.Add(arrayList4)
                                text3 = (arrayList2.Count - 1).ToString()
                            End If
                            If CrmViewPanel.Common.CheckInlist(reference, text7) Then
                                arrayList3.Add(reference)
                                arrayList3.Add(CrmViewPanel.Common.GetReferenceQuery(information, reference, current.Key, parentheses, text))
                                dictionary3.Add(name, arrayList3)
                            End If
                            If Operators.CompareString(type, "Image", False) = 0 Then
                                dictionary2.Add(name, "")
                                If requestCount = 0 Then
                                    views = Regex.Replace(views, String.Format("\b{0}\b", name), String.Concat(New String() {text3, ".", CrmViewPanel.Common.lcNameType, ".", current.Row}))
                                End If
                            Else
                                text5 = text5 + CrmViewPanel.Common.GetMainQuery(name, type, current.AliasName, current.DefaultValue, text4) + ","
                                If requestCount = 0 Then
                                    views = Regex.Replace(views, String.Format("\b{0}\b", name + ".Label"), text3 + "." + CrmViewPanel.Common.lcLabelType)
                                    views = Regex.Replace(views, String.Format("\b{0}\b", name), text3)
                                End If
                            End If
                            dictionary.Add(name, Nothing)
                        End While
                    Finally
                        CType(enumerator, IDisposable).Dispose()
                    End Try
                    text5 = text5.Substring(0, text5.Length - 1)
                    If String.IsNullOrEmpty(text4) Then
                        text5 = String.Concat(New String() {"select ", text5, " from ", text2, " where ", text6})
                    Else
                        text5 = text4.Replace("@@fieldExternal", text5).Replace("@@table", text2).Replace("@@whereClause", text6).Replace("%l", l)
                    End If
                    CrmViewPanel.Common.GetImageData(dictionary2, recordID, database, userID, dictionary)
                    CrmViewPanel.Common.GetFieldData(text5, dictionary3, text7, database, userID, dictionary)
                    arrayList.Add(arrayList2)
                    arrayList.Add(views)
                    arrayList.Add(dictionary.Values.ToArray())
                    arrayList.Add(value)
                    result = arrayList.ToArray()
                Catch ex As Exception
                    result = Nothing
                End Try
                Return result
            End Function

            Private Shared Sub GetFieldData(ByVal mainQuery As String, ByVal refQuery As Dictionary(Of String, ArrayList), ByVal reference As String, ByVal database As String, ByVal userID As Integer, ByRef values As Dictionary(Of String, Object))
                Dim dataSet As DataSet = New DataSet()
                Dim dataTable As DataTable = New DataTable()
                Dim arrayList As ArrayList = New ArrayList()
                Dim text As String = ""
                dataSet = CrmViewPanel.Common.RetrieveData(mainQuery, "appConnectionString", database, userID)
                dataTable = dataSet.Tables(0)
                Dim enumerator As IEnumerator = Nothing
                Try
                    enumerator = dataTable.Columns.GetEnumerator()
                    While enumerator.MoveNext()
                        Dim dataColumn As DataColumn = CType(enumerator.Current, DataColumn)
                        Dim columnName As String = dataColumn.ColumnName
                        Dim objectValue As Object = RuntimeHelpers.GetObjectValue(dataTable.Rows(0)(columnName))
                        If values.ContainsKey(columnName) And Not CrmViewPanel.Common.CheckInlist(columnName, reference) Then
                            values(columnName) = RuntimeHelpers.GetObjectValue(objectValue)
                        End If
                        If refQuery.ContainsKey(columnName) Then
                            arrayList = refQuery(columnName)
                            If Information.IsDBNull(RuntimeHelpers.GetObjectValue(objectValue)) Then
                                values(Conversions.ToString(arrayList(0))) = ""
                            ElseIf String.IsNullOrEmpty(Conversions.ToString(objectValue)) Then
                                values(Conversions.ToString(arrayList(0))) = ""
                            Else
                                Dim array As Object() = New Object(1) {}
                                Dim arrayList2 As ArrayList = arrayList
                                Dim index As Integer = 1
                                array(0) = RuntimeHelpers.GetObjectValue(arrayList2(index))
                                array(1) = RuntimeHelpers.GetObjectValue(objectValue)
                                Dim array3 As Boolean() = New Boolean() {True, True}
                                Dim arg As Object = NewLateBinding.LateGet(Nothing, GetType(String), "Format", array, Nothing, Nothing, array3)
                                If array3(0) Then
                                    arrayList2(index) = RuntimeHelpers.GetObjectValue(array(0))
                                End If
                                If array3(1) Then
                                    objectValue = RuntimeHelpers.GetObjectValue(array(1))
                                End If
                                text = Conversions.ToString(Operators.AddObject(text, Operators.AddObject(arg, vbCr)))
                            End If
                        End If
                    End While
                Finally
                    If TypeOf enumerator Is IDisposable Then
                        TryCast(enumerator, IDisposable).Dispose()
                    End If
                End Try
                If Not String.IsNullOrEmpty(text) Then
                    dataSet = CrmViewPanel.Common.RetrieveData(text, "appConnectionString", database, userID)
                    Dim enumerator2 As IEnumerator = Nothing
                    Try
                        enumerator2 = dataSet.Tables.GetEnumerator()
                        While enumerator2.MoveNext()
                            Dim dataTable2 As DataTable = CType(enumerator2.Current, DataTable)
                            If dataTable2.Rows.Count > 0 Then
                                values(dataTable2.Columns(0).ColumnName) = RuntimeHelpers.GetObjectValue(dataTable2.Rows(0)(0))
                            Else
                                values(dataTable2.Columns(0).ColumnName) = ""
                            End If
                        End While
                    Finally
                        If TypeOf enumerator2 Is IDisposable Then
                            TryCast(enumerator2, IDisposable).Dispose()
                        End If
                    End Try
                End If
            End Sub

            Private Shared Sub GetImageData(ByVal query As Dictionary(Of String, String), ByVal recordID As String, ByVal database As String, ByVal userID As Integer, ByRef values As Dictionary(Of String, Object))
                Try
                    Dim dataSet As DataSet = New DataSet()
                    Dim dataTable As DataTable = New DataTable()
                    Dim commandText As String = "select rkey from hreanh where stt_rec = '" + recordID + "'"
                    dataSet = CrmViewPanel.Common.RetrieveData(commandText, "appConnectionString", database, userID)
                    dataTable = dataSet.Tables(0)
                    If dataTable.Rows.Count > 0 Then
                        values(values.Keys.ElementAtOrDefault(0)) = String.Format(CrmViewPanel.Common.lcImageUrl, recordID, database, RuntimeHelpers.GetObjectValue(dataTable.Rows(0)(0)))
                    Else
                        values(values.Keys.ElementAtOrDefault(0)) = ""
                    End If
                Catch ex As Exception
                End Try
            End Sub

            Private Shared Function GetEditRight(ByVal controller As String, ByVal userID As Integer) As String
                Dim result As String
                Try
                    Dim commandText As String = String.Concat(New String() {"select r_edit from crmaccessrights where user_id = ", userID.ToString(), " and controller = '", controller, "'"})
                    result = Conversions.ToString(CrmViewPanel.Common.RetrieveData(commandText, "sysConnectionString", "", userID).Tables(0).Rows(0)(0))
                Catch ex As Exception
                    result = ""
                End Try
                Return result
            End Function

            Private Shared Function GetMainQuery(ByVal name As String, ByVal type As String, ByVal aliasName As String, ByVal defaultValue As String, ByVal loadingQuery As String) As String
                Dim flag As Boolean = Operators.CompareString(type, "", False) = 0 Or Operators.CompareString(type, "String", False) = 0
                Dim text As String = "rtrim("
                Dim text2 As String = ") as "
                Dim text3 As String = "."
                If String.IsNullOrEmpty(loadingQuery) Then
                    aliasName = ""
                End If
                If String.IsNullOrEmpty(aliasName) Then
                    text3 = ""
                End If
                If Not String.IsNullOrEmpty(defaultValue) Then
                    Return defaultValue + " as " + name
                End If
                If flag Then
                    Return String.Concat(New String() {text, aliasName, text3, name, text2, name})
                End If
                Return aliasName + text3 + name
            End Function

            Private Shared Function GetReferenceQuery(ByVal information As String, ByVal reference As String, ByVal key As String, ByVal p1 As String, ByVal p2 As String) As String
                Dim array As String() = information.Split(New Char() {"$"c, "."c})
                Dim text As String = String.Concat(New String() {"select rtrim(", array(2), ") as ", reference, " from ", array(1), " where ", p1, array(0), " = '{0}'", p2})
                If Not String.IsNullOrEmpty(key) Then
                    text = String.Concat(New String() {text, " and ", p1, key, p2})
                End If
                Return text
            End Function

            Private Shared Function CheckInlist(ByVal c As String, ByVal s As String) As Boolean
                Return Not String.IsNullOrEmpty(c) AndAlso New Regex(String.Format("\b{0}\b", c)).IsMatch(s)
            End Function

            Private Shared Function GetWhenLoadingQuery(ByVal xDoc As XDocument, ByVal xns As XNamespace, ByVal type As String) As String
                Dim result As String
                Try
                    result = xDoc.Descendants(xns + "query").Where(Function(e As XElement) CStr(e.Attribute("event")) = type).[Select](Function(e As XElement) e.Value).ToList().First().Trim()
                Catch ex As Exception
                    result = ""
                End Try
                Return result
            End Function

            Private Shared Function GetAttribute(ByVal element As XElement, ByVal name As XName) As String
                If element Is Nothing Then
                    Return ""
                End If
                If element.Attribute(name) Is Nothing Then
                    Return ""
                End If
                Return element.Attribute(name).Value
            End Function

            Private Shared Function GetParentheses(ByVal p As String) As String
                Dim random As Random = New Random(DateTime.Now.Millisecond)
                Dim text As String = ""
                Dim num As Integer = random.[Next](1, 8)
                For i As Integer = 1 To num
                    text += p
                Next
                Return text
            End Function

            Private Shared Function RetrieveData(ByVal commandText As String, ByVal connectionString As String, ByVal database As String, ByVal userID As Integer) As DataSet
                Dim connectionStringSettings As ConnectionStringSettings = WebConfigurationManager.ConnectionStrings(connectionString)
                Dim factory As DbProviderFactory = DbProviderFactories.GetFactory(connectionStringSettings.ProviderName)
                Dim dbConnection As DbConnection = factory.CreateConnection()
                Dim dbCommand As DbCommand = factory.CreateCommand()
                Dim dbDataAdapter As DbDataAdapter = factory.CreateDataAdapter()
                Dim dataSet As DataSet = New DataSet()
                dbConnection.ConnectionString = connectionStringSettings.ConnectionString.Replace("%Database", database).Replace("%UserID", userID.ToString())
                dbConnection.Open()
                Dim dbCommand2 As DbCommand = dbCommand
                dbCommand2.Connection = dbConnection
                dbCommand2.CommandText = commandText
                dbCommand2.CommandTimeout = Conversions.ToInteger(WebConfigurationManager.AppSettings("commandTimeout"))
                dbDataAdapter.SelectCommand = dbCommand
                dbDataAdapter.Fill(dataSet)
                dbConnection.Close()
                If Not Information.IsDBNull(dataSet) Then
                    Return dataSet
                End If
                Return Nothing
            End Function

            <DebuggerStepThrough(), CompilerGenerated()>
            Private Shared Function _Lambda__1(ByVal e As XElement) As String
                Return e.Attribute("value").Value
            End Function

            <DebuggerStepThrough(), CompilerGenerated()>
            Private Shared Function _Lambda__7(ByVal e As XElement) As String
                Return e.Value
            End Function
        End Class

        <DebuggerNonUserCode()>
        Public Sub New()
        End Sub

        <ScriptMethod(ResponseFormat:=ResponseFormat.Json), WebMethod(EnableSession:=True)>
        Public Function GetTreeItem(ByVal type As String) As Object
            Dim text As String = Conversions.ToString(HttpContext.Current.Session("appDatabaseName"))
            If String.IsNullOrEmpty(text) Then
                Return Nothing
            End If
            Dim result As Object
            Try
                Dim text2 As String = ""
                If Operators.CompareString(type, "0", False) = 0 Then
                    text2 = "exec dbo.Sthink$CRM$Department$Loading @@unit, @@userID, @@admin, @@appDatabaseName, @@language"
                ElseIf Operators.CompareString(type, "1", False) = 0 Then
                    text2 = "exec dbo.Sthink$CRM$Tab$Loading @@userID, @@admin, @@language"
                End If
                Dim num As Integer = Conversions.ToInteger(HttpContext.Current.Session("userID"))
                text2 = text2.Replace("@@userID", Conversions.ToString(num))
                text2 = text2.Replace("@@appDatabaseName", text)
                text2 = text2.Replace("@@admin", Conversions.ToString(Interaction.IIf(Conversions.ToBoolean(HttpContext.Current.Session("admin")), "1", "0")))
                text2 = text2.Replace("@@language", Conversions.ToString(Operators.AddObject(Operators.AddObject("'", HttpContext.Current.Session("language")), "'")))
                text2 = text2.Replace("@@unit", String.Format("'{0}'", Conversions.ToString(HttpContext.Current.Session("unit"))))
                result = CrmViewPanel.Common.GetTreeData(text2, num)
            Catch ex As Exception
                result = Nothing
            End Try
            Return result
        End Function

        <ScriptMethod(ResponseFormat:=ResponseFormat.Json), WebMethod(EnableSession:=True)>
        Public Function GetViewPage(ByVal xmlController As String, ByVal recordID As String, ByVal requestCount As Integer) As Object
            Dim result As Object
            Try
                Dim database As String = Conversions.ToString(HttpContext.Current.Session("appDatabaseName"))
                Dim userID As Integer = Conversions.ToInteger(HttpContext.Current.Session("userID").ToString())
                Dim admin As Boolean = Conversions.ToBoolean(HttpContext.Current.Session("admin"))
                Dim language As String = HttpContext.Current.Session("language").ToString().ToLower()
                Dim unit As String = Conversions.ToString(HttpContext.Current.Session("unit"))
                recordID = recordID.Replace("'", "")
                xmlController = xmlController.Replace("'", "")
                result = CrmViewPanel.Common.GatherInformation(xmlController, recordID, requestCount, database, userID, admin, language, unit)
            Catch ex As Exception
                result = Nothing
            End Try
            Return result
        End Function
    End Class
End Namespace
