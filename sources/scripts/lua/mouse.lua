-- title:  demo mouse
-- author: Filippo
-- desc:   wiki demo mouse
-- script: lua
-- input:  mouse
  
r=0
function TIC()
 cls()
 
 --get mouse info 
 x,y,p=mouse() 
             
 --if pressed   
 if p>0 then r=r+2 end r=r-1
 r=math.max(0, math.min(32, r))
                     
 --draw stuff        
 line(x,0,x,136,11)  
 line(0,y,240,y,11)  
 circ(x,y,r,11)      
                     
 --show coordinates  
 c=string.format('(%03i,%03i)',x,y)   
 print(c,0,0,15,1)                   
end                   