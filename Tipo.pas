unit Tipo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Objects, System.IOUtils;

type
  TForm2 = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    ToolBar1: TToolBar;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    searchEdit: TEdit;
    addNewTypeButton: TButton;
    searchButton: TButton;
    backButton: TButton;
    searchLabel: TLabel;
    ListView1: TListView;
    FDQuery1: TFDQuery;
    Label1: TLabel;
    EditNome: TEdit;
    Gravar: TButton;
    Button2: TButton;
    procedure CarregarLista;
    procedure backButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure addNewTypeButtonClick(Sender: TObject);
    procedure GravarClick(Sender: TObject);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const [Ref] LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  acao: Char;
  id: Integer;

implementation

uses Menu, Cliente;

{$R *.fmx}

procedure TForm2.addNewTypeButtonClick(Sender: TObject);
begin
  TabItem1.Enabled := false;
  TabItem2.Enabled := true;
  TabControl1.ActiveTab := TabItem2;
  acao := 'I';
  EditNome.Text := '';
end;

procedure TForm2.backButtonClick(Sender: TObject);
begin
  acao := 'A';
  Close;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  if acao = 'B' then
  begin
    TabItem2.Enabled := False;
    addNewTypeButton.Enabled := False;
  end
  else
  begin
    TabItem2.Enabled := False;
    addNewTypeButton.Enabled := True;
    TabControl1.ActiveTab := TabItem1;
  end;

  Form1.FDConnection1.Connected := True;
  CarregarLista;
end;

procedure TForm2.GravarClick(Sender: TObject);
var qrySalvar: TFDQuery;
begin
  try
    qrySalvar := TFDQuery.Create(Nil);
    qrySalvar.Connection := Form1.FDConnection1;
    qrySalvar.SQL.Clear;

    if acao = 'I' then
    begin
      qrySalvar.SQL.Add('INSERT INTO Tipo(nome) VALUES (:nome)');
      qrySalvar.ParamByName('nome').AsString := EditNome.Text;
      qrySalvar.ExecSQL;

      EditNome.Text := '';

      CarregarLista;
      TabControl1.ActiveTab := TabItem1;
      TabItem1.Enabled := True;
      TabItem2.Enabled := False;
      addNewTypeButton.Enabled := True;
    end
    else if acao = 'A' then
    begin
      qrySalvar.SQL.Add('UPDATE Tipo SET nome = :nome WHERE CodigoTipo = :id');
      qrySalvar.ParamByName('nome').AsString := EditNome.Text;
      qrySalvar.ParamByName('id').AsInteger := id;
      qrySalvar.ExecSQL;

      EditNome.Text := '';

      ShowMessage('Alterado com sucesso!');
      CarregarLista;
      TabControl1.ActiveTab := TabItem1;
      TabItem1.Enabled := True;
      TabItem2.Enabled := False;
      addNewTypeButton.Enabled := True;
    end;


  except
    on e: Exception do
  begin
    ShowMessage(e.Message);
  end;
  end;

  acao := 'I';
end;

procedure TForm2.ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const [Ref] LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  var
    qryCarregar: TFDQuery;
begin

  if LocalClickPos.X >= TListView (Sender).Width - 65 then
  begin
    qryCarregar := TFDQuery.Create(nil);
    qryCarregar.Connection := Form1.FDConnection1;
    qryCarregar.SQL.Clear;

    qryCarregar.SQL.Add('SELECT * FROM Tipo WHERE CodigoTipo = :id');
    qryCarregar.ParamByName('id').AsInteger := StrToIntDef(ListView1.Items[ItemIndex].Detail, 0);
    qryCarregar.Open();

    if acao = 'B' then
    begin
      Cliente.Form3.ETipoID.Text := IntToStr(qryCarregar.FieldByName('CodigoTipo').AsInteger);
      Close;
    end
    else
    begin
      if qryCarregar.RecordCount > 0 then
      begin
        acao := 'A';
        id := qryCarregar.FieldByName('CodigoTipo').AsInteger;
        EditNome.Text := qryCarregar.FieldByName('Nome').AsString;
        TabItem2.Enabled := True;
        TabControl1.ActiveTab := TabItem2;
      end;
    end;
  end;
end;

procedure TForm2.CarregarLista;
var
  qryLista: TFDQuery;
  AddItem: TListViewItem;
begin
  try
    qryLista := TFDQuery.Create(Nil);
    qryLista.Connection := Form1.FDConnection1;
    qryLista.SQL.Clear;
    qryLista.SQL.Add('Select * from Tipo');
    qryLista.Open();
    qryLista.First;
    ListView1.Items.Clear;
    while not qryLista.Eof do
    begin
      AddItem := ListView1.Items.Add;
      AddItem.Detail:= qryLista.FieldByName('CodigoTipo').AsString;
      AddItem.Text:= qryLista.FieldByName('CodigoTipo').AsString + ' - ' + qryLista.FieldByName('Nome').AsString;
      qryLista.Next;
    end;

    qryLista.Close;
    qryLista.Free;

  except
    on e: Exception do
  begin
    ShowMessage(e.Message);
  end;

  end;
end;

end.

