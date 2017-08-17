--[[
        Gadget_TextField.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.07.30
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
       -- print("User pressed: "..key) -- I need to make sure I got all keys right.
       if s~=lun_active then return end
       local ch
       local xd = lunamorica.xdown
       if #key==1 then
          ch=key
          if xd.shift then 
             ch = ch:upper()
             -- I took the standard QWERTY keyboard in mind. This would otherwise be too much hassle to deal with. Sorry!
             if ch=='`'  then ch="~" end
             if ch=='1'  then ch='!' end
             if ch=='2'  then ch='@' end
             if ch=='3'  then ch='#' end
             if ch=='4'  then ch='$' end
             if ch=='5'  then ch='%' end
             if ch=='6'  then ch='^' end
             if ch=='7'  then ch='&' end
             if ch=='8'  then ch='*' end
             if ch=='9'  then ch='(' end
             if ch=='0'  then ch=')' end
             if ch=='-'  then ch='_' end
             if ch=='\\' then ch='|' end
             if ch==';'  then ch=':' end
             if ch=="'"  then ch='"' end
             if ch==','  then ch='<' end
             if ch=='>'  then ch='>' end
             if ch=='/'  then ch='?' end
             if ch=='['  then ch='{' end
             if ch==']'  then ch='}' end    
          end
       end     
       if prefixed(key,'kp') and #key==3 then ch=right(key,1) end
       if key=='space' then ch=" " end
       if ch and #s.text<s.maxlength then 
          s.text=s.text..ch
          if s.typing then s:typing() end 
       end
       if key=='return' or key=='kpenter' and s.action then s:action() end
       if key=='backspace' and s.text~="" then 
          s.text=left(s.text,#s.text-1)
          if s.typing then s:typing() end 
       end
    end,
   
   mpressed = function(s,mx,my,b,t)
      --print("CLICK! ("..s.ax..","..s.ay..")")
      if s==lun_active then return end
      if mx>=s.ax and mx<=s.ax+s.w and my>=s.ay and my<=s.ay+s.h then lun_active=s end
   end 
}








return tf
