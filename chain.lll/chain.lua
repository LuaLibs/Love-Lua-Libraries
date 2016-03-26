--[[
  chain.lua
  
  version: 16.03.26
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

-- *if ignore
local love = {}   -- This was only meant to fool the outliner in my Lua IDE.
-- *fi

mkl.version("","")
mkl.lic("","")

local chain={ current=nil, currentname=nil, map={} }


function love.draw()
assert ( chain.current,"I cannot draw without a valid chain! ")
assert ( chain.current.draw, "Hey chain "..valstr(chain.currentname).." has no draw data! ")
chain.current.draw()
end

function love.update()
if not chain.current then return end
if not chain.current.update then return end
return chain.current.update()
end 



function chain.reg(name,chaindata)
chain.map[name] = chaindata
end

function chain.go(chaindata)
({ ["string"] = function() chain.currentname=chaindata chain.current=chain.map[chaindata] end,
   ["table"]  = function() chain.currentname="<???>" chain.current=chaindata end})[type(chaindata)]()
end



return chain
