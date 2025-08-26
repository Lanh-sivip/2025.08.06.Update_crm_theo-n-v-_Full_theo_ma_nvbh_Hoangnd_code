Imports System
Imports System.Web
Imports System.Web.SessionState

Namespace crmAccessRight.crmAccessRight
    Public Class Handler
        Implements IHttpHandler, IRequiresSessionState
        ' Methods
        Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
            Process.ProcessRequest(context)
        End Sub


        ' Properties
        ' nho check lai them khoa chinh dvcs vao crmbp
        Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
            Get
                Return True
            End Get
        End Property

    End Class
End Namespace

