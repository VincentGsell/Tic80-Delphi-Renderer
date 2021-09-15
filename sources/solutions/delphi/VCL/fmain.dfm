object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 613
  ClientWidth = 1085
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 482
    Top = 65
    Width = 603
    Height = 548
    Align = alClient
    Proportional = True
    Stretch = True
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
    ExplicitLeft = 488
    ExplicitTop = 63
    ExplicitWidth = 465
    ExplicitHeight = 337
  end
  object Splitter1: TSplitter
    Left = 474
    Top = 65
    Width = 8
    Height = 548
    ResizeStyle = rsUpdate
    ExplicitTop = 81
    ExplicitHeight = 471
  end
  object Memo1: TMemo
    Left = 0
    Top = 65
    Width = 474
    Height = 548
    Align = alLeft
    Lines.Strings = (
      '-- title:  3D demo'
      '-- author: by Filippo'
      '-- desc:   3D demo'
      '-- script: lua'
      '-- input:  gamepad'
      ''
      't=0'
      ''
      'cx=0'
      'cy=0'
      'cz=200'
      'pivot={x=0,y=0,z=0}'
      'angle=0'
      'points={}'
      'pal={15,14,9,6,8,2,1}'
      ''
      'function createCube(t)'
      #9'--Init points for cube'
      #9'points={}'
      #9'local l'
      #9'l = 5 + math.abs((math.sin(t/100))*10)'
      #9'local p'
      #9'for x=-3,3 do'
      #9#9'for y=-3,3 do'
      #9#9#9'for z=-3,3 do'
      #9#9#9#9#9'p={x=x*l,'
      #9#9#9#9#9#9#9#9'y=y*l,'
      #9#9#9#9#9#9#9#9'z=z*l,'
      #9#9#9#9#9#9#9#9'c=pal[4+z]}'
      #9#9#9#9#9'table.insert(points,p)'
      #9#9#9'end'
      #9#9'end'
      #9'end'
      'end'
      ''
      'function createCurve(t)'
      #9'--Init points for 3d curve'
      #9'points={}'
      #9'local i=0'
      #9'local l'
      #9'l1 = math.abs(5*(math.cos(t/50)))'
      #9'for u=-70,70,15 do'
      #9#9'local r1 = math.cos(math.rad(u))*30'
      #9#9'for v=1,360,15 do'
      #9#9#9'local x = math.sin(math.rad(v))'
      #9#9#9'local y = math.cos(math.rad(v))'
      #9#9#9#9'p={x=x*r1,'
      #9#9#9#9#9#9#9'y=y*r1,'
      #9#9#9#9#9#9#9'z=(u/(l1+0.7)+v/5),'
      #9#9#9#9#9#9#9'c=pal[1+i%7]}'#9#9
      #9#9#9#9#9#9#9'table.insert(points,p)'
      #9#9'end'#9
      #9'i=i+1'
      #9'end'
      'end'
      ''
      ''
      'function p2d(p3d)'
      #9'local fov = 180'
      #9'local x0 = p3d.x + cx'
      #9'local y0 = p3d.y + cy'
      #9'local z0 = p3d.z + cz'
      #9'local x2d = fov * x0 / z0'
      #9'local y2d = fov * y0 / z0'
      #9
      #9'x2d = x2d + 120 --center w'
      #9'y2d = y2d + 68  --center h'
      #9
      #9'return x2d,y2d'
      'end'
      ''
      'function rotate(p3d,center,ax,ay,az)'
      #9'local a,b,c'
      #9'local a1,b1,c1'
      #9'local a2,b2,c2'
      #9'local a3,b2,c3'
      #9'local np3d={x=0,y=0,z=0,c=0}'
      ''
      #9'a = p3d.x-center.x'
      #9'b = p3d.y-center.y'
      #9'c = p3d.z-center.z'
      #9
      #9'a1 = a*math.cos(az)-b*math.sin(az) '
      ' b1 = a*math.sin(az)+b*math.cos(az)'
      #9'c1 = c'
      ''
      #9'c2 = c1*math.cos(ay)-a1*math.sin(ay) '#9
      #9'a2 = c1*math.sin(ay)+a1*math.cos(ay)'
      ' b2 = b1'
      #9
      #9'b3 = b2*math.cos(ax)-c2*math.sin(ax) '#9
      #9'c3 = b2*math.sin(ax)+c2*math.cos(ax)'
      ' a3 = a2'#9#9
      #9#9#9
      #9'np3d.x=a3'
      #9'np3d.y=b3'
      #9'np3d.z=c3'
      #9'np3d.c=p3d.c'
      #9'return np3d'
      'end'
      ''
      'function zsort(p1,p2)'
      #9'return p1.z>p2.z'
      'end'
      ''
      'function TIC()'
      ''
      #9'cls(10)'
      #9'--Create points'
      #9'if(t%900<450) then'
      #9' createCube(t)'
      #9'else'
      #9' createCurve(t)'
      #9'end'
      #9
      #9'--Rotate points'
      #9'for k,p in pairs(points)do'
      #9' pr = rotate(p,pivot,'
      #9#9'angle,'
      #9#9'angle/2,'
      #9#9'angle/4)'
      #9#9'points[k] = pr'#9
      #9'end'#9#9
      #9
      #9'--Z Sort'
      #9'table.sort(points,zsort)'
      #9
      #9'--Draw points'
      #9'for k,p in pairs(points)do'
      #9#9#9'i,j = p2d(p)'#9#9
      #9#9#9'rect(i,j,6,6,p.c)'
      #9'end'#9#9
      #9
      #9'angle = angle + 0.05'
      #9't=t+1'
      'end')
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitTop = 81
    ExplicitHeight = 532
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1085
    Height = 65
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 219
      Top = 24
      Width = 70
      Height = 13
      Caption = 'Color template'
    end
    object Button1: TButton
      Left = 113
      Top = 5
      Width = 100
      Height = 54
      Caption = 'Run'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button4: TButton
      Left = 7
      Top = 5
      Width = 100
      Height = 54
      Caption = 'Load...'
      TabOrder = 1
      OnClick = Button4Click
    end
    object ComboBox1: TComboBox
      Left = 219
      Top = 38
      Width = 145
      Height = 21
      TabOrder = 2
      Text = 'ComboBox1'
      OnChange = ComboBox1Change
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 472
    Top = 272
  end
end
