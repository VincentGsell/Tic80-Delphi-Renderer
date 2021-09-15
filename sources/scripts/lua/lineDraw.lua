-- title:  line draw
-- author: Shiny
-- desc:   walking line
-- script: lua

l={}
st=4--step
l[0]=20--x1
l[1]=-st--dx

l[2]=20--y1
l[3]=st--dy

l[4]=220--x2
l[5]=st--dx

l[6]=124--y2
l[7]=st--dy

l[8]=20--x3
l[9]=-st--dx

l[10]=20--y3
l[11]=st--dy

l[12]=220--x4
l[13]=st--dx

l[14]=124--y4
l[15]=st--dy

function step(i,e)
l[i]=l[i]+l[i+1]

if l[i]==e or l[i]==0 then
l[i+1]=-l[i+1]
end
return l[i]
end

cls()

for i=0,15 do
step(0,240)
step(2,136)
step(4,240)
step(6,136)
end

function TIC()
line(step(0,240),step(2,136),step(4,240),step(6,136),time()%4+1)
line(step(8,240),step(10,136),step(12,240),step(14,136),0)
end
