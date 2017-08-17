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

mkl.version()
mkl.lic()

lunar = {}

local function deal_event(evnt,a1,a2,a3,a4,a5)
  local cn = chain.currentname  
  if lunar[cn] then
     if lunar[cn][evnt] then lunar[cn][evnt](lunar[cn],a1,a2,a3,a5) end
  end
end        


chain.x.update=function()               deal_event('update') end
chain.x.afterdraw=function()            deal_event('draw') end
chain.x.keypressed=function(k,s,r)      deal_event('keypressed',k,s,r) end
chain.x.keyreleased=function(k,s,r)     deal_event('keyreleased',k,s,r) end
chain.x.mousepressed=function(x,y,b,t)  deal_event('mousepressed',x,y,b,t)  end
chain.x.mousereleased=function(x,y,b,t) deal_event('mousereleased',x,y,b,t) end
