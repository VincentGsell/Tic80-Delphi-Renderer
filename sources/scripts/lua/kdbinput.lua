-- title:  input tester
-- author: lb_ii
-- desc:   ultimate input tester
-- script: lua

step=11

kbd={
 {
  {"`",44,16},
		{"1",28},{"2",29},{"3",30},{"4",31},
		{"5",32},{"6",33},{"7",34},{"8",35},
		{"9",36},{"0",27},{"-",37},{"=",38},
  {"BkSp",51,26},
  {"Ins",53,26},
  {"Home",56,26},
  {"PgUp",54,26},
 },
 {
  {"Tab",49,21},
  {"Q",17},{"W",23},{"E",5}, {"R",18},
  {"T",20},{"Y",25},{"U",21},{"I",9},
  {"O",15},{"P",16},{"[",39},{"]",40},
  {"\\",41,21},
  {"Del",52,26},
  {"End",57,26},
  {"PgDn",55,26},
 },
 {
  {"Caps",62,26},
  {"A",1}, {"S",19},{"D",4}, {"F",6},
  {"G",7}, {"H",8}, {"J",10},{"K",11},
  {"L",12},{";",42},{"'",43},
  {"Entr",50,26},
 },
 {
  {"Shift",64,31},
  {"Z",26},{"X",24},{"C",3}, {"V",22},
  {"B",2}, {"N",14},{"M",13},{",",45},
  {".",46},{"/",47},
  {"Shift",64,31},
	 {nil,nil,26},
  {"Up",58,26},
 },
 {
  {"Ctrl",63,26},
  {"Alt",65,26},
  {"",48,61},
  {"Alt",65,26},
  {"Ctrl",63,26},
  {"Left",60,26},
  {"Down",59,26},
  {"Rght",61,26},
 },
}

joy={
 {
  {nil,nil},
  {"^",0},
  {nil,nil},
  {nil,nil},
  {nil,nil},
  {"Y",7},
  {nil,nil},
 },
 {
  {"<",2},
  {nil,nil},
  {">",3},
  {nil,nil},
  {"X",6},
  {nil,nil},
  {"B",5},
 },
 {
  {nil,nil},
  {"V",1},
  {nil,nil},
  {nil,nil},
  {nil,nil},
  {"A",4},
  {nil,nil},
 },
}

function KEY(code,fn,delta,letter,x,y,w)
 if code==nil then
 	return
	elseif fn(code+delta) then
  rect(x,y,w,step,7)
 else
  rectb(x,y,w,step,7)
 end
	print(letter,x+2,y+3)
end

function KEYS(l,fn,delta,x0,y0)
 y = y0
 for i=1, #l do
	 x = x0
 	for j=1,#l[i] do
			k = l[i][j]
		 w = k[3] or step
   KEY(k[2],fn,delta,k[1],x,y,w)
			x = x+w-1
 	end
		y = y + step-1 
	end
end

function KBD(x,y)
rectb(x,y,240,55,7)
	KEYS(kbd,key,0,x+2,y+2)
end

function MOUSE(x,y)
  rectb(x,y,52,60,7)
  mx,my,ml,mm,mr = mouse()
  if ml then
   rect(x,y,18,22,7)
		else
   rectb(x,y,18,22,7)
		end
  if mm then
   rect(x+17,y,18,22,7)
		else
   rectb(x+17,y,18,22,7)
		end
  if mr then
   rect(x+17+17,y,18,22,7)
		else
   rectb(x+17+17,y,18,22,7)
		end
		print("("..mx..","..my..")",x+5,y+40)
end

function JOY(idx,x,y)
 rectb(x,y,75,35,7)
 KEYS(joy,btn,idx*8,x+2,y+2)
end

function TIC()
 cls(0)
 KBD(0,5)
 MOUSE(176,70)
	JOY(0,0,63)
	JOY(1,86,63)
	JOY(2,0,101)
	JOY(3,86,101)
end
