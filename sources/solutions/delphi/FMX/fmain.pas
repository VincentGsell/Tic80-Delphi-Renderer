unit fmain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Memo.Types, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  Tic80BackEnd, FMX.Objects, FMX.ListBox;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Button2: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
    MX,MY : Integer;
    MBl,MBr,MBc : Integer;
    MK : Integer;
    mt,mt2,mtTicCount,mtStable : Integer;

    procedure IsDialogKey(const Key: Word;
                          const KeyChar: WideChar;
                          const Shift: TShiftState;
                          var IsDialog: boolean); Override;
  public
    { Public declarations }
    procedure OnErrorProc(Msg: String);

    procedure idle(Sender: TObject; var Done: Boolean);
    procedure drawRectEvent(x,y,w,h : single; filled : boolean; color : TTic80Color);
    procedure drawLineEvent(x,y,w,h : single; filled : boolean; color : TTic80Color);
    procedure askForElapsedTimeEvent(var secondFromStart : integer);
    procedure askForSurfaceData(var width, height : integer);
    procedure askForMouseData(var x,y,leftB,centerB,rightB : integer);
    procedure askForKeyboardData(Tic80KeyCode : integer; var keyCode : integer);
    procedure drawTextEvent(aText : String; x,y : single; color : TTic80Color);
    procedure drawEllipseEvent(x,y,w,h : single; filled : boolean; color : TTic80Color);
  end;

var
  Form2: TForm2;
  Tic80: TTic80Backend;

implementation

uses VerySimple.Lua.Lib;


{$R *.fmx}

procedure TForm2.askForElapsedTimeEvent(var secondFromStart: integer);
begin
  secondFromStart := TThread.GetTickCount;
end;



function tic80keymap(key : Word) : Integer;
  { TODO : refactor all with :
    - a config system
    - able to handle multi key
    - able to handle id 1 to 4
    - able to do cover strange btnp api
    - see kdbInput.lua script
  }
//https://github.com/nesbox/TIC-80/wiki/key-map
//                                          UP DW LF RG Y A X B
Const mapid1 : Array[0..1,0..7] of word = ((38,40,37,39,0,0,0,0),(0,1,2,3,4,5,6,7));
var i : integer;
begin
  result := -1;
  for i := 0 to 7 do
    if (mapid1[0][i] = key) then
      result := mapid1[1][i];
end;



procedure TForm2.IsDialogKey(const Key: Word; const KeyChar: WideChar;
  const Shift: TShiftState; var IsDialog: boolean);
begin
  inherited;
  MK := Key;
end;

procedure TForm2.askForKeyboardData(Tic80KeyCode: integer;
  var keyCode: integer);
var l : integer;
begin
  l := tic80KeyMap(MK);
  if l>-1 then
  begin
    KeyCode := l;
  end;
end;

procedure TForm2.askForMouseData(var x, y, leftB, centerB, rightB: integer);
begin
  x := MX;
  y := MY;
  leftB := MBl;
  rightB := MBr;
  centerB := MBc;
end;

procedure TForm2.askForSurfaceData(var width, height: integer);
begin
  width := Image1.Bitmap.Width;
  height := Image1.Bitmap.Height;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Image1.DisableInterpolation := true;
  Application.OnIdle := nil;
  if Assigned(Tic80) then
    FreeAndNil(Tic80);
  Tic80 := TTic80Backend.Create;
  Tic80.LibraryPath := LUA_LIBRARY;

  ComboBox1.Items.Text := Tic80.GetPaletteList;
  ComboBox1.ItemIndex := 0;

  Tic80.OnDrawRect := drawRectEvent;
  Tic80.OnDataSystemSecondElapsedNeed := askForElapsedTimeEvent;
  Tic80.OnDataSurfaceNeeded := askForSurfaceData;
  Tic80.OnDrawLine := drawLineEvent;
  Tic80.OnDataMouse := askForMouseData;
  Tic80.OnDataKeyBoard := askForKeyboardData;
  Tic80.OnDrawText := drawTextEvent;
  Tic80.OnDrawEllipse := drawEllipseEvent;
  Tic80.OnError := OnErrorProc;

  Tic80.LoadString(Memo1.Lines.Text);
  Tic80.Run;

  mt := TThread.GetTickCount;
  mt2 := mt;
  mtStable := 13;


  Application.OnIdle := idle;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
  if Assigned(Tic80) then
    if Assigned(ComboBox1.Selected) then
      Tic80.ApplyPalette(ComboBox1.Selected.Text);
end;

procedure TForm2.drawEllipseEvent(x, y, w, h: single; filled: boolean;
  color: TTic80Color);
var l : TAlphaColor;
begin
  if Image1.Bitmap.Canvas.BeginScene then
  begin
    TAlphaColorRec(l).R := Color.R;
    TAlphaColorRec(l).G := Color.G;
    TAlphaColorRec(l).B := Color.B;
    TAlphaColorRec(l).A := 255;
    if filled then begin
      Image1.Bitmap.Canvas.Fill.Color := l;
      Image1.Bitmap.Canvas.FillEllipse(rectf(x,y,x+w,y+h),1.0);
    end
    else
    begin
      Image1.Bitmap.Canvas.Stroke.Color := l;
      Image1.Bitmap.Canvas.DrawEllipse(rectf(x,y,x+w,y+h),1.0);
    end;
    Image1.Bitmap.Canvas.EndScene;
  end;
end;

procedure TForm2.drawLineEvent(x, y, w, h: single; filled: boolean;
  color: TTic80Color);
var l : TAlphaColor;
begin
  if Image1.Bitmap.Canvas.BeginScene then
  begin
    TAlphaColorRec(l).R := Color.R;
    TAlphaColorRec(l).G := Color.G;
    TAlphaColorRec(l).B := Color.B;
    TAlphaColorRec(l).A := 255;
    Image1.Bitmap.Canvas.Stroke.Color := l;
    Image1.Bitmap.Canvas.DrawLine(PointF(x,y),pointf(w,h),1.0);
    Image1.Bitmap.Canvas.EndScene;
  end;
end;

procedure TForm2.drawRectEvent(x, y, w, h: single; filled: boolean;
  color: TTic80Color);
var l : TAlphaColor;
begin
  if Image1.Bitmap.Canvas.BeginScene then
  begin
    TAlphaColorRec(l).R := Color.R;
    TAlphaColorRec(l).G := Color.G;
    TAlphaColorRec(l).B := Color.B;
    TAlphaColorRec(l).A := 255;
    if filled then begin
      Image1.Bitmap.Canvas.Fill.Color := l;
      Image1.Bitmap.Canvas.FillRect(rectf(x,y,x+w,y+h),0,0,[],1.0,TCornerType.Round);
    end
    else
    begin
      Image1.Bitmap.Canvas.Stroke.Color := l;
      Image1.Bitmap.Canvas.DrawRect(rectf(x,y,x+w,y+h),0,0,[],1.0,TCornerType.Round);
    end;
    Image1.Bitmap.Canvas.EndScene;
  end;
end;

procedure TForm2.drawTextEvent(aText: String; x, y: single; color: TTic80Color);
var l : TAlphaColor;
begin
  if Image1.Bitmap.Canvas.BeginScene then
  begin
    TAlphaColorRec(l).R := Color.R;
    TAlphaColorRec(l).G := Color.G;
    TAlphaColorRec(l).B := Color.B;
    TAlphaColorRec(l).A := 255;
    Image1.Bitmap.Canvas.Stroke.Color := l;
    Image1.Bitmap.Canvas.FillText(rectf(x,y,x+100,y+20),aText,True,1.0,[TFillTextFlag.RightToLeft],TTextAlign.Leading);
    Image1.Bitmap.Canvas.EndScene;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Image1.Bitmap.Resize(240,136);
  MK := -1;
end;

procedure TForm2.idle(Sender: TObject; var Done: Boolean);
begin
  if (TThread.GetTickCount - mt>mtStable) then begin
     if assigned(Tic80) then
        Tic80.DoString('TIC()');
    mt := TThread.GetTickCount;
    inc(mtTicCount);
  end;

  if (TThread.GetTickCount - mt2>1000) then begin
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

procedure TForm2.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  MBl := 0;
  MBr := 0;
  MBc := 0;
  if ssLeft in Shift then
    MBl := 1;
  if ssRight in Shift then
    MBr := 1;
  if ssMiddle in Shift then
    MBc := 1;
end;

procedure TForm2.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  MX := round(X);
  MY := Round(Y);
end;

procedure TForm2.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  MBl := 0;
  MBr := 0;
  MBc := 0;
end;


procedure TForm2.OnErrorProc(Msg: String);
begin
  ShowMessage(Msg);
end;

end.
