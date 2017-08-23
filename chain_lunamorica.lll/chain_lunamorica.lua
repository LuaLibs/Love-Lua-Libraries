--[[
  chain_lunamorica.lua
  
  version: 17.08.23
  Copyright (C) 2017 Jeroen P. Broks
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
--[[ 

    This module combines chain with lunarmorica.
    You can use your normal chains as you are used to do, but note that the x functions are taken over!
    If you redefine them... Boohooo!
    
    This module adds the "lunar" variable and this should be a table containing the sane key names as your chain map and the values should be the gadgets.
    Since Lua is pointer based it's easy to tie one gadget to multiple chain pages.
    
    This will cause the gadget to get visible on every chain page.
    
]]

-- *import chain
-- *import lunamorica

mkl.version("Love Lua Libraries (LLL) - chain_lunamorica.lua","17.08.23")
mkl.lic    ("Love Lua Libraries (LLL) - chain_lunamorica.lua","ZLib License")

lunar = {}

local function deal_event(evnt,a1,a2,a3,a4,a5)
  local cn = chain.currentname  
  if lunar[cn] then
     if lunar[cn][evnt] then lunar[cn][evnt](lunar[cn],a1,a2,a3,a5) end
  end
end        


chain.x.update=function(dt)             deal_event('lupdate',dt) end
chain.x.afterdraw=function()            deal_event('draw') end
chain.x.keypressed=function(k,s,r)      deal_event('keypressed',k,s,r) end
chain.x.keyreleased=function(k,s,r)     deal_event('keyreleased',k,s,r) end
chain.x.mousepressed=function(x,y,b,t)  deal_event('mousepressed',x,y,b,t)  end
chain.x.mousereleased=function(x,y,b,t) deal_event('mousereleased',x,y,b,t) end
