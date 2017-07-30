-- *import altellipse

local radio_gaga_radio_blahblah = {

      init = function(g)
             g.w = g.w or 12
             g.h = g.h or 12
             assert(g.w>=7 and g.h>=7,"Radio too small. 7x7 required at least")
             g.checked = g.checked==true
             --[[
             for cg in each(g.parent.kids) do
                 assert((not cg.checked) or cg==g,"Double checked radio") 
             end 
             -- ]]                             
      end,
      
      draw = function(g)
             g:color()
             altellipse('line',g.ax,g.ay,g.w,g.h)
             if g.checked then
                altellipse('fill',g.ax+3,g.ay+3,g.w-6,g.h-6)
             end   
      end

}




return radio_gaga_radio_blahblah
