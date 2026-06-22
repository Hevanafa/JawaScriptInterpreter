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
    fLetterPairs: TStringDictionary;

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

  fLetterPairs := TStringDictionary.create;

  fLetterPairs.Add('h', 'ꦲ');
  fLetterPairs.add('n', 'ꦤ');

  fLetterPairs.add('dh', 'ꦝ');
  fLetterPairs.add('ny', 'ꦚ');
  fLetterPairs.add('th', 'ꦛ');
  fLetterPairs.add('ng', 'ꦔ');
  { fLetterPairs.add('', ''); }
end;

procedure TForm1.InputEditChange(Sender: TObject);
begin
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  inputQuery: string;
  buffer: string;
  letter, nextLetter: string;
  digraph: string;
  idx: word;
  len: smallint;
begin
  if key = VK_RETURN then begin
    OutputEdit.clear;

    buffer := '';
    inputQuery := InputEdit.text;
    len := length(InputEdit.text);

    if len > 0 then begin
      idx := 1;

      while idx <= len do begin
        letter := inputQuery[idx];
        nextLetter := '';

        { peek }
        if idx + 1 <= len then begin
          nextLetter := inputQuery[idx + 1];
          digraph := letter + nextLetter;

          if fLetterPairs.ContainsKey(digraph) then begin
            buffer := buffer + fLetterPairs[digraph];
            inc(idx, 2);
            continue
          end;
        end;

        if fLetterPairs.ContainsKey(letter) then
          buffer := buffer + fLetterPairs[letter]
        else
          buffer := buffer + letter;

        inc(idx)
      end;

      OutputEdit.text := buffer
    end;
  end;
end;

end.

