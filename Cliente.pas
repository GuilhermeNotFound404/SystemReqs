unit Cliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.ListView,
  FMX.TabControl, FMX.Layouts, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm3 = class(TForm)
    Layout2: TLayout;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    ListView1: TListView;
    TabItem2: TTabItem;
    Gravar: TButton;
    Button2: TButton;
    ToolBar1: TToolBar;
    Layout1: TLayout;
    searchEdit: TEdit;
    addNewTypeButton: TButton;
    searchButton: TButton;
    backButton: TButton;
    searchLabel: TLabel;
    Layout3: TLayout;
    EditNome: TEdit;
    Label1: TLabel;
    Layout4: TLayout;
    EditEndereco: TEdit;
    Label2: TLabel;
    Layout5: TLayout;
    EditCidade: TEdit;
    Label3: TLabel;
    Layout6: TLayout;
    EditTelefone: TEdit;
    Label4: TLabel;
    Layout7: TLayout;
    ETipoID: TEdit;
    Label5: TLabel;
    Button1: TButton;
    FDQuery1: TFDQuery;
    procedure FormShow(Sender: TObject);
    procedure CarregarLista;
    procedure addNewTypeButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure backButtonClick(Sender: TObject);
    procedure GravarClick(Sender: TObject);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const [Ref] LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  acao: Char;

implementation

{$R *.fmx}

uses Menu, Tipo;

procedure TForm3.FormShow(Sender: TObject);
begin
  TabItem2.Enabled := False;
  addNewTypeButton.Enabled := True;
  TabControl1.ActiveTab := TabItem1;

  Menu.Form1.FDConnection1.Connected := True;
  CarregarLista;
end;

procedure TForm3.GravarClick(Sender: TObject);
var qrySalvar: TFDQuery;
begin
  try
    qrySalvar := TFDQuery.Create(Nil);
    qrySalvar.Connection := Form1.FDConnection1;
    qrySalvar.SQL.Clear;

    if acao = 'I' then
    begin
      qrySalvar.SQL.Add('INSERT INTO Cliente(Nome, Endereco, Cidade, Telefone, CodTipo) VALUES (:nome, :endereco, :cidade, :telefone, :codtipo)');
      qrySalvar.ParamByName('nome').AsString := EditNome.Text;
      qrySalvar.ParamByName('endereco').AsString := EditEndereco.Text;
      qrySalvar.ParamByName('cidade').AsString := EditCidade.Text;
      qrySalvar.ParamByName('telefone').AsString := EditTelefone.Text;
      qrySalvar.ParamByName('codtipo').AsString := ETipoID.Text;

      qrySalvar.ExecSQL;

      EditNome.Text := '';
      EditEndereco.Text := '';
      EditCidade.Text := '';
      ETipoID.Text := '';
      EditTelefone.Text := '';

      CarregarLista;
      TabItem1.Enabled := True;
      TabControl1.ActiveTab := TabItem1;
      addNewTypeButton.Enabled := True;
    end
    else if acao = 'A' then
    begin
      qrySalvar.SQL.Add('UPDATE Cliente SET Nome = :nome, Endereco = :endereco, Cidade = :cidade, Telefone = :telefone, CodTipo = :codtipo WHERE CodClient = :id');
      qrySalvar.ParamByName('id').AsInteger := id;
      qrySalvar.ParamByName('nome').AsString := EditNome.Text;
      qrySalvar.ParamByName('endereco').AsString := EditEndereco.Text;
      qrySalvar.ParamByName('cidade').AsString := EditCidade.Text;
      qrySalvar.ParamByName('telefone').AsString := EditTelefone.Text;
      qrySalvar.ParamByName('codtipo').AsInteger := StrToIntDef(ETipoID.Text, 0);
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
  TabItem2.Enabled := False;
end;


procedure TForm3.ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const [Ref] LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  var
    qryCarregar: TFDQuery;
begin
  if LocalClickPos.X >= TListView (Sender).Width - 65 then
  begin
    qryCarregar := TFDQuery.Create(nil);
    qryCarregar.Connection := Form1.FDConnection1;
    qryCarregar.SQL.Clear;

    qryCarregar.SQL.Add('SELECT * FROM Cliente WHERE CodClient = :id');
    qryCarregar.ParamByName('id').AsInteger := StrToIntDef(ListView1.Items[ItemIndex].Detail, 0);
    qryCarregar.Open();

      if qryCarregar.RecordCount > 0 then
      begin
        acao := 'A';
        id := qryCarregar.FieldByName('CodClient').AsInteger;
        EditNome.Text := qryCarregar.FieldByName('Nome').AsString;
        EditEndereco.Text := qryCarregar.FieldByName('Endereco').AsString;
        EditCidade.Text := qryCarregar.FieldByName('Cidade').AsString;
        EditTelefone.Text := qryCarregar.FieldByName('Telefone').AsString;
        ETipoID.Text := qryCarregar.FieldByName('CodTipo').AsString;
        TabItem2.Enabled := True;
        TabControl1.ActiveTab := TabItem2;
      end;
  end;
end;

procedure TForm3.addNewTypeButtonClick(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem2;
  acao := 'I';
  addNewTypeButton.Enabled := false;
  TabItem1.Enabled := false;
  TabItem2.Enabled := true;
  EditNome.Text := '';
end;

procedure TForm3.backButtonClick(Sender: TObject);
begin
  acao := 'A';
  Close;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  Tipo.acao := 'B';
  Tipo.Form2.Show;
end;

procedure TForm3.CarregarLista;
var
  qryLista: TFDQuery;
  AddItem: TListViewItem;
begin
  try
    qryLista := TFDQuery.Create(Nil);
    qryLista.Connection := Form1.FDConnection1;
    qryLista.SQL.Clear;
    qryLista.SQL.Add('Select * from Cliente');
    qryLista.Open();
    qryLista.First;
    ListView1.Items.Clear;
    while not qryLista.Eof do
    begin
      AddItem := ListView1.Items.Add;
      AddItem.Detail:= qryLista.FieldByName('CodClient').AsString;
      AddItem.Text:= qryLista.FieldByName('CodClient').AsString + ' - ' + qryLista.FieldByName('Nome').AsString;
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
