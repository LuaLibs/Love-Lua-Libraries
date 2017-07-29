--[[
        Gadget_Button.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.07.29
]]
-- *import xmath

local knopje = { 

    --[[
         This will just be the standard design button.
         Support for buttons with their complete own design MAY be added later.
         I am not planning to make "OK_Button" support.
         Too much hassle to deal with, and if you link the same action function function to all textfields you'll get the same effect, so WHY BOTHER! :P
         
    ]]
    
    
    init = function(g,c)
         g.hot = 'cc'
         g.x  = g.x  or 0
         g.y  = g.y  or 0
         g.t_text = { w=0, h=0, x=0, y=0, cpf='F' }
         g.t_img  = { w=0, h=0, x=0, y=0, cpf='I'}
         g.drwlst = {}        
         g.acaption = g:getcaption()
         if g.acaption~="" then 
            g.t_text.drw = love.graphics.newText(g:setfont(true),g.acaption)
            g.t_text.w   = g.t_text.drw:getWidth()
            g.t_text.h   = g.t_text.drw:getHeight()
            g.drwlst[#g.drwlst+1] = g.t_text            
         end
         if g.image then
            g.t_img.drw  = love.graphics.newImage(g.image:upper())
            g.t_img.w    = g.t_img.drw:getWidth()
            g.t_img.h    = g.t_img.drw:getHeight()
            g.drwlst[#g.drwlst+1] = g.t_img
         end
         if g.acaption and g.image then g.margin = 15 else g.margin = 0 end
         g.totalw = g.margin + g.t_img.w + g.t_text.w
         g.w = g.w or (g.totalw + 14)
         g.h = highest(g.t_text.h,g.t_img.h) + 14
         g.center = g.w/2
         g.centerh = g.h/2
         g.t_img.x = g.center - (g.totalw/2)
         g.t_text.x = g.t_img.x + g.margin + g.t_img.w
         g.t_img.y  = g.centerh - (g.t_img .h/2)
         g.t_text.y = g.centerh - (g.t_text.h/2)
         g.botR    = g.BR / 2
         g.botG    = g.BG / 2
         g.botB    = g.BB / 2
         if (g.botR+g.botG+g.botB)<25 then g.botR=25 g.botG=25 g.botB=25 end
         g.topR    = g.BR * 2   if g.topR>255 then g.topR=255 end    
         g.topG    = g.BG * 2   if g.topG>255 then g.topG=255 end    
         g.topB    = g.BB * 2   if g.topB>255 then g.topB=255 end   
         if (g.topR + g.topG + g.topB) - (g.BR + g.BG + g.BB) < 50 then g.topR = 255 g.topG=255 g.topB=255 end 
         g.SR , g.SG, g.SB = 0,0,0 
         g.IR , g.IG, g.IB = 255,255,255
    end,
    
    draw = function(g)
         local lijn  = love.graphics.line
         -- background
         g:color(true)
         love.graphics.rectangle( 'fill', g.ax, g.ay, g.w, g.h )
         for i=1,4 do
             local i2 = i-1
             -- left & top color
             if g.held then 
                love.graphics.setColor(g.botR,g.botG,g.botB)
             else    
                love.graphics.setColor(g.topR,g.topG,g.topB)
             end
             -- left side
             lijn(g.ax+i2,g.ay,g.ax+i2,(g.ay+g.h)-i)
             -- top side
             lijn(g.ax,g.ay+i2,g.ax+g.w-i,g.ay+i2)
             -- right & bottom color       
             if g.held then 
                love.graphics.setColor(g.topR,g.topG,g.topB)
             else    
                love.graphics.setColor(g.botR,g.botG,g.botB)
             end
             -- right side
             lijn((g.ax+g.w)-i2,g.ay+i,(g.ax+g.w)-i2,(g.ay+g.h)-1)
             -- bottom side
             lijn(g.ax+i,(g.ay+g.h)-i2,(g.ax+g.w),(g.ay+g.h)-i2)
         end
         --g:color()
         for drw in each(g.drwlst) do
             love.graphics.setColor(g[drw.cpf.."R"],g[drw.cpf.."G"],g[drw.cpf.."B"])
             love.graphics.draw(drw.drw,drw.x+g.ax,drw.y+g.ay)
         end  
    end
    



} 




return knopje
