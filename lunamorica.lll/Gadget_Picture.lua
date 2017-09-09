--[[
        Gadget_Picture.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.09.09
]]
local pic = {


     init = function(g,c)
         g.x  = g.x  or 0
         g.y  = g.y  or 0
         g.ox = g.ox or 0
         g.oy = g.oy or 0
         g.sx = g.sx or 1
         g.sy = g.sy or 1         
         g.PR = g.PR or 255
         g.PG = g.PG or 255
         g.PB = g.PB or 255       
         if g.caption then g.image='text:'..g.getcaption() end
         assert(g.image or "No image for picture gadget")
         assert(type(g.image)=='string','Invalid file name type. Expected string but got '..type(g.image))
         if prefixed(g.image,"text:") then
            print('Converting '..g.image..' into a picture')
            local f = g:setfont(true)
            g.dimage = love.graphics.newText(f,right(g.image,#g.image-5))
         else   
            print('Loading picture: '..g.image:upper())
            g.dimage = love.graphics.newImage(g.image:upper())      
            assert(g.dimage,"Loading picture ("..g.image..") failed")
         end      
         g.iw = g.dimage:getWidth( )
         g.ih = g.dimage:getHeight()
         if g.hot then
           if     g.hot=="ur" then g.ox=g.iw   g.oy=0 
           elseif g.hot=="ul" then g.ox=0      g.oy=0
           elseif g.hot=='uc' then g.ox=g.iw/2 g.oy=0
           elseif g.hot=="lr" then g.ox=g.iw   g.oy=g.ih
           elseif g.hot=="ul" then g.ox=0      g.oy=g.ih
           elseif g.hot=='uc' then g.ox=g.iw/2 g.oy=g.ih
           elseif g.hot=="cr" then g.ox=g.iw   g.oy=g.ih/2
           elseif g.hot=="cl" then g.ox=0      g.oy=g.ih/2
           elseif g.hot=='cc' then g.ox=g.iw/2 g.oy=g.ih/2
           elseif g.hot=='c'  then g.ox=g.iw/2 g.oy=g.ih/2
           else   error('Unknown hot-code: '..g.hot)
           end
        end   
     end,
     
     hover = function(g,x,y)
        assert(g.image,"Picture gadget without data!")
        return x>g.ax and y>g.ay and x<g.ax+g.image:getWidth() and y<g.ay+g.image:getHeigth()
     end,
     
     draw = function (g)
        local x = g.ax
        local y = g.ay 
        g:color('pic')
        assert(g.image,"Picture gadget without data!")
        love.graphics.draw(g.dimage,x,y,g.radius,g.sx,g.sy,g.ox,g.oy)
     end


}




return pic

