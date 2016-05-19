program TesteDelphi;

uses
  Vcl.Forms,
  main in 'main.pas' {frmMain},
  Produtos in 'Produtos.pas' {frmProdutos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
