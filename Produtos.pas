unit Produtos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ImgList, Vcl.Menus,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.DBCtrls;

type
  TfrmProdutos = class(TForm)
    stbCadastro: TStatusBar;
    pgcCadastro: TPageControl;
    tbsLista: TTabSheet;
    tbsCadastro: TTabSheet;
    MainMenu1: TMainMenu;
    Incluir1: TMenuItem;
    Alterar1: TMenuItem;
    Salvar1: TMenuItem;
    Cancelar1: TMenuItem;
    Excluir1: TMenuItem;
    Sair1: TMenuItem;
    ActionToolBar1: TActionToolBar;
    dbgCadastro: TDBGrid;
    dtsProdutos: TDataSource;
    qryProdutos: TFDQuery;
    acmCadastros: TActionManager;
    actIncluir: TAction;
    actAlterar: TAction;
    actSalvar: TAction;
    actCancelar: TAction;
    actExcluir: TAction;
    actSair: TAction;
    ImageList2: TImageList;
    qryProdutosIdProduto: TFDAutoIncField;
    qryProdutosCodigo: TStringField;
    qryProdutosDescricao: TStringField;
    qryProdutosMarca: TStringField;
    qryProdutosModelo: TStringField;
    qryProdutosCor: TStringField;
    Label1: TLabel;
    edtCodigo: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    procedure actSairExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dtsProdutosStateChange(Sender: TObject);
    procedure actIncluirExecute(Sender: TObject);
    procedure actAlterarExecute(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure actExcluirExecute(Sender: TObject);
    procedure pgcCadastroChanging(Sender: TObject; var AllowChange: Boolean);
    procedure dbgCadastroDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    procedure Modo;
    procedure DisplayHint(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmProdutos: TfrmProdutos;

implementation
uses Main;

{$R *.dfm}

procedure TfrmProdutos.actAlterarExecute(Sender: TObject);
begin
  pgcCadastro.ActivePage := tbsCadastro;
  qryProdutos.Edit;
end;

procedure TfrmProdutos.actCancelarExecute(Sender: TObject);
begin
  qryProdutos.Cancel;
  pgcCadastro.ActivePage := tbsLista;
end;

procedure TfrmProdutos.actExcluirExecute(Sender: TObject);
begin
  if (MessageBox(0, 'Confirma exclus�o do produto ?', 'Confirma��o', MB_ICONQUESTION or MB_YESNO) = idYes) then begin
    qryProdutos.Delete;
    qryProdutos.Refresh;
  end;
end;

procedure TfrmProdutos.actIncluirExecute(Sender: TObject);
begin
  pgcCadastro.ActivePage := tbsCadastro;
  qryProdutos.Insert;
end;

procedure TfrmProdutos.actSairExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmProdutos.actSalvarExecute(Sender: TObject);
begin
  qryProdutos.Post;
  qryProdutos.Refresh;
  pgcCadastro.ActivePage := tbsLista;
end;

procedure TfrmProdutos.dbgCadastroDblClick(Sender: TObject);
begin
  if actAlterar.Enabled then
    actAlterar.Execute;
end;

procedure TfrmProdutos.dtsProdutosStateChange(Sender: TObject);
begin
  Modo;
end;

procedure TfrmProdutos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qryProdutos.Close;
end;

procedure TfrmProdutos.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canClose := not (qryProdutos.State in [dsEdit, dsInsert]);
end;

procedure TfrmProdutos.FormCreate(Sender: TObject);
begin
  pgcCadastro.ActivePage := tbsLista;
  Application.OnHint := DisplayHint;
  qryProdutos.Open;
end;

procedure TfrmProdutos.Modo;
var
  modoIncluir: Boolean;
  modoAlterar: Boolean;
  vazio: Boolean;
begin
  modoIncluir := qryProdutos.State = dsInsert;
  modoAlterar := qryProdutos.State = dsEdit;
  vazio := qryProdutos.RecordCount = 0;

  actIncluir.Enabled := not modoIncluir and not modoAlterar;
  actAlterar.Enabled := not modoIncluir and not modoAlterar and not vazio;
  actSalvar.Enabled := modoIncluir or ModoAlterar;
  actCancelar.Enabled := modoIncluir or modoAlterar;
  actExcluir.Enabled := not modoIncluir and not modoAlterar and not vazio;
  actSair.Enabled := not modoIncluir and not modoAlterar;
end;

procedure TfrmProdutos.pgcCadastroChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if pgcCadastro.ActivePage = tbsLista then
    AllowChange := qryProdutos.State in [dsEdit, dsInsert];
  if pgcCadastro.ActivePage = tbsCadastro then
    AllowChange := not (qryProdutos.State in [dsEdit, dsInsert]);
end;

procedure TfrmProdutos.DisplayHint(Sender: TObject);
begin
  stbCadastro.SimpleText := Application.Hint;

end;

end.
