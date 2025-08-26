<%@ Page AutoEventWireup="false" MasterPageFile="~/Main/MasterPage.master" Inherits="Sthink.ReportExtender.UI.Page" v="Hạn chế truy cập màn hình chính" e="Access Right by Unit"%>
<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="Sthink" runat="server">
    <div>
        <asp:Panel ID="panelReport" runat="server"/>
    </div>
    <Sthink:ReportExtender ID="MainReport" runat="server" TargetControlID="panelReport" ReadOnly="true" FilterMode="true" Controller="crmdashboard"/>
</asp:Content>