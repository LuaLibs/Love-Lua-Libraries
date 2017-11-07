--[[
  phantasar.lua
  Phantasar Load Screen
  version: 17.11.07
  Copyright (C) 2016, 2017 Jeroen P. Broks
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

--[[ Please note that the Phantasar Productions logo is property of Jeroen Petrus Broks.
     If you use this library, please use your own logo in stead!
     Also note that the zlib license does NOT apply for the name Phantasar which is also property of Jeroen Petrus Broks ]]

-- *import chain
-- *import qgfx2
-- *import audio

-- *undef dev_screen
-- *undef dev_shownum
-- *undef dev_after

mkl.version("Love Lua Libraries (LLL) - phantasar.lua","17.11.07")
mkl.lic    ("Love Lua Libraries (LLL) - phantasar.lua","ZLib License")


local r ={}
local mylogo = LoadImage("$$mydir$$/LOGO.PNG")-- love.graphics.newImage("$$mydir$$/LOGO.PNG")
assert(mylogo,"$$mydir$$/LOGO.PNG was not setup at all somehow")
assert(mylogo.image,"$$mydir$$/LOGO.PNG was not loaded somehow")

local retdata
local afteraction = {}


function r.after(a)
  assert(type(a)=='function' or type(a)=='table',"phantasar.after(): I cannot process: "..type(a))
  --print(type(a))
  local tab = ({['function'] = {a}, ['table']=a })[type(a)]
  for f in each(tab) do
      afteraction[#afteraction+1] = f
      -- *if dev_after
      print("after "..type(f).." added - "..#afteraction)
      -- *fi
  end 
end

function r.draw()
local ww --= love.window.getWidth()
local wh --= love.window.getHeight()
local wf
ww,wh,wf = love.window.getMode()
local cx = ww/2
local cy = wh/2
local iw = mylogo.image:getWidth()
local ih = mylogo.image:getHeight()
local dx = cx - (iw/2)
local dy = cy - (ih/2)
CLS()
DrawImage(mylogo,dx,dy) -- old love.graphics.draw(mylogo,dx,dy)
Color(50,50,50)
Rect(50,wh-50,ww-100,25)
Color(r.barcol[1],r.barcol[2],r.barcol[3])
Rect(51,(wh-50)+1,r.barsize,23)
Color(255,255,255)
love.graphics.print(r.procent.."%",ww/2,wh-45)
-- *if dev_screen
love.graphics.print("Screen Size: "..ww.."x"..wh,0,0)
-- *if dev_shownum
love.graphics.print("Processing: "..r.process.." of "..r.total,0,15)
-- *fi 
end

function r.update()
local ww --= love.window.getWidth()
local wh --= love.window.getHeight()
local wf
ww,wh,wf = love.window.getMode()
if r.process>=r.total then
   for f in each(afteraction) do
       -- *if dev_after
       print("= After function being executed")
       -- *fi 
       f() 
       end
   chain.go(r.chainto) 
   return 
   end
r.process = r.process + 1
r.rawprog = (r.process/r.total)
r.procent = math.floor(r.rawprog*100)
r.barsize = math.floor(r.rawprog*(ww-102))
local croll = r.roll[r.process]
;(({
      image = function()
               r.retdata[croll[2]] = LoadImage(croll[3])
              end,
      audio = function()
               r.retdata[croll[2]] = LoadSound(croll[3],croll[4] or false,croll[5] or 'static')       
              end   ,
      font  = function()
               if love.filesystem.isFile(croll[3].."_size.lua") then
                  size = j_love_import(croll[3].."_size.lua")
                  r.retdata[croll[2]] = love.graphics.newFont( croll[3], size )
               else   
                  r.retdata[croll[2]] = love.graphics.newFont( croll[3] )
               end   
              end                                  
      
   })[croll[1]] or function() error("Unknown asset type: "..croll[1]) end)()
   print ( "Loaded "..croll[1]..": "..croll[3].." to "..croll[2])
end


function r.init(assetlist,chainto,barcol)
chain.go(r)
r.chainto = chainto
r.retdata = {}
r.total = 0
r.process = 0
r.roll = {}
r.barcol = r.barcol or {255,180,0}
for k,v in pairs(assetlist) do for k2,v2 in pairs(v) do r.total=r.total+1 r.roll[#r.roll+1] = { k,k2,v2 } end end
return r.retdata
end

function r.adddir(assetlist,dtype,dir,prefix)
print("Must add dir "..dir.." to "..dtype)
local list = love.filesystem.getDirectoryItems( dir )
local tag,st
for file in each(list) do
    assetlist[dtype] = assetlist[dtype] or {}
    print("adding to list:"..file)
    st = mysplit(file,".")
    tag = lower(st[1])
    tag = replace(tag," ","_")
    assetlist[dtype][(prefix or "")..tag] = dir.."/"..file
    end
end

return r
