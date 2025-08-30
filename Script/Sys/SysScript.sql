/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmtabinfo') AND xType = 'U')
DROP TABLE [dbo].[crmtabinfo]
*/
GO
CREATE TABLE [dbo].[crmtabinfo] (
	[id] CHAR(2) NOT NULL,
	[id0] CHAR(2),
	[bar] NVARCHAR(128) NOT NULL,
	[bar2] NVARCHAR(128),
	[sysid] VARCHAR(64),
	[grid_yn] BIT NOT NULL,
	[hidden_grid_yn] BIT,
	[view_yn] BIT,
	[table_del_yn] BIT,
	[table_name] VARCHAR(32)
)

ALTER TABLE dbo.crmtabinfo ADD 
	CONSTRAINT PK_crmtabinfo PRIMARY KEY CLUSTERED
	(
		id
	) ON [PRIMARY] 


GO


/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmquyenbp') AND xType = 'U')
DROP TABLE [dbo].[crmquyenbp]
*/
GO
CREATE TABLE [dbo].[crmquyenbp] (
	[user_id] INT NOT NULL,
	[r_access] VARCHAR(8000),
	[r_access2] VARCHAR(8000)
)

ALTER TABLE dbo.crmquyenbp ADD 
	CONSTRAINT PK_crmquyenbp PRIMARY KEY CLUSTERED
	(
		user_id
	) ON [PRIMARY] 


GO

CREATE INDEX [user_id] ON dbo.crmquyenbp([user_id]) ON [PRIMARY]
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$Department$Loading') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$Department$Loading
GO




CREATE PROCEDURE [dbo].[Sthink$CRM$Department$Loading]
	@Unit VARCHAR(32),
	@UserID INT,
	@Admin BIT,
	@AppDB VARCHAR(32),
	@Language CHAR(1)
AS BEGIN
	SET NOCOUNT ON
	DECLARE @q NVARCHAR(4000), @cmd NVARCHAR(4000), @AccessRight VARCHAR(8000), @Ref VARCHAR(128), @Ref2 VARCHAR(128)

	IF @Admin = 1 BEGIN
		SET @q = 'SELECT RTRIM(ma_bp) id, RTRIM(bp_me) AS pid, ' + CASE WHEN @Language = 'V' THEN 'RTRIM(ten_bp)' ELSE 'RTRIM(ten_bp2)' END + ' AS bar, stt_ref FROM ' + @AppDB + '..crmbp where ma_dvcs = ''' + RTRIM(@Unit) + ''' ORDER BY stt_ref, ma_bp'
	print @q
	EXEC(@q)
		RETURN
	END

	SELECT TOP 0 CAST('' AS CHAR(16)) id, CAST('' AS CHAR(16)) pid, CAST('' AS NVARCHAR(128)) bar, CAST('' AS VARCHAR(128)) AS bp_ref, CAST('' AS VARCHAR(512)) AS stt_ref INTO #r
	SELECT @AccessRight = REPLACE(r_access2, ' ', '') FROM crmquyenbp WHERE user_id = @UserID
	IF @AccessRight <> '' BEGIN
		SELECT @AccessRight = 'bp_ref LIKE ''' + REPLACE(@AccessRight, ',', '%''' + ' OR bp_ref LIKE ''') + '%'''
		IF LEN(@AccessRight) > 3000 GOTO Result

		SET @q = 'INSERT INTO #r SELECT ma_bp, bp_me, '''' bar, bp_ref, stt_ref FROM ' + @AppDB + '..crmbp WHERE ma_dvcs = ''' + RTRIM(@Unit) + ''' and ' + @AccessRight
		EXEC(@q)
	END
	ELSE GOTO Result

	IF NOT EXISTS(SELECT 1 FROM #r) GOTO Result

	SELECT * INTO #k FROM #r WHERE pid <> '' AND (LEN(bp_ref) <> 3) AND (pid NOT IN (SELECT id FROM #r))

	IF EXISTS(SELECT COUNT(1) FROM #k) BEGIN 
		SELECT TOP 0 bp_ref INTO #k2 FROM #k
		WHILE EXISTS(SELECT 1 FROM #k) BEGIN	
			SELECT TOP 1 @Ref = id, @Ref2 = bp_ref FROM #k
			WHILE LEN(@Ref2) <> 3 BEGIN
				SELECT @Ref2 = RTRIM(LEFT(@Ref2, LEN(@Ref2) - 3))
				INSERT INTO #k2 SELECT @Ref2
				IF LEN(@Ref2) = 3 DELETE #k WHERE id = @Ref
			END
		END
	END

	SET @q = 'INSERT INTO #r SELECT ma_bp, bp_me, '''' AS name, bp_ref, stt_ref FROM ' + @AppDB + '..crmbp'
	SET @q = @q + ' WHERE bp_ref IN(SELECT DISTINCT bp_ref FROM #k2) and ma_dvcs = ''' + RTRIM(@Unit) + ''''
print @q
	EXEC(@q)

	Result:
	SELECT @q = 'SELECT DISTINCT RTRIM(ma_bp) AS id, RTRIM(bp_me) AS pid, CASE ''' + @Language + ''' WHEN ''V'' THEN b.ten_bp ELSE b.ten_bp2 END bar, a.stt_ref'
	SELECT @q = @q + ' FROM #r a JOIN ' + @AppDB + '..crmbp b ON a.id = b.ma_bp and b.ma_dvcs = ''' + RTRIM(@Unit) + ''' ORDER BY a.stt_ref, id'
print @q
	EXEC(@q)

	SET NOCOUNT OFF
END









 





GO


DELETE crmtabinfo WHERE  1=1
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'10', N'', N'Quản lý khách hàng', N'Customerl Information', N'', 0, 0, 0, 0, N'')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'11', N'10', N'Thông tin chung', N'General Information', N'crmCustomer', 0, 0, 1, 0, N'zcdmkh')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'12', N'10', N'Liên hệ', N'Regular Education', N'crmLienhe', 1, 0, 0, 1, N'crmdmlienhe')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'14', N'10', N'Tài liệu đính kèm', N'Regular Education', N'crmFiles', 1, 0, 0, 1, N'crm_dmlienhe')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'15', N'10', N'Nhật ký công việc', N'Educational Background', N'crmNhatky', 1, 0, 0, 1, N'crmnhatky')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'20', N'', N'Bán hàng', N'Educational Background', N'', 0, 0, 0, 0, N'')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'21', N'20', N'Báo giá', N'Contact', N'crmbg', 1, 0, 0, 1, N'm61$000000')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'22', N'20', N'Đơn hàng', N'Contact', N'crmdhban', 1, 0, 0, 1, N'm64$000000')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'23', N'20', N'Hóa đơn', N'Contact', N'crmhdban', 1, 0, 0, 1, N'm81$000000')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'24', N'20', N'Công nợ phải thu', N'Contact', N'crmCongNoCustomer', 1, 0, 0, 1, N'')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'30', N'', N'Mua hàng', N'Educational Background', N'', 0, 0, 0, 0, N'')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'31', N'30', N'Đơn hàng mua', N'Contact', N'crmdhmua', 1, 0, 0, 1, N'm94$000000')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'32', N'30', N'Hoá đơn mua', N'Contact', N'crmhdmua', 1, 0, 0, 1, N'm71$000000')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'33', N'30', N'Công nợ phải trả', N'Contact', N'crmCongNoSupplier', 1, 0, 0, 1, N'')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'40', N'', N'Tiền', N'Educational Background', N'', 0, 0, 0, 0, N'')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'41', N'40', N'Thu', N'Contact', N'crmPhieuThu', 1, 0, 0, 1, N'm41$000000')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'42', N'40', N'Chi', N'Contact', N'crmPhieuChi', 1, 0, 0, 1, N'm51$000000')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'43', N'40', N'Báo có', N'Contact', N'crmBaoCo', 1, 0, 0, 1, N'm46$000000')
INSERT INTO crmtabinfo([id], [id0], [bar], [bar2], [sysid], [grid_yn], [hidden_grid_yn], [view_yn], [table_del_yn], [table_name]) VALUES(N'44', N'40', N'Báo nợ', N'Contact', N'crmBaoNo', 1, 0, 0, 1, N'm56$000000')
GO

/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmdmquyen') AND xType = 'U')
DROP TABLE [dbo].[crmdmquyen]
*/
GO
CREATE TABLE [dbo].[crmdmquyen] (
	[ma_dvcs] CHAR(8) NOT NULL,
	[ma_quyen] CHAR(16) NOT NULL,
	[ten_quyen] NVARCHAR(128) NOT NULL,
	[ten_quyen2] NVARCHAR(128),
	[loai_quyen] CHAR(1) NOT NULL,
	[status] CHAR(1),
	[datetime0] DATETIME,
	[datetime2] DATETIME,
	[user_id0] INT,
	[user_id2] INT
)

ALTER TABLE dbo.crmdmquyen ADD 
	CONSTRAINT PK_crmdmquyen PRIMARY KEY CLUSTERED
	(
		ma_dvcs, ma_quyen
	) ON [PRIMARY] 


GO


/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmquyennsd') AND xType = 'U')
DROP TABLE [dbo].[crmquyennsd]
*/
GO
CREATE TABLE [dbo].[crmquyennsd] (
	[ma_dvcs] CHAR(8) NOT NULL,
	[ma_quyen] CHAR(16) NOT NULL,
	[user_id] INT NOT NULL,
	[datetime0] DATETIME,
	[datetime2] DATETIME,
	[user_id0] INT,
	[user_id2] INT
)

ALTER TABLE dbo.crmquyennsd ADD 
	CONSTRAINT PK_crmquyennsd PRIMARY KEY CLUSTERED
	(
		ma_dvcs, user_id, ma_quyen
	) ON [PRIMARY] 


GO

CREATE INDEX [ma_quyen] ON dbo.crmquyennsd([ma_quyen]) ON [PRIMARY]
GO

CREATE INDEX [user_id] ON dbo.crmquyennsd([user_id]) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vcrmquyennsd') AND xType = 'V')
DROP VIEW dbo.vcrmquyennsd
GO




CREATE VIEW [dbo].[vcrmquyennsd]
AS
SELECT a.ma_dvcs, a.user_id, a.ma_quyen, c.loai_quyen, b.name, b.comment, b.comment2, b.admin, b.user_yn, c.ten_quyen, c.ten_quyen2
	FROM crmquyennsd AS a LEFT JOIN userinfo2 AS b ON a.user_id = b.id LEFT JOIN crmdmquyen AS c ON a.ma_quyen = c.ma_quyen and a.ma_dvcs = c.ma_dvcs








GO


/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmrightinfo9') AND xType = 'U')
DROP TABLE [dbo].[crmrightinfo9]
*/
GO
CREATE TABLE [dbo].[crmrightinfo9] (
	[ma_dvcs] CHAR(8) NOT NULL,
	[ma_quyen] CHAR(16) NOT NULL,
	[r1] TEXT,
	[r2] TEXT,
	[r3] TEXT,
	[r4] TEXT,
	[r5] TEXT,
	[l1] TEXT,
	[l2] TEXT,
	[l3] TEXT,
	[l4] TEXT,
	[l5] TEXT
)

GO


/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmctquyenbp') AND xType = 'U')
DROP TABLE [dbo].[crmctquyenbp]
*/
GO
CREATE TABLE [dbo].[crmctquyenbp] (
	[ma_dvcs] CHAR(8) NOT NULL,
	[ma_quyen] CHAR(16) NOT NULL,
	[r_access] VARCHAR(4000) NOT NULL,
	[r_access2] VARCHAR(4000),
	[datetime0] DATETIME,
	[datetime2] DATETIME,
	[user_id0] INT,
	[user_id2] INT
)

ALTER TABLE dbo.crmctquyenbp ADD 
	CONSTRAINT PK_crmctquyenbp PRIMARY KEY CLUSTERED
	(
		ma_dvcs, ma_quyen
	) ON [PRIMARY] 


GO

CREATE INDEX [ma_quyen] ON dbo.crmctquyenbp([ma_quyen]) ON [PRIMARY]
GO


/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmctquyentab') AND xType = 'U')
DROP TABLE [dbo].[crmctquyentab]
*/
GO
CREATE TABLE [dbo].[crmctquyentab] (
	[ma_dvcs] CHAR(8) NOT NULL,
	[ma_quyen] CHAR(16) NOT NULL,
	[r_access] VARCHAR(1024) NOT NULL,
	[r_new] VARCHAR(1024) NOT NULL,
	[r_edit] VARCHAR(1024) NOT NULL,
	[r_del] VARCHAR(1024) NOT NULL,
	[datetime0] DATETIME,
	[datetime2] DATETIME,
	[user_id0] INT,
	[user_id2] INT
)

ALTER TABLE dbo.crmctquyentab ADD 
	CONSTRAINT PK_crmctquyentab PRIMARY KEY CLUSTERED
	(
		ma_dvcs, ma_quyen
	) ON [PRIMARY] 


GO

CREATE INDEX [ma_quyen] ON dbo.crmctquyentab([ma_quyen]) ON [PRIMARY]
GO


/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmaccessrights') AND xType = 'U')
DROP TABLE [dbo].[crmaccessrights]
*/
GO
CREATE TABLE [dbo].[crmaccessrights] (
	[user_id] INT NOT NULL,
	[controller] VARCHAR(128) NOT NULL,
	[r_access] TINYINT,
	[r_new] TINYINT,
	[r_edit] TINYINT,
	[r_del] TINYINT
)

ALTER TABLE dbo.crmaccessrights ADD 
	CONSTRAINT PK_crmaccessrights PRIMARY KEY CLUSTERED
	(
		user_id, controller
	) ON [PRIMARY] 


GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$System$SetTabRight') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$System$SetTabRight
GO


CREATE PROCEDURE [dbo].[Sthink$CRM$System$SetTabRight]
	@UserID INT,
	@Unit VARCHAR(32)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM userinfo2 WHERE id = @UserID AND user_yn = 0) RETURN

	DECLARE @Username VARCHAR(32), @OwnerRight CHAR(16), @q NVARCHAR(4000), @cmd NVARCHAR(4000)
	DECLARE @AccessRight VARCHAR(8000), @NewRight VARCHAR(8000), @EditRight VARCHAR(8000), @DelRight VARCHAR(8000)
	
	SELECT @AccessRight = '', @NewRight = '', @EditRight = '', @DelRight = '', @OwnerRight = ''
	SELECT TOP 0 CAST(0 AS INT) AS user_id, CAST('' AS VARCHAR(32)) AS id, CAST('' AS VARCHAR(128)) AS controller, CAST(0 AS TINYINT) AS r_access,
		CAST(0 AS TINYINT) AS r_new, CAST(0 AS TINYINT) AS r_edit, CAST(0 AS TINYINT) AS r_del INTO #k

	SELECT @Username = RTRIM(name) FROM userinfo2 WHERE id = @UserID
	SELECT @OwnerRight = a.ma_quyen FROM crmctquyentab a JOIN crmquyennsd b ON a.ma_quyen = b.ma_quyen AND a.ma_dvcs = b.ma_dvcs JOIN crmdmquyen c ON a.ma_quyen = c.ma_quyen AND a.ma_dvcs = c.ma_dvcs WHERE b.user_id = @UserID AND b.ma_dvcs = @Unit AND c.loai_quyen = '1'
	SELECT @AccessRight = r_access, @NewRight = r_new, @EditRight = r_edit, @DelRight = r_del FROM crmctquyentab WHERE ma_quyen = @OwnerRight AND ma_dvcs = @Unit

	SELECT @AccessRight = @AccessRight + ',' + a.r_access, @NewRight = @NewRight + ',' + a.r_new, @EditRight = @EditRight + ',' + a.r_edit, @DelRight = @DelRight + ',' + a.r_del
		FROM crmctquyentab a JOIN crmquyennsd b ON a.ma_quyen = b.ma_quyen AND a.ma_dvcs = b.ma_dvcs JOIN crmdmquyen c ON a.ma_quyen = c.ma_quyen AND a.ma_dvcs = c.ma_dvcs JOIN userinfo2 d ON b.user_id = d.id
		WHERE CHARINDEX(@Username + ',', REPLACE(d.user_lst, ' ', '') + ',') <> 0 AND c.loai_quyen = '1' AND a.ma_quyen <> @OwnerRight AND b.ma_dvcs = @Unit
	
	IF REPLACE(@AccessRight, ',', '') + REPLACE(@NewRight, ',', '') + REPLACE(@EditRight, ',', '') + REPLACE(@DelRight, ',', '')	= '' BEGIN
		DELETE crmaccessrights WHERE user_id = @UserID
		RETURN
	END

	SET @AccessRight = CHAR(39) + REPLACE(REPLACE(@AccessRight, '.01A', ''), ',', ''',''') + CHAR(39)
	SET @NewRight = CHAR(39) + REPLACE(REPLACE(@NewRight, '.02N', ''), ',', ''',''') + CHAR(39)
	SET @EditRight =	CHAR(39) + REPLACE(REPLACE(@EditRight, '.03E', ''), ',', ''',''') + CHAR(39)
	SET @DelRight = CHAR(39) + REPLACE(REPLACE(@DelRight, '.04D', ''), ',', ''',''') + CHAR(39)

	SET @q = 'INSERT INTO #k(user_id, id, controller, r_access, r_new, r_edit, r_del) SELECT DISTINCT ' + RTRIM(@UserID) + ', id, sysid, 0, 0, 0, 0 FROM crmtabinfo WHERE id IN (' + @AccessRight + ')'
	EXEC(@q)

	SET @q = 'UPDATE #k SET %right% = 1 WHERE id IN (%id%)'
	SET @cmd = REPLACE(REPLACE(@q, '%id%', @AccessRight), '%right%', 'r_access')
	EXEC(@cmd)
	SET @cmd = REPLACE(REPLACE(@q, '%id%', @NewRight), '%right%', 'r_new')
	EXEC(@cmd)
	SET @cmd = REPLACE(REPLACE(@q, '%id%', @EditRight), '%right%', 'r_edit')
	EXEC(@cmd)
	SET @cmd = REPLACE(REPLACE(@q, '%id%', @DelRight), '%right%', 'r_del')
	EXEC(@cmd)

	DELETE crmaccessrights WHERE user_id = @UserID
	INSERT INTO crmaccessrights(user_id, controller, r_access, r_new, r_edit, r_del) SELECT user_id, controller, r_access, r_new, r_edit, r_del FROM #k
END









GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$System$SetDepartmentRight') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$System$SetDepartmentRight
GO




CREATE PROCEDURE [dbo].[Sthink$CRM$System$SetDepartmentRight]
	@UserID INT,
	@AppDB VARCHAR(32),
	@Unit VARCHAR(32)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM userinfo2 WHERE id = @UserID AND user_yn = 0) RETURN

	DECLARE @AccessRight VARCHAR(8000), @Right VARCHAR(8000), @Right2 VARCHAR(8000), @Username VARCHAR(32), @OwnerRight CHAR(16), @q NVARCHAR(4000)
	SELECT @AccessRight = '', @Right = '', @Right2 = '', @OwnerRight = '', @q = ''

	SELECT TOP 0 CAST('' AS CHAR(16)) AS ma_bp, CAST('' AS VARCHAR(128)) AS bp_ref INTO #r
	SELECT @Username = RTRIM(name) FROM userinfo2 WHERE id = @UserID
	SELECT @OwnerRight = a.ma_quyen FROM crmctquyenbp a JOIN crmquyennsd b ON a.ma_quyen = b.ma_quyen AND a.ma_dvcs = b.ma_dvcs JOIN crmdmquyen c ON a.ma_quyen = c.ma_quyen AND a.ma_dvcs = c.ma_dvcs WHERE b.user_id = @UserID AND b.ma_dvcs = @Unit AND c.loai_quyen = '2' 

	SELECT @AccessRight = r_access FROM crmctquyenbp WHERE ma_quyen = @OwnerRight AND ma_dvcs = @Unit
	SELECT @AccessRight = @AccessRight + ',' + a.r_access FROM crmctquyenbp a JOIN crmquyennsd b ON a.ma_quyen = b.ma_quyen AND a.ma_dvcs = b.ma_dvcs JOIN crmdmquyen c ON a.ma_quyen = c.ma_quyen AND a.ma_dvcs = c.ma_dvcs JOIN userinfo2 d ON b.user_id = d.id 
	WHERE CHARINDEX(@Username + ',', REPLACE(d.user_lst, ' ', '') + ',') <> 0 AND c.loai_quyen = '2' AND a.ma_quyen <> @OwnerRight AND b.ma_dvcs = @Unit

	IF REPLACE(@AccessRight, ',', '') = '' BEGIN
		DELETE FROM crmquyenbp WHERE user_id = @UserID
		RETURN
	END	

	SET @AccessRight = CHAR(39) + REPLACE(@AccessRight, ',', ''',''') + CHAR(39)
	SET @q = 'SELECT @Right = @Right + RTRIM(ma_bp) + '','' FROM ' + @AppDB + '..crmbp WHERE ma_bp in (' + @AccessRight + ')'
	SET @q = @q + 'SELECT @Right2 = @Right2 + bp_ref + '','' FROM ' + @AppDB + '..crmbp WHERE ma_bp in (' + @AccessRight + ')'
	EXEC sp_executesql @q, N'@Right VARCHAR(8000) OUTPUT, @Right2 VARCHAR(8000) OUTPUT', @Right = @Right OUTPUT, @Right2 = @Right2 OUTPUT

	IF @Right <> '' SELECT @Right = LEFT(@Right, LEN(@Right) - 1)
	IF @Right2 <> '' SELECT @Right2 = LEFT(@Right2, LEN(@Right2) - 1)
	
	DELETE FROM crmquyenbp WHERE user_id = @UserID
	INSERT INTO crmquyenbp SELECT @UserID, @Right, @Right2
END








GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$GetDepartmentTreeview') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$GetDepartmentTreeview
GO




CREATE PROCEDURE [dbo].[Sthink$CRM$GetDepartmentTreeview]
	@RightID VARCHAR(33),
	@UnitID VARCHAR(33),
	@AppDB VARCHAR(32),
	@Language CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @q NVARCHAR(4000), @AccessRight VARCHAR(8000)
	SELECT @AccessRight = ''
	SELECT TOP 0 CAST('' AS CHAR(16)) AS ma_bp, CAST('' AS CHAR(16)) AS bp_me, CAST('' AS VARCHAR(128)) AS bp_ref, 
		CAST('' AS VARCHAR(512)) AS stt_ref, CAST('' AS NVARCHAR(128)) AS bar, CAST(0 AS BIT) AS access INTO #r

	SET @q = 'INSERT INTO #r SELECT ma_bp, bp_me, bp_ref, stt_ref, '''', CAST(0 AS BIT) AS access FROM ' + @AppDB + '..crmbp where ma_dvcs = ''' + @UnitID + ''''
	EXEC(@q)

	SELECT @AccessRight = REPLACE(r_access2, ' ', '') FROM crmctquyenbp WHERE ma_quyen = @RightID and ma_dvcs = @UnitID
	IF REPLACE(@AccessRight, ',', '') <> '' BEGIN
		SELECT @AccessRight = 'bp_ref LIKE ''' + REPLACE(@AccessRight, ',', '%''' + ' OR bp_ref LIKE ''') + '%'''
		IF LEN(@AccessRight) <= 3000 BEGIN
			SELECT @q = 'UPDATE #r SET access = 1 WHERE ' + @AccessRight
			EXEC(@q)
		END
	END

	SELECT @q = 'SELECT a.ma_bp id, a.bp_me id0, CASE ''' + @Language + ''' WHEN ''V'' THEN b.ten_bp ELSE b.ten_bp2 END bar, a.access'
	SELECT @q = @q + ' FROM #r a JOIN ' + @AppDB + '..crmbp b ON a.ma_bp = b.ma_bp AND b.ma_dvcs = ''' + @UnitID + ''' ORDER BY a.stt_ref, a.ma_bp'
	EXEC(@q)

	SET NOCOUNT OFF
END







GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$GetTabTreeview') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$GetTabTreeview
GO




CREATE PROCEDURE [dbo].[Sthink$CRM$GetTabTreeview]
	@RightID VARCHAR(33),
	@UnitID VARCHAR(33),
	@Language CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	SELECT @RightID = REPLACE(@RightID, '''', '')

	DECLARE @q NVARCHAR(4000), @cmd NVARCHAR(4000)
	SELECT TOP 0 CAST('' AS VARCHAR(33)) AS id, CAST('' AS VARCHAR(33)) AS id0, CAST('' AS VARCHAR(33)) AS id2, bar, CAST(0 AS BIT) AS access INTO #r FROM crmtabinfo
	SELECT id, id0, grid_yn, view_yn INTO #h FROM crmtabinfo WHERE sysid <> ''

	INSERT INTO #r SELECT id, id0, '', '', CAST(0 AS BIT) AS access FROM crmtabinfo

	INSERT INTO #r (id, id0, id2, bar, access)
		SELECT RTRIM(id) + '.01A', RTRIM(id0), RTRIM(id), CASE @Language WHEN 'V' THEN N'Truy cập' ELSE N'Access' END, 0 FROM #h
			UNION ALL SELECT RTRIM(id) + '.02N', RTRIM(id0), RTRIM(id), CASE @Language WHEN 'V' THEN N'Mới' ELSE N'New' END, 0 FROM #h WHERE grid_yn = 1 AND view_yn = 0
			UNION ALL SELECT RTRIM(id) + '.03E', RTRIM(id0), RTRIM(id), CASE @Language WHEN 'V' THEN N'Sửa' ELSE N'Edit' END, 0 FROM #h WHERE view_yn = 0
			UNION ALL SELECT RTRIM(id) + '.04D', RTRIM(id0), RTRIM(id), CASE @Language WHEN 'V' THEN N'Xóa' ELSE N'Delete' END, 0 FROM #h WHERE grid_yn = 1 AND view_yn = 0

	SELECT @cmd = 'UPDATE #r SET access = 1 FROM #r a, crmctquyentab b WHERE PATINDEX(''%'' + RTRIM(a.id) + ''%'', b.%r%) > 0 AND b.ma_quyen = ''' + @RightID + ''' and b.ma_dvcs = ''' + @UnitID + ''''

	SELECT @q = REPLACE(@cmd, '%r%', 'r_access')
	EXEC(@q)

	SELECT @q = REPLACE(@cmd, '%r%', 'r_new')
	EXEC(@q)

	SELECT @q = REPLACE(@cmd, '%r%', 'r_edit')
	EXEC(@q)

	SELECT @q = REPLACE(@cmd, '%r%', 'r_del')
	EXEC(@q)

	UPDATE #r SET id0 = id2 WHERE id2 <> ''
	UPDATE #r SET bar = CASE @Language WHEN 'V' THEN b.bar ELSE b.bar2 END FROM #r a, crmtabinfo b WHERE a.id = b.id

	SELECT id, id0, id2, bar, access FROM #r ORDER BY id

	SET NOCOUNT OFF
END








GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$System$GetAccessRight') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$System$GetAccessRight
GO


CREATE PROCEDURE [dbo].[Sthink$System$GetAccessRight] @id INT, @controller VARCHAR(128), @type TINYINT, @right VARCHAR(128) AS
BEGIN
	SET NOCOUNT ON
	DECLARE @c VARCHAR(4), @r INT
	SELECT @c = '0000', @r = 0
	IF @controller IN('DashBoardNS_DSNV', 'DashBoardNS_DSNVTV', 'DashBoardNS_DSNVNV', 'DashBoardNS_DSNVNH', 'DashboardKho_ChiTietNhap', 'DashboardKho_ChiTietXuat', 'DashboardKho_TonVatTu', 'DashboardKho_TonCham', 'DashboardSXTK_VTTieuHao') BEGIN

		SELECT '1' AS VALUE
		RETURN
	END
	IF EXISTS(SELECT 1 FROM accessrights WHERE user_id = @id AND controller = @controller) BEGIN
		IF @type = 0 SELECT @c = 
				CASE WHEN r_access = 1 THEN '1' ELSE '0' END + 
				CASE WHEN r_new = 1 THEN '1' ELSE '0' END + 
				CASE WHEN r_edit = 1 THEN '1' ELSE '0' END + 
				CASE WHEN r_del = 1 THEN '1' ELSE '0' END
			FROM accessrights WHERE user_id = @id AND controller = @controller
		ELSE
			SELECT @r = CASE
				WHEN @right = 'access' THEN r_access
				WHEN @right = 'new' THEN r_new
				WHEN @right = 'edit' THEN r_edit
				WHEN @right = 'del' THEN r_del
				ELSE 0
			END
			FROM accessrights WHERE user_id = @id AND controller = @controller
	END
	IF EXISTS(SELECT 1 FROM crmaccessrights WHERE user_id = @id AND controller = @controller) BEGIN
		IF @type = 0 SELECT @c = 
				CASE WHEN r_access = 1 THEN '1' ELSE '0' END + 
				CASE WHEN r_new = 1 THEN '1' ELSE '0' END + 
				CASE WHEN r_edit = 1 THEN '1' ELSE '0' END + 
				CASE WHEN r_del = 1 THEN '1' ELSE '0' END
			FROM crmaccessrights WHERE user_id = @id AND controller = @controller
		ELSE
			SELECT @r = CASE
				WHEN @right = 'access' THEN r_access
				WHEN @right = 'new' THEN r_new
				WHEN @right = 'edit' THEN r_edit
				WHEN @right = 'del' THEN r_del
				ELSE 0
			END
			FROM crmaccessrights WHERE user_id = @id AND controller = @controller
	END
	IF @type = 0 SELECT @c AS VALUE
		ELSE SELECT @r AS VALUE
	
	SET NOCOUNT OFF
END








GO


--DELETE wcommand WHERE  wmenu_id >= '01.40.00' AND wmenu_id <= '01.40.09'
INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'01.40.00', N'01.00.00', N'99.50.01', N'Phân quyền CRM theo nhân viên KD', N'Customer Access Control', N'.', N'', N'', 0, N'1', N'', 0, N'', N'', NULL, NULL, 0, 0, N'', N'', 0, N'', N'00', N'', N'')
INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'01.40.01', N'01.40.00', N'99.50.02', N'Khai báo quyền sử dụng', N'Access Right List', N'crmAccessRight.aspx', N'', N'', 0, N'1', N'b64Property', 0, N'crmAccessRight', N'', NULL, NULL, 0, 0, N'D', N'', 0, N'', N'00', N'', N'')
INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'01.40.02', N'01.40.00', N'99.50.03', N'Phân quyền chức năng', N'Defining Task Access Control', N'crmAllowTabRight.aspx', N'', N'', 0, N'1', N'', 0, N'crmAllowTabRight', N'', NULL, NULL, 0, 0, N'D', N'', 0, N'', N'00', N'', N'')
INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'01.40.03', N'01.40.00', N'99.50.05', N'Phân quyền bộ phận', N'Defining Department Access Control', N'crmAllowDepartmentRight.aspx', N'', N'', 0, N'1', N'', 0, N'crmAllowDepartmentRight', N'', NULL, NULL, 0, 0, N'D', N'', 0, N'', N'00', N'', N'')
--INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'01.40.05', N'01.40.00', N'99.50.11', N'Khai báo quyền khách hàng', N'Defining Customer Access Right', N'crmAllowCustomerRight.aspx', N'', N'', 0, N'1', N'', 0, N'crmAllowCustomerRight', N'', NULL, NULL, 0, 0, N'D', N'', 0, N'', N'00', N'', N'')
INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'01.40.06', N'01.40.00', N'99.50.11', N'-', N'-', N'.', N'', N'', 0, N'1', N'', 0, N'', N'', NULL, NULL, 0, 0, N'', N'', 0, N'', N'00', N'', N'')
INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'01.40.08', N'01.40.00', N'99.50.07', N'Phân quyền người sử dụng', N'User Access Control', N'crmAllowUserRight.aspx', N'', N'', 0, N'1', N'b64Access', 0, N'crmAllowUserRight', N'', NULL, NULL, 0, 0, N'D', N'', 0, N'', N'00', N'', N'')
--INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'01.40.09', N'01.40.00', N'99.50.09', N'Phân quyền nhóm người sử dụng', N'Group Access Control', N'crmAllowGroupRight.aspx', N'', N'', 0, N'1', N'', 0, N'crmAllowGroupRight', N'', NULL, NULL, 0, 0, N'D', N'', 0, N'', N'00', N'', N'')
GO

--DELETE command WHERE  menu_id >= '99.50.01' AND menu_id <= '99.50.11'
INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'99.50.01', N'99.00.00', N'Phân quyền', N'User Right Assignment', N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'99.50.02', N'99.00.00', N'Danh mục quyền sử dụng', N'Access Right List', N'', N'crmAccessRight.aspx', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'crmAccessRight', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'99.50.03', N'99.00.00', N'Khai báo quyền chức năng', N'Allow Tab Right', N'', N'crmUserRightAssignmentByInfoTab.aspx', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'crmAllowTabRight', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'99.50.05', N'99.00.00', N'Khai báo quyền bộ phận', N'Allow Department Right', N'', N'crmAllowDepartmentRight.aspx', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'crmAllowDepartmentRight', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'99.50.07', N'99.00.00', N'Phân quyền người sử dụng', N'Allow User Right', N'', N'crmAllowUserRight.aspx', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'crmAllowUserRight', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
--INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'99.50.09', N'99.00.00', N'Phân quyền nhóm người sử dụng', N'Allow Group Right', N'', N'crmAllowGroupRight.aspx', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'crmAllowGroupRight', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
--INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'99.50.11', N'99.00.00', N'Khai báo quyền khách hàng', N'Allow Customer Right', N'', N'crmAllowCustomerRight.aspx', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'crmAllowCustomerRight', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

--DELETE wcommand WHERE  wmenu_id like '39.%'
INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'39.00.00', N'', N'39.00.00', N'CRM', N'Insurance', N'', N'', N'', 0, N'1', N'', 0, N'', N'', NULL, NULL, 0, 0, N'', N'', 0, N'', N'00', N'', N'')
INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'39.05.01', N'39.00.00', N'39.05.01', N'Thông tin khách hàng', N'Customer Information', N'crmCustomerInformation.aspx', N'', N'', 0, N'1', N'b64Employee', 0, N'crmCIGeneralInformation', N'', NULL, NULL, 0, 0, N'D', N'', 0, N'', N'00', N'', N'')
INSERT INTO wcommand([wmenu_id], [wmenu_id0], [menu_id], [bar], [bar2], [link], [parameter], [icon_url], [width], [status], [icon], [expl_icon], [sysid], [edition], [datetime2], [datetime0], [user_id0], [user_id2], [type], [syscode], [msys], [target], [xtype], [smenu_id], [sicon]) VALUES(N'39.05.02', N'39.00.00', N'39.05.02', N'Danh mục phân cấp khách hàng theo NVKD', N'Department List', N'crmDepartment.aspx', N'', N'', 0, N'1', N'', 0, N'crmDepartment', N'', NULL, NULL, 0, 0, N'D', N'', 0, N'', N'00', N'', N'')
GO

--DELETE command WHERE  menu_id like '39.%'
INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'39.00.00', N'99.00.00', N'CRM', N'Customer', N'', N'', N'', N'', N'', 0, N'', N'', 0, N'', N'', N'', 0, 0, N'', N'', 0, 0.00, 0.00, N'', N'', N'', N'', N'', N'', N'', N'', 0.00, 0.00, N'', N'', N'', N'', N'', N'', NULL, NULL, 0, 0)
INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'39.05.01', N'99.00.00', N'Thông tin khách hàng', N'Customer Information', N'', N'crmCustomerInformation.aspx', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'crmCustomer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT INTO command([menu_id], [menu_id0], [bar], [bar2], [type], [exe], [rep_file], [title], [title2], [web_menu], [web_doc], [icon], [expl_icon], [sysid], [rep_form], [syscode], [hide_yn], [password], [expl_id], [expl_id0], [msys], [xtop], [xleft], [sbar], [sbar2], [vc_active], [mbar], [mbar2], [nbar], [nbar2], [nicon], [ntop], [nleft], [ngroup], [ngroupicon], [npopupicon], [ndesc], [ndesc2], [edition], [datetime2], [datetime0], [user_id0], [user_id2]) VALUES(N'39.05.02', N'99.00.00', N'Danh mục bộ phận theo nhân viên KD', N'Department List', N'', N'crmDepartment.aspx', N'', N'', N'', 0, N'', N'', 0, N'crmDepartment', N'', N'', 0, 0, N'', N'', 0, 0.00, 0.00, N'', N'', N'', N'', N'', N'', N'', N'', 0.00, 0.00, N'', N'', N'', N'', N'', N'', NULL, NULL, 0, 0)
GO

/*
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmquyenkh') AND xType = 'U')
DROP TABLE [dbo].[crmquyenkh]
*/
GO
CREATE TABLE [dbo].[crmquyenkh] (
	[user_id] INT NOT NULL
)

ALTER TABLE dbo.crmquyenkh ADD 
	CONSTRAINT PK_crmquyenkh PRIMARY KEY CLUSTERED
	(
		user_id
	) ON [PRIMARY] 


GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$System$SetCustomerRight') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$System$SetCustomerRight
GO


CREATE PROCEDURE [dbo].[Sthink$CRM$System$SetCustomerRight]
	@UserID INT,
	@Unit VARCHAR(32)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM userinfo2 WHERE id = @UserID AND user_yn = 0) RETURN

	DECLARE @Username VARCHAR(32)
	SELECT @Username = RTRIM(name) FROM userinfo2 WHERE id = @UserID
	
	DELETE crmquyenkh WHERE user_id = @UserID
	IF EXISTS(
		SELECT 1 FROM crmquyennsd a JOIN crmdmquyen b ON a.ma_quyen = b.ma_quyen AND a.ma_dvcs = b.ma_dvcs WHERE a.user_id = @UserID AND a.ma_dvcs = @Unit AND b.loai_quyen = '3'
			UNION ALL SELECT 1 FROM crmquyennsd a JOIN crmdmquyen b ON a.ma_quyen = b.ma_quyen AND a.ma_dvcs = b.ma_dvcs JOIN userinfo2 c ON a.user_id = c.id
				WHERE CHARINDEX(@Username + ',', REPLACE(c.user_lst, ' ', '') + ',') <> 0 AND b.loai_quyen = '3' AND a.ma_dvcs = @Unit
	) INSERT INTO crmquyenkh SELECT @UserID
END







GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$Tab$Loading') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$Tab$Loading
GO




CREATE PROCEDURE [dbo].[Sthink$CRM$Tab$Loading]	
	@UserID INT,
	@Admin BIT,
	@Language CHAR(1)

AS BEGIN
	SET NOCOUNT ON

	IF @Admin = 1 BEGIN
		SELECT id, id0 AS pid, CASE WHEN @Language = 'V' THEN RTRIM(bar) ELSE RTRIM(bar2) END bar, RTRIM(sysid) AS sysid, grid_yn, hidden_grid_yn FROM crmtabinfo ORDER BY id
		RETURN
	END

	SELECT DISTINCT b.id, b.id0 AS pid, CAST('' AS NVARCHAR(128)) bar, RTRIM(b.sysid) AS sysid, b.grid_yn AS grid_yn, b.hidden_grid_yn AS hidden_grid_yn
		INTO #t
		FROM crmaccessrights a JOIN crmtabinfo b ON a.controller = b.sysid
		WHERE a.user_id = @UserID	

	INSERT INTO #t SELECT DISTINCT id, id0 AS pid, '', RTRIM(sysid) AS sysid, grid_yn, hidden_grid_yn
		FROM crmtabinfo WHERE id IN (SELECT DISTINCT pid FROM #t)
	INSERT INTO #t SELECT DISTINCT id, id0 AS pid, '', RTRIM(sysid) AS sysid, grid_yn, hidden_grid_yn
		FROM crmtabinfo WHERE id IN (SELECT pid FROM #t WHERE pid NOT IN (SELECT DISTINCT id FROM #t))

	UPDATE #t SET bar = CASE @Language WHEN 'V' THEN b.bar ELSE b.bar2 END FROM #t a, crmtabinfo b WHERE a.id = b.id
	SELECT * FROM #t ORDER BY id

	SET NOCOUNT OFF
END










GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$System$SetAccessRight') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$System$SetAccessRight
GO




CREATE PROCEDURE [dbo].[Sthink$CRM$System$SetAccessRight]
	@UserID INT,
	@AppDB VARCHAR(32),
	@Type CHAR(1), -- 1: Task, 2: Department, 3: User, 4: All
	@Unit VARCHAR(32)
AS
BEGIN
	IF @Type = '1' EXEC Sthink$CRM$System$SetTabRight @UserID, @Unit
	IF @Type = '2' EXEC Sthink$CRM$System$SetDepartmentRight @UserID, @AppDB, @Unit
	IF @Type = '3' EXEC Sthink$CRM$System$SetCustomerRight @UserID, @Unit

	IF @Type = '4' BEGIN		
		EXEC Sthink$CRM$System$SetTabRight @UserID, @Unit
		EXEC Sthink$CRM$System$SetDepartmentRight @UserID, @AppDB, @Unit
		EXEC Sthink$CRM$System$SetCustomerRight @UserID, @Unit
	END
END








GO



--Insert vao don vi 9999  - danh mục quyền
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'BP01', N'Bộ phận full', N'', N'2', N'1', '20250827 12:24:21', '20250827 12:24:21', 1, 1)
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'BP02', N'Bộ phận PKD1', N'', N'2', N'1', '20250827 12:24:32', '20250827 12:24:32', 1, 1)
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'BP03', N'Bộ phận PKD2', N'', N'2', N'1', '20250827 12:24:39', '20250827 12:24:39', 1, 1)
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'CN01', N'Quyền chức năng full', N'', N'1', N'1', '20250827 12:19:10', '20250829 11:12:59', 1, 1)
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'CN02', N'Quyền chức năng chỉ có mua hàng', N'', N'1', N'1', '20250827 12:19:26', '20250829 11:13:08', 1, 1)
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'CN03', N'Quyền chức năng chỉ có bán hàng', N'', N'1', N'1', '20250827 12:19:41', '20250829 11:13:12', 1, 1)
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'CN04', N'Quyền chức năng chỉ có thu chi', N'', N'1', N'1', '20250827 12:19:49', '20250829 11:13:17', 1, 1)
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'CN05', N'Quyền chức năng có mua, bán', N'', N'1', N'1', '20250827 12:20:07', '20250829 11:13:24', 1, 1)
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'CN06', N'Quyền chức năng có mua, chi', N'', N'1', N'1', '20250827 12:20:22', '20250829 11:13:30', 1, 1)
INSERT INTO crmdmquyen(ma_dvcs, ma_quyen, ten_quyen, ten_quyen2, loai_quyen, status, datetime0, datetime2, user_id0, user_id2) VALUES(N'9999', N'CN07', N'Quyền chức năng có bán, thu', N'', N'1', N'1', '20250827 12:20:31', '20250829 11:13:38', 1, 1)


GO

