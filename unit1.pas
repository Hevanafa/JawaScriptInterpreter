unit Unit1;

{$Mode ObjFPC}
{$H+}

interface

uses
  Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs, StdCtrls,
  FGL, Generics.Collections, LazUTF8;

type
  TStringDictionary = specialize TDictionary<string, string>;

  { TForm1 }
  TForm1 = class(TForm)
    InputEdit: TEdit;
    OutputEdit: TEdit;

    procedure FormShow(Sender: TObject);
    procedure InputEditChange(Sender: TObject);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    letters: TStringDictionary;

  public

  end;

var
  Form1: TForm1;

implementation

uses
  LCLType, Windows;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
begin
  InputEdit.clear;
  OutputEdit.clear;

  letters := TStringDictionary.create;

  letters.Add('h', 'ꦲ');
  letters.add('n', 'ꦤ');
end;

procedure TForm1.InputEditChange(Sender: TObject);
begin
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  a: Word;
  buffer: string;
  idx: word;
  len: smallint;
begin
  if key = VK_RETURN then begin
    OutputEdit.clear;

    len := UTF8Length(InputEdit.text);

    if len > 0 then begin
      idx := 0;

      while idx < len do begin
        { if letters.ContainsKey(InputEdit.text[a]) then
          OutputEdit.text := OutputEdit.text + letters[inputedit.Text[a]]; }

        inc(idx)
      end;
    end;
  end;
end;

end.

