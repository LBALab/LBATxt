unit Utils;

interface

uses Windows;

//result is in microseconds
function MeasureTime(var Cnt: Int64; Start: Boolean): Int64;

implementation

function MeasureTime(var Cnt: Int64; Start: Boolean): Int64;
var freq, c: Int64;
begin
 QueryPerformanceCounter(c); //Zakoñczenie pomiaru
 Result:= -1;
 if QueryPerformanceFrequency(freq) and (freq > 0) then begin //Licznik istnieje
   Result:= ((c - Cnt) * 1000000) div freq;
   if Start then QueryPerformanceCounter(Cnt); //Rozpoczêcie pomiaru
 end;
end;

end.
 