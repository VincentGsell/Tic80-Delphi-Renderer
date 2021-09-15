-- title:  Particle test
-- author: Time_Tripper
-- desc:   Particle test
-- script: lua
-- input:  mouse

par={}
scr={}
st=0
sx={1,2,1,2}
sy={1,1,2,2}

bmx=0
bmy=0

pal={
"000000",
"ad3405",
"c53f00",
"d85209",
"f47500",
"fd8d03",
"fdad0e",
"ffc018",
"ffe958",
"ffff9b",
"ffffe3",
"ffffff",
"ffffe5",
"fffc91",
"ffffc1",
"ffffff"
}

function pallet()
	i=0x3FC0
	for y=1,16 do
		for x=1,6,2 do
			poke(i,tonumber(string.sub(pal[y],x,x+1),16))
			i=i+1
		end
	end	
end

function move()
	for i=#par,1,-1 do
		local p=par[i]
		p.px=p.px+p.pvx
		p.py=p.py+p.pvy
		if p.px>1 and p.px<238 and p.py>1 and p.py<135 then
			if math.random(2)==1 then
				scr[math.floor(p.px)+math.floor(p.py)*240]=p.pc
			end
			p.pvx=p.pvx*0.98
			p.pvy=p.pvy*0.98
			p.pl=p.pl-1
		else
			p.pl=0
		end
		if p.pl<1 then
			table.remove(par,i)
		end
	end
end	

function draw()
	w=st%4+1
	for y=sy[w],134,2 do
		for x=sx[w],239,2 do
			i=x+y*240
			pix(x-1,y-1,scr[i])
			scr[i]=(scr[i]+scr[i-1]+scr[i+1]+scr[i-240]+scr[i+240])/5.1
		end
	end	
end

function init()
	cls()
	pallet()
	for i=1,32640 do
		table.insert(scr,0)
	end
end

--------------------
	init()
--------------------
function TIC()
	mx,my,md=mouse()
	if md then
		for i=1,5 do
		local p={}
		p.px=mx+math.random(10)-5
		p.py=my+math.random(10)-5
		p.pvx=(mx-bmx)*0.5
		p.pvy=(my-bmy)*0.5
		p.pc=15
		p.pl=math.random(50)+50
		table.insert(par,p)
		end
		bmx=mx
		bmy=my
	end
	move()
	draw()
	st=st+1
end

