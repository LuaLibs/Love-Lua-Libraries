--[[
  time.lua
  Time Library
  version: 16.04.17
  Copyright (C) 2016 Jeroen P. Broks
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
]]

-- *import quickmath

mkl.version("Love Lua Libraries (LLL) - time.lua","16.04.17")
mkl.lic    ("Love Lua Libraries (LLL) - time.lua","ZLib License")

local t = {


     sec2time = function (secs)
         local sec = 0
         local min = 0
         local hor = 0
         local w = secs
         hor = floor(w/3600); w = w - (hor*3600)
         min = floor(w/60);   w = w - (min*60)
         sec = w
         local ret = ""
         if hor>0 then ret = hor..":" end
         ret = ret .. right("0"..min,2)..":"..right("0"..sec,2)
         return ret                 
     end,

    now = function()
      return os.date("%A %B %d"..(({['01']='st',['21']='st',['31']='st',['02']='nd',['22']='nd',['03']='rd',['23']='rd'})[os.date("%d")] or "th")..os.date(" %Y; %I:%M:%S%p"))
    end


}




return t
