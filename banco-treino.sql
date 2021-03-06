USE [Banco-Treino-SQL]
GO
/****** Object:  User [usrAluno]    Script Date: 02/04/2022 21:55:15 ******/
CREATE USER [usrAluno] FOR LOGIN [usrAluno] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [usrAluno]
GO
/****** Object:  Schema [Producao]    Script Date: 02/04/2022 21:55:15 ******/
CREATE SCHEMA [Producao]
GO
/****** Object:  Schema [Rh]    Script Date: 02/04/2022 21:55:15 ******/
CREATE SCHEMA [Rh]
GO
/****** Object:  Schema [Vendas]    Script Date: 02/04/2022 21:55:15 ******/
CREATE SCHEMA [Vendas]
GO
/****** Object:  Table [Vendas].[Pedido]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Vendas].[Pedido](
	[iIDPedido] [int] IDENTITY(1,1) NOT NULL,
	[iIDCliente] [int] NULL,
	[iIDEmpregado] [int] NOT NULL,
	[DataPedido] [date] NOT NULL,
	[DataRequisicao] [date] NOT NULL,
	[DataEnvio] [date] NULL,
	[iIDRemetente] [int] NOT NULL,
	[Frete] [money] NOT NULL,
	[shipname] [varchar](40) NOT NULL,
	[shipaddress] [varchar](60) NOT NULL,
	[shipCidade] [varchar](15) NOT NULL,
	[shipregion] [varchar](15) NULL,
	[shipCEP] [varchar](10) NULL,
	[shipPais] [varchar](15) NOT NULL,
 CONSTRAINT [PK_Pedido] PRIMARY KEY CLUSTERED 
(
	[iIDPedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Vendas].[ItensPedido]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Vendas].[ItensPedido](
	[iIDPedido] [int] NOT NULL,
	[iIDProduto] [int] NOT NULL,
	[PrecoUnitario] [money] NOT NULL,
	[Quantidade] [smallint] NOT NULL,
	[Desconto] [numeric](4, 3) NULL,
 CONSTRAINT [PK_ItensPedido] PRIMARY KEY CLUSTERED 
(
	[iIDPedido] ASC,
	[iIDProduto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Vendas].[OrderValues]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------
-- Create Views
---------------------------------------------------------------------

CREATE VIEW [Vendas].[OrderValues]
  WITH SCHEMABINDING
AS

SELECT O.iIDPedido, O.iIDCliente, O.iIDEmpregado, O.iIDRemetente, O.DataPedido,
  CAST(SUM(OD.Quantidade * OD.PrecoUnitario * (1 - Desconto))
       AS NUMERIC(12, 2)) AS val
FROM Vendas.Pedido AS O
  JOIN Vendas.ItensPedido AS OD
    ON O.iIDPedido = OD.iIDPedido
GROUP BY O.iIDPedido, O.iIDCliente, O.iIDEmpregado, O.iIDRemetente, O.DataPedido;
GO
/****** Object:  View [Vendas].[OrderTotalsByYear]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Vendas].[OrderTotalsByYear]
  WITH SCHEMABINDING
AS

SELECT
  YEAR(O.DataPedido) AS orderyear,
  SUM(OD.Quantidade) AS Quantidade
FROM Vendas.Pedido AS O
  JOIN Vendas.ItensPedido AS OD
    ON OD.iIDPedido = O.iIDPedido
GROUP BY YEAR(DataPedido);
GO
/****** Object:  View [Vendas].[CustPedido]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Vendas].[CustPedido]
  WITH SCHEMABINDING
AS

SELECT
  O.iIDCliente, 
  DATEADD(month, DATEDIFF(month, 0, O.DataPedido), 0) AS ordermonth,
  SUM(OD.Quantidade) AS Quantidade
FROM Vendas.Pedido AS O
  JOIN Vendas.ItensPedido AS OD
    ON OD.iIDPedido = O.iIDPedido
GROUP BY iIDCliente, DATEADD(month, DATEDIFF(month, 0, O.DataPedido), 0);
GO
/****** Object:  Table [Producao].[Categoria]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Producao].[Categoria](
	[iIDCategoria] [int] IDENTITY(1,1) NOT NULL,
	[NomeCategoria] [varchar](15) NOT NULL,
	[Descricao] [varchar](200) NOT NULL,
 CONSTRAINT [PK_Categoria] PRIMARY KEY CLUSTERED 
(
	[iIDCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Producao].[Fornecedor]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Producao].[Fornecedor](
	[iIDFornecedor] [int] IDENTITY(1,1) NOT NULL,
	[RazaoSocial] [varchar](40) NOT NULL,
	[Contato] [varchar](30) NOT NULL,
	[Cargo] [varchar](30) NOT NULL,
	[Endereco] [varchar](60) NOT NULL,
	[Cidade] [varchar](15) NOT NULL,
	[Regiao] [varchar](15) NULL,
	[CEP] [varchar](10) NULL,
	[Pais] [varchar](15) NOT NULL,
	[Telefone] [varchar](24) NOT NULL,
	[fax] [varchar](24) NULL,
 CONSTRAINT [PK_Fornecedor] PRIMARY KEY CLUSTERED 
(
	[iIDFornecedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Producao].[Produto]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Producao].[Produto](
	[iIDProduto] [int] IDENTITY(1,1) NOT NULL,
	[NomeProduto] [varchar](40) NOT NULL,
	[iIDFornecedor] [int] NOT NULL,
	[iIDCategoria] [int] NOT NULL,
	[PrecoUnitario] [money] NOT NULL,
	[Desativado] [bit] NOT NULL,
 CONSTRAINT [PK_Produto] PRIMARY KEY CLUSTERED 
(
	[iIDProduto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Rh].[Empregado]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rh].[Empregado](
	[iIDEmpregado] [int] IDENTITY(1,1) NOT NULL,
	[UltimoNome] [varchar](20) NOT NULL,
	[PrimeiroNome] [varchar](10) NOT NULL,
	[Cargo] [varchar](30) NOT NULL,
	[Cortesia] [varchar](25) NOT NULL,
	[DataAniversario] [datetime] NOT NULL,
	[DataAdmissao] [datetime] NOT NULL,
	[Endereco] [varchar](60) NOT NULL,
	[Cidade] [varchar](15) NOT NULL,
	[Regiao] [varchar](15) NULL,
	[CEP] [varchar](10) NULL,
	[Pais] [varchar](15) NOT NULL,
	[Telefone] [varchar](24) NOT NULL,
	[Salario] [money] NOT NULL,
	[iIDChefe] [int] NULL,
 CONSTRAINT [PK_Empregado] PRIMARY KEY CLUSTERED 
(
	[iIDEmpregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Vendas].[Cliente]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Vendas].[Cliente](
	[iIDCliente] [int] IDENTITY(1,1) NOT NULL,
	[RazaoSocial] [varchar](40) NOT NULL,
	[Contato] [varchar](30) NOT NULL,
	[Cargo] [varchar](30) NOT NULL,
	[Documento] [varchar](10) NULL,
	[Endereco] [varchar](60) NOT NULL,
	[Cidade] [varchar](15) NOT NULL,
	[Regiao] [varchar](15) NULL,
	[CEP] [varchar](10) NULL,
	[Pais] [varchar](15) NOT NULL,
	[Telefone] [varchar](24) NOT NULL,
	[fax] [varchar](24) NULL,
 CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[iIDCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Vendas].[Remetente]    Script Date: 02/04/2022 21:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Vendas].[Remetente](
	[iIDRemetente] [int] IDENTITY(1,1) NOT NULL,
	[RazaoSocial] [varchar](40) NOT NULL,
	[Telefone] [varchar](24) NOT NULL,
 CONSTRAINT [PK_Remetente] PRIMARY KEY CLUSTERED 
(
	[iIDRemetente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Producao].[Produto] ADD  CONSTRAINT [DFT_Produto_PrecoUnitario]  DEFAULT ((0)) FOR [PrecoUnitario]
GO
ALTER TABLE [Producao].[Produto] ADD  CONSTRAINT [DFT_Produto_Desativado]  DEFAULT ((0)) FOR [Desativado]
GO
ALTER TABLE [Vendas].[ItensPedido] ADD  CONSTRAINT [DFT_ItensPedido_PrecoUnitario]  DEFAULT ((0)) FOR [PrecoUnitario]
GO
ALTER TABLE [Vendas].[ItensPedido] ADD  CONSTRAINT [DFT_ItensPedido_Quantidade]  DEFAULT ((1)) FOR [Quantidade]
GO
ALTER TABLE [Vendas].[ItensPedido] ADD  CONSTRAINT [DFT_ItensPedido_Desconto]  DEFAULT ((0)) FOR [Desconto]
GO
ALTER TABLE [Vendas].[Pedido] ADD  CONSTRAINT [DFT_Pedido_Frete]  DEFAULT ((0)) FOR [Frete]
GO
ALTER TABLE [Producao].[Produto]  WITH CHECK ADD  CONSTRAINT [FK_Produto_Categoria] FOREIGN KEY([iIDCategoria])
REFERENCES [Producao].[Categoria] ([iIDCategoria])
GO
ALTER TABLE [Producao].[Produto] CHECK CONSTRAINT [FK_Produto_Categoria]
GO
ALTER TABLE [Producao].[Produto]  WITH CHECK ADD  CONSTRAINT [FK_Produto_Fornecedor] FOREIGN KEY([iIDFornecedor])
REFERENCES [Producao].[Fornecedor] ([iIDFornecedor])
GO
ALTER TABLE [Producao].[Produto] CHECK CONSTRAINT [FK_Produto_Fornecedor]
GO
ALTER TABLE [Rh].[Empregado]  WITH CHECK ADD  CONSTRAINT [FK_Empregado_Empregado] FOREIGN KEY([iIDChefe])
REFERENCES [Rh].[Empregado] ([iIDEmpregado])
GO
ALTER TABLE [Rh].[Empregado] CHECK CONSTRAINT [FK_Empregado_Empregado]
GO
ALTER TABLE [Vendas].[ItensPedido]  WITH CHECK ADD  CONSTRAINT [FK_ItensPedido_Pedido] FOREIGN KEY([iIDPedido])
REFERENCES [Vendas].[Pedido] ([iIDPedido])
GO
ALTER TABLE [Vendas].[ItensPedido] CHECK CONSTRAINT [FK_ItensPedido_Pedido]
GO
ALTER TABLE [Vendas].[ItensPedido]  WITH CHECK ADD  CONSTRAINT [FK_ItensPedido_Produto] FOREIGN KEY([iIDProduto])
REFERENCES [Producao].[Produto] ([iIDProduto])
GO
ALTER TABLE [Vendas].[ItensPedido] CHECK CONSTRAINT [FK_ItensPedido_Produto]
GO
ALTER TABLE [Vendas].[Pedido]  WITH CHECK ADD  CONSTRAINT [FK_Pedido_Cliente] FOREIGN KEY([iIDCliente])
REFERENCES [Vendas].[Cliente] ([iIDCliente])
GO
ALTER TABLE [Vendas].[Pedido] CHECK CONSTRAINT [FK_Pedido_Cliente]
GO
ALTER TABLE [Vendas].[Pedido]  WITH CHECK ADD  CONSTRAINT [FK_Pedido_Empregado] FOREIGN KEY([iIDEmpregado])
REFERENCES [Rh].[Empregado] ([iIDEmpregado])
GO
ALTER TABLE [Vendas].[Pedido] CHECK CONSTRAINT [FK_Pedido_Empregado]
GO
ALTER TABLE [Vendas].[Pedido]  WITH CHECK ADD  CONSTRAINT [FK_Pedido_Remetente] FOREIGN KEY([iIDRemetente])
REFERENCES [Vendas].[Remetente] ([iIDRemetente])
GO
ALTER TABLE [Vendas].[Pedido] CHECK CONSTRAINT [FK_Pedido_Remetente]
GO
ALTER TABLE [Producao].[Produto]  WITH CHECK ADD  CONSTRAINT [CHK_Produto_PrecoUnitario] CHECK  (([PrecoUnitario]>=(0)))
GO
ALTER TABLE [Producao].[Produto] CHECK CONSTRAINT [CHK_Produto_PrecoUnitario]
GO
ALTER TABLE [Rh].[Empregado]  WITH CHECK ADD  CONSTRAINT [CHK_DataAniversario] CHECK  (([DataAniversario]<=getdate()))
GO
ALTER TABLE [Rh].[Empregado] CHECK CONSTRAINT [CHK_DataAniversario]
GO
ALTER TABLE [Rh].[Empregado]  WITH CHECK ADD  CONSTRAINT [CHK_Salario] CHECK  (([Salario]>(0)))
GO
ALTER TABLE [Rh].[Empregado] CHECK CONSTRAINT [CHK_Salario]
GO
ALTER TABLE [Vendas].[ItensPedido]  WITH CHECK ADD  CONSTRAINT [CHK_Desconto] CHECK  (([Desconto]>=(0) AND [Desconto]<=(1)))
GO
ALTER TABLE [Vendas].[ItensPedido] CHECK CONSTRAINT [CHK_Desconto]
GO
ALTER TABLE [Vendas].[ItensPedido]  WITH CHECK ADD  CONSTRAINT [CHK_PrecoUnitario] CHECK  (([PrecoUnitario]>=(0)))
GO
ALTER TABLE [Vendas].[ItensPedido] CHECK CONSTRAINT [CHK_PrecoUnitario]
GO
ALTER TABLE [Vendas].[ItensPedido]  WITH CHECK ADD  CONSTRAINT [CHK_Quantidade] CHECK  (([Quantidade]>(0)))
GO
ALTER TABLE [Vendas].[ItensPedido] CHECK CONSTRAINT [CHK_Quantidade]
GO
