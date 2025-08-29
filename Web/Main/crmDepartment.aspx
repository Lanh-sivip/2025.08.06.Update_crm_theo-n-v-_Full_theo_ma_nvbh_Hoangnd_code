<%@ Page AutoEventWireup="false" MasterPageFile="~/Main/MasterPage.master" Inherits="Sthink.ReportExtender.UI.Page" v="Danh mục phân cấp khách hàng theo NVKD" e="Department List"%>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="mainContent" ContentPlaceHolderID="Sthink" runat="server">
    <div>
        <asp:Panel ID="panelReport" runat="server"/>
    </div>
    <Sthink:ReportExtender ID="MainReport" runat="server" TargetControlID="panelReport" ReadOnly="true" Controller="crmDepartment"/>
</asp:Content>