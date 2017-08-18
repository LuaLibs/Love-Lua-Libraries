--[[
        Core.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.08.19
]]

mkl.version("Love Lua Libraries (LLL) - Core.lua","17.08.19")
mkl.lic    ("Love Lua Libraries (LLL) - Core.lua","Mozilla Public License 2.0")


-- *if ignore
local kthura={} -- This makes it easier to use my outliner, otherwise it won't outline and these functions are too important for me. 
-- *fi

function kthura.remapdominance(map)
   map.dominancemap = {}
   for lay,objl in pairs(map.MapObjects) do for o in each(objl) do
       map.dominancemap[lay] = map.dominancemap[lay] or {}
       local domstring = right("00000000000000000000"..o.DOMINANCE,5)
       map.dominancemap[lay][domstring] = map.dominancemap[lay][domstring] or {}
       local m =map.dominancemap[lay][domstring]
       m[#m+1]=o
   end end
end

function kthura.makeobjectclass(kthuraobject)
     kthuraobject.draw = kthura.drawobject
end

function kthura.makeclass(map)
     for lay,objl in pairs(map.MapObjects) do for o in each(objl) do kthura.makeobjectclass(o) end end
     map.draw = kthura.drawmap
     map.remapdominance = kthura.remapdominance(map)
end




-- Please note, only maps exported in Lua format can be read.
-- No pure Kthura Maps. This to save resources on Lua engines such as Love
-- and because scripting a JCR6 reader can be problametic too.
function kthura.load(amap,real,dontclass)
   assert(type(amap)=="string",errortag('kthura.load',{amap,real,dontclass},"I just need a simple filename in a string. Not a "..type(amap)..", bozo!"))
   local map = amap:upper()
   if not suffixed(map,".LUA") then map=map..".LUA" end
   local script
   if real then
      local bt = io.open(map,'rb')
      script = bt:read('*all')
      bt:close()
   else
      script = love.filesystem.read(map)
   end
   assert( script, errortag('kthura.load',{amap,real,dontclass},"I could not read the content for the requested map"))
   local compiled = loadstring(script)
   assert ( compiled, errortag('kthura.load',{amap,real,dontclass},"Failed to compile map data"))
   local ret = compiled()
   if not dontclass then kthura.makeclass(ret) end
   kthura.remapdominance(ret)
   return ret   
end
