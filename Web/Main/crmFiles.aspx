<%@ Page AutoEventWireup="false" MasterPageFile="~/Main/MasterPage.master" Inherits="Sthink.ReportExtender.UI.Page" v="Tập tin" e="Files" %>
<%@ Register Assembly="FileUploadExtender" Namespace="FileUploadExtender" TagPrefix="upload" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <link href="../Css/ViewPanel.css" rel="stylesheet" type="text/css" />
    <script src="../ClientScript/ViewPanel.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="Sthink" runat="server">
    <div>
        <asp:Panel ID="panelReport" runat="server"/>
    </div>
    <Sthink:ReportExtender ID="MainReport" runat="server" TargetControlID="panelReport" ReadOnly="true" Controller="crmFiles"
	
	InitScript
	="var g=this;g._resources.Pager.PageSizes=[2,5,50,100,1000];g._gridPageSize=g._resources.Pager.PageSizes[1];"
	
	/>
    <div style="display: none"><asp:Panel ID="panelList" runat="server" /></div>
    <upload:UploadExtenderControl ID="ListControl" runat="server" TargetControlID="panelList" />	
</asp:Content>