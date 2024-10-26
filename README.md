# zString v1.1

Compress strings using zLib on the fly.

Tested in Delphi 11.3+

Build and Install `CompressedStringPkg.dpk`

Add path to source code in Search Path or Library Path.

## Example Usage

```delphi
var
  s: zString;
  x: double;
begin
  s := 'this is a short string'; // this will not compress as it's just too small
  ShowMessage(s);
  ShowMessage('Short zString Length = ' + s.Length.ToString); // shows 22
  ShowMessage('Short zString CompressSize = ' + s.CompressSize.ToString); // shows 44 (2 bytes per unicode char)
  ShowMessage('Short zString CompressionPercentage = ' + s.CompressionPercentage.ToString); // -100, it did not compress

  case s.IsCompressed of
    true: ShowMessage('compressed');
    false: ShowMessage('not compressed'); // should be not compressed
  end;

  s := LoremIpsum; // this will compress as it is pretty big
  ShowMessage(s);
  ShowMessage('Long zString Length = ' + s.Length.ToString); // 2154
  ShowMessage('Long zString CompressSize = ' + s.CompressSize.ToString); // Compressed down to 1235, LoremIpsum is 2154
  ShowMessage('Long zString CompressionPercentage = ' + s.CompressionPercentage.ToString); // Compressed by 42.6648096564531%

  case s.IsCompressed of
    true: ShowMessage('compressed'); // should be compressed
    false: ShowMessage('not compressed');
  end;

  s := '123.45';
  x := s.ToDouble;
  ShowMessage(x.ToString); // should show 123.45

  s := '123';
  x := s.ToInteger;
  ShowMessage(x.ToString); // should show 123
end;
```
### Thanks to Luka @ https://github.com/havrlisan for coming up with the debugger visualizer!
