-- 'rectb' demo by Filippo, refactored by Al Rado

HALF_SCR_W = 240/2
HALF_SCR_H = 136/2
DEVIATION = 150
SPEED = 1/500
RECT_COUNT = 70
RECT_STEP = 4
RECT_COLOR = 8

function TIC()
 cls()
 for i = 1, RECT_COUNT do
  width = i*RECT_STEP
  height = width/2	
  slowedTime = time()*SPEED
  x = math.sin(slowedTime) * DEVIATION/i - width/2
  y = math.cos(slowedTime) * DEVIATION/i - height/2
  rectb(HALF_SCR_W+x, HALF_SCR_H+y, width, height, RECT_COLOR)
 end 
end 