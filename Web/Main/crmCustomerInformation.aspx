<%@ Page AutoEventWireup="false" MasterPageFile="~/Main/MasterPage.master" Inherits="Sthink.ReportExtender.UI.Page" v="Thông tin khách hàng" e="Customer Information" %>
<%@ Register Assembly="FileUploadExtender" Namespace="FileUploadExtender" TagPrefix="upload" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <link href="../Css/ViewPanel.css" rel="stylesheet" type="text/css" />
    <script src="../ClientScript/crmViewPanel.js" type="text/javascript"></script>   
    
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="Sthink" runat="server">
    <Sthink:ReportExtender ID="MainReport" runat="server" TargetControlID="panelReport" ReadOnly="true" Controller="crmCustomer" InitScript="initInformation(this,'ma_kh','ma_bp, ten_kh, ma_so_thue, dia_chi, dien_thoai, tinh_thanh, nh_kh1, nh_kh2, nh_kh3, ma_nvbh, nv_cd_yn, status', null, '../AppService/CrmViewPanelService.asmx','GetTreeItem','GetViewPage')" />    <div style="display: none"><asp:Panel ID="panelList" runat="server" /></div>
    <upload:UploadExtenderControl ID="ListControl" runat="server" TargetControlID="panelList" />

    <div id="line" style="margin:0px; padding:0px;background-color:#B8B6B6;position:absolute;width:100%;height:1px;"></div>
    <div id="divSplitter">
        <table cellpadding="0" cellspacing="0" style="height:100%;width:100%;">
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" style="width:100%;height:100%">
                        <tr>
                            <td id="topLeftPanel">
                                <div id="topLeftView" class="TreePanelContainer">
                                    <div id="treeDept" style="height:auto;width:0;padding-top:10px; padding-bottom:10px;"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td id="bottomLeftPanel">
                                <div id="bottomLeftView" class="TreePanelContainer">
                                    <div id="treeFunc" style="height:auto;width:0;padding-top:10px; padding-bottom:10px;"></div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
                
                <td>
                    <table cellpadding="0" cellspacing="0" style="width:100%;height:100%;">
                        <tr>
                            <td id="topRightPanel">
                                <div id="topRightView" style="overflow:auto;">
                                    <asp:Panel ID="panelReport" runat="server" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td id="bottomRightPanel">
                                <div id="bottomRightView" style="height:100%;overflow:auto;padding:0;margin:0;background-color:#EDF5FF;"></div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        
        <div id="splitter0" style="margin:0;padding:0;width:1px;top:0;cursor:e-resize;background-color:#B8B6B6;position:absolute;display:none;"></div>
        <div id="splitter1" style="margin:0;padding:0;height:1px;left:0;cursor:n-resize;background-color:#B8B6B6;position:absolute;"></div>
        <div id="splitter2" style="margin:0;padding:0;height:1px;right:0;cursor:n-resize;background-color:#B8B6B6;position:absolute;display:none;"></div>
    </div>
    
</asp:Content>
