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
       local domstring = right("00000000000000000000"..(o.DOMINANCE or 20),5)
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

function kthura.remapall(map)
    kthura.remapdominance(map)
end

function kthura.Spawn(map,layer,spot,tag,xdata)
    local x,y
    assert(map,errortag('kthura.Spawn',{map,layer,spot,tag,xdata},"No Map"))
    assert(map.MapObjects[layer],errortag('kthura.Spawn',{map,layer,spot,tag,xdata},"Layer not found"))
    if type(spot)=='table' then
       x = spot[1] or spot.x or spot.X or 0
       y = spot[2] or spot.y or spot.Y or 0
    elseif type(spot)=='string' then
       local xspot = map.TagMap[layer][spot]
       assert(xspot,errortag('kthura.Spawn',{map,layer,spot,tag,xdata},"Tried to spawn on an non-existent spot"))
       x = xspot.COORD.x
       y = xspot.COORD.y
    end   
    local actor = {}
    local list = map.MapObjects[layer]
    list[#list+1] = actor
    actor.KIND = "Actor"
    actor.COORD = {x=x,y=y}
    actor.INSERT = {x=0,y=0}
    actor.ROTATION = 0
    actor.SIZE = { width = 0, height = 0 } 
    actor.TAG = tag
    actor.TEXTURE = ""
    actor.CURRENTFRAME = 1
    actor.FRAMESPEED = -1
    actor.ALPHA = 1
    actor.VISIBLE = true
    actor.COLOR = { r = 255, g = 255, b = 255 } 
    actor.IMPASSIBLE = false
    actor.FORCEPASSIBLE = false
    actor.SCALE = { x = 1000, y = 1000 } 
    actor.BLEND = 0
    kthura.makeobjectclass(actor)
    for k,v in pairs(xdata or {}) do actor[k] = v end
    kthura.remapall(map)
end
kthura.spawn=kthura.Spawn




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
