unit DebuggerVisualizerZString;

interface

uses
 System.SysUtils,
 System.Character,
 ToolsAPI;

type
 TDebuggerVisualizerZString = class(TInterfacedObject, IOTADebuggerVisualizer, IOTADebuggerVisualizerValueReplacer)
 protected type
  EDebuggerVisualizerZString = class(Exception)
  end;

 strict private
  function DecompressZString(const AStr: string): String;
 protected
  { IOTADebuggerVisualizer }
  function GetSupportedTypeCount: Integer;
  procedure GetSupportedType(Index: Integer; var TypeName: string; var AllDescendants: Boolean); overload;
  function GetVisualizerIdentifier: string;
  function GetVisualizerName: string;
  function GetVisualizerDescription: string;
  { IOTADebuggerVisualizerValueReplacer }
  function GetReplacementValue(const Expression, TypeName, EvalResult: string): string;

 strict private
  class var FInstance: IOTADebuggerVisualizer;
  class destructor ClassDestroy;
 public
  class procedure Register; static;
 end;

procedure Register;

implementation

uses
 CompressedString;

procedure Register;
begin
 TDebuggerVisualizerZString.Register;
end;

type
{$SCOPEDENUMS ON}
 TTypeLang = (Delphi, Cpp);
{$SCOPEDENUMS OFF}

 TVisualizerType = record
  TypeName: string;
  TypeLang: TTypeLang;
 end;

const
 CVisualizerTypes: array [0 .. 4] of TVisualizerType = (

      (TypeName: 'zString'; TypeLang: TTypeLang.Delphi),

      (TypeName: 'function: zString'; TypeLang: TTypeLang.Delphi),

      (TypeName: 'System::zString'; TypeLang: TTypeLang.Cpp),

      (TypeName: 'System::zString &'; TypeLang: TTypeLang.Cpp),

      (TypeName: 'zString &'; TypeLang: TTypeLang.Cpp)

      );

resourcestring
 SVisualizerName = 'zString Visualizer for Delphi';
 SVisualizerDesc = 'Displays zString properly instead of compressed string';

 { TDebuggerVisualizerZString }

function TDebuggerVisualizerZString.DecompressZString(const AStr: string): String;

 function GetUIntValue(const ABuffer: String; const AMaxValue: Cardinal): Cardinal;
 begin
  Result := StrToUInt(ABuffer);
  if Result > AMaxValue then
   raise EDebuggerVisualizerZString.Create('Invalid zString representation');
 end;

const
 CFieldName = 'FCompressedData:';
 CIgnoredChars = ['(', ',', ')', ' '];
var
 LBytes: TBytes;
begin
 var
 LResult := AStr;
 { delete ZString brackets }
 Delete(LResult, 1, 1);
 Delete(LResult, Length(LResult), 1);
 { in case the EvalResult is written like (FCompressedData:....) }
 if LResult.StartsWith(CFieldName) then
  Delete(LResult, 1, Length(CFieldName));
 SetLength(LBytes, LResult.CountChar(',') + 1);
 var
 LBytesIdx := 0;
 var
 LBuffer := String.Empty;
 var
 I := 1;
 try
  while I <= LResult.Length do
   if CharInSet(LResult[I], CIgnoredChars) then
   begin
    if not LBuffer.IsEmpty then
    begin
     var
     LByte := Byte(GetUIntValue(LBuffer, Byte.MaxValue));
     LBytes[LBytesIdx] := LByte;
     Inc(LBytesIdx);
     LBuffer := String.Empty;
    end;
    Inc(I);
   end else if LResult[I].IsNumber then
   begin
    LBuffer := LBuffer + LResult[I];
    Inc(I);
   end
   else
    raise EDebuggerVisualizerZString.Create('Invalid zString representation');
  Result := Format('''%s''', [zString.DecompressString(LBytes)]);
 except
  on E: Exception do
   Result := AStr;
 end;
end;

function TDebuggerVisualizerZString.GetSupportedTypeCount: Integer;
begin
 Result := Length(CVisualizerTypes);
end;

procedure TDebuggerVisualizerZString.GetSupportedType(Index: Integer; var TypeName: string; var AllDescendants: Boolean);
begin
 TypeName := CVisualizerTypes[Index].TypeName;
 AllDescendants := False;
end;

function TDebuggerVisualizerZString.GetVisualizerIdentifier: string;
begin
 Result := ClassName;
end;

function TDebuggerVisualizerZString.GetVisualizerName: string;
begin
 Result := SVisualizerName;
end;

function TDebuggerVisualizerZString.GetVisualizerDescription: string;
begin
 Result := SVisualizerDesc;
end;

function TDebuggerVisualizerZString.GetReplacementValue(const Expression, TypeName, EvalResult: string): string;
begin
 var
 Lang := TTypeLang(-1);
 for var LVisualizerType in CVisualizerTypes do
  if TypeName = LVisualizerType.TypeName then
  begin
   Lang := LVisualizerType.TypeLang;
   Break;
  end;
 if Lang = TTypeLang.Delphi then
  Result := DecompressZString(EvalResult)
 else if Lang = TTypeLang.Cpp then
 begin
  { not implemented }
  Result := EvalResult;
 end;
end;

class destructor TDebuggerVisualizerZString.ClassDestroy;
var
 LDebuggerServices: IOTADebuggerServices;
begin
 if Assigned(FInstance) and Supports(BorlandIDEServices, IOTADebuggerServices, LDebuggerServices) then
 begin
  LDebuggerServices.UnregisterDebugVisualizer(FInstance);
  FInstance := nil;
 end;
end;

class procedure TDebuggerVisualizerZString.Register;
var
 LDebuggerServices: IOTADebuggerServices;
begin
 if (FInstance = nil) and Supports(BorlandIDEServices, IOTADebuggerServices, LDebuggerServices) then
 begin
  FInstance := TDebuggerVisualizerZString.Create;
  (BorlandIDEServices as IOTADebuggerServices).RegisterDebugVisualizer(FInstance);
 end;
end;

end.
