--[[
  audio.lua
  audio.lua
  version: 16.04.09
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
-- *import mkl_version

mkl.version("Love Lua Libraries (LLL) - audio.lua","16.04.09")
mkl.lic    ("Love Lua Libraries (LLL) - audio.lua","ZLib License")

local shit = {}

assets = assets or {}


function LoadSound(file,loop,mode)
local ret = {
               t = 'audio',
               source = love.audio.newSource(file,mode or 'stream')
            }
       ret.source:setLooping(loop==true)     
       assert(ret.source,"Failed to load: "..file)
return ret            
end shit.LoadSound = LoadSound

function PlaySound(source)
local src = ({ ['string']=(function() return assets[source] end)(), ['table']=source})[type(source)] or error("invalid sfx type: "..type(source))
assert(src.t=="audio","This is not audio. This is: "..strval(src.t))
--print(serialize('source',src)) -- debug line
love.audio.play(src.source)
end shit.PlaySound=PlaySound

function StopSound(source)
love.audio.stop(source.source)
end shit.StopSound=StopSound

return shit
