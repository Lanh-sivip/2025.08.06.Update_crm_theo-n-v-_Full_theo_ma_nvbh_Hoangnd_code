<%@ Page AutoEventWireup="false" MasterPageFile="~/Main/MasterPage.master" Inherits="Sthink.ReportExtender.UI.Page" v="Khai báo quyền khách hàng" e="Defining Employee Access Right"%>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="Sthink" runat="server">
    <div>
        <asp:Panel ID="panelReport" runat="server"/>
    </div>
    <Sthink:ReportExtender ID="MainReport" runat="server" TargetControlID="panelReport" ReadOnly="true" Controller="crmAllowCustomerRight"/>
</asp:Content>