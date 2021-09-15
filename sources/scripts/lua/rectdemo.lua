-- rect demo                
x=120                       
y=68                        
dx=7                        
dy=4                        
col=1                       
                            
                            
function TIC()              
--Update x/y                
 x=x+dx                     
 y=y+dy                     
 --Check screen walls       
 if x>240-6 or x<0 then     
  dx=-dx                    
  col=col%15+1              
 end                        
 if y>136-6 or y<0 then     
  dy=-dy                    
  col=col%15+1              
 end                      
 --Draw rectangle         
 rect (x,y,6,6,col)       
end
    
cls(0)