--lanhnt hehe
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.svTaptin') AND xType = 'U')
DROP TABLE [dbo].[svTaptin]

GO
CREATE TABLE [dbo].[svTaptin] (
	[stt_rec] CHAR(13) NOT NULL,
	[ma_dvcs] CHAR(8) NOT NULL,
	[ma_file] CHAR(16) NOT NULL,
	[ten_file] NVARCHAR(256) NOT NULL,
	[ngay_file] DATETIME NOT NULL,
	[ma_kh] CHAR(33),
	[ma_vv] CHAR(33),
	[ma_phi] CHAR(33),
	[ma_bp] CHAR(33),
	[ma_nvbh] CHAR(33),
	[ghi_chu] NVARCHAR(256),
	[status] CHAR(1),
	[datetime0] DATETIME,
	[datetime2] DATETIME,
	[user_id] INT,
	[user_id0] INT,
	[user_id2] INT
)

ALTER TABLE dbo.svTaptin ADD 
	CONSTRAINT PK_svTaptin PRIMARY KEY CLUSTERED
	(
		stt_rec
	) ON [PRIMARY] 


GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmbp') AND xType = 'U')
DROP TABLE [dbo].[crmbp]

GO
CREATE TABLE [dbo].[crmbp] (
	[ma_bp] CHAR(16) NOT NULL,
	[bp_me] CHAR(16) NOT NULL,
	[bp_ref] VARCHAR(128) NOT NULL,
	[stt_ref] VARCHAR(512),
	[bac_bp] INT,
	[ten_bp] NVARCHAR(128) NOT NULL,
	[ten_bp2] NVARCHAR(128) NOT NULL,
	[ma_ngam_dinh] CHAR(5),
	[nh_bp1] CHAR(8),
	[nh_bp2] CHAR(8),
	[nh_bp3] CHAR(8),
	[ma_bp0] CHAR(8),
	[ma_dvcs] CHAR(8) NOT NULL,
	[stt] INT,
	[ghi_chu] NVARCHAR(256),
	[status] CHAR(1),
	[datetime0] DATETIME,
	[datetime2] DATETIME,
	[user_id0] INT,
	[user_id2] INT
)

ALTER TABLE dbo.crmbp ADD 
	CONSTRAINT PK_crmbp PRIMARY KEY CLUSTERED
	(
		ma_dvcs, ma_bp
	) ON [PRIMARY] 


GO

CREATE INDEX [bp_me] ON dbo.crmbp([bp_me]) ON [PRIMARY]
GO

CREATE INDEX [bp_ref] ON dbo.crmbp([bp_ref]) ON [PRIMARY]
GO

CREATE INDEX [stt_ref] ON dbo.crmbp([stt_ref]) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vcrmbp') AND xType = 'V')
DROP VIEW dbo.vcrmbp
GO



CREATE VIEW [dbo].[vcrmbp] AS
SELECT *, SPACE(2 * (CASE WHEN bac_bp > 0 THEN bac_bp - 1 ELSE 0 END)) + ten_bp AS ten, 
		SPACE(2 * (CASE WHEN bac_bp > 0 THEN bac_bp - 1 ELSE 0 END)) + ten_bp2 AS ten2
	FROM	dbo.crmbp





GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$AccessRightFilter') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$AccessRightFilter
GO



CREATE PROCEDURE [dbo].[Sthink$CRM$AccessRightFilter]
	@UserID INT,
	@Admin BIT,
	@SysDB VARCHAR(32),
	@Key NVARCHAR(4000) OUTPUT
AS
BEGIN	
	IF @Admin = 1 BEGIN
		SELECT @Key = ''
		RETURN
	END
	
	DECLARE @q NVARCHAR(4000), @UnitKey NVARCHAR(4000), @DeptKey NVARCHAR(4000)
	DECLARE @RefList VARCHAR(8000), @Right BIT, @OwnerRight NVARCHAR(1024)
	SELECT @UnitKey = NULL, @DeptKey = NULL, @q = '', @RefList = '', @OwnerRight = '', @Right = 0
	IF (SELECT COUNT(1) FROM dmdvcs) = (SELECT COUNT(1) FROM sysunitrights WHERE user_id = @UserID AND r_access = 1) SELECT @UnitKey = ''
	ELSE BEGIN
		SELECT @UnitKey = ISNULL(@UnitKey, '') + CASE WHEN @UnitKey IS NULL THEN '''' ELSE ',''' END + RTRIM(ma_dvcs) + ''''
			FROM sysunitrights
			WHERE user_id = @UserID AND r_access = 1
		IF ISNULL(@UnitKey, '') = '' BEGIN
			SELECT @Key = NULL
			GOTO EmployeeRight
		END
		ELSE
			SELECT @UnitKey = '(a.ma_dvcs in (' + @UnitKey + '))'
	END
	SELECT @q = 'select @RefList = r_access2 from ' + @SysDB + '..crmquyenbp where user_id = ' + RTRIM(@UserID)
	EXEC sp_executesql @q, N'@RefList varchar(8000) output', @RefList = @RefList OUTPUT

	SELECT @RefList = REPLACE(ISNULL(@RefList, ''), ' ', '')
	IF LEN(@RefList) > 1024 BEGIN
		SELECT @Key = '(1 = 0)'
		RETURN
	END

	IF @RefList = '' BEGIN
		SELECT @Key = NULL
		GOTO EmployeeRight
	END ELSE BEGIN
		SELECT @q = 'if (select count(1) from crmbp where bp_me = '''') = (select count(1) from crmbp where bp_ref in ('''
		SELECT @q = @q +	REPLACE(@RefList, ',', ''',''') + ''') and bp_me = '''') select @DeptKey = '''''			
		EXEC sp_executesql @q, N'@DeptKey nvarchar(4000) output', @DeptKey = @DeptKey OUTPUT
		IF @UnitKey = '' AND @DeptKey = '' BEGIN
			SELECT @Key = ''
			RETURN
		END ELSE BEGIN
			IF @DeptKey IS NULL SELECT @DeptKey = '(b.bp_ref like ''' + REPLACE(@RefList, ',', '%'' or b.bp_ref LIKE ''') + '%'')'
		END
	END
	SELECT @Key = CASE WHEN @UnitKey = '' THEN @DeptKey ELSE @UnitKey + CASE WHEN @DeptKey = '' THEN '' ELSE ' and ' + '(' + @DeptKey + ')' END END
	
	EmployeeRight:
	SELECT @q = 'if exists(select 1 from ' + @SysDB + '..crmquyenkh where user_id = ' + RTRIM(@UserID) + ') select @Right = 1'		
	EXEC sp_executesql @q, N'@Right bit output', @Right = @Right OUTPUT
	IF @Right = 1 BEGIN	
		IF @Key IS NULL BEGIN
			SELECT @Key = '(user_id = ' + RTRIM(@UserID) + ')'
			RETURN
		END
		SELECT @q = 'if not exists(select 1 from crmquyenkh a where ' + @Key + ' and user_id = ' + RTRIM(@UserID) + ')'
		SELECT @q = @q + 'select @OwnerRight = '' or (user_id = ' + RTRIM(@UserID) + ')'''		
		
		EXEC sp_executesql @q, N'@OwnerRight nvarchar(1024) output', @OwnerRight = @OwnerRight OUTPUT
	END ELSE IF @Key IS NULL BEGIN
		SELECT @Key = '(1 = 0)'
		RETURN
	END
	SELECT @Key = '((' + @Key + ')' + @OwnerRight + ')'	
END










 





GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$CustomerInformation$Loading') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$CustomerInformation$Loading
GO



CREATE PROCEDURE [dbo].[Sthink$CRM$CustomerInformation$Loading]
	@PageCount INT,
	@Unit VARCHAR(1024),
	@UserID INT,
	@Admin BIT,
	@SysDB VARCHAR(32),
	@Language CHAR(1)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @q NVARCHAR(4000), @Key NVARCHAR(4000),@Join NVARCHAR(4000)
	DECLARE @sMale NVARCHAR(64), @sFemale NVARCHAR(64), @f1 VARCHAR(32), @f2 VARCHAR(32), @f3 VARCHAR(32)

	SELECT @f1 = 'ten_bp', @f2 = 'ten_kh', @f3 = 'ten_ttnv'
	IF @Language <> 'V' SELECT @f1 = @f1 + '2', @f2 = @f2 + '2', @f3 = @f3 + '2'

	SELECT @sMale = CASE WHEN @Language = 'v' THEN name ELSE name2 END FROM hrdirinfo WHERE code = '1' AND type = 'Gender'
	SELECT @sFemale = CASE WHEN @Language = 'v' THEN name ELSE name2 END FROM hrdirinfo WHERE code = '2' AND type = 'Gender'
	SELECT @Key = NULL, @Join = ''

	IF @Admin = 1 SELECT @Key = 'a.status = ''1'''
	ELSE EXEC Sthink$CRM$AccessRightFilter @UserID, @Admin, @SysDB, @Key OUTPUT
	PRINT @Key
	SELECT @Key = @Key + CASE @Key WHEN '' THEN '' ELSE ' and ' END + 'a.ma_dvcs = ''' + RTRIM(@Unit) + ''''
	SELECT @Key = @Key + CASE @Key WHEN '' THEN '' ELSE ' and ' END + 'a.status = ''1'' and isnull(a.ma_nvbh, '''') <> '''''	
	IF ISNULL(@Key, '') <> '' AND LEN(@Key) > 3000 SET @Key = '(1 = 0)'

	SELECT @q = 'SELECT TOP ' + RTRIM(@PageCount) + N' rtrim(a.ma_kh) ma_kh, ' + @f2 + ', a.dia_chi, a.ma_so_thue, a.ten_tt_mst, a.e_mail, a.dien_thoai, a.ma_tt_mst, a.ma_dvcs'
	--SELECT @q = @q + 'ngay_sinh, ' + @f1 + ', ' + @f2 + ', ngay_vao, ' + @f3
	SELECT @q = @q + ' FROM dmkh a WITH (nolock) LEFT JOIN crmbp b ON a.ma_dvcs = b.ma_dvcs and a.ma_nvbh = b.nh_bp3 LEFT JOIN crmquyenkh c ON a.ma_dvcs = c.ma_dvcs and a.ma_kh = c.ma_kh' --LEFT JOIN dmnhkh b ON a.nh_kh1 = b.ma_bp 
	SELECT @q = @q + CASE WHEN @Key <> '' THEN ' WHERE ' + @Key ELSE '' END	+ ' ORDER BY a.ma_kh'
	PRINT @q
	EXEC sp_executesql @q

	SET NOCOUNT OFF
END



















 





GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmnhatky') AND xType = 'U')
DROP TABLE [dbo].[crmnhatky]

GO
CREATE TABLE [dbo].[crmnhatky] (
	[ma_dvcs] CHAR(8) NOT NULL,
	[stt_rec0] CHAR(3) NOT NULL,
	[ma_kh] CHAR(16) NOT NULL,
	[ma_vv] CHAR(24),
	[ngay_bd] DATETIME,
	[ngay_kt] DATETIME,
	[ngay_hen] DATETIME,
	[tieu_de] NVARCHAR(128),
	[noi_dung] NVARCHAR(4000),
	[ma_gdtn] CHAR(10),
	[ma_gdhd] CHAR(10),
	[ma_lienhe] INT,
	[chu_y] NVARCHAR(512),
	[muc_do] CHAR(16),
	[status] CHAR(1),
	[line_nbr] NUMERIC(5, 0) NOT NULL,
	[datetime0] DATETIME,
	[datetime2] DATETIME,
	[user_id0] INT,
	[user_id2] INT
)

ALTER TABLE dbo.crmnhatky ADD 
	CONSTRAINT PK_crmnhatky PRIMARY KEY CLUSTERED
	(
		ma_dvcs, ma_kh, stt_rec0
	) ON [PRIMARY] 


GO

CREATE INDEX [ma_kh] ON dbo.crmnhatky([ma_kh]) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmgdtn') AND xType = 'U')
DROP TABLE [dbo].[crmgdtn]

GO
CREATE TABLE [dbo].[crmgdtn] (
	[ma_dvcs] CHAR(8) NOT NULL,
	[ma_gdtn] CHAR(10) NOT NULL,
	[ten_gdtn] NVARCHAR(128) NOT NULL,
	[ten_gdtn2] NVARCHAR(128) NOT NULL,
	[ghi_chu] NCHAR(256),
	[ti_le] NUMERIC(16, 4),
	[status] CHAR(1),
	[datetime0] DATETIME,
	[datetime2] DATETIME,
	[user_id0] INT,
	[user_id2] INT,
	[ma_td1] CHAR(16),
	[ma_td2] CHAR(16),
	[ma_td3] CHAR(16),
	[sl_td1] NUMERIC(16, 4),
	[sl_td2] NUMERIC(16, 4),
	[sl_td3] NUMERIC(16, 4),
	[ngay_td1] SMALLDATETIME,
	[ngay_td2] SMALLDATETIME,
	[ngay_td3] SMALLDATETIME,
	[gc_td1] NVARCHAR(512),
	[gc_td2] NCHAR(64),
	[gc_td3] NCHAR(64),
	[s1] CHAR(16),
	[s2] CHAR(16),
	[s3] CHAR(16),
	[s4] NUMERIC(16, 4),
	[s5] NUMERIC(16, 4),
	[s6] NUMERIC(16, 4),
	[s7] SMALLDATETIME,
	[s8] SMALLDATETIME,
	[s9] SMALLDATETIME
)

ALTER TABLE dbo.crmgdtn ADD 
	CONSTRAINT PK_crmgdtn PRIMARY KEY CLUSTERED
	(
		ma_dvcs, ma_gdtn
	) ON [PRIMARY] 


GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vcrmnhatky') AND xType = 'V')
DROP VIEW dbo.vcrmnhatky
GO










IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$GetRowID') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$GetRowID
GO



CREATE PROCEDURE [dbo].[Sthink$CRM$GetRowID] @RowID VARCHAR(3) OUTPUT, @RowNumber INT OUTPUT
AS
BEGIN
	SELECT @RowNumber = @RowNumber + 1, @RowID = dbo.ff_IncreaseSeq(@RowID)
	IF LEN(@RowNumber) > 3 RETURN ''
	SELECT @RowID = REPLICATE('0', 3 - LEN(@RowID)) + @RowID

END







GO


DELETE dmct9 WHERE  ma_ct = 'SQ1'
INSERT INTO dmct9([ma_ct], [c$], [m$], [d$], [i$], [url]) VALUES(N'SQ1', N'c61$', N'm61$', N'd61$', N'i61$', N'soctsq1.aspx?query=%s')
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmrs_rptDCCustomer') AND xType = 'P')
DROP PROCEDURE dbo.crmrs_rptDCCustomer
GO




CREATE PROCEDURE [dbo].[crmrs_rptDCCustomer] --fs_DCCustomer--
	@DateFrom AS SMALLDATETIME, 
	@DateTo AS SMALLDATETIME, 
	@Unit VARCHAR(1023), 
	@Account VARCHAR(33), 
	@Customer VARCHAR(33), 
	@Language CHAR(1),
	@isBalance BIT, -- 1 - Tinh so du, 0 - Khong tinh so du
	@isDetail BIT, -- 1 - Co chi tiet, 0 - Khong chi tiet
	@Type TINYINT, -- 1 - Phai thu, 2 - Phai tra
	@UserID INT,
	@Admin BIT,
	@ListView  VARCHAR(1023)
AS
BEGIN
	SET NOCOUNT ON
	SET ANSI_NULLS OFF

	-- Declare
	DECLARE @s1 NVARCHAR(511), @s2 NVARCHAR(511), @s3 NVARCHAR(511)
	DECLARE @nDu_dk NUMERIC(16, 2), @nDu_dk_nt NUMERIC(16, 2), @nDu NUMERIC(16, 2), @nDu_nt NUMERIC(16, 2)
	DECLARE @nPs_no NUMERIC(16, 2), @nPs_no_nt NUMERIC(16, 2), @nPs_co NUMERIC(16, 2), @nPs_co_nt NUMERIC(16, 2)
	DECLARE @nDu_ck NUMERIC(16, 2), @nDu_ck_nt NUMERIC(16, 2)
	DECLARE @Key NVARCHAR(4000), @AccountKey NVARCHAR(4000), @q NVARCHAR(4000)

	-- Struct
	SELECT TOP 0 5 AS sysorder, 1 AS sysprint, 1 AS systotal
		, a.stt_rec, a.ma_ct, a.ngay_ct, a.so_ct, a.ma_kh, a.tk_du
		, a.ps_no, a.ps_co, a.ps_no_nt, a.ps_co_nt, a.ma_nt, a.ty_gia
		, a.ma_vv, a.dien_giai, a.line_nbr
		, a.ps_no AS du_no, a.ps_co AS du_co, a.ps_no_nt AS du_no_nt, a.ps_co_nt AS du_co_nt
		, b.sl_nhap AS so_luong, b.gia2 AS gia, b.gia_nt2 AS gia_nt, b.tien2 AS tien, b.tien_nt2 AS tien_nt, b.ck AS ck, b.ck_nt AS ck_nt, b.tien2 AS thanhtoan, b.tien_nt2 AS thanhtoan_nt, a.ma_dvcs, a.ty_gia as ty_gia_ck
	INTO #report
	FROM wrkgl a, r70$000000 b

	-- Key
	SET @Key = 'status = ' + CHAR(39) + '1' + CHAR(39)
	IF @Customer <> '' SET @Key = @Key + ' and ma_kh like ''' + @Customer + '%'''
	SET @AccountKey = dbo.FastBusiness$Function$System$GetAccountFilter('tk', 'like', @Account)
	IF @AccountKey IS NOT NULL SET @Key = @Key + ' and ' + @AccountKey
	--
	SET @Key = dbo.FastBusiness$Function$System$GetCheckKey(@Key)
	--
	SET @q = 'insert into #report select 5, 1, 1, stt_rec, ma_ct, ngay_ct, so_ct, ma_kh, tk_du'
	SET @q = @q + ', ps_no, ps_co, ps_no_nt, ps_co_nt, ma_nt, ty_gia, ma_vv, dien_giai, line_nbr, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ma_dvcs, ty_gia as ty_gia_ck'
	SET @q = @q + ' from r00$%Partition with(nolock, index(tk_ma_kh)) where %[' + @Key + ']%'
	EXEC FastBusiness$Partition$Execute @q, @Unit, 'ngay_ct', @DateFrom, @DateTo, @UserID, @Admin

	-- Balance
	SELECT TOP 0 du_no00 AS du, du_no_nt00 AS du_nt INTO #Balance FROM cdkh
	INSERT INTO #Balance EXEC dbo.FastBusiness$Balance$Customer @DateFrom, @Unit, @Account, @Customer, 1, 1, @UserID, @Admin, 'join dmtk b on a.tk = b.tk', 'b.tk_cn = ''1'''
	SELECT @nDu_dk = du, @nDu_dk_nt = du_nt FROM #Balance
	IF @nDu_dk IS NULL SET @nDu_dk = 0
	IF @nDu_dk_nt IS NULL SET @nDu_dk_nt = 0
	SELECT @nDu = @nDu_dk, @nDu_nt = @nDu_dk_nt	

	SELECT @nPs_no = SUM(ps_no), @nPs_no_nt = SUM(ps_no_nt), @nPs_co = SUM(ps_co), @nPs_co_nt = SUM(ps_co_nt)
		FROM #report WHERE systotal = 1

	IF @nPs_no IS NULL SET @nPs_no = 0
	IF @nPs_co IS NULL SET @nPs_co = 0
	IF @nPs_no_nt IS NULL SET @nPs_no_nt = 0
	IF @nPs_co_nt IS NULL SET @nPs_co_nt = 0

	SET @nDu_ck = @nDu_dk + @nPs_no - @nPs_co
	SET @nDu_ck_nt = @nDu_dk_nt + @nPs_no_nt - @nPs_co_nt

	DECLARE @ty_gia_dk NUMERIC(24, 12), @ty_gia_ck NUMERIC(24, 12)
	IF @nDu_dk_nt <> 0 SET @ty_gia_dk = @nDu_dk/@nDu_dk_nt
	IF @nDu_ck_nt <> 0 SET @ty_gia_ck = @nDu_ck/@nDu_ck_nt

	SELECT @s1 = CASE WHEN @Language = 'V' THEN cname ELSE cname2 END FROM reports WHERE UPPER(ccode) = 'OPBAL'
	SELECT @s2 = CASE WHEN @Language = 'V' THEN cname ELSE cname2 END FROM reports WHERE UPPER(ccode) = 'PRAMOUNT'
	SELECT @s3 = CASE WHEN @Language = 'V' THEN cname ELSE cname2 END FROM reports WHERE UPPER(ccode) = 'CLBAL'

	SET @q = dbo.ff_GetAlterFieldsNull('#report', 'ngay_ct', 'SMALLDATETIME')
	EXEC sp_executesql @q

	INSERT INTO #report (sysorder, sysprint, systotal, dien_giai, ps_no, ps_no_nt, ps_co, ps_co_nt, ty_gia) 
		VALUES (0, 0, 0, @s1, 
			CASE WHEN @nDu_dk >= 0 THEN @nDu_dk ELSE 0 END, 
			CASE WHEN @nDu_dk_nt >= 0 THEN @nDu_dk_nt ELSE 0 END, 
			CASE WHEN @nDu_dk < 0 THEN -@nDu_dk ELSE 0 END, 
			CASE WHEN @nDu_dk_nt < 0 THEN -@nDu_dk_nt ELSE 0 END,
			@ty_gia_dk)

	INSERT INTO #report (sysorder, sysprint, systotal, dien_giai, ps_no, ps_no_nt, ps_co, ps_co_nt) 
		VALUES (1, 0, 0, @s2, @nPs_no, @nPs_no_nt, @nPs_co, @nPs_co_nt)

	INSERT INTO #report (sysorder, sysprint, systotal, dien_giai, ps_no, ps_no_nt, ps_co, ps_co_nt, ty_gia) 
		VALUES (2, 0, 0, @s3, 
			CASE WHEN @nDu_ck >= 0 THEN @nDu_ck ELSE 0 END, 
			CASE WHEN @nDu_ck_nt >= 0 THEN @nDu_ck_nt ELSE 0 END, 
			CASE WHEN @nDu_ck < 0 THEN -@nDu_ck ELSE 0 END, 
			CASE WHEN @nDu_ck_nt < 0 THEN -@nDu_ck_nt ELSE 0 END,
			@ty_gia_ck)

	INSERT INTO #report (sysorder, sysprint, systotal) VALUES (3, 0, 0)

	IF @isBalance = 1 BEGIN
		DECLARE crOrder CURSOR FOR SELECT a.stt_rec, a.line_nbr FROM #report a LEFT JOIN dmct b WITH(NOLOCK) ON a.ma_ct = b.ma_ct WHERE a.systotal= 1 ORDER BY a.ngay_ct, b.stt_ct_nkc, a.so_ct, a.stt_rec, a.sysorder, a.line_nbr
		DECLARE @Stt_rec CHAR(13), @Line_nbr INT
		OPEN crOrder
		FETCH NEXT FROM crOrder INTO @Stt_rec, @Line_nbr
			WHILE @@FETCH_STATUS = 0
				BEGIN
					UPDATE #report SET du_no = @nDu + ps_no - ps_co, du_no_nt = @nDu_nt + ps_no_nt - ps_co_nt, du_co = 0, du_co_nt = 0 
						WHERE stt_rec = @Stt_rec AND line_nbr = @Line_nbr
					SELECT @nDu = du_no, @nDu_nt = du_no_nt FROM #report WHERE stt_rec = @Stt_rec AND line_nbr = @Line_nbr
					FETCH NEXT FROM crOrder INTO @Stt_rec, @Line_nbr
				END
		CLOSE crOrder
		DEALLOCATE crOrder
		UPDATE #report SET ty_gia_ck = CASE WHEN du_no<>0 AND du_no_nt<>0 THEN du_no/du_no_nt WHEN du_co<>0 AND du_co_nt<>0 THEN du_co/du_co_nt ELSE NULL END
		UPDATE #report SET du_co = - du_no, du_no = 0 WHERE du_no < 0
		UPDATE #report SET du_co_nt = - du_no_nt, du_no_nt = 0 WHERE du_no_nt < 0
		
	END

	IF @isDetail = 1 BEGIN
		-- Struct
		SELECT stt_rec, ma_ct, ngay_ct, so_ct, ma_nt
				, sl_nhap AS so_luong, tien_nt2 AS tien_nt, tien2 AS tien, gia_nt2 AS gia_nt, gia2 AS gia, ck AS ck, ck_nt AS ck_nt, tien2 AS thanhtoan, tien_nt2 AS thanhtoan_nt
				, CAST('' AS NVARCHAR(511)) AS dien_giai, ma_dvcs, gc_td1, ma_vt
		INTO #Detail
		FROM r70$000000

		SET @q = N'insert into #Detail select stt_rec, ma_ct, ngay_ct, so_ct, a.ma_nt, sl_nhap + sl_xuat as so_luong'
		SET @q = @q + CASE WHEN @Type = 1 THEN N', a.tien_nt2' ELSE N', a.tien_nt0 ' END + ' as tien_nt'
		SET @q = @q + CASE WHEN @Type = 1 THEN N', a.tien2 ' ELSE N', a.tien0 ' END + ' as tien'
		SET @q = @q + CASE WHEN @Type = 1 THEN N', a.gia_nt2 ' ELSE N', a.gia_nt1 ' END + ' as gia_nt'
		SET @q = @q + CASE WHEN @Type = 1 THEN N', a.gia2 ' ELSE N', a.gia1 ' END + ' as gia'
		SET @q = @q + N', isnull(a.ck, 0), isnull(a.ck_nt,0), 0, 0'
		SET @q = @q + N', rtrim(a.ma_vt) + '' - '' + b.ten_vt' + CASE WHEN @Language = 'V' THEN '' ELSE '2' END + ', a.ma_dvcs as ma_dvcs, case when a.gc_td1 = '''' then b.ten_vt else a.gc_td1 end as gc_td1, a.ma_vt as ma_vt'
		SET @q = @q + N' from r70$%Partition a with(nolock) join dmvt b on (a.ma_vt + a.ma_dvcs) = (b.ma_vt + b.ma_dvcs) where %[a.stt_rec in (select stt_rec from #report)]%'
		EXEC FastBusiness$Partition$Execute @q, NULL, NULL, @DateFrom, @DateTo, @UserID, @Admin
		
		UPDATE #Detail SET dien_giai = RTRIM(ma_vt) + ' - ' + gc_td1 WHERE ma_vt IN (SELECT ma_vt FROM dmvt WHERE sua_ten_vt='1')
		UPDATE #Detail SET tien_nt = 0, gia_nt = 0 WHERE ma_nt = ''
		UPDATE #Detail SET thanhtoan = tien - ck, thanhtoan_nt = tien_nt - ck_nt	
		
		ALTER TABLE #report ALTER COLUMN dien_giai NVARCHAR(511)

		INSERT INTO #report
			SELECT 6 AS sysorder, 1 AS sysprint, 0 AS systotal
				, stt_rec AS stt_rec, ma_ct AS ma_ct, ngay_ct AS ngay_ct, so_ct AS so_ct, '' AS ma_kh, '' AS tk_du
				, 0, 0, 0, 0
				, '' AS ma_nt, 0 AS ty_gia, '' AS ma_vv, dien_giai AS dien_giai, 0 AS line_nbr
				, 0 AS du_no, 0 AS du_co, 0 AS du_no_nt, 0 AS du_co_nt
				, so_luong AS so_luong, gia AS gia, gia_nt AS gia_nt, tien AS tien, tien_nt AS tien_nt, ck, ck_nt, thanhtoan, thanhtoan_nt, ma_dvcs AS ma_dvcs, @ty_gia_ck as ty_gia_ck
			FROM #Detail
	END

	SELECT sysorder, sysprint, systotal
			, a.stt_rec, a.ngay_ct, a.so_ct, a.ma_kh, a.tk_du
			, a.ps_no, a.ps_co, a.ps_no_nt, a.ps_co_nt, a.ma_nt, a.ty_gia
			, a.ma_vv, a.dien_giai, a.line_nbr
			, du_no, du_co, du_no_nt, du_co_nt
			, so_luong, gia, gia_nt, tien, tien_nt, ck, ck_nt, thanhtoan, thanhtoan_nt
			, b.ten_kh, b.ten_kh2, c.ten_tk AS ten_tk_du, c.ten_tk2 AS ten_tk_du2, d.ma_ct_in AS ma_ct0, d.ma_ct AS ma_ct, d.stt_ct_nkc, a.ty_gia_ck
		INTO #tmp FROM #report a	
			LEFT JOIN dmkh b ON (a.ma_kh + a.ma_dvcs) = (b.ma_kh + b.ma_dvcs) 
			LEFT JOIN dmtk c ON a.tk_du = c.tk 
			LEFT JOIN dmct d ON a.ma_ct = d.ma_ct
		ORDER BY a.ngay_ct, d.stt_ct_nkc, a.so_ct, a.stt_rec, a.sysorder, a.line_nbr
	SET @q = N'select ' + @ListView + ' from #tmp ORDER BY ngay_ct, stt_ct_nkc, so_ct, stt_rec, sysorder, line_nbr'
	EXEC sp_executesql @q

	SET ANSI_NULLS ON
	SET NOCOUNT OFF
END









GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmlienhe') AND xType = 'U')
DROP TABLE [dbo].[crmlienhe]

GO
CREATE TABLE [dbo].[crmlienhe] (
	[ma_dvcs] CHAR(8) NOT NULL,
	[stt_rec0] CHAR(3) NOT NULL,
	[ma_kh] CHAR(20) NOT NULL,
	[ten_lienhe] NVARCHAR(128),
	[ten_lienhe2] NVARCHAR(128),
	[chuc_vu] NVARCHAR(128),
	[dien_thoai] NVARCHAR(128),
	[fax] NVARCHAR(128),
	[e_mail] NCHAR(256),
	[ghi_chu] NVARCHAR(512),
	[status] CHAR(1),
	[line_nbr] NUMERIC(5, 0) NOT NULL,
	[datetime0] DATETIME,
	[datetime2] DATETIME,
	[user_id0] INT,
	[user_id2] INT,
	[ma_td1] CHAR(16),
	[ma_td2] CHAR(16),
	[ma_td3] CHAR(16),
	[sl_td1] NUMERIC(16, 4),
	[sl_td2] NUMERIC(16, 4),
	[sl_td3] NUMERIC(16, 4),
	[ngay_td1] SMALLDATETIME,
	[ngay_td2] SMALLDATETIME,
	[ngay_td3] SMALLDATETIME,
	[gc_td1] NVARCHAR(512),
	[gc_td2] NCHAR(64),
	[gc_td3] NCHAR(64),
	[s1] CHAR(16),
	[s2] CHAR(16),
	[s3] CHAR(16),
	[s4] NUMERIC(16, 4),
	[s5] NUMERIC(16, 4),
	[s6] NUMERIC(16, 4),
	[s7] SMALLDATETIME,
	[s8] SMALLDATETIME,
	[s9] SMALLDATETIME
)

ALTER TABLE dbo.crmlienhe ADD 
	CONSTRAINT PK_crmlienhe PRIMARY KEY CLUSTERED
	(
		ma_dvcs, ma_kh, stt_rec0
	) ON [PRIMARY] 


GO




CREATE VIEW [dbo].[vcrmnhatky]
AS
SELECT	a.*, a.ma_dvcs + a.ma_kh AS stt_rec, b.ten_kh, b.ten_kh2, c.ten_gdtn, c.ten_gdtn2, d.ten_lienhe, d.ten_lienhe2
	, CASE a.muc_do WHEN '1' THEN N'1. Thấp' WHEN '2' THEN '2. Bình thường' WHEN '3' THEN '3. Cao' WHEN '4' THEN '4. Khẩn cấp' WHEN '5' THEN '5. Rất Khẩn cấp' END AS ten_muc_do
	, CASE a.muc_do WHEN '1' THEN N'1. Low' WHEN '2' THEN '2. Normal' WHEN '3' THEN '3. High' WHEN '4' THEN '4. Emergency' WHEN '5' THEN '4. Very Emergency' END AS ten_muc_do2
	FROM crmnhatky AS a LEFT JOIN zcdmkh AS b ON a.ma_kh = b.ma_kh AND a.ma_dvcs = b.ma_dvcs
	 LEFT JOIN crmgdtn c ON a.ma_gdtn = c.ma_gdtn AND a.ma_dvcs = c.ma_dvcs
	 LEFT JOIN crmlienhe d ON a.ma_lienhe = d.stt_rec0 AND a.ma_kh = d.ma_kh AND a.ma_dvcs = d.ma_dvcs
	 
	 

















GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.crmquyenkh') AND xType = 'U')
DROP TABLE [dbo].[crmquyenkh]

GO
CREATE TABLE [dbo].[crmquyenkh] (
	[ma_dvcs] CHAR(8) NOT NULL,
	[ma_kh] CHAR(16) NOT NULL,
	[user_id] INT
)

ALTER TABLE dbo.crmquyenkh ADD 
	CONSTRAINT PK_crmquyenkh PRIMARY KEY CLUSTERED
	(
		ma_dvcs, ma_kh
	) ON [PRIMARY] 


GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vcrmquyenkh') AND xType = 'V')
DROP VIEW dbo.vcrmquyenkh
GO




CREATE VIEW [dbo].[vcrmquyenkh]
AS
SELECT a.ma_dvcs, a.ma_kh, a.ten_kh, a.ten_kh2, isnull(d.ma_bp, '') as bo_phan, isnull(c.name, '') AS name2
	FROM zcdmkh AS a 
	LEFT JOIN crmquyenkh b ON a.ma_dvcs = b.ma_dvcs AND a.ma_kh = b.ma_kh 
	LEFT JOIN vsysuserinfo c ON b.user_id = c.id
	LEFT JOIN crmbp d on a.ma_nvbh = d.nh_bp3 and a.ma_dvcs = d.ma_dvcs and isnull(d.nh_bp3, '') <> ''









GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vcrmlienhe') AND xType = 'V')
DROP VIEW dbo.vcrmlienhe
GO



CREATE VIEW [dbo].[vcrmlienhe]
AS
SELECT	a.*, a.ma_dvcs + a.ma_kh AS stt_rec, b.ten_kh, b.ten_kh2
	FROM crmlienhe AS a LEFT JOIN zcdmkh AS b ON a.ma_kh = b.ma_kh AND a.ma_dvcs = b.ma_dvcs
	 
	 
	 

















GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sthink$CRM$CustomerInformation$Finding') AND xType = 'P')
DROP PROCEDURE dbo.Sthink$CRM$CustomerInformation$Finding
GO


CREATE PROCEDURE [dbo].[Sthink$CRM$CustomerInformation$Finding]
	@Prime VARCHAR(32),
	@Refresh BIT,
	@PageIndex INT,
	@PageCount INT, 
	@LastPage INT,
	@LastCount INT, 
	@FirstItem VARCHAR(128),
	@LastItem VARCHAR(128),
	@Key NVARCHAR(4000),
	@Join VARCHAR(4000),
	@PrimaryFields VARCHAR(512),
	@ExternalFields NVARCHAR(4000),
	@OrderByClause VARCHAR(128),
	@Unit VARCHAR(1024),
	@SysDB VARCHAR(32),
	@Admin BIT,
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON

	-- Declare
	DECLARE @strSQL NVARCHAR(4000), @PageKey NVARCHAR(4000), @RightKey NVARCHAR(4000), @q NVARCHAR(4000)
	DECLARE @t INT, @d INT, @v INT, @ItemCount INT, @o VARCHAR(32), @b BIT, @Right BIT

	SELECT @ItemCount = 0, @o = '', @PageIndex = CASE WHEN @PageIndex < 0 THEN 0 ELSE @PageIndex END

	-- Struct
	CREATE TABLE #n(n INT)
	CREATE TABLE #r(c$ VARCHAR(128))

	--Key
	IF @Admin = 0 EXEC Sthink$CRM$AccessRightFilter @UserID, @Admin, @SysDB, @RightKey OUTPUT

	IF ISNULL(@RightKey, '') <> '' AND LEN(@RightKey) > 3000 SET @RightKey = '(1 = 0)'
	SELECT @Key = CASE @Key WHEN '' THEN '' ELSE '(' + @Key + ')' END + CASE WHEN ISNULL(@RightKey, '') = '' THEN '' ELSE CASE	@Key WHEN '' THEN '' ELSE ' AND ' END + '(' + @RightKey + ')' END
	SELECT @Key = @Key + CASE @Key WHEN '' THEN '' ELSE ' and ' END + 'a.ma_dvcs = ''' + RTRIM(@Unit) + ''''
	-- Count
	IF @Refresh = 1 BEGIN
		SELECT @strSQL = 'insert into #n select count(1) from ' + @Prime + ' a with (nolock) ' + @Join + CASE WHEN @Key = '' THEN '' ELSE ' where ' + @Key END
		EXEC(@strSQL)

		SELECT @ItemCount = SUM(n) FROM #n
		SELECT @ItemCount = ISNULL(@ItemCount, 0)
		IF @ItemCount = 0 GOTO QueryEmpty
		IF @PageCount > @ItemCount SELECT @PageCount = @ItemCount
	END
		ELSE IF @PageCount > @LastCount SELECT @PageCount = @LastCount

	--	PageKey
	SELECT @PageKey = '', @d = 0, @v = 0
	IF @PageIndex > 0 AND @LastItem <> '' BEGIN
		IF @PageIndex = @LastPage SELECT @PageKey = @PrimaryFields + ' >= ''' + REPLACE(@FirstItem, '''', '''''') + ''''
		ELSE BEGIN
			IF @PageIndex > @LastPage SELECT @d = (@PageIndex - @LastPage -1) * @PageCount, @PageKey = @PrimaryFields + ' > ''' + REPLACE(@LastItem, '''', '''''') + ''''
				ELSE SELECT @d = (@LastPage - @PageIndex -1) * @PageCount, @PageKey = @PrimaryFields + ' < ''' + @FirstItem + '''', @o = ' desc'
		END
	END

	IF @PageIndex > 0 AND ((@PageIndex + 1) * @PageCount >= @LastCount) SELECT @v = (@PageIndex + 1) * @PageCount - @LastCount

	-- Primary
	SELECT @b = 1, @t = COUNT(*) FROM #r
	IF @Refresh = 1 BEGIN
		IF NOT EXISTS(SELECT * FROM #n WHERE n > 0) SELECT @b = 0
	END
	IF @b = 1 BEGIN
		SELECT @strSQL = 'insert into #r select top ' + LTRIM(STR(@PageCount - @v + @d - @t)) + ' ' + @PrimaryFields + ' as c$'
		SELECT @strSQL = @strSQL + ' from ' + @Prime + ' a with (nolock)' + @Join + CASE
			WHEN @Key = '' THEN CASE WHEN @PageKey = '' THEN '' ELSE ' where ' + @PageKey END
			ELSE ' where ' + @Key + CASE WHEN @PageKey = '' THEN '' ELSE ' and (' + @PageKey + ')' END
		END + ' order by c$' + @o
		EXEC(@strSQL)
	END

	IF @d > 0 BEGIN
		IF @PageIndex > @LastPage SELECT @strSQL = 'delete #r where c$ in (select top ' + LTRIM(STR(@d)) + ' c$ from #r order by c$)'
			ELSE SELECT @strSQL = 'delete #r where c$ not in (select top ' + LTRIM(STR(@PageCount)) + ' c$ from #r order by c$)'
		EXEC(@strSQL)
	END

	-- Data
	IF EXISTS(SELECT * FROM #r) BEGIN		
		SELECT @strSQL = 'select ' + RTRIM(@ItemCount)
		SELECT @strSQL = @strSQL + CHAR(13) + 'select ' + @ExternalFields + ' from ' + @Prime + ' a with (nolock) ' + @Join + ' where ' + @PrimaryFields + ' in (select c$ from #r) order by ' + @OrderByClause
		EXEC(@strSQL)

	END ELSE GOTO QueryEmpty
	GOTO Result;

	QueryEmpty:
		SELECT * FROM #r

	Result:

	SET NOCOUNT OFF
	RETURN
END






GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Sivip$Files$Finding') AND xType = 'P')
DROP PROCEDURE dbo.Sivip$Files$Finding
GO



CREATE PROCEDURE [dbo].[Sivip$Files$Finding]
	@Datefrom DATETIME,
	@Dateto DATETIME,
	@Prime VARCHAR(32),
	@Refresh BIT,
	@PageIndex INT,
	@PageCount INT, 
	@LastPage INT,
	@LastCount INT, 
	@FirstItem VARCHAR(128),
	@LastItem VARCHAR(128),
	@Key NVARCHAR(4000),
	@Join VARCHAR(4000),
	@PrimaryFields VARCHAR(512),
	@ExternalFields NVARCHAR(4000),
	@OrderByClause VARCHAR(128),
	@SysDB VARCHAR(32),
	@Admin BIT,
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON

	-- Declare
	DECLARE @strSQL NVARCHAR(4000), @PageKey NVARCHAR(4000), @RightKey NVARCHAR(4000), @q NVARCHAR(4000)
	DECLARE @t INT, @d INT, @v INT, @ItemCount INT, @o VARCHAR(32), @b BIT, @Right BIT

	SELECT @ItemCount = 0, @o = '', @PageIndex = CASE WHEN @PageIndex < 0 THEN 0 ELSE @PageIndex END

	-- Struct
	CREATE TABLE #n(n INT)
	CREATE TABLE #r(c$ VARCHAR(128))

	--Key
	--IF @Admin = 0 EXEC FastBusiness$HRM$AccessRightFilter @UserID, @Admin, @SysDB, @RightKey OUTPUT

	--IF ISNULL(@RightKey, '') <> '' AND LEN(@RightKey) > 3000 SET @RightKey = '(1 = 0)'
	--SELECT @Key = CASE @Key WHEN '' THEN '' ELSE '(' + @Key + ')' END + CASE WHEN ISNULL(@RightKey, '') = '' THEN '' ELSE CASE	@Key WHEN '' THEN '' ELSE ' AND ' END + '(' + @RightKey + ')' END
	-- Count
	IF @Refresh = 1 BEGIN
		SELECT @strSQL = 'insert into #n select count(1) from ' + @Prime + ' a with (nolock) ' + @Join + CASE WHEN @Key = '' THEN '' ELSE ' where ' + @Key + ' and a.ngay_file BETWEEN @startDate AND @endDate ' END
		EXEC sp_executesql @strSQL,N'@startDate DATE, @EndDate DATE',@Datefrom, @Dateto

		SELECT @ItemCount = SUM(n) FROM #n
		SELECT @ItemCount = ISNULL(@ItemCount, 0)
		IF @ItemCount = 0 GOTO QueryEmpty
		IF @PageCount > @ItemCount SELECT @PageCount = @ItemCount
	END
		ELSE IF @PageCount > @LastCount SELECT @PageCount = @LastCount

	----ban sap xep theo ngay thang
	CREATE TABLE #chuong(id INT, zcma VARCHAR(128))
	SELECT @strSQL = 'insert into #chuong select ROW_NUMBER() OVER (ORDER BY a.ngay_file desc) AS rn, a.stt_rec AS zcma from ' + @Prime + ' a with (nolock) ' + @Join + CASE WHEN @Key = '' THEN '' ELSE ' where ' + @Key + ' and a.ngay_file BETWEEN @startDate AND @endDate ' END + 'order by a.ngay_file desc'
	EXEC sp_executesql @strSQL,N'@startDate DATE, @EndDate DATE',@Datefrom, @Dateto
	
	--	PageKey
	DECLARE @FirstId CHAR(10), @LastId CHAR(10), @soht INT
	SELECT @FirstId = id FROM #chuong WHERE zcma = @FirstItem
	SELECT @LastId = id FROM #chuong WHERE zcma = @LastItem
	SELECT @soht = @PageCount * @PageIndex
	SELECT @PageKey = '', @d = 0, @v = 0
	--IF @PageIndex > 0 AND @LastItem <> '' BEGIN
	--	IF @PageIndex = @LastPage SELECT @PageKey = ' id >= ''' + REPLACE(@FirstId, '''', '''''') + ''''
	--	ELSE BEGIN
	--		IF @PageIndex > @LastPage SELECT @d = (@PageIndex - @LastPage -1) * @PageCount, @PageKey = ' id > ''' + REPLACE(@LastId, '''', '''''') + ''''
	--			ELSE SELECT @d = (@LastPage - @PageIndex -1) * @PageCount, @PageKey = ' id < ''' + @FirstId + '''', @o = ' desc'
	--	END
	--END

	--IF @PageIndex > 0 AND ((@PageIndex + 1) * @PageCount >= @LastCount) SELECT @v = (@PageIndex + 1) * @PageCount - @LastCount
	IF @PageIndex > 0 AND @LastItem <> '' BEGIN
		IF @PageIndex = @LastPage SELECT @PageKey = ' id >= ''' + REPLACE(@FirstId, '''', '''''') + ''''
		ELSE BEGIN
			SELECT @PageKey = ' id > ''' + LTRIM(STR(@soht)) + '''', @o = ' desc'
		END
	END

	IF @PageIndex > 0 AND ((@PageIndex + 1) * @PageCount >= @LastCount) SELECT @v = (@PageIndex + 1) * @PageCount - @LastCount


	-- Primary
	SELECT @b = 1, @t = COUNT(*) FROM #r
	IF @Refresh = 1 BEGIN
		IF NOT EXISTS(SELECT * FROM #n WHERE n > 0) SELECT @b = 0
	END
	IF @b = 1 BEGIN
		SELECT @strSQL = 'insert into #r select top ' + LTRIM(STR(@PageCount)) + ' ' + @PrimaryFields + ' as c$'
		SELECT @strSQL = @strSQL + ' from (select * from #chuong LEFT JOIN ' + @Prime + ' on #chuong.zcma = ' + @Prime + '.stt_rec ) a ' + @Join + CASE
			WHEN @Key = '' THEN CASE WHEN @PageKey = '' THEN '' ELSE ' where ' + @PageKey END
			ELSE ' where ' + @Key + CASE WHEN @PageKey = '' THEN '' ELSE ' and (' + @PageKey + ')' END
		END + ' order by id'
		PRINT @strSQL
		EXEC(@strSQL)
	END

	IF @d > 0 BEGIN
		IF @PageIndex > @LastPage SELECT @strSQL = 'delete #r where c$ in (select top ' + LTRIM(STR(@d)) + ' c$ from #r order by c$)'
			ELSE SELECT @strSQL = 'delete #r where c$ not in (select top ' + LTRIM(STR(@PageCount)) + ' c$ from #r order by c$)'
		EXEC(@strSQL)
	END

	-- Data
	IF EXISTS(SELECT * FROM #r) BEGIN		
		SELECT @strSQL = 'select ' + RTRIM(@ItemCount)
		SELECT @strSQL = @strSQL + CHAR(13) + 'select ' + @ExternalFields + ' from ' + @Prime + ' a with (nolock) ' + @Join + ' where ' + @PrimaryFields + ' in (select c$ from #r) order by ' + @OrderByClause
		EXEC(@strSQL)

	END ELSE GOTO QueryEmpty
	GOTO Result;

	QueryEmpty:
		SELECT * FROM #r

	Result:

	SET NOCOUNT OFF
	RETURN
END




 



GO
-----Bổ sung danh mục giai đoan trong CRM - 29-08-2025

DELETE FROM crmgdtn WHERE 1=1
INSERT INTO crmgdtn(ma_dvcs, ma_gdtn, ten_gdtn, ten_gdtn2, ghi_chu, ti_le, status, datetime0, datetime2, user_id0, user_id2, ma_td1, ma_td2, ma_td3, sl_td1, sl_td2, sl_td3, ngay_td1, ngay_td2, ngay_td3, gc_td1, gc_td2, gc_td3, s1, s2, s3, s4, s5, s6, s7, s8, s9) VALUES(N'9999', N'01', N'Gọi điện', N'', N'', NULL, N'1', '20250101 00:00:00', '20250101 00:00:00', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT INTO crmgdtn(ma_dvcs, ma_gdtn, ten_gdtn, ten_gdtn2, ghi_chu, ti_le, status, datetime0, datetime2, user_id0, user_id2, ma_td1, ma_td2, ma_td3, sl_td1, sl_td2, sl_td3, ngay_td1, ngay_td2, ngay_td3, gc_td1, gc_td2, gc_td3, s1, s2, s3, s4, s5, s6, s7, s8, s9) VALUES(N'9999', N'02', N'Hẹn gặp', N'', N'', NULL, N'1', '20250101 00:00:00', '20250101 00:00:00', 1, NULL, N'', N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT INTO crmgdtn(ma_dvcs, ma_gdtn, ten_gdtn, ten_gdtn2, ghi_chu, ti_le, status, datetime0, datetime2, user_id0, user_id2, ma_td1, ma_td2, ma_td3, sl_td1, sl_td2, sl_td3, ngay_td1, ngay_td2, ngay_td3, gc_td1, gc_td2, gc_td3, s1, s2, s3, s4, s5, s6, s7, s8, s9) VALUES(N'9999', N'03', N'Gửi báo giá', N'', N'', NULL, N'1', '20250101 00:00:00', '20250101 00:00:00', 1, NULL, N'', N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT INTO crmgdtn(ma_dvcs, ma_gdtn, ten_gdtn, ten_gdtn2, ghi_chu, ti_le, status, datetime0, datetime2, user_id0, user_id2, ma_td1, ma_td2, ma_td3, sl_td1, sl_td2, sl_td3, ngay_td1, ngay_td2, ngay_td3, gc_td1, gc_td2, gc_td3, s1, s2, s3, s4, s5, s6, s7, s8, s9) VALUES(N'9999', N'04', N'Xuất hóa đơn', N'', N'', NULL, N'1', '20250101 00:00:00', '20250101 00:00:00', 1, NULL, N'', N'', N'', NULL, NULL, NULL, NULL, NULL, NULL, N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, NULL, NULL)




