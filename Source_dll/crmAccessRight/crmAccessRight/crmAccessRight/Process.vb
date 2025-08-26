Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections
Imports System.Configuration
Imports System.Data
Imports System.Data.Common
Imports System.Diagnostics
Imports System.Globalization
Imports System.IO.Compression
Imports System.Linq
Imports System.Runtime.CompilerServices
Imports System.Web
Imports System.Web.Configuration
Imports System.Xml

Namespace crmAccessRight.crmAccessRight
    Public Class Process
        ' Methods
        <CompilerGenerated(), DebuggerStepThrough()>
        Private Shared Function _Lambda__1(ByVal p As String) As Boolean
            Return p.Contains(".01A")
        End Function

        <DebuggerStepThrough(), CompilerGenerated()>
        Private Shared Function _Lambda__2(ByVal p As String) As Boolean
            Return p.Contains(".02N")
        End Function

        <CompilerGenerated(), DebuggerStepThrough()>
        Private Shared Function _Lambda__3(ByVal p As String) As Boolean
            Return p.Contains(".03E")
        End Function

        <CompilerGenerated(), DebuggerStepThrough()>
        Private Shared Function _Lambda__4(ByVal p As String) As Boolean
            Return p.Contains(".04D")
        End Function

        Private Shared Sub AddNode(ByVal dt As DataTable, ByVal xmlDoc As XmlDocument, ByVal xmlParent As XmlElement, ByVal id0 As String)
            Dim source As DataRow() = dt.Select(("id0 = '" & id0 & "'"))
            If (Enumerable.Count(Of DataRow)(source) <> 0) Then
                Dim row As DataRow
                For Each row In source
                    Dim newChild As XmlElement = xmlDoc.CreateElement("item")
                    newChild.SetAttribute("text", Strings.Trim(Conversions.ToString(row.Item("bar"))))
                    newChild.SetAttribute("id", Strings.Trim(Conversions.ToString(row.Item("id"))))
                    If Operators.ConditionalCompareObjectEqual(row.Item("access"), "True", False) Then
                        newChild.SetAttribute("checked", "True")
                    End If
                    xmlParent.AppendChild(newChild)
                    Process.AddNode(dt, xmlDoc, newChild, Conversions.ToString(row.Item("id")))
                Next
            End If
        End Sub

        Private Shared Sub ExecuteCMD(ByVal commandText As String, ByVal connectionString As String, ByVal database As String)
            Dim settings As ConnectionStringSettings = WebConfigurationManager.ConnectionStrings.Item(connectionString)
            Dim factory As DbProviderFactory = DbProviderFactories.GetFactory(settings.ProviderName)
            Dim connection As DbConnection = factory.CreateConnection
            Dim command As DbCommand = factory.CreateCommand
            factory.CreateDataAdapter()
            connection.ConnectionString = settings.ConnectionString.Replace("%Database", database).Replace("%UserID", "0")
            connection.Open()
            Dim command2 As DbCommand = command
            command2.Connection = connection
            command2.CommandText = commandText
            command2.CommandTimeout = Conversions.ToInteger(WebConfigurationManager.AppSettings.Item("commandTimeout"))
            command2.ExecuteNonQuery()
            command2 = Nothing
            connection.Close()
        End Sub

        Public Shared Sub ProcessRequest(ByVal context As HttpContext)
            Dim str As String = context.Session.Item("appDatabaseName").ToString
            If Not String.IsNullOrEmpty(str) Then
                Try
                    Dim language As String = context.Session.Item("language").ToString
                    Dim type As String = Strings.Trim(context.Request.QueryString.Item("type"))
                    Dim rightID As String = Strings.Trim(context.Request.QueryString.Item("rid"))
                    Dim unitID As String = Strings.Trim(context.Request.QueryString.Item("unit"))
                    context.Response.Write(Process.SetXMLTree(type, rightID, unitID, str, language))
                    Dim request As HttpRequest = context.Request
                    Dim response As HttpResponse = context.Response
                    Dim str2 As String = request.Headers.Item("Accept-Encoding")
                    If Not String.IsNullOrEmpty(str2) Then
                        str2 = str2.ToLower(CultureInfo.InvariantCulture)
                        If str2.Contains("gzip") Then
                            response.Filter = New GZipStream(response.Filter, CompressionMode.Compress)
                            response.AddHeader("Content-encoding", "gzip")
                        ElseIf str2.Contains("deflate") Then
                            response.Filter = New DeflateStream(response.Filter, CompressionMode.Compress)
                            response.AddHeader("Content-encoding", "deflate")
                        End If
                    End If
                Catch exception1 As Exception
                    ProjectData.SetProjectError(exception1)
                    ProjectData.ClearProjectError()
                End Try
            End If
        End Sub

        Private Shared Function RetrieveData(ByVal commandText As String, ByVal connectionString As String, ByVal database As String) As DataSet
            Dim settings As ConnectionStringSettings = WebConfigurationManager.ConnectionStrings.Item(connectionString)
            Dim factory As DbProviderFactory = DbProviderFactories.GetFactory(settings.ProviderName)
            Dim connection As DbConnection = factory.CreateConnection
            Dim command As DbCommand = factory.CreateCommand
            Dim adapter As DbDataAdapter = factory.CreateDataAdapter
            Dim dataSet As New DataSet
            connection.ConnectionString = settings.ConnectionString.Replace("%Database", database).Replace("%UserID", "0")
            connection.Open()
            Dim command2 As DbCommand = command
            command2.Connection = connection
            command2.CommandText = commandText
            command2.CommandTimeout = Conversions.ToInteger(WebConfigurationManager.AppSettings.Item("commandTimeout"))
            command2 = Nothing
            adapter.SelectCommand = command
            adapter.Fill(dataSet)
            connection.Close()
            If Not Information.IsDBNull(dataSet) Then
                Return dataSet
            End If
            Return Nothing
        End Function

        Private Shared Function SetXMLData(ByVal dt As DataTable) As String
            Dim xmlDoc As New XmlDocument
            Dim newChild As XmlElement = xmlDoc.CreateElement("tree")
            newChild.SetAttribute("id", "0")
            xmlDoc.AppendChild(newChild)
            Process.AddNode(dt, xmlDoc, newChild, "")
            Return newChild.OuterXml
        End Function

        Private Shared Function SetXMLTree(ByVal type As String, ByVal rightID As String, ByVal unitID As String, ByVal appDatabase As String, ByVal language As String) As String
            rightID = rightID.Replace("'", "")
            If (rightID.Length > &H20) Then
                Return Nothing
            End If
            Dim commandText As String = ""
            If (type = "0") Then
                commandText = String.Concat(New String() {"exec dbo.Sthink$CRM$GetDepartmentTreeview '", rightID, "', '", unitID, "', '", appDatabase, "', '", language, "'"})
            Else
                commandText = String.Concat(New String() {"exec dbo.Sthink$CRM$GetTabTreeview '", rightID, "', '", unitID, "', '", language, "'"})
            End If
            Return Process.SetXMLData(Process.RetrieveData(commandText, "sysConnectionString", "").Tables.Item(0))
        End Function

        Public Shared Sub UpdateDepartmentRight(ByVal rightID As String, ByVal unitID As String)
            rightID = rightID.Replace("'", "")
            If (rightID.Length <= &H20) Then
                Dim enumerator As IEnumerator
                Dim str As String = HttpContext.Current.Session.Item("appDatabaseName").ToString
                Dim [set] As New DataSet
                Dim table As New DataTable
                Dim left As String = ""
                Dim str4 As String = ""
                Dim str5 As String = ""
                table = Process.RetrieveData((("select l1, l2, l3, l4, l5 from crmrightinfo9 where ma_quyen = '" & rightID & "' and ma_dvcs = '" & unitID & "'" & ChrW(13)) & "update crmrightinfo9 set l1 = '', l2 = '', l3 = '', l4 = '', l5 = '' where ma_quyen = '" & rightID & "' and ma_dvcs = '" & unitID & "'"), "sysConnectionString", "").Tables.Item(0)
                Dim num2 As Integer = (table.Columns.Count - 1)
                Dim i As Integer = 0
                Do While (i <= num2)
                    left = Conversions.ToString(Operators.AddObject(left, table.Rows.Item(0).Item(i)))
                    i += 1
                Loop
                left = left.Replace(Conversions.ToString(Strings.Chr(&HFF)), ",").Replace("'", "")
                str5 = left.Replace(",", "','")
                table = Process.RetrieveData(String.Concat(New String() {"select bp_ref from ", str, "..crmbp where ma_bp in('", str5, "') and ma_dvcs = '" & unitID & "'"}), "sysConnectionString", "").Tables.Item(0)
                Try
                    enumerator = table.Rows.GetEnumerator
                    Do While enumerator.MoveNext
                        Dim objectValue As Object = RuntimeHelpers.GetObjectValue(enumerator.Current)
                        str4 = Conversions.ToString(Operators.AddObject(str4, Operators.AddObject(NewLateBinding.LateIndexGet(objectValue, New Object() {"bp_ref"}, Nothing), ",")))
                    Loop
                Finally
                    If TypeOf enumerator Is IDisposable Then
                        TryCast(enumerator, IDisposable).Dispose()
                    End If
                End Try
                If Not String.IsNullOrEmpty(str4) Then
                    str4 = str4.Substring(0, (Strings.Len(str4) - 1))
                End If
                Dim str2 As String = ("if not exists(select 1 from crmctquyenbp where ma_quyen = '" & rightID & "' and ma_dvcs = '" & unitID & "') begin" & ChrW(13))
                str2 = String.Concat(New String() {str2, "insert into crmctquyenbp (ma_dvcs, ma_quyen, r_Access, r_Access2) values('", unitID, "','", rightID, "','", left, "','", str4, "') end else begin" & ChrW(13)})
                Process.ExecuteCMD(String.Concat(New String() {str2, "update crmctquyenbp set r_Access = '", left, "', r_Access2 = '", str4, "' where ma_quyen = '", rightID, "' and ma_dvcs = '", unitID, "' end"}), "sysConnectionString", "")
                Process.ExecuteCMD((((((((("declare @uid int, @cid int" & ChrW(13) & "select user_id into #r from crmquyennsd where rtrim(ma_quyen) = '" & rightID & "' and rtrim(ma_dvcs) = '" & unitID & "'" & ChrW(13)) & "while exists(select 1 from #r) begin" & ChrW(13) & "select top 1 @uid = user_id from #r" & ChrW(13)) & "exec dbo.Sthink$CRM$System$SetDepartmentRight @uid, '" & str & "', '" & unitID & "'" & ChrW(13)) & "if exists(select 1 from userinfo2 where id = @uid and user_yn = 0 and rtrim(user_lst) <> '') begin" & ChrW(13) & "declare @s varchar(8000), @c varchar(128); select @s = '', @c = ''" & ChrW(13)) & "select @s = rtrim(user_lst) + ',' from userinfo2 where id = @uid; while len(@s) > 0 begin" & ChrW(13) & "set @c = substring(rtrim(@s), 0, charindex(',', @s))" & ChrW(13)) & "set @s = replace(@s, @c + ',', ''); if @c <> '' begin" & ChrW(13) & "select @cid = id from userinfo2 where name = ltrim(@c)" & ChrW(13)) & "exec dbo.Sthink$CRM$System$SetDepartmentRight @cid, '" & str & "', '" & unitID & "'; end; end; end" & ChrW(13)) & "delete #r where user_id = @uid; end; drop table #r;"), "sysConnectionString", "")
            End If
        End Sub

        Public Shared Sub UpdateTabRight(ByVal rightID As String, ByVal unitID As String)
            rightID = rightID.Replace("'", "")
            If (rightID.Length <= &H20) Then
                Dim [set] As New DataSet
                Dim table As New DataTable
                Dim str2 As String = ""
                Dim str6 As String = ""
                Dim str4 As String = ""
                Dim str3 As String = ""
                Dim str As String = ("select r1, r2, r3, r4, r5 from crmrightinfo9 where ma_quyen = '" & rightID & "' and ma_dvcs = '" & unitID & "'" & ChrW(13))
                Dim left As String = ""
                table = Process.RetrieveData((str & "update crmrightinfo9 set r1 = '', r2 = '', r3 = '', r4 = '', r5 = '' where ma_quyen = '" & rightID & "' and ma_dvcs = '" & unitID & "'"), "sysConnectionString", "").Tables.Item(0)
                Dim num2 As Integer = (table.Columns.Count - 1)
                Dim i As Integer = 0
                Do While (i <= num2)
                    left = Conversions.ToString(Operators.AddObject(left, table.Rows.Item(0).Item(i)))
                    i += 1
                Loop
                Dim source As String() = left.Split(New Char() {Strings.Chr(&HFF)})
                str2 = String.Join(",", Enumerable.ToArray(Of String)(Enumerable.Where(Of String)(source, New Func(Of String, Boolean)(AddressOf Process._Lambda__1))))
                str6 = String.Join(",", Enumerable.ToArray(Of String)(Enumerable.Where(Of String)(source, New Func(Of String, Boolean)(AddressOf Process._Lambda__2))))
                str4 = String.Join(",", Enumerable.ToArray(Of String)(Enumerable.Where(Of String)(source, New Func(Of String, Boolean)(AddressOf Process._Lambda__3))))
                str3 = String.Join(",", Enumerable.ToArray(Of String)(Enumerable.Where(Of String)(source, New Func(Of String, Boolean)(AddressOf Process._Lambda__4))))
                str2 = str2.Replace("'", "")
                str6 = str6.Replace("'", "")
                str4 = str4.Replace("'", "")
                str3 = str3.Replace("'", "")
                str = ("if not exists(select 1 from crmctquyentab where ma_quyen = '" & rightID & "' and ma_dvcs = '" & unitID & "') begin" & ChrW(13))
                str = String.Concat(New String() {str, "insert into crmctquyentab (ma_dvcs, ma_quyen, r_Access, r_New, r_Edit, r_Del) values('", unitID, "','", rightID, "','", str2, "','", str6, "','", str4, "','", str3, "') end else begin" & ChrW(13)})
                Process.ExecuteCMD(String.Concat(New String() {str, "update crmctquyentab set r_Access = '", str2, "', r_New = '", str6, "', r_Edit = '", str4, "', r_Del = '", str3, "' where ma_quyen = '", rightID, "' and ma_dvcs = '", unitID, "' end"}), "sysConnectionString", "")
                Process.ExecuteCMD(((((((("declare @uid int, @cid int" & ChrW(13) & "select user_id into #r from crmquyennsd where rtrim(ma_quyen) = '" & rightID & "' and ma_dvcs = '" & unitID & "'" & ChrW(13)) & "while exists(select 1 from #r) begin" & ChrW(13)) & "select top 1 @uid = user_id from #r" & ChrW(13) & "exec dbo.Sthink$CRM$System$SetTabRight @uid, '" & unitID & "'" & ChrW(13)) & "if exists(select 1 from userinfo2 where id = @uid and user_yn = 0 and rtrim(user_lst) <> '') begin" & ChrW(13) & "declare @s varchar(8000), @c varchar(128); select @s = '', @c = ''" & ChrW(13)) & "select @s = rtrim(user_lst) + ',' from userinfo2 where id = @uid; while len(@s) > 0 begin" & ChrW(13) & "set @c = rtrim(left(@s, charindex(',', @s) - 1))" & ChrW(13)) & "set @s = right(@s, len(@s) - len(@c) - 1); if @c <> '' begin" & ChrW(13) & "select @cid = id from userinfo2 where name = @c" & ChrW(13)) & "exec dbo.Sthink$CRM$System$SetTabRight @cid, '" & unitID & "'; end; end; end" & ChrW(13) & "delete #r where user_id = @uid; end; drop table #r;"), "sysConnectionString", "")
            End If
        End Sub

    End Class
End Namespace

