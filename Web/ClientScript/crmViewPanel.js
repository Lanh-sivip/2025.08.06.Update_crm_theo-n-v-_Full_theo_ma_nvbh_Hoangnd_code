function initInformation(n, t, i, r, u, f, e) {
    var o = new SplitterBar("splitter0", "splitter1", "splitter2", "topLeftView", "topRightView", "bottomLeftView", "bottomRightView", "line", n),
        s = new ViewInformation($get("bottomRightView"), "treeDept", "treeFunc", o, n, t, i, r, u, f, e);
    n._view = s
}
ViewInformation = function(n, t, i, r, u, f, e, o, s, h, c) {
    var l = this;
    l.grid = u, l._deptID = t, l._funcID = i, l.deptTree = l.funcTree = null, l._type = l._kind = !1, l._activeTab = l._prevTab = l._activeDept = l._currentID = l._controller = l._command = "", l._tabs = [], l._divList = [], l._dirInfo = [], l._openTab = [], l._requestCount = [], l._onFailed = Function.createDelegate(l, l.onFailed), l.element = n, l.splitter = r, l.splitter.grids = [], l._key = f, l._stringFields = e.split(","), l._dateTimeFields = o ? o.split(",") : [], l._servicePath = s, l._treeMethod = h, l._pageMethod = c, l.init()
}, ViewInformation.prototype = {
    init: function() {
        this.initDeptTree(), this.initFuncTree()
    },
    deptTreeClickHandler: function(n) {
        var t = n.id;
        t != this._activeDept && (this.filterByDepartment(t), this._activeDept = t)
    },
    funcTreeClickHandler: function(n) {
        var r = n.id,
            u = n.tag,
            t = n.type,
            f = "($find('" + this.grid.get_id() + "')._view).showDirForm();",
            i = n.kind,
            e = i ? f : "";
        this._activeTab = r, this._controller = u, this._type = t, this._kind = i, this._command = e, this._controller && (t ? this.showGridDetail() : this.showViewPanel())
    },
    showViewPanel: function() {
        var t = this.grid,
            n;
        t._activeRow != -1 && (n = t._getItemValue(t._activeRow, t._getColumnOrder(this._key)), n != "") && (this.validOpenTab(n) == !0 ? (this._currentID = n, this._prevTab = this._activeTab, this.getViewPage()) : this.showTabControl(this._controller))
    },
    initDataInfo: function(n, t, i, r) {
        this.requestCount(0) > 0 ? (n = this.getDirInfo(0), t = this.getDirInfo(1), r = this.getDirInfo(3)) : this.setDirInfo(n, t, r), this.showTabControl(this._controller), this.initViewPanel(n, t, i, r), this._tabs.push(this._activeTab), this._kind && this.initDir(), this.requestCount(1)
    },
    initViewPanel: function(n, t, i, r) {
        this.renderViewPanel($get(this._controller), n, t, i, r)
    },
    validOpenTab: function(n) {
        for (var t = 0; t < this._openTab.length; t++)
            if (this._openTab[t][0] == this._controller) return this._openTab[t][1] != n ? (this._openTab[t][1] = n, !0) : !1
    },
    requestCount: function(n) {
        for (var t = 0; t < this._requestCount.length; t++)
            if (this._requestCount[t][0] == this._controller) {
            if (n == 0) return this._requestCount[t][1];
            this._requestCount[t][1] += 1;
            break
        }
    },
    setDirInfo: function(n, t, i) {
        for (var r = 0; r < this._dirInfo.length; r++)
            if (this._dirInfo[r][0] == this._controller) {
            this._dirInfo[r][1] = n, this._dirInfo[r][2] = t, this._dirInfo[r][3] = this.setFieldList(n), this._dirInfo[r][4] = i;
            break
        }
    },
    getDirInfo: function(n) {
        for (var t = 0; t < this._dirInfo.length; t++)
            if (this._dirInfo[t][0] == this._controller) {
            if (n == 0) return this._dirInfo[t][1];
            if (n == 1) return this._dirInfo[t][2];
            if (n == 2) return this._dirInfo[t][3];
            if (n == 3) return this._dirInfo[t][4];
            break
        }
    },
    scatterMemvar: function(n) {
        var u = this.getDirInfo(2),
            o = this._controller + "_view_",
            i, r, e, f, t;
        if (u)
            for (i = 0; i < u.length; i++) r = u[i][0], u[i][1] != "Image" && (e = $get(o + r), f = $func.findField(r, n._fields), e && n && (t = $func.findMemvar(r, n._memvars), !t && n._extensions && n._extensions.length > 0 && (t = $func.findMemvar(r, n._extensions)), t && ($func.compareFieldValue(f, t.OldValue, t.NewValue) || (e.innerHTML = $func.htmlEncode(this.renderViewFormatValue(t.NewValue, f.Type, f.DataFormatString))))))
    },
    setFieldList: function(n) {
        for (var r = [], t, i = 0; i < n.length; i++) t = [], Array.add(t, n[i][0]), Array.add(t, n[i][2]), Array.add(r, t);
        return r
    },
    showDirForm: function() {
        var n = $find(this.grid._id + this._activeTab);
        n._rowCount == 1 && (n._setActiveCell(n._getItem(1, 1)), n.executeCommand({
            commandName: "Edit",
            commandArgument: "0"
        }))
    },
    showGridDetail: function () {
        var t = this.grid,
            i, n;
        if (t._activeRow != -1) {
            if (i = t._activeRow, n = t._getItemValue(i, 1), this.showTabControl(this._controller), this.initGrid(i)) {
                this._currentID = n, this._prevTab = this._activeTab, this.validOpenTab(n);
                return
            }
            p = $find(t._id + this._activeTab), this.validOpenTab(n) == !0 && (this._prevTab = this._activeTab, this._currentID = n, this.setGridDetail(p))
        }
    },
    setGridDetail: function (n) {
        var t = [];
        var a = [];
        Array.add(a, {
            Name: 'ma_kh',
            OldValue: null,
            NewValue: this._currentID ? this._currentID : null
        });
        Array.add(t, {
            Name: this._key,
            Opr: "=",
            Value: this._currentID,
            Type: "String",
            Ignore: !1
        }), n.set_externalKey(t), n.set_memvars(a), window.setTimeout(function() {
            n.set_gridPageIndex(0), n.goToPage(-1)
        }, 100)
    },
    initDir: function() {
        var t = document.createElement("div"),
            i = this._controller + "_GridContainer",
            r = [],
            n = this.grid,
            u = n._activeCell ? n._activeRow : 1;
        t.setAttribute("id", i), t.setAttribute("style", "height:0;width:0;"), $get(this._controller).appendChild(t), Array.add(r, {
            Name: this._key,
            Opr: "=",
            Value: n._getItemValue(u, 1),
            Type: "String",
            Ignore: !1
        }), this.createGrid($get(i), n, n._id + this._activeTab, r, null), this._tabs.push(this._activeTab)
    },
    initGrid: function (n) {
        var t = this.grid,
            i = [],
            r;
        var a = [];
        Array.add(a, {
            Name: 'ma_kh',
            OldValue: null,
            NewValue: t._getItemValue(n, 1) ? t._getItemValue(n, 1) : null
        });
        
        if (Array.indexOf(this._tabs, this._activeTab) == -1) return Array.add(i, {
            Name: this._key,
            Opr: "=",
            Value: t._getItemValue(n, 1),
            Type: "String",
            Ignore: !1
        }), r = this.createGrid($get(this._controller), t, t._id + this._activeTab, i, this.getGridOffsetHeight(), a), Array.add(this.splitter.grids, r), this._tabs.push(this._activeTab), !0
    },
    filterByDepartment: function(n) {
        var i = this.grid,
            r = [],
            t;
        for (this.showTabControl(""), t = 0; t < this._stringFields.length; t++) Array.add(r, {
            Name: $func.trim(this._stringFields[t]),
            OldValue: null,
            NewValue: t == 0 ? n : i._stringValue ? i._stringValue[t] : ""
        });
        for (t = 0; t < this._dateTimeFields.length; t++) Array.add(r, {
            Name: $func.trim(this._dateTimeFields[t]),
            OldValue: null,
            NewValue: i._dateTimeValue ? i._dateTimeValue[t] : null
        });
        i.set_memvars(r), i.set_gridPageIndex(-2), i._loadPage(1)
    },
    showTabControl: function(n) {
        var t = $get(n),
            r = "ViewOnShow",
            u = "ViewOnHide",
            i;
        for (t && (Sys.UI.DomElement.removeCssClass(t, u), Sys.UI.DomElement.addCssClass(t, r)), i = 0; i < this._divList.length; i++) this._divList[i] != n && (t = $get(this._divList[i]), t && (Sys.UI.DomElement.removeCssClass(t, r), Sys.UI.DomElement.addCssClass(t, u)))
    },
    initDeptTree: function() {
        Sys.Net.WebServiceProxy.invoke(this._servicePath, this._treeMethod, !1, {
            type: "0"
        }, Function.createDelegate(this, this.onDeptTreeSucceeded), this._onFailed)
    },
    onDeptTreeSucceeded: function(n) {
        var t = this.deptTree = new Tree(this._deptID, n, !0);
        t.onClickHandler = Function.createDelegate(this, this.deptTreeClickHandler)
    },
    initFuncTree: function() {
        Sys.Net.WebServiceProxy.invoke(this._servicePath, this._treeMethod, !1, {
            type: "1"
        }, Function.createDelegate(this, this.onFuncTreeSucceeded), this._onFailed)
    },
    onFuncTreeSucceeded: function(n) {
        var h = this.funcTree = new Tree(this._funcID, n, !0),
            o, u, r, t;
        for (h.onClickHandler = Function.createDelegate(this, this.funcTreeClickHandler), o = this.element, u = n, r = 0; r <= u.length - 1; r++)
            if (t = u[r][3], t != "") {
            var s = document.createElement("div"),
                    f = [],
                    e = [],
                    i = [];
            s.setAttribute("id", t), o.appendChild(s), Array.add(f, t), Array.add(f, ""), Array.add(this._openTab, f), Array.add(e, t), Array.add(e, 0), Array.add(this._requestCount, e), Array.add(i, t), Array.add(i, []), Array.add(i, ""), Array.add(i, []), Array.add(i, ""), Array.add(this._dirInfo, i), this._divList.push(t)
        }
    },
    getViewPage: function() {
        Sys.Net.WebServiceProxy.invoke(this._servicePath, this._pageMethod, !1, {
            xmlController: this._controller,
            recordID: this._currentID,
            requestCount: this.requestCount(0)
        }, Function.createDelegate(this, this.onGetViewPageSucceeded), this._onFailed)
    },
    onGetViewPageSucceeded: function(n) {
        if (!n) {
            this.showTabControl("");
            return
        }
        this.initDataInfo(n[0], n[1], n[2], n[3])
    },
    onFailed: function() {
        return this.showTabControl(""), !1
    },
    getGridOffsetHeight: function() {
        return h = this.grid._fixedHeight + 112, $func.isFF && (h -= 1), $func.isCs && (h += 1), h
    },
    createGrid: function (n, t, i, r, u, _memvars) {
        return $create(Sthink.AjaxControlExtender.ReportExtender, {
            externalKey: r,
            offsetHeight: u,
            baseUrl: t._baseUrl,
            controller: this._controller,
            cookie: t._cookie,
            denySessionStorage: t._denySessionStorage,
            id: i,
            language: t._language,
            offsetTime: t._offsetTime,
            readOnly: !0,
            serviceLookup: t._serviceLookup,
            serviceMethod: t._serviceMethod,
            servicePath: t._servicePath,
            memvars: _memvars
        }, null, null, n)
    },
    renderViewPanel: function(n, t, i, r, u) {
        var f = new Sys.StringBuilder,
            h = n.id,
            e = i.split(";"),
            a = e[0],
            c = a.split(",").length + 1,
            v = 'th style="width:',
            o, s;
        for (f.append(String.format('<table id="{0}_viewPanel" class="ViewTable"><tbody><{1}{2}px;"></th>', h, v, a.replace(/ /g, "").replace(/,/g, 'px;"></th><' + v))), o = 1; o < e.length; o++)
            if (s = e[o].split(":"), s.length == 1) f.append(String.format('<tr><td colspan="{0}"><div class="ViewBreak"></div></td><tr>', c));
        else {
            var l = s[0],
                    p = s[1].split(","),
                    y = l.length;
            y < c && (l += $func.replicate("-", c - y)), f.append("<tr>"), this.renderViewRow(f, h, t, e, r, l, p), f.append("</tr>")
        }
        f.append("</tbody></table>"), this._command && u == "1" && f.append(String.format('<div id="{0}_ToolbarButton_Edit" class="ToolbarBackgroundImage Edit" style="margin-top:10px;margin-left:14px;height:22px;width:22px;border-width:0px;" title="{1}" onmouseover="Sys.UI.DomElement.addCssClass(this, \'EditOverGreen\');" onmouseout="Sys.UI.DomElement.removeCssClass(this, \'EditOverGreen\');" onclick="{2}"/>', h, this.grid._language == "v" ? "Sửa" : "Edit", this._command)), n.innerHTML = f.toString()
    },
    renderViewRow: function(n, t, i, r, u, f, e) {
        for (var v, a, s = 0, y = 0; s < f.length; ) {
            if (v = f[s], v == "-") n.append("<td/>");
            else if (v == "1") {
                for (a = 1; s < f.length - 1 && f[s + 1] == "0"; ) a += 1, s += 1;
                var l = e[y].split("."),
                    g = parseInt(l[0]),
                    h = i[g],
                    o, c, p = null,
                    w = 1,
                    b = "",
                    d = l.length;
                if (d == 3 && (w = parseInt(l[2])), d == 1 ? p = !0 : l[1] == "0" && (p = !0), p) {
                    var k = h[2],
                        nt = "",
                        o = u[g];
                    k == "Image" ? o ? (o = String.format('<img id="view_image" src="{0}">', o), c = "ViewImage") : (o = '<div class="ViewBlank"/>', c = "ViewDiv") : (h.length > 3 && (nt = h[3]), o = h.length > 2 ? this.renderViewFormatValue(o, k, nt) : o == null ? "" : o.toString(), o = $func.htmlEncode(o), c = "ViewField"), b = h[0]
                } else o = h[l[1] == "1" ? 1 : 4], c = "ViewLabel";
                n.append(String.format('<td{0}{1} class="ViewCell"><div style="height:100%;width:100%;" class="{2}"{3}>{4}</div></td>', a == 1 ? "" : String.format(" colspan={0}", a), w == 1 ? "" : String.format(" rowspan={0}", w), c, b ? String.format(' id="{0}_view_{1}"', t, b) : "", o)), y += 1
            }
            s += 1
        }
    },
    renderViewFormatValue: function(n, t, i) {
        switch (t) {
            case "":
            case "String":
                return n ? n : "";
            case "Boolean":
                return n ? "1" : "0";
            case "DateTime":
                return i && i.length > 0 ? n == null || n == "" ? "" : n.format(i) : n;
            default:
                return i.length > 0 && i.indexOf("#") > -1 ? (n = n == null ? 0 : n, $func.numberFormat(n, i)) : n == null ? "" : n.toString()
        }
    }
}, SplitterBar = function(n, t, i, r, u, f, e, o, s) {
    var h = this;
    h.grid = s, h.height = 0, h.line = $get(o), h.topLeftPanel = $get(r).parentNode, h.topRightPanel = $get(u).parentNode, h.bottomLeftPanel = $get(f).parentNode, h.bottomRightPanel = $get(e).parentNode, s._anchor = null;
    var l = 50,
        c = ",",
        a = h.topLeftPanel.id + c + r,
        v = h.topRightPanel.id + c + u,
        y = h.bottomLeftPanel.id + c + f,
        p = h.bottomRightPanel.id + c + e,
        w = h.vsb = new Splitter(n, !0, l, l, a + c + y, v + c + p),
        b = h.hsb1 = new Splitter(t, !1, l, l, a, y),
        k = h.hsb2 = new Splitter(i, !1, l, l, v + c + s.get_element().id, p);
    w.splitterBar = b.splitterBar = k.splitterBar = h, $func.isOpr && (h.line.style.height = "0px"), h.whenResize(), s._resizeHandler && ($removeHandler(window, "resize", s._resizeHandler), s._resizeHandler = null), h._resizeHandler = Function.createDelegate(h, h.onResize), $addHandler(window, "resize", h._resizeHandler)
}, SplitterBar.prototype = {
    whenResize: function (n) {
        var yy = 190;
        var t = this,
            f = t.grid,
            o = t.getHeight(t.line),
            s = t.getViewPort(),
            h = s.height,
            p = s.width,
            e = h - o - ($func.isIE ? 24 : 28),
            y = parseInt(e * 0.6) - yy,
            i, r, u = 180;
        t.height = e, n ? (i = t.getHeight(t.topLeftPanel), r = t.getHeight(t.topRightPanel), u = $func.measurementToNumber(t.topLeftPanel.style.width)) : i = r = y;
        var a = e - i,
            w = e - r,
            v = p - u,
            c = i + o - 1,
            l = r + o - 1;        
        if (n && (u = i = r = c = l = null), t.setDivStyle(t.vsb.element, e, u, o), t.setFrameSize(t.vsb, u, v), t.setDivStyle(t.hsb1.element, u, c, 0), t.setFrameSize(t.hsb1, i, a), t.setDivStyle(t.hsb2.element, v, l, 0), t.setFrameSize(t.hsb2, r, w), n) {
            if (f._divMaster) try {
                f._divMaster.style.height = f._mpHeight + h - f._clientHeight + "px"
            } catch (b) { }
        } else f._fixedHeight = a + ($func.isFF ? 54 : 55) - 2 * yy
    },
    onResize: function() {
        this.whenResize(!0)
    },
    setFrameSize: function(n, t, i) {
        var r = n.vertical;
        r ? (this.setMultiFrameSize(n.leftTarget, t, r), this.setMultiFrameSize(n.rightTarget, i, r)) : (this.setMultiFrameSize(n.topTarget, t, r), this.setMultiFrameSize(n.bottomTarget, i, r))
    },
    setMultiFrameSize: function(n, t, i) {
        for (var u = n.split(","), r = 0; r < u.length; r++) this.setFrameLength($get($func.trim(u[r])), t, i)
    },
    setFrameLength: function(n, t, i) {
        if (t && !(t < 0)) {
            var r = n.style,
                u = t + "px";
            i ? r.width = u : r.height = u
        }
    },
    setDivStyle: function(n, t, i, r) {
        var u = n.style;
        u.cursor == "e-resize" ? (t && (u.height = t + "px"), i && (u.left = i + "px"), r && (u.top = r + "px")) : (t && (u.width = t + "px"), i && (u.top = i + "px"))
    },
    getViewPort: function() {
        return $common.getClientBounds()
    },
    getHeight: function(n) {
        return $func.getCurrentStyle(n, "height")
    }
}, Splitter = function(n, t, i, r, u, f) {
    var e = this;
    e.id = n, e.element = $get(n), e.vertical = t, t ? (e.maxLeft = i, e.maxRight = r, e.leftTarget = u, e.rightTarget = f) : (e.maxTop = i, e.maxBottom = r, e.topTarget = u, e.bottomTarget = f, e.step = 0), e.element._addMouseDownHandler || (e.mousedownHandle = Function.createDelegate(e, e.startDrag), $addHandler(e.element, "mousedown", e.mousedownHandle))
}, Splitter.prototype = {
    startDrag: function(n) {
        var t = this,
            i = document,
            o = t.id,
            r = t.element,
            e = t.getPos(n),
            u, f = t.vertical;
        n || (n = window.event), n.cancelBubble = !0, i.onselectstart = function() {
            return !1
        }, $func.isFF && (i.body.style.MozUserSelect = "none"), r.style.zIndex = 9999, u || (u = {
            x: e.posX - r.offsetLeft,
            y: e.posY - r.offsetTop
        }), i.onmousemove = function(n) {
            var i = t.splitterBar,
                w = i.getViewPort(),
                a, y;
            if (f) {
                var v = t.getPos(n).posX - u.x,
                    g = i.vsb.maxLeft,
                    rt = w.width - i.vsb.maxRight,
                    l = 0,
                    p = 0;
                v >= g && v <= rt && (l = v, p = w.width - v, r.style.left = l + "px", i.setFrameSize(i.vsb, l, p), i.setFrameLength(i.hsb1.element, l, f), i.setFrameLength(i.hsb2.element, p, f))
            } else {
                var e = t.getPos(n).posY - u.y,
                    o = i.grid,
                    h = o._divGrid,
                    b = o._fixedHeight,
                    nt = i.getHeight(h),
                    k = $func.vertex(i.vsb.element),
                    s = 0,
                    tt = k + i.hsb1.maxTop,
                    it = w.height - i.hsb1.maxBottom - ($func.isIE ? 24 : 28),
                    c = 0,
                    d = 0;
                if (e != t.step && t.step != 0 && (s = e - t.step, nt += s, b += s), e >= tt && e <= it) {
                    if (r.style.top = e + "px", c = e - k, d = i.height - c, i.setFrameSize(t, c, d), t.topTarget.indexOf(o.get_element().id) != -1 && (i.setFrameLength(h, c - ($func.isFF ? 138 : 139)), o._fixedHeight = b, o._setHeight(), i.grids))
                        for (a = 0; a <= i.grids.length - 1; a++) y = i.grids[a], h = y._divGrid, i.setFrameLength(h, i.getHeight(h) - s), y._offsetHeight += s, y._setHeight()
                } else return;
                t.step = e
            }
        }, i.onmouseup = function() {
            r.style.zIndex = 0, i.onmousedown = null, i.onmousemove = null, i.onselectstart = null, i.onmouseup = null, t.step = 0, $func.isFF && (i.body.style.MozUserSelect = "text")
        }
    },
    getPos: function(n) {
        var t = document,
            i = t.documentElement,
            r = 0,
            u = 0;
        return (n || (n = window.event), n.pageX || n.pageY) ? {
            posX: n.pageX,
            posY: n.pageY
} : n.clientX || n.clientY ? {
    posX: n.clientX + t.body.scrollLeft + i.scrollLeft,
    posY: n.clientY + t.body.scrollTop + i.scrollTop
} : void 0
        }
    }, Tree = function(n, t, i) {
        this.loadData(n, t), this.addElement(n);
        for (var r = 0; r < this._items.length; r++) this._items[r].expand($get(n + r), i)
    }, Tree.prototype = {
        loadData: function(n, t) {
            var i, r;
            for (this._items = [], i = 0; i < t.length; i++)
                if (!t[i][1].trim()) {
                var u = null,
                    f = null,
                    e = null;
                t[i].length > 3 && (u = t[i][3], f = t[i][4], e = t[i][5]), r = {
                    id: t[i][0],
                    name: t[i][2],
                    tag: u,
                    type: f,
                    kind: e,
                    list: []
                }, this.addNode(t, r), this._items.push(new TreeNode(r, this))
            }
        },
        addElement: function(n) {
            for (var r = $get(n), t, i = 0; i < this._items.length; i++) t = document.createElement("div"), t.setAttribute("id", n + i), r.appendChild(t)
        },
        addNode: function(n, t) {
            for (var r, i = 0; i < n.length; i++)
                if (n[i][1] == t.id) {
                var u = null,
                    f = null,
                    e = null;
                n[i].length > 3 && (u = n[i][3], f = n[i][4], e = n[i][5]), r = {
                    id: n[i][0],
                    name: n[i][2],
                    tag: u,
                    type: f,
                    kind: e,
                    list: []
                }, this.addNode(n, r), t.list.push(r)
            }
        },
        select: function(n) {
            this.unSelect(), this.selectedItem = n, Sys.UI.DomElement.addCssClass(n.content, "TreeNodeSelected")
        },
        unSelect: function() {
            this.selectedItem && (Sys.UI.DomElement.removeCssClass(this.selectedItem.content, "TreeNodeSelected"), this.selectedItem = null)
        }
    }, TreeNode = function(n, t) {
        var r, i;
        if (this.name = n.name, this.id = n.id, this.tag = n.tag, this.type = n.type, this.kind = n.kind, this.tree = t, n.list != "") {
            for (r = [], i = 0; i < n.list.length; i++) r[i] = new TreeNode(n.list[i], t), r[i].parent = this;
            this.list = [], this.addList(r)
        }
        this.render()
    }, TreeNode.prototype = {
        addList: function(n) {
            var i, t;
            if (this.list && n.length > 0)
                for (i = this.list.length, t = 0; t < n.length; t++, i++) this.list[i] = n[t]
        },
        newTag: function(n) {
            return document.createElement(n ? n : "a")
        },
        render: function() {
            var r = this.body = this.newTag("div"),
            i = this.html = this.newTag("div"),
            u = this.header = this.newTag().appendChild(this.newTag()),
            n = this.content = this.newTag().appendChild(this.newTag()),
            t;
            if (u.onclick = Function.createDelegate(this, this.showHide), n.setAttribute("id", this.id), n.setAttribute("class", "TreeNodeText"), n.appendChild(document.createTextNode(this.name)), n.onclick = Function.createDelegate(this, this.onClick), i.className = "TreeNodeElement", i.appendChild(u), i.appendChild(n), i.appendChild(r), this.list)
                for (t = 0; t < this.list.length; t++) this.list[t].render(), r.appendChild(this.list[t].html)
        },
        showHide: function() {
            this.setStyle(this.body.style.display)
        },
        onClick: function() {
            if (this.tree.select(this), this.tree.onClickHandler) this.tree.onClickHandler(this)
        },
        setStyle: function(n) {
            this.body.style.display = n ? "" : "none", this.header.className = (n ? " TreeNodeOpened" : "TreeNodeClosed") + " TreeNodeImage"
        },
        expand: function(n, t) {
            this.prepare(t), n.innerHTML = "", n.appendChild(this.html)
        },
        prepare: function(n) {
            if (!this.list) {
                this.header.className = "TreeNodeHeader";
                return
            }
            this.setStyle(n);
            for (var t = 0; t < this.list.length; t++) this.list[t].prepare(n)
        }
    }, typeof Sys != "undefined" && Sys.Application.notifyScriptLoaded();