--[[
        xmath.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.07.29
]]
function highest(a1,a2)
   local ret=nil
   local a = {a1,a2} 
   for i in each(a) do
       if (not ret) or ret<i then ret=i end
   end
   return ret or 0
end   
