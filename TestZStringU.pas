unit TestZStringU;

interface

uses
 DUnitX.TestFramework,
 System.SysUtils,
 CompressedString;

const
 LoremIpsum: string = 'Lorem ipsum odor amet, consectetuer adipiscing elit. Nibh lacinia inceptos cras suspendisse etiam. ' +
      'Faucibus montes curae integer, in finibus volutpat. Ullamcorper maecenas per, lobortis aliquet hendrerit nibh. ' +
      'Sapien condimentum magna litora curae class quam condimentum. Vestibulum vehicula sem nullam; ' +
      'ultrices nisi consectetur luctus. Rhoncus ipsum gravida dictum lobortis conubia neque habitasse nam nam. ' +
      'Tempus odio pretium potenti rhoncus dui maecenas pharetra.' + sLineBreak + '' +
      'Aptent amet ligula ultricies sapien sagittis potenti vivamus. Porta aliquet metus; libero scelerisque fermentum condimentum dolor. '
      + 'Fringilla posuere mi vestibulum luctus taciti nisi inceptos. Penatibus rutrum leo nisl neque amet molestie pharetra efficitur. ' +
      'Laoreet class curae dignissim lectus aenean vitae parturient potenti fringilla. Sagittis nascetur molestie class netus finibus per sed. '
      + 'Rhoncus curabitur aenean mollis nascetur dictum molestie dis.' + sLineBreak + '' +
      'Nam ullamcorper aptent gravida neque conubia mollis torquent. Eget ex aliquam eleifend facilisis; torquent interdum himenaeos ad. ' +
      'Maximus nascetur sem ut himenaeos parturient sem sed! Aptent nulla sodales tristique nisi consequat quisque natoque. ' +
      'Scelerisque ipsum netus tempus nostra nisl consequat. Ultrices malesuada egestas semper orci mattis rutrum lectus nulla. ' +
      'Blandit volutpat natoque a augue ornare.' + sLineBreak + '' +
      'Integer morbi lorem accumsan tincidunt sollicitudin penatibus. Dis euismod pulvinar mauris faucibus lobortis commodo, pharetra placerat. '
      + 'Odio penatibus vulputate cursus nascetur lacus potenti posuere. Nullam primis volutpat sociosqu imperdiet curabitur. ' +
      'Ridiculus placerat varius sit consectetur bibendum enim semper. Facilisis nec libero eu pellentesque ultricies massa. ' +
      'Feugiat lectus efficitur ipsum cubilia condimentum.' + sLineBreak + '' +
      'Pretium quis urna volutpat magnis sodales bibendum. Augue sed blandit diam; commodo erat ullamcorper. ' +
      'Congue ligula laoreet curabitur urna odio dignissim litora. Nostra sit suscipit donec mauris, aptent dis mi. ' +
      'Cras elit urna hendrerit molestie tristique volutpat amet. Dis habitasse consectetur suscipit mi diam; nisl ornare accumsan torquent. '
      + 'Finibus vitae urna cras quis senectus convallis.';

type

 [TestFixture]
 TTestZString = class
 public
  [Test]
  procedure TestImplicitConversion_StringToZString;

  [Test]
  procedure TestImplicitConversion_ZStringToString;

  [Test]
  procedure TestImplicitConversion_ZStringToZString;

  [Test]
  procedure TestEquality_ZStringAndStringEqual;

  [Test]
  procedure TestEquality_StringAndZStringEqual;

  [Test]
  procedure TestInequality_ZStringAndStringNotEqual;

  [Test]
  procedure TestInequality_StringAndZStringNotEqual;

  [Test]
  procedure TestToDouble;

  [Test]
  procedure TestCompressionPercentage;

  [Test]
  procedure TestCompressionSize;

  [Test]
  procedure TestCompressionIsCompressed;

  [Test]
  procedure TestCompressionIsNotCompressed;

 end;

implementation

procedure TTestZString.TestImplicitConversion_StringToZString;
var
 original: string;
 zStr: zString;
begin
 original := LoremIpsum;
 zStr := original; // Implicit conversion from string to zString
 Assert.AreEqual<string>(original, zStr.Value, 'Implicit conversion from string to zString failed');
end;

procedure TTestZString.TestImplicitConversion_ZStringToString;
var
 original: string;
 zStr: zString;
 convertedBack: string;
begin
 original := LoremIpsum;
 zStr := zString.Create(original);
 convertedBack := zStr; // Implicit conversion from zString to string
 Assert.AreEqual<string>(original, convertedBack, 'Implicit conversion from zString to string failed');
end;

procedure TTestZString.TestImplicitConversion_ZStringToZString;
var
 original: zString;
 zStr: zString;
begin
 original := LoremIpsum;
 zStr := LoremIpsum;
 Assert.IsTrue(original = zStr);
end;

procedure TTestZString.TestEquality_ZStringAndStringEqual;
var
 original: string;
 zStr: zString;
begin
 original := LoremIpsum;
 zStr := zString.Create(original);
 Assert.IsTrue(zStr = original, 'Equality check between zString and string failed');
end;

procedure TTestZString.TestEquality_StringAndZStringEqual;
var
 original: string;
 zStr: zString;
begin
 original := LoremIpsum;
 zStr := zString.Create(original);
 Assert.IsTrue(original = zStr, 'Equality check between string and zString failed');
end;

procedure TTestZString.TestInequality_ZStringAndStringNotEqual;
var
 original: string;
 zStr: zString;
begin
 original := LoremIpsum;
 zStr := zString.Create('Different content');
 Assert.IsTrue(zStr <> original, 'Inequality check between zString and string failed');
end;

procedure TTestZString.TestInequality_StringAndZStringNotEqual;
var
 original: string;
 zStr: zString;
begin
 original := LoremIpsum;
 zStr := zString.Create('Different content');
 Assert.IsTrue(original <> zStr, 'Inequality check between string and zString failed');
end;

procedure TTestZString.TestToDouble;
var
 zStr: zString;
 doubleValue: Double;
begin
 zStr := zString.Create('123.45');
 doubleValue := zStr.ToDouble;
 Assert.IsTrue(Abs(doubleValue - 123.45) < 0.01, 'ToDouble conversion failed');
end;

procedure TTestZString.TestCompressionPercentage;
var
 original: zString;
 expectedPercentage: Double;
 actualPercentage: Double;
begin
 original := zString.Create(LoremIpsum);
 expectedPercentage := 42.6648096564531;
 actualPercentage := original.CompressionPercentage;
 Assert.AreEqual(expectedPercentage, actualPercentage);
end;

procedure TTestZString.TestCompressionSize;
var
 original: zString;
 expectedSize: Double;
 actualSize: Double;
begin
 original := zString.Create(LoremIpsum);
 expectedSize := 1235;
 actualSize := original.CompressSize;
 Assert.AreEqual(expectedSize, actualSize);
end;

procedure TTestZString.TestCompressionIsCompressed;
var
 original: string;
 zStr: zString;
begin
 original := LoremIpsum;
 zStr := original;
 Assert.IsTrue(zStr.isCompressed);
end;

procedure TTestZString.TestCompressionIsNotCompressed;
var
 original: string;
 zStr: zString;
begin
 original := 'This is a short string';
 zStr := original;
 Assert.IsFalse(zStr.isCompressed);
end;

initialization

TDUnitX.RegisterTestFixture(TTestZString);

end.
