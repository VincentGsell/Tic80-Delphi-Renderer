-- 'rectb' demo
xx=104
yy=60

function TIC()
 cls()
 for s=280,0,-4 do
  s2=s/2
  sd=500/(s+1)
  x=sd*math.sin(time()/1000)+xx
  y=sd*math.cos(time()/1000) + yy
  rectb(120+x-s2,68+y-(s2/2),s,s2,8)
print(sd,0,45)
print(s2,0,60)
 end 
print(time())
print(x,0,15)
print(y,0,30)

end