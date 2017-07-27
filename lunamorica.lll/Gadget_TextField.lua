--[[
        Gadget_TextField.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.07.27
]]
local tf = {

    init = function(s)
       s.default = s.default or s:getcaption() or ""
       s.text    = s.text or s.default
       s.cursor  = s.cursor or "|"
       s.topR    = s.BR / 2
       s.topG    = s.BG / 2
       s.topB    = s.BB / 2
       if (s.topR+s.topG+s.topB)<25 then s.topR=25 s.topG=25 s.topB=25 end
       s.botR    = s.BR * 2   if s.botR>255 then s.botR=255 end    
       s.botG    = s.BG * 2   if s.botG>255 then s.botG=255 end    
       s.botB    = s.BB * 2   if s.botB>255 then s.botB=255 end    
       s.x  = s.x  or 0
       s.y  = s.y  or 0
       s.w  = s.w  or s.parent.w
       s.fontsize = s.fontsize or 12
       s.h  = s.h  or math.ceil(s.fontsize * 1.25)
       s.alpha = s.alpha or 127
       s.maxlength = s.maxlength or math.floor((s.w-s.fontsize)/s.fontsize)
       if s.maxlength<=1 then s.maxlength=2 end
       lun_active = lun_active or s -- If no active gadget is selected, well, then we are the first, eh?       
    end,
    
    draw = function(s)
       s:color(true)
       love.graphics.rectangle( 'fill', s.ax, s.ay, s.w, s.h )
       local kleur = love.graphics.setColor
       local lijn  = love.graphics.line
       kleur(s.topR,s.topG,s.topB,255)
       lijn(s.ax-1,s.ay-1,s.ax+s.w+1,s.ay-1) -- top
       lijn(s.ax-1,s.ay-1,s.ax-1,s.ay+s.h+1) -- left
       kleur(s.botR,s.botG,s.botB,255)
       lijn(s.ax,s.ay+s.h+1,s.ax+s.w+1,s.ay+s.h+1) -- bottom
       lijn(s.ax+s.w+1,s.ay+s.h+1,s.ax+s.w+1,s.ay) -- right
       local cursor = lun_active == s and s.enabled
       local time = math.floor(love.timer.getTime()*1.5)
       local l = tonumber(right(time,1)) or 0
       cursor = cursor and l<5
       local show = s.text
       if cursor then show = show .. s.cursor end
       s:color(false)
       love.graphics.print(show,s.ax+1,s.ay+1)
    end,
    
    kpressed = function(s,key,scancode)
    end
}








return tf
