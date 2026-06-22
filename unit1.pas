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
    CopyButton: TButton;
    InputEdit: TEdit;
    Label1: TLabel;
    OutputMemo: TMemo;

    procedure CopyButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InputEditChange(Sender: TObject);
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    const
      FullStop = '꧉';

    var
      fTrigraphs,
      fDigraphs,
      fLetters,
      fNumberPairs: TStringDictionary;

    procedure PerformTransliteration;
  public

  end;

var
  Form1: TForm1;

implementation

uses
  Clipbrd, LCLType, Windows;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
begin
  InputEdit.clear;
  OutputMemo.clear;

  fTrigraphs := TStringDictionary.create;
  fDigraphs := TStringDictionary.create;
  fLetters := TStringDictionary.create;

  fNumberPairs := TStringDictionary.create;

  fLetters.add('h', 'ꦲ');
  fLetters.add('n', 'ꦤ');
  fLetters.add('c', 'ꦕ');
  fLetters.add('r', 'ꦫ');
  fLetters.add('k', 'ꦏ');

  fLetters.add('d', 'ꦢ');
  fLetters.add('t', 'ꦠ');
  fLetters.add('s', 'ꦱ');
  fLetters.add('w', 'ꦮ');
  fLetters.add('l', 'ꦭ');

  fLetters.add('p', 'ꦥ');
  fDigraphs.add('dh', 'ꦝ');
  fLetters.add('j', 'ꦗ');
  fLetters.add('y', 'ꦪ');
  fDigraphs.add('ny', 'ꦚ');

  fLetters.add('m', 'ꦩ');
  fLetters.add('g', 'ꦒ');
  fLetters.add('b', 'ꦧ');
  fDigraphs.add('th', 'ꦛ');
  fDigraphs.add('ng', 'ꦔ');

  fDigraphs.add('ee', 'ꦺ');
  fLetters.add('e', 'ꦼ');
  fLetters.add('i', 'ꦶ');
  fLetters.add('o', 'ꦴ');
  fLetters.add('u', 'ꦸ');

  fNumberPairs.add('0', '꧐');
  fNumberPairs.add('1', '꧑');
  fNumberPairs.add('2', '꧒');
  fNumberPairs.add('3', '꧓');
  fNumberPairs.add('4', '꧔');

  fNumberPairs.add('5', '꧕');
  fNumberPairs.add('6', '꧖');
  fNumberPairs.add('7', '꧗');
  fNumberPairs.add('8', '꧘');
  fNumberPairs.add('9', '꧙');

  fTrigraphs.add('ng.', 'ꦁ');

  fTrigraphs.add('*re', 'ꦽ');

  fDigraphs.add('*r', 'ꦿ');
  fDigraphs.add('*y', 'ꦾ');
  fDigraphs.add('*l', '꧀ꦭ');
  fDigraphs.add('*w', '꧀ꦮ');

  { fNumberPairs.add('', ''); }
end;

procedure TForm1.CopyButtonClick(Sender: TObject);
begin
  if trim(OutputMemo.text) = '' then begin
    MessageBox(0, 'Nothing to copy!', 'Copy Output', MB_OK or MB_ICONINFORMATION);
    exit
  end;

  Clipboard.AsText := OutputMemo.text;
  MessageBox(0, 'Copied output to clipboard', 'Copy Output', MB_OK or MB_ICONINFORMATION)
end;

procedure TForm1.PerformTransliteration;
var
  inputQuery: string;
  buffer: string;
  letter, nextLetter, prevLetter: string;
  digraph, trigraph: string;
  idx: word;
  len: smallint;
begin
  OutputMemo.clear;

  buffer := '';
  inputQuery := InputEdit.text;
  len := length(InputEdit.text);

  if len > 0 then begin
    idx := 1;

    while idx <= len do begin
      letter := inputQuery[idx];

      if (letter = '-') or (letter = 'a') then begin
        inc(idx);
        continue
      end;

      if letter[1] in ['0'..'9'] then begin
        buffer := buffer + fNumberPairs[letter];
        inc(idx);
        continue
      end;

      prevLetter := '';
      nextLetter := '';
      digraph := '';
      trigraph := '';

      if idx - 1 > 0 then
        prevLetter := inputQuery[idx];

      if idx + 1 <= len then begin
        nextLetter := inputQuery[idx + 1];
        digraph := letter + nextLetter
      end;

      if idx + 2 <= len then
        trigraph := letter + inputQuery[idx + 1] + inputQuery[idx + 2];

      { Begin handle special cases }
      if trigraph <> '' then begin
        if fTrigraphs.ContainsKey(trigraph) then begin
          buffer := buffer + fTrigraphs[trigraph];
          inc(idx, 3);
          continue
        end
        else if trigraph = ' . ' then begin
          buffer := buffer + FullStop;
          inc(idx, 3);
          continue
        end
        else if trigraph[3] = '.' then begin
          if fLetters.ContainsKey(digraph) then begin
            { Trigger pangkon (coda) }
            buffer := buffer + fLetters[digraph] + '꧀';
            inc(idx, 3);
            continue
          end;
        end;
      end;

      if digraph <> '' then begin
        if digraph = 'r.' then begin
          buffer := buffer + 'ꦂ';
          inc(idx, 2);
          continue
        end
        else if digraph = 'h.' then begin
          buffer := buffer + 'ꦃ';
          inc(idx, 2);
          continue
        end
        else if digraph = ' .' then begin
          buffer := buffer + FullStop;
          inc(idx, 2);
          continue
        end else if nextLetter = '.' then begin
          { Trigger pangkon (coda) for 1 letter }
          if fLetters.ContainsKey(letter) then begin
            buffer := buffer + fLetters[letter] + '꧀';
            inc(idx, 2);
            continue
          end;
        end;
      end;

      { Regular letter processing }
      if (digraph <> '') then begin
        if fLetters.ContainsKey(digraph) then begin
          buffer := buffer + fLetters[digraph];
          inc(idx, 2);
          continue
        end;
      end;

      if fLetters.ContainsKey(letter) then
        buffer := buffer + fLetters[letter]
      else if letter = 'q' then
        buffer := buffer + 'ꧏ '
      else if letter = ',' then
        buffer := buffer + '꧈'
      else if (letter = '+') or (letter = '^') then
        buffer := buffer + '꧇'
      else if letter = ' ' then
      else
        buffer := buffer + letter;

      inc(idx)
    end;

    OutputMemo.text := buffer
  end;
end;

procedure TForm1.InputEditChange(Sender: TObject);
begin
  PerformTransliteration
end;

procedure TForm1.InputEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_RETURN then
    PerformTransliteration;
end;

end.

