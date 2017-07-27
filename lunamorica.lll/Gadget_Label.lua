--[[
        Gadget_Label.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.07.27
]]
local labeltjesplakken = {


     init = function(g,c)
         g.x  = g.x  or 0
         g.y  = g.y  or 0
         g.w  = g.w  or g.parent.w
         g.h  = g.h  or 5
         g.FR = g.FR or c.General.FR
         g.FG = g.FG or c.General.FG
         g.FB = g.FB or c.General.FB         
         g.align = g.align or "left"
         g.valign= g.valign or "top"
     end,
     
     draw = function (g)
        local x = g.ax
        local y = g.ay 
        g:color()
        g:setfont()
        love.graphics.print(g:getcaption(),x,y,g.radius or 0)
     end


}


return labeltjesplakken -- Wie die onzinnige term heeft bedacht is wat mij betreft genomineerd voor de prijs van grootste idioot die de mensheid ooit gekend heeft.


--[[ 

    This is for simple lables.
    I did set align values, but they won't be used here due to some lack of functionality Love2d provides here.
    AdvLabel will have better support, but it will also require to always update the gadget when text has been changed.
    This routine doesn't have to (unless you work with localisation).
    
]]    
