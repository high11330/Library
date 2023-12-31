USE [master]
GO
/****** Object:  Database [Library]    Script Date: 2023/6/18 上午 09:57:49 ******/
CREATE DATABASE [Library]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Library', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Library.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Library_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Library_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Library] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Library].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Library] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Library] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Library] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Library] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Library] SET ARITHABORT OFF 
GO
ALTER DATABASE [Library] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Library] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Library] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Library] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Library] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Library] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Library] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Library] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Library] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Library] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Library] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Library] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Library] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Library] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Library] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Library] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Library] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Library] SET RECOVERY FULL 
GO
ALTER DATABASE [Library] SET  MULTI_USER 
GO
ALTER DATABASE [Library] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Library] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Library] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Library] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Library] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Library] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Library', N'ON'
GO
USE [Library]
GO
/****** Object:  Table [dbo].[Book]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[ISBN] [char](13) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Author] [nvarchar](30) NOT NULL,
	[Introduction] [nvarchar](200) NULL,
 CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED 
(
	[ISBN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BorrowingRecord]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BorrowingRecord](
	[UserId] [int] NOT NULL,
	[InventoryId] [int] NOT NULL,
	[BorrowingTime] [datetime] NULL,
	[ReturnTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inventory]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventory](
	[InventoryId] [int] IDENTITY(1,1) NOT NULL,
	[ISBN] [char](13) NOT NULL,
	[StoreTime] [datetime] NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
(
	[InventoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[PhoneNumber] [char](10) NOT NULL,
	[Password] [char](30) NOT NULL,
	[UserName] [nvarchar](20) NOT NULL,
	[RegistrationTime] [datetime] NULL,
	[LastLoginTime] [datetime] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BorrowingRecord]    Script Date: 2023/6/18 上午 09:57:50 ******/
CREATE NONCLUSTERED INDEX [IX_BorrowingRecord] ON [dbo].[BorrowingRecord]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[BorrowBook]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[BorrowBook] 
	@UserId int,
    @InventoryId int
AS
BEGIN TRY
    BEGIN TRANSACTION;
    
    INSERT INTO BorrowingRecord (UserId, InventoryId, BorrowingTime) VALUES (@UserId, @InventoryId, GETDATE());
    UPDATE Inventory SET Status = '出借中' WHERE InventoryId = @InventoryId;
    
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
        PRINT 'Transaction rolled back.';
    END
END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[GetBookList]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBookList]
    @ISBN char(13)
AS
SET NOCOUNT ON;
 IF @ISBN IS NULL
    BEGIN
        SELECT * FROM [Book] JOIN [Inventory] on [Book].[ISBN] = [Inventory].[ISBN];
    END
    ELSE
    BEGIN
        SELECT * FROM [Book] JOIN [Inventory] on [Book].[ISBN] = [Inventory].[ISBN] WHERE [Book].[ISBN] = @ISBN;
    END


GO
/****** Object:  StoredProcedure [dbo].[GetBorrowingRecord]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBorrowingRecord]
	@UserId int, 
	@Status nvarchar(30)
AS
SET NOCOUNT ON;
IF @Status IS NULL
    BEGIN
        SELECT * FROM [BorrowingRecord] 
		JOIN [Inventory] on [BorrowingRecord].[InventoryId] = [Inventory].[InventoryId] 
		JOIN [Book] on [Book].[ISBN] = [Inventory].[ISBN]
		WHERE [UserId] = @UserId;
    END
    ELSE
    BEGIN
        SELECT * FROM [BorrowingRecord] 
		JOIN [Inventory] on [BorrowingRecord].[InventoryId] = [Inventory].[InventoryId] 
		JOIN [Book] on [Book].[ISBN] = [Inventory].[ISBN]
		WHERE [UserId] = @UserId AND [Status] = @Status AND ReturnTime is null;
    END
GO
/****** Object:  StoredProcedure [dbo].[GetUser]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUser]
    @PhoneNumber char(10),
    @Password char(30)
AS
SET NOCOUNT ON;

IF @Password IS NULL
BEGIN
    SELECT * FROM [User] WHERE PhoneNumber = @PhoneNumber ;
END
ELSE
BEGIN
    SELECT * FROM [User] WHERE PhoneNumber = @PhoneNumber and [Password] = @Password ;
END
GO
/****** Object:  StoredProcedure [dbo].[InsertUser]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertUser]
    @PhoneNumber char(10),
    @Password char(30),
    @UserName nvarchar(20)
AS
BEGIN
	INSERT INTO [dbo].[User]
           ([PhoneNumber]
           ,[Password]
           ,[UserName]
           ,[RegistrationTime]
           ,[LastLoginTime])
     VALUES
           (@PhoneNumber
           ,@Password
           ,@UserName
           ,GETDATE()
           ,NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[RetrunBook]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RetrunBook] 
	@UserId int,
    @InventoryId int
AS
BEGIN TRY
    BEGIN TRANSACTION;
    
    UPDATE BorrowingRecord SET ReturnTime = GETDATE() WHERE InventoryId = @InventoryId AND UserId = @UserId;
    UPDATE Inventory SET Status = '在庫' WHERE InventoryId = @InventoryId;
    
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END
END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[UpdateUserLastLoginTime]    Script Date: 2023/6/18 上午 09:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUserLastLoginTime]
	@UserId int
AS
BEGIN
	UPDATE [User] set LastLoginTime = GETDATE() where UserId = @UserId
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'國際標準書號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Book', @level2type=N'COLUMN',@level2name=N'ISBN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'書名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Book', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'作者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Book', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'書籍內容簡介' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Book', @level2type=N'COLUMN',@level2name=N'Introduction'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'使用者ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BorrowingRecord', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'庫存ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BorrowingRecord', @level2type=N'COLUMN',@level2name=N'InventoryId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'借出日期時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BorrowingRecord', @level2type=N'COLUMN',@level2name=N'BorrowingTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'歸還日期時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BorrowingRecord', @level2type=N'COLUMN',@level2name=N'ReturnTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'庫存ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Inventory', @level2type=N'COLUMN',@level2name=N'InventoryId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'國際標準書號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Inventory', @level2type=N'COLUMN',@level2name=N'ISBN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'書籍入庫(購買)日期時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Inventory', @level2type=N'COLUMN',@level2name=N'StoreTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'書籍狀態' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Inventory', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'使用者ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'手機' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'PhoneNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'密碼' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'使用者名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'UserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'註冊日期時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'RegistrationTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'最後登入時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'LastLoginTime'
GO
USE [master]
GO
