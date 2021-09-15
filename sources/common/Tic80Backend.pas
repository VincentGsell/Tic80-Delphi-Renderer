///
/// Tic-80 tiny computer pascal rendered backend
/// https://tic80.com/
/// Vincent Gsell - 2018
///
/// Dependancy : VerySimple.Lua by Dennis D. Spreen (http://blog.spreendigital.de/)
///
unit Tic80Backend;

interface

Uses SysUtils,
     Classes,
     VerySimple.Lua,
     VerySimple.Lua.Lib;

Type
  TPaletteItem = record
    code : string;
    data : string;
  end;

  TPaletteData = array[0..14] of TPaletteItem;


Const
  GLB_PALETTES_DATA : TPaletteData =   (
                                        (code:'DB16'; data:'140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6'),
                                        (code:'SWEETIE-16'; data:'1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7333c57566c8694b0c2f4f4f4'),
                                        (code:'PICO-8'; data:'0000007e25531d2b535f574fab5236008751ff004d83769cff77a8ffa300c2c3c700e756ffccaa29adfffff024fff1e8'),
                                        (code:'ARNE16'; data:'0000001b2632005784493c2ba4642244891abe26332f484e31a2f2eb89319d9d9da3ce27e06f8bb2dceff7e26bffffff'),
                                        (code:'EDG16'; data:'193d3f3f2832743f399e2835b86f50327345e53b444f67810484d1fb922bafbfd263c64de4a6722ce8f4ffe762ffffff'),
                                        (code:'A64'; data:'0000004c3435313a9148545492562b509450b148638080787655a28385cf9cabb19ccc47cd93738fbfd5bbc840ede6c8'),
                                        (code:'C64'; data:'00000057420040318d5050508b542955a0498839327878788b3f967869c49f9f9f94e089b8696267b6bdbfce72ffffff'),
                                        (code:'VIC20';data:'000000772d2642348ba85fb4b668627e70caa8734a559e4ae99df5e9b287bdcc7185d4dc92df87c5ffffffffb0ffffff'),
                                        (code:'CGA';data:'000000aa00000000aa555555aa550000aa00ff5555aaaaaa5555ffaa00aa00aaaa55ff55ff55ff55ffffffff55ffffff'),
                                        (code:'SLIFE';data:'0000001226153f28117a2222513155d13b27286fb85d853acc8218e07f8a9b8bff68c127c7b581b3e868a8e4d4ffffff'),
                                        (code:'JMP';data:'000000191028833129453e78216c4bdc534b7664fed365c846af45e18d79afaab9d6b97b9ec2e8a1d685e9d8a1f5f4eb'),
                                        (code:'CGARNE';data:'0000002234d15c2e788a36225e606e0c7e45e23d69aa5c3d4c81fb44aacceb8a60b5b5b56cd9477be2f9ffd93fffffff'),
                                        (code:'PSYG';data:'0000001b1e29003308362747084a3c443f41a2324e52524c546a0073615064647c516cbf77785be08b799ea4a7cbe8f7'),
                                        (code:'EROGE';data:'0d080d2a23494f2b247d384032535f825b314180a0c16c5bc591547bb24e74adbbe89973bebbb2f0bd77fbdf9bfff9e4'),
                                        (code:'EISLAND';data:'051625794765686086567864ca657e8686918184abcc8d867ea78839d4b98dbcd29dc085edc38de6d1d1f5e17af6f6bf')
                                        );

Type
  TTic80ColorMode = (colorPalette16,colorGrayMode);

  TTic80Color = Record
    R,G,B : Byte;
  End;


  TTic80PlatformEventDebug = procedure(debugTxt : String) of Object;
  TTic80PlatformEventDrawRectShape = procedure(x,y,w,h : single; filled : boolean; color : TTic80Color) of Object;
  TTic80PlatformEventDrawText = procedure(aText : String; x,y : single; color : TTic80Color) of Object;
  TTic80PlatformEventSurfaceData = procedure(var width, height : integer) of Object;
  TTic80PlatformEventSystemSecondElapsed = procedure(var secondFromStart : integer) of Object;
  TTic80PlatformEventMouseData = procedure(var x,y,leftB,centerB,rightB : integer) of Object;
  TTic80PlatformEventKeyBoardData =  procedure(Tic80KeyCode : integer; var keyCode : integer) of Object;

  TTic80Backend = class(TVerySimpleLua)
  private
    FStart : Integer;
    FFactorX,FFactorY : single;
    FPalette : Array[0..15] of TTic80Color;
    FColorMode : TTic80ColorMode;
    FOnDrawEllipse: TTic80PlatformEventDrawRectShape;
    FOnDrawRect: TTic80PlatformEventDrawRectShape;
    FOnSurfaceDataNeed: TTic80PlatformEventSurfaceData;
    FOnSystemSecElapsed: TTic80PlatformEventSystemSecondElapsed;
    FOnDebug: TTic80PlatformEventDebug;
    FOnDrawLine: TTic80PlatformEventDrawRectShape;
    FOnDataMouse: TTic80PlatformEventMouseData;
    FOnDataKeyb: TTic80PlatformEventKeyBoardData;
    FOnDrawPixel: TTic80PlatformEventDrawRectShape;
    FonDrawText: TTic80PlatformEventDrawText;
    function InternalPaletteValue(aTic80Color : integer) : TTic80Color;
    function InternalSurfaceWidth : integer;
    function InternalSurfaceHeight : integer;
    function InternalSystemSecondElapsed : integer;
    procedure InternalLoadPalette(paletteName : String);

  Public
    Constructor Create; override;

    Procedure ApplyPalette(paletteName : String);
    function GetPaletteList : String;

    property FactorX : Single read FFactorX Write FFactorX;
    property FactorY : Single read FFactorY Write FFactorY;

    property OnDrawEllipse : TTic80PlatformEventDrawRectShape read FOnDrawEllipse write FOnDrawEllipse;
    property OnDrawRect : TTic80PlatformEventDrawRectShape read FOnDrawRect write FOnDrawRect;
    property OnDrawLine : TTic80PlatformEventDrawRectShape read FOnDrawLine write FOnDrawLine;
    property OnDrawPixel : TTic80PlatformEventDrawRectShape read FOnDrawPixel write FOnDrawPixel;
    property OnDrawText : TTic80PlatformEventDrawText read FonDrawText write FOnDrawText;
    property OnDataSurfaceNeeded : TTic80PlatformEventSurfaceData read FOnSurfaceDataNeed write FOnSurfaceDataNeed;
    property OnDataSystemSecondElapsedNeed : TTic80PlatformEventSystemSecondElapsed read FOnSystemSecElapsed write FOnSystemSecElapsed;
    property OnDebug : TTic80PlatformEventDebug read FOnDebug Write FOnDebug;
    property OnDataMouse : TTic80PlatformEventMouseData read FOnDataMouse write FOnDataMouse;
    property OnDataKeyBoard : TTic80PlatformEventKeyBoardData read FOnDataKeyb write FOnDataKeyb;

  published //Rtti lua access.
    function cls(LuaState: Lua_State): Integer;
    function rect(LuaState: Lua_State): Integer;
    function rectb(LuaState: Lua_State): Integer;
    function line(LuaState: Lua_State): Integer;
    function circ(LuaState: Lua_State): Integer;
    function debug(LuaState: Lua_State): Integer;
    function mouse(LuaState: Lua_State): Integer;
    function print(LuaState: Lua_State): Integer;
    function pix(LuaState: Lua_State): Integer;
    function btn(LuaState: Lua_State): Integer;
    function time(LuaState: Lua_State): Integer;
  end;




implementation

{ TTic80Backend }

procedure TTic80Backend.ApplyPalette(paletteName: String);
begin
  InternalLoadPalette(paletteName);
end;

function TTic80Backend.btn(LuaState: Lua_State): Integer;
var lkeyCode,lKC : integer;
    lv : Boolean;
begin
  lKeyCode := Lua_ToInteger(LuaState, 1);
  if Assigned(FOnDataKeyb) then
    FOnDataKeyb(lKeyCode, lKc);
  lv := lKeyCode = lkC;
  lua_pushboolean(LuaState, Integer(lv));
  result := 1;
end;

function TTic80Backend.circ(LuaState: Lua_State): Integer;
var x,y,rx,ry : Single;
    c : Integer;
begin
  x := Lua_ToNumber(LuaState, 1) * FFactorX;
  y := Lua_ToNumber(LuaState, 2) * FFactorY;
  rx := Lua_ToNumber(LuaState, 3) * FFactorX;
  ry := Lua_ToNumber(LuaState, 3) * FFactorY;
  c := Lua_ToInteger(LuaState, 4);
  if Assigned(FOnDrawEllipse) then
    FOnDrawEllipse(x-rx/2,y-ry/2,rx,ry,false,InternalPaletteValue(c));
end;

function TTic80Backend.cls(LuaState: Lua_State): Integer;
var c : Integer;
begin
  c := Lua_ToInteger(LuaState, 1);
  if Assigned(FOnDrawRect) then
    FOnDrawRect(0,0,InternalSurfaceWidth, InternalSurfaceHeight,true,InternalPaletteValue(c));
end;

constructor TTic80Backend.Create;
var i : integer;
begin
  inherited;
  FStart := InternalSystemSecondElapsed;
  FFactorX := 1.0;
  FFactorY := 1.0;
  FColorMode := TTic80ColorMode.colorPalette16;

  //Sweetie 16 hardcoded palette;
  InternalLoadPalette('SWEETIE-16');
  //InternalLoadPalette('DB16');
end;

function TTic80Backend.debug(LuaState: Lua_State): Integer;
begin
  if Assigned(FOnDebug) then
    FOnDebug(Lua_ToString(LuaState, 1));
end;

function TTic80Backend.GetPaletteList: String;
var l : TStringList;
    i : integer;
begin
  l := TStringList.Create;
  try
    for I := 0 to Length(GLB_PALETTES_DATA)-1 do
      l.Add(GLB_PALETTES_DATA[i].code);
    result := l.Text;
  finally
    FreeAndNil(l);
  end;
end;

procedure TTic80Backend.InternalLoadPalette(paletteName: String);
var i,j : integer;
    ls : string;
begin
  for j := 0 to Length(GLB_PALETTES_DATA)-1 do
    if GLB_PALETTES_DATA[j].code = paletteName then
    begin
      for i := 0 to 15 do
      begin
        ls := Copy(GLB_PALETTES_DATA[j].data,1+i*6,6);
        FPalette[i].R := StrToInt('$'+copy(ls,1,2));
        FPalette[i].G := StrToInt('$'+copy(ls,3,2));
        FPalette[i].B := StrToInt('$'+copy(ls,5,2));
      end;
      Break;
    end;
end;

function TTic80Backend.InternalPaletteValue(aTic80Color : integer): TTic80Color;
var lc : integer;
begin
  lc := aTic80Color;
  if (aTic80Color<0) or (aTic80Color>15) then
    lc := 8; //Default.

  case FcolorMode of
    TTic80ColorMode.colorPalette16 : result := FPalette[lc];
    TTic80ColorMode.colorGrayMode  :
    begin
      result.R := 15*lc;
      result.G := 15*lc;
      result.B := 15*lc;
    end;
  end;
end;

function TTic80Backend.InternalSurfaceWidth: integer;
var w,h : integer;
begin
  w := 640;
  h := 480;
  if Assigned(FOnSurfaceDataNeed) then
    FOnSurfaceDataNeed(w,h);
  result := w;
end;

function TTic80Backend.InternalSurfaceHeight: integer;
var w,h : integer;
begin
  w := 640;
  h := 480;
  if Assigned(FOnSurfaceDataNeed) then
    FOnSurfaceDataNeed(w,h);
  result := h;
end;


function TTic80Backend.InternalSystemSecondElapsed: integer;
begin
  result:=0;
  if Assigned(FOnSystemSecElapsed) then
    FOnSystemSecElapsed(result);
end;


function TTic80Backend.line(LuaState: Lua_State): Integer;
var x,y,xx,yy : single;
    c : integer;
begin
  x := lua_tonumber(LuaState, 1) * FFactorX;
  y := lua_tonumber(LuaState, 2) * FFactorY;
  xx := lua_tonumber(LuaState, 3) * FFactorX;
  yy := lua_tonumber(LuaState, 4) * FFactorY;
  c := lua_tointeger(LuaState, 5);

  if Assigned(FOnDrawLine) then
    FOnDrawLine(x,y,xx,yy,false,InternalPaletteValue(c));

//  FContext.Image.Canvas.Pen.Color := InternalPaletteValue(c);
//  FContext.Image.Canvas.MoveTo(round(x),round(y));
//  FContext.Image.Canvas.LineTo(round(xx),round(yy));
end;

function TTic80Backend.mouse(LuaState: Lua_State): Integer;
var ix,iy,iml,imc,imr : integer;
    lx, ly : Single;
begin
//x : x coordinate of the mouse pointer
//y : y coordinate of the mouse pointer
//left : left button is down (true/false)
//middle : middle button is down (true/false)
//right : right button is down (true/false)
//scrollx : x scroll delta since last frame (-31..32)
//scrolly : y scroll delta since last frame (-31..32)
  if Assigned(FOnDataMouse) then
    FOnDataMouse(ix,iy,iml,imc,imr);

  lx := ix;
  if FFactorX<>0 then
    lx := lx / FFactorX;
  ly := iy;
  if FFactorY<>0 then
    ly := ly / FFactorY;
  Lua_PushInteger(LuaState, Round(lx));
  Lua_PushInteger(LuaState, Round(ly));
  Lua_PushInteger(LuaState, Integer(iml));
  Lua_PushBoolean(LuaState, Integer(imc=1));
  Lua_PushBoolean(LuaState, Integer(imr=1));
  Lua_PushBoolean(LuaState, Integer(0));
  Result := 6;
end;

function TTic80Backend.pix(LuaState: Lua_State): Integer;
var x,y : single;
    c : integer;
begin
  x := lua_tonumber(LuaState, 2) * FFactorX;
  y := lua_tonumber(LuaState, 3) * FFactorY;
  c := Lua_ToInteger(LuaState, 3);
  if Assigned(FOnDrawPixel) then
    FOnDrawPixel(x,y,0,0,False,InternalPaletteValue(c));
//  FContext.Image.Canvas.Pixels[Round(x),round(y)] := InternalPaletteValue(c);
end;

function TTic80Backend.print(LuaState: Lua_State): Integer;
var x,y : single;
    s : String;
    c : integer;
begin
  s := lua_tostring(LuaState, 1);
  x := lua_tonumber(LuaState, 2) * FFactorX;
  y := lua_tonumber(LuaState, 3) * FFactorY;
  c := lua_tointeger(LuaState, 4);

  if Assigned(FonDrawText) then
    FonDrawText(s,x,y,InternalPaletteValue(c));
//  FContext.Image.Canvas.pen.Color := InternalPaletteValue(c);
//  FContext.Image.Canvas.TextOut(round(x),round(y),s);
end;

function TTic80Backend.rect(LuaState: Lua_State): Integer;
var x,y,w,h : single;
    c : integer;
begin
  x := lua_tonumber(LuaState, 1) * FFactorX;
  y := lua_tonumber(LuaState, 2) * FFactorY;
  w := lua_tonumber(LuaState, 3) * FFactorX;
  h := lua_tonumber(LuaState, 4) * FFactorY;
  c := lua_tointeger(LuaState, 5);

  if Assigned(FOnDrawRect) then
    FOnDrawRect(x,y,w,h,true,InternalPaletteValue(c));
end;

function TTic80Backend.rectb(LuaState: Lua_State): Integer;
var x,y,w,h : single;
    c : integer;
begin
  x := lua_tonumber(LuaState, 1) * FFactorX;
  y := lua_tonumber(LuaState, 2) * FFactorY;
  w := lua_tonumber(LuaState, 3) * FFactorX;
  h := lua_tonumber(LuaState, 4) * FFactorY;
  c := lua_tointeger(LuaState, 5);
  if Assigned(FOnDrawRect) then
    FOnDrawRect(x,y,w,h,false,InternalPaletteValue(c));
end;


function TTic80Backend.time(LuaState: Lua_State): Integer;
begin
  Lua_PushInteger(LuaState, InternalSystemSecondElapsed-FStart);
  result := 1;
end;


end.
