-- title:  Benchmark
-- author: MonstersGoBoom
-- desc:   several performance tests
-- script: lua

local runningTime = 0
local t = 0
local RUNNER = {}
-- predictable random 
-- give the same sequence every time
local random = {}
random.max = 8000
random.count = 0
for x=0,random.max do 
  random[x+1] = math.random(100)/100
end
function Random(v)
  random.count = random.count+1
  return random[(random.count%random.max)+1] * v 
end

-- epilepsy warning
local Warning = [[
A very small percentage of individuals
may experience epileptic seizures
or blackouts when exposed to
certain light patterns or flashing lights.

Exposure to certain patterns or backgrounds
on a television screen or when playing
video games may trigger epileptic seizures
or blackouts in these individuals.

These conditions may trigger previously
undetected epileptic symptoms or seizures
in persons who have no history of prior seizures
or epilepsy.

If you, or anyone in your family has an
epileptic condition or has had
seizures of any kind,
consult your physician before playing.
]]

-- UI stuff
local UI = {currentOption=1}
-- default UI for each test
function UI:bench()
  print("Press Z",170,130,15)
  -- back to menu
  if btnp(4) then
    RUNNER = nil
  end
end
-- main UI
function UI:mainmenu()
	cls(1)
		print("Let the test run until the bar is full",0,0,15)
	
	--	print position 
	local yp = 68-((#UI.options*8)/2)
	--	what is selected
	local currentOption = 1+(UI.currentOption % (#UI.options))
	--	display options
	for o=1,#UI.options do 
 	color = 6
  opt = UI.options[o]
  if o==currentOption then 
				color = 15
				-- if highlighted and press Z
				--	then start it
				-- and set to white
				if btnp(4) then
		  	RUNNER = opt[2]
		  	-- if we have an INIT then run it
		  	random.count = 0
		  	if RUNNER.init ~= nil then 
		   	RUNNER:init()
		  	end
		  	RUNNER.count = 0
    end
  end
		--  display text and results
		if opt[2]~=nil then
			if opt[2].count==nil then opt[2].count=0 end
			s = opt[1] .. ":" .. (opt[2].count * opt[2].callmult)
		else
			s = opt[1]
		end
		print(s,xp,yp,color)
		yp=yp+6
 end
	if btnp(0) then UI.currentOption=UI.currentOption-1 end
	if btnp(1) then UI.currentOption=UI.currentOption+1 end
end

-- SQRT test

local SQRT = { add = 1 , callmult = 2}
function SQRT:init()
end
function SQRT:run()
  cls(0)
	local wiggle= t/20 % 20
  for y=0,136 do 
    for x=0,RUNNER.count do 
      pix(x%240,y,16-(math.sqrt(wiggle+(x*x + y*y)/136)%16))
    end
  end
end

-- SINCOS test
local SINCOS = { add = 1 , callmult = 5}
function SINCOS:init()
end
function SINCOS:run()
  cls(0)
	local wiggle= t/20 % 20
  for y=0,136 do 
    for x=0,RUNNER.count do 
      local v = 0
      v = v + math.sin(wiggle+x) + math.cos(wiggle+y)
      v = v + math.cos(wiggle-y) + math.sin(wiggle-x)
      pix(x%240,y,v%16)
    end
  end
end

-- READ WRITE TEST

local PIXELRW = { add = 1 , callmult = 1}
function PIXELRW:init()
  print(Warning,0,0,15)
end
function PIXELRW:run()
	local wiggle= t/20 % 120
  for y=0,136 do 
    for x=0,RUNNER.count do 
      local a = pix(x+wiggle,y)
      local b = Random(100)
      if b<25 then
        pix(x,y,a)
      else
        circb(x,y,4,a+1)
      end
    end
	end
end

-- WRITE TEST
local PIXELW = { add = 5 , callmult = 1}
function PIXELW:init()
end
function PIXELW:run()
  for y=0,136 do 
    for x=0,RUNNER.count do 
      pix(x&0xff,y,32+(x+(y*8)))
    end
	end
end

-- math.random
local MATHRANDOM = { add = 1000 , callmult = 2}
function MATHRANDOM:run()
  cls(0)
  for rc=0,RUNNER.count do 
    pix(math.random(240),math.random(136),math.random(15))
	end
end

-- circles
local SHAPES = { add = 25, callmult = 1}
function SHAPES:run()
  cls(2)
  for x=0,RUNNER.count do 
    circ(Random(240),Random(136),Random(16),x&1)
  end
end

-- map 

local MAP = { add = 1 , callmult = 1}
function MAP:run()
  cls(10)
  for x=0,RUNNER.count do 
    map(0,0,30,18,-x,0,10)
  end
end

-- sprites

local Sprites = { add = 100 , callmult = 1}
function Sprites:run()
  local a = t + 1/RUNNER.count
  cls(0)
  for x=0,RUNNER.count do 
    spr(1,120+math.sin(x+a)*120,68+math.cos(x-a)*68)
  end
end

-- falling dots
local Particles = { add = 0 , callmult = 1}
function Particles:init()
  Particles.list = {}
end

function Particles:run()
  cls(0)
  table.sort(Particles, function(a,b) return a.y>b.y end)

  if (t//40)&1==0 then
    if runningTime<16.2 then 
      for x=1,100 do
        table.insert(Particles.list,{x=Random(240),y=-Random(32),c=1+((x//10)%14),fs=0.5+Random(5)/10.0})
      end
    end
  end

		Particles.count = #Particles.list
 
  for x=1,#Particles.list do 
    p = Particles.list[x]
    if p.y<100 then
      if (pix(p.x,(p.y+p.fs)//1)==0) then 
        p.y=p.y+p.fs
      else
        if Random(100)>80 then
          if (pix(p.x-1,p.y+1)==0) then 
            p.x = p.x-1
          elseif (pix(p.x+1,p.y+1)==0) then 
            p.x = p.x+1
          end
        end
      end
    end
  pix(p.x,p.y,p.c)
  end
end

-- options

UI.options = {
  {"Shapes",SHAPES},
  {"MAP",MAP},
  {"Sprites",Sprites},
  {"Particles",Particles},
  {"Write Screen",PIXELW},
  {"Read and Write Screen",PIXELRW},
  {"Math.Random",MATHRANDOM},
  {"Math.SquareRoot",SQRT},
  {"Math.SinCos",SINCOS},
--  {"Packer",test_shapes},
}

RUNNER = nil

function MAINTIC()
  local stime = time()
  if RUNNER~=nil then 
    if RUNNER.count~=nil then
      if runningTime<16.6 then 
        RUNNER.count=RUNNER.count + RUNNER.add
      end
      if runningTime>18.0 then 
        RUNNER.count=RUNNER.count - RUNNER.add
      end
      print(RUNNER.count,0,110,15)
    end
    if RUNNER.run~=nil then
      RUNNER.run()
      runningTime = time() - stime
						rect(0,119,240,6,0)
      rect(0,120,runningTime*14.20,4,15)
						
      print(string.format("runTime %.2f",runningTime),1,127,0)
      print(string.format("runTime %.2f",runningTime),0,126,15)
      if runningTime>16 then 
        UI:bench()
      end
    end
  else
    UI:mainmenu()
  end

  t=t+1
end

t=0
function TIC()
  cls(0)
  local y = 136-(t/3)
  if y<0 then y=0 end
  print(Warning,0,y,15)
  t=t+1
  if (t>60*2) then
    UI:bench()
    if btnp(4) then 
      TIC=MAINTIC
    end
	end
end

