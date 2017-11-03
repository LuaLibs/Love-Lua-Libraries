--[[
  chain.lua
  
  version: 17.08.23
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
-- *import mkl_version

-- *if ignore
local love = {}   -- This was only meant to fool the outliner in my Lua IDE.
-- *fi

mkl.version("Love Lua Libraries (LLL) - chain.lua","17.08.23")
mkl.lic    ("Love Lua Libraries (LLL) - chain.lua","ZLib License")

local chain={ current=nil, currentname=nil, map={}, x = {}, nothing = function() end}

keypressed = {}
scankeypressed = {}

function love.draw()
local cn = chain.currentname or "<<NIL>>"
assert ( chain.current,"I cannot draw without a valid chain! ("..cn..")")
assert ( chain.current.draw, "Hey chain "..valstr(chain.currentname).." has no draw data! ")
;(chain.x.priordraw or chain.nothing)()
chain.current.draw()
;(chain.x.afterdraw or chain.nothing)()
end

function love.update(dt)
  if not chain.current then return end
  if not chain.current.update then return end
  if chain.x.update then chain.x.update(dt) end
  return chain.current.update(dt)
end 


function love.mousemoved(x,y,dx,dy)
if not chain.current then return end
if not chain.current.mousemoved then return end
return chain.current.mousemoved(x,y,dx,dy)
end 

function love.keypressed(key,scan,repeated)
keypressed[key] = true
scankeypressed[scan] = true
if chain.x.keypressed then chain.x.keypressed(key,scan,repeated) end
if not chain.current then return end
if not chain.current.keypressed then return end
chain.current.keypressed(key,scan,repeated)
end

function love.keyreleased(key,scan,repeated)
keypressed[key] = nil
scankeypressed[scan]=nil
if chain.x.keyreleased then chain.x.keyreleased(key,scan,repeated) end 
if not chain.current then return end
if not chain.current.keyreleased then return end
chain.current.keyreleased(key,scan,repeated)
end


function love.mousepressed( x, y, button, istouch )
if chain.x.mousepressed then chain.x.mousepressed(x,y,button,istouch) end
if not chain.current then return end
if not chain.current.mousepressed then return end
chain.current.mousepressed(x, y, button, istouch)
--print("X"..type(chain.x.mousepressed)) -- Debug
end

function love.mousereleased( x, y, button, istouch )
if chain.x.mousereleased then chain.x.mousereleased(x,y,button,istouch) end
if not chain.current then return end
if not chain.current.mousereleased then return end
chain.current.mousereleased(x, y, button, istouch)
end


function love.quit()
local ret = false
if chain.current and chain.current.quit then ret = chain.current.quit()
elseif great_quit then ret = great_quit() end
return ret
end
function chain.reg(name,chaindata)
chain.map[name] = chaindata
end

function chain.go(chaindata)
if chain.current and chain.current.leave then chain.current.leave() end
(({ ["string"] = function() chain.currentname=chaindata chain.current=chain.map[chaindata] end,
    ["table"]  = function() chain.currentname="<???>" chain.current=chaindata end})[type(chaindata)] or function() error('I cannot handle type: '..type(chaindata).." for chaining!") end)()
if chain.current and chain.current.arrive then chain.current.arrive() end
end



return chain
