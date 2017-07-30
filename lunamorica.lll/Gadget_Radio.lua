--[[
        Gadget_Radio.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.07.30
]]
-- *import altellipse

local function inside(g,x,y)
    return x>g.ax and x<g.ax+g.w and y>g.ay and y<g.ay+g.h
end    


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
      end,
      
      mpressed = function(g,x,y,b,t)
          if b==1 and inside(g,x,y) then 
             for k,cg in pairs(g.parent.kids) do cg.checked=false end
             g.checked=true
             if g.action then g:action() end
          end   
      end

}




return radio_gaga_radio_blahblah
