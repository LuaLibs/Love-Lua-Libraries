--[[
        Gadget_Pivot.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.08.17
]]
--[[ This gadget does NOTHING at all, but it can serve as a pinpoint to base kids on. ]]

local pivot = {}


function pivot.init(g)
         g.x  = g.x  or 0
         g.y  = g.y  or 0
end

function pivot.draw(g)
  -- lalalala we do nothing at all, lalalala!
end

return pivot  
