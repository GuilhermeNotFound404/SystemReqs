program SistemaPedido;

uses
  System.StartUpCopy,
  FMX.Forms,
  Menu in 'Menu.pas' {Form1},
  Tipo in 'Tipo.pas' {Form2},
  Cliente in 'Cliente.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
