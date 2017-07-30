--[[
  cleartable.lua
  
  version: 17.07.30
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
local function cleartable(table)
   assert ( type(table)=='table', 'cleartable ONLY works on table variables, dummy!')
   local elements = {}
   for k,_ in pairs(table) do elements[#elements+1]=k end
   for _,k in ipairs(elements) do table[k]=nil end
   -- This double approach is eating extra RAM and speed, I know, but experience taught me that doing this directly does spook up iterators causing very nasty effects (and half of the table not being emptied)
end

ClearTable = cleartable

return cleartable
