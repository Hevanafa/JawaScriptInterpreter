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
    OutputMemo: TMemo;

    procedure FormShow(Sender: TObject);
    procedure InputEditChange(Sender: TObject);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    const
      FullStop = '꧉';

    var
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
  OutputMemo.clear;

  fLetterPairs := TStringDictionary.create;

  fLetterPairs.Add('h', 'ꦲ');
  fLetterPairs.add('n', 'ꦤ');
  fLetterPairs.add('c', 'ꦕ');
  fLetterPairs.add('r', 'ꦫ');
  fLetterPairs.add('k', 'ꦏ');

  fLetterPairs.add('d', 'ꦢ');
  fLetterPairs.add('t', 'ꦠ');
  fLetterPairs.add('s', 'ꦱ');
  fLetterPairs.add('w', 'ꦮ');
  fLetterPairs.add('l', 'ꦭ');

  fLetterPairs.add('p', 'ꦥ');
  fLetterPairs.add('dh', 'ꦝ');
  fLetterPairs.add('j', 'ꦗ');
  fLetterPairs.add('y', 'ꦪ');
  fLetterPairs.add('ny', 'ꦚ');

  fLetterPairs.add('m', 'ꦩ');
  fLetterPairs.add('g', 'ꦒ');
  fLetterPairs.add('b', 'ꦧ');
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
  letter, nextLetter, prevLetter: string;
  digraph: string;
  idx: word;
  len: smallint;
begin
  if key = VK_RETURN then begin
    OutputMemo.clear;

    buffer := '';
    inputQuery := InputEdit.text;
    len := length(InputEdit.text);

    if len > 0 then begin
      idx := 1;

      while idx <= len do begin
        letter := inputQuery[idx];

        if letter = '-' then begin
          inc(idx);
          continue
        end;


        prevLetter := '';
        nextLetter := '';
        digraph := '';

        if idx - 1 > 0 then
          prevLetter := inputQuery[idx];

        { peek }
        if idx + 1 <= len then begin
          nextLetter := inputQuery[idx + 1];
          digraph := letter + nextLetter
        end;

        if letter = ' ' then
          if nextLetter = '.' then begin
            buffer := buffer + FullStop;
            inc(idx, 2);
            continue
          end;

        { if letter = '.' then begin
          if (prevLetter = ' ') and (nextLetter = ' ') then begin
            buffer := buffer + FullStop;
            inc(idx, 3)
          end;

          if (idx = len) and (prevLetter = ' ') then begin
            buffer := buffer + FullStop;
            inc(idx)
          end;

          continue
        end; }

        if (digraph <> '') and fLetterPairs.ContainsKey(digraph) then begin
          buffer := buffer + fLetterPairs[digraph];
          inc(idx, 2);
          continue
        end;

        if fLetterPairs.ContainsKey(letter) then
          buffer := buffer + fLetterPairs[letter]
        else
          buffer := buffer + letter;

        inc(idx)
      end;

      OutputMemo.text := buffer
    end;
  end;
end;

end.

