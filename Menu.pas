unit Menu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.ListBox, FMX.Layouts, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Comp.Client, Data.DB, System.IOUtils;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    Text1: TText;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    FDConnection1: TFDConnection;
    FDTransaction1: TFDTransaction;
    procedure ListBoxItem1Click(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses Tipo, Cliente;

procedure TForm1.FDConnection1BeforeConnect(Sender: TObject);
begin
  Form1.FDConnection1.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath,'mongodb.s3db');
end;

procedure TForm1.ListBoxItem1Click(Sender: TObject);
begin
  Tipo.acao := 'C';
  Tipo.Form2.Show;
end;

procedure TForm1.ListBoxItem2Click(Sender: TObject);
begin
  Cliente.Form3.Show;
end;

end.
