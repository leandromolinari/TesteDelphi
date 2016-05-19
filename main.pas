unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, Vcl.ComCtrls, Vcl.Menus,
  Vcl.ToolWin, Vcl.XPMan, Vcl.ActnMan, Vcl.ActnCtrls, System.Actions,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, Data.DB, FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Vcl.RibbonSilverStyleActnCtrls, IniFiles,
  IWSystem;

type
  TfrmMain = class(TForm)
    XPManifest1: TXPManifest;
    stbMain: TStatusBar;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    Produtos1: TMenuItem;
    ImageList1: TImageList;
    acmMain: TActionManager;
    actProdutos: TAction;
    actSair: TAction;
    Image1: TImage;
    fdcTesteDelphi: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    ActionToolBar1: TActionToolBar;
    procedure actSairExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actProdutosExecute(Sender: TObject);
  private
    { Private declarations }
    Database, Server: String;

    procedure DisplayHint(Sender: TObject);
    procedure LerArquivoConfiguracao;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
uses Produtos;

{$R *.dfm}

procedure TfrmMain.actProdutosExecute(Sender: TObject);
begin
  application.CreateForm(TfrmProdutos, frmProdutos);
  frmProdutos.ShowModal;
  FreeAndNil(frmProdutos);
  Application.OnHint := DisplayHint;
end;

procedure TfrmMain.actSairExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.DisplayHint(Sender: TObject);
begin
  stbMain.SimpleText := Application.Hint;

end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := false;
  if (MessageBox(0, 'Confirma a sa�da do sistema ?', 'Confirma��o', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON1) = idYes) then
    Application.Terminate;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Application.OnHint := DisplayHint;
  try
    LerArquivoConfiguracao;
    fdcTesteDelphi.Params.Clear;
    fdcTesteDelphi.DriverName := 'MSSQL';
    fdcTesteDelphi.Params.Add('Server='+Server);
    fdcTesteDelphi.Params.Add('Database='+Database);
    fdcTesteDelphi.Params.Add('OSAuthent=yes');
    fdcTesteDelphi.Connected := true;
  except
    on e: Exception do
    begin
      ShowMessage(e.Message);
      Application.Terminate;
    end;
  end;
end;

procedure TfrmMain.LerArquivoConfiguracao;
var
  ArqIni: TIniFile;
begin
  try
    ArqIni := TIniFile.Create(gsAppPath+'TesteDelphi.ini');
    if not FileExists(ArqIni.FileName) then
      raise Exception.Create('Arquivo TesteDelphi.ini n�o encontrado na pasta do execut�vel');
    Database := ArqIni.ReadString('Database', 'Database', '');
    Server := ArqIni.ReadString('Database', 'Server', '');
  finally
    ArqIni.Free;
  end;
end;

end.
