--[[
        Gadget_Strike.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.07.27
]]
local strike = {

     init = function(g,c)
         g.x  = g.x  or 0
         g.y  = g.y  or 0
         g.w  = g.w  or g.parent.w
         g.h  = g.h  or 5
         g.FR = g.FR or c.General.FR
         g.FG = g.FG or c.General.FG
         g.FB = g.FB or c.General.FB         
     end,
     
     draw = function (g)
        local x = g.ax
        local y = g.ay + math.ceil((g.h or 0)/2)
        g:color()
        love.graphics.line(x,y,x+g.w,y)
     end


}

return strike
