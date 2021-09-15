unit fmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Tic80Backend;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    Button1: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Splitter1: TSplitter;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ComboBox1Change(Sender: TObject);
    procedure idle(Sender: TObject; var Done: Boolean);
  private
    { Private declarations }
  public
    MX,MY,MBl,MBr,MBc : Integer;
    MK : Integer;
    MT,MT2,mtTicCount, mtStable : integer;
    { Public declarations }
    procedure OnErrorProc(Msg: String);

    procedure drawRectEvent(x,y,w,h : single; filled : boolean; color : TTic80Color);
    procedure drawEllipseEvent(x,y,w,h : single; filled : boolean; color : TTic80Color);
    procedure askForElapsedTimeEvent(var secondFromStart : integer);
    procedure drawLineEvent(x,y,w,h : single; filled : boolean; color : TTic80Color);
    procedure askForSurfaceData(var width, height : integer);
    procedure askForMouseData(var x,y,leftB,centerB,rightB : integer);
    procedure askForKeyboardData(Tic80KeyCode : integer; var keyCode : integer);
    procedure drawTextEvent(aText : String; x,y : single; color : TTic80Color);


  end;

var
  Form1: TForm1;
  Tic80: TTic80Backend;

implementation

uses VerySimple.Lua.Lib;

{$R *.dfm}

procedure TForm1.askForElapsedTimeEvent(var secondFromStart: integer);
begin
  secondFromStart := GetTickCount;
end;

procedure TForm1.askForKeyboardData(Tic80KeyCode: integer;
  var keyCode: integer);
begin
  //...
end;

procedure TForm1.askForMouseData(var x, y, leftB, centerB, rightB: integer);
begin
  x := MX;
  y := MY;
  leftB := MBl;
  centerB := MBc;
  rightB := MBr;
end;

procedure TForm1.askForSurfaceData(var width, height: integer);
begin
  width := Image1.Picture.Bitmap.Width;
  height := Image1.Picture.Bitmap.Height;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Application.OnIdle := idle;

  if Assigned(Tic80) then
    FreeAndNil(Tic80);

  Tic80 := TTic80Backend.Create;
  Tic80.LibraryPath :=  ExtractFilePath(Application.ExeName)+'\'+LUA_LIBRARY;

  ComboBox1.Items.Text := Tic80.GetPaletteList;
  ComboBox1.ItemIndex := 0;
  ComboBox1Change(nil);

  Tic80.OnError := OnErrorProc;

  Tic80.OnDrawRect := drawRectEvent;
  Tic80.OnDataSystemSecondElapsedNeed := askForElapsedTimeEvent;
  Tic80.OnDataSurfaceNeeded := askForSurfaceData;
  Tic80.OnDrawLine := drawLineEvent;
  Tic80.OnDataMouse := askForMouseData;
  Tic80.OnDataKeyBoard := askForKeyboardData;
  Tic80.OnDrawText := drawTextEvent;
  Tic80.OnDrawEllipse := drawEllipseEvent;

  Tic80.LoadString(memo1.text);
  Tic80.Run;

  mt := TThread.GetTickCount;
  mt2 := mt;
  mtStable := 13;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
 end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if Assigned(Tic80) then
    Tic80.ApplyPalette(ComboBox1.Text);
end;

procedure TForm1.drawEllipseEvent(x, y, w, h: single; filled: boolean;
  color: TTic80Color);
var lcolor : TColor;
begin
  lcolor := RGB(color.R,color.G,color.B);
  Image1.Canvas.Brush.Style := TBrushStyle.bsClear;
  if filled then
  begin
    Image1.Canvas.Brush.Style := TBrushStyle.bsSolid;
    Image1.Canvas.Brush.Color := lColor;
  end;
  Image1.Canvas.pen.Color := lColor;
  Image1.Canvas.Ellipse(Round(x),Round(y),Round(x+w),Round(y+h));
end;

procedure TForm1.drawLineEvent(x, y, w, h: single; filled: boolean;
  color: TTic80Color);
var lcolor : TColor;
begin
  lcolor := RGB(color.R,color.G,color.B);
  Image1.Canvas.Pen.Color := lColor;
  Image1.Canvas.MoveTo(Round(x),Round(y));
  Image1.Canvas.LineTo(Round(w),Round(h));
end;

procedure TForm1.drawRectEvent(x, y, w, h: single; filled: boolean;
  color: TTic80Color);
var lcolor : TColor;
begin
  lcolor := RGB(color.R,color.G,color.B);
  Image1.Canvas.Brush.Style := TBrushStyle.bsClear;
  if filled then
  begin
    Image1.Canvas.Brush.Style := TBrushStyle.bsSolid;
    Image1.Canvas.Brush.Color := lColor;
  end;
  Image1.Canvas.pen.Color := lColor;
  Image1.Canvas.Rectangle(Round(x),Round(y),Round(x+w),Round(y+h));
end;

procedure TForm1.drawTextEvent(aText: String; x, y: single; color: TTic80Color);
var lcolor : TColor;
begin
  lcolor := RGB(color.R,color.G,color.B);
  Image1.Canvas.Pen.Color := lColor;
  Image1.Canvas.TextOut(Round(x),Round(y),aText);
end;

procedure TForm1.FormCreate(Sender: TObject);
var lb : TBitmap;
begin
  lb :=TBitmap.Create(240,136);
  lb.PixelFormat := TPixelFormat.pf32bit;
  Image1.Picture.Assign(lb);
end;

procedure tic80keymap(key : Word);
  { TODO : refactor all with :
    - a config system
    - able to handle multi key
    - able to handle id 1 to 4
    - able to do cover strange btnp api
    - see kdbInput.lua script
  }
//https://github.com/nesbox/TIC-80/wiki/key-map
//                                          UP    DW      LF      RG       Y A X B
Const mapid1 : Array[0..1,0..7] of word = ((vk_up,vk_down,vk_left,vk_right,0,0,0,0),(0,1,2,3,4,5,6,7));
var i : integer;
begin
  Form1.MK := -1;
  for i := 0 to 7 do
    if (mapid1[0][i] = key) then
      Form1.MK := mapid1[1][i];
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  tic80keymap(Key);
end;

procedure TForm1.idle(Sender: TObject; var Done: Boolean);
begin
  if (GetTickCount - mt>mtStable) then begin
     if assigned(Tic80) then
        Tic80.DoString('TIC()');
    mt := TThread.GetTickCount;
    inc(mtTicCount);
  end;

  if (GetTickCount - mt2>1000) then begin
    Caption := IntToStr(mtTicCount)+' ('+IntToStr(mtStable)+')';
    if mtTicCount<60 then
      dec(mtStable);
    if mtTicCount>70 then
      inc(mtStable);

    if mtStable<2 then
      mtStable := 2;

    mtTicCount := 0;
    mt2 := TThread.GetTickCount;
  end;

  done := false;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MBl := -1;
  MBr := -1;
  MBc := -1;
  if ssLeft in Shift then
    MBl := 1;
  if ssRight in Shift then
    MBr := 1;
  if ssMiddle in Shift then
    MBc := 1;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  MX := X;
  MY := Y;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MBl := -1;
  MBr := -1;
  MBc := -1;
end;

procedure TForm1.OnErrorProc(Msg: String);
begin
  ShowMessage('ERROR : '+msg);
end;

end.
