unit CompressedString;

interface

uses
 System.SysUtils,
 System.Classes,
 System.ZLib;

// 1.1 - Added toInteger and Length ( original length )
// 1.0 - First release - Thanks to https://github.com/havrlisan for lots of help and making the debugger visualizer!

Const
 zStringVersion = 1.1;

type
 zString = record
 strict private
  FCompressedData: TBytes;
  FCompressed: Boolean;
  FOriginalLength: longint;
  function GetValue: string;
  function GetLength: longint;
  procedure SetValue(const Value: string);
 public
  class operator Implicit(const Value: string): zString;
  class operator Implicit(const Value: zString): string;

  class operator Equal(const A: zString; const B: zString): Boolean;
  class operator Equal(const A: zString; const B: string): Boolean;
  class operator Equal(const A: string; const B: zString): Boolean;

  class operator NotEqual(Const A: zString; const B: zString): Boolean;
  class operator NotEqual(const A: zString; const B: string): Boolean;
  class operator NotEqual(const A: string; const B: zString): Boolean;

  class operator Add(const A, B: zString): zString;
  class operator Add(const A: zString; const B: string): zString;
  class operator Add(const A: string; const B: zString): zString;

  class operator GreaterThan(const A: zString; const B: zString): Boolean;
  class operator GreaterThan(const A: zString; const B: string): Boolean;
  class operator GreaterThan(const A: string; const B: zString): Boolean;


  class operator LessThan(const A: zString; const B: zString): Boolean;
  class operator LessThan(const A: zString; const B: string): Boolean;
  class operator LessThan(const A: string; const B: zString): Boolean;

  class function CompressString(const Value: string): TBytes; static;
  class function DecompressString(const CompressedData: TBytes): string; static;

  constructor Create(const Value: string);
  procedure Assign(const Value: zString);

  function CompressionPercentage: Double;
  function ToDouble: Double;
  function ToInteger: Integer;

  property Value: string read GetValue write SetValue;
  property CompressSize: longint read GetLength;
  property isCompressed: Boolean read FCompressed;
  property Length: longint read FOriginalLength;
 end;

implementation

class function zString.CompressString(const Value: string): TBytes;
begin
 Result := ZCompressStr(Value, TZCompressionLevel.zcMax); // default is max because why else?
end;

class function zString.DecompressString(const CompressedData: TBytes): string;
begin
 Result := ZDecompressStr(CompressedData);
end;

procedure zString.SetValue(const Value: string);
begin
 FOriginalLength:= Value.Length;
 FCompressedData := CompressString(Value);
 If System.Length(FCompressedData) > Value.Length then
 begin
  FCompressedData := TEncoding.Unicode.GetBytes(Value);
  FCompressed := false;
 end
 else
  FCompressed := true;
end;

function zString.GetValue: string;
begin
 if FCompressed then
  Result := DecompressString(FCompressedData)
 else
  Result := TEncoding.Unicode.GetString(FCompressedData);
end;

function zString.GetLength: longint;
begin
 Result := System.Length(FCompressedData);
end;

class operator zString.Implicit(const Value: string): zString;
begin
 Result.SetValue(Value);
end;

class operator zString.Implicit(const Value: zString): string;
begin
 Result := Value.GetValue;
end;

class operator zString.Equal(const A: zString; const B: zString): Boolean;
begin
 Result := A.GetValue = B;
end;

class operator zString.Equal(const A: zString; const B: string): Boolean;
begin
 Result := A.GetValue = B;
end;

class operator zString.Equal(const A: string; const B: zString): Boolean;
begin
 Result := A = B.GetValue;
end;

class operator zString.NotEqual(const A: zString; const B: zString): Boolean;
begin
 Result := A.GetValue <> B;
end;

class operator zString.NotEqual(const A: zString; const B: string): Boolean;
begin
 Result := A.GetValue <> B;
end;

class operator zString.NotEqual(const A: string; const B: zString): Boolean;
begin
 Result := A <> B.GetValue;
end;

class operator zString.Add(const A, B: zString): zString;
begin
 Result := zString(A.GetValue + B.GetValue);
end;

class operator zString.Add(const A: zString; const B: string): zString;
begin
 Result := zString(A.GetValue + B);
end;

class operator zString.Add(const A: string; const B: zString): zString;
begin
 Result := zString(A + B.GetValue);
end;

class operator zString.GreaterThan(const A, B: zString): Boolean;
begin
 Result := A.GetValue > B.GetValue;
end;

class operator zString.GreaterThan(const A: zString; const B: string): Boolean;
begin
 Result := A.GetValue > B;
end;

class operator zString.GreaterThan(const A: string; const B: zString): Boolean;
begin
 Result := A > B.GetValue;
end;

class operator zString.LessThan(const A, B: zString): Boolean;
begin
 Result := A.GetValue < B.GetValue;
end;

class operator zString.LessThan(const A: zString; const B: string): Boolean;
begin
 Result := A.GetValue < B;
end;

class operator zString.LessThan(const A: string; const B: zString): Boolean;
begin
 Result := A < B.GetValue;
end;

constructor zString.Create(const Value: string);
begin
 SetValue(Value);
end;

procedure zString.Assign(const Value: zString);
begin
 FCompressedData := Value.FCompressedData;
end;

function zString.ToDouble: Double;
begin
 Result := StrToFloat(GetValue);
end;

function zString.ToInteger: Integer;
begin
 Result := StrToInt(GetValue);
end;

function zString.CompressionPercentage: Double;
var
 OriginalSize: integer;
 CompressedSize: integer;
begin
 OriginalSize := System.Length(GetValue);
 CompressedSize := System.Length(FCompressedData);
 if OriginalSize = 0 then
  Exit(0.0);
 Result := ((OriginalSize - CompressedSize) / OriginalSize) * 100;
end;

end.
