<%@ Page AutoEventWireup="false" MasterPageFile="~/Main/MasterPage.master" Inherits="Sthink.ReportExtender.UI.Page" v="Khai báo quyền bộ phận" e="Defining Department Access Control"%>
<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="Sthink" runat="server">
    <link rel="stylesheet" type="text/css" href="../Css/Treeview.css">
    <script src="../ClientScript/TreeView.js" type="text/javascript"></script>
    <div>
        <asp:Panel ID="panelReport" runat="server"/>
    </div>
    <Sthink:ReportExtender ID="MainReport" runat="server" TargetControlID="panelReport" ReadOnly="true" Controller="crmAllowDepartmentRight"/>
</asp:Content>