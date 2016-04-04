--[[
  save.lua
  Save Routine
  version: 16.04.04
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
-- I need to note! You require the serializer which is included to your game automatically in order to use this library.
-- Without it, this library will NOT work!

local s = {}

function s.save(file,var)
local str = 
[[

  -- This file has been generated by ]]..gametitle..[[.
  -- and may only be used in combination with that game
  -- and in unmodified form. 
  -- unless stated otherwise in the game license.
  
	local ret
	
	]]..serialize("ret",var)..[[
	
return ret
]]	
love.filesystem.write(file..".lua",str)
end


function s.multisave(file,vars)
assert ( type(vars)=='table' , "MultiSave: Expected table and the developer gave me a "..type(vars) )
local str = 
[[

  -- This file has been generated by ]]..gametitle..[[.
  -- and may only be used in combination with that game
  -- and in unmodified form. 
  -- unless stated otherwise in the game license.

]]
str = str .."\nlocal "
local loc = ""
for i = 1 , #vars do
    if i>1 then loc = loc ..", " end
    loc = loc .. "ret"..i
    end    
str = str .. loc .. "\n\n\n\n";
for i,v in ipairs(vars) do
    str = str .. serialize("ret"..i,v).."\n\n";
    end
str = str .. "\n\nreturn "..loc  .."\n\n\n"       
love.filesystem.write(file..".lua",str)
end

function s.load(file,keepcase,careful)
   if careful then
      return j_love_import(file..".lua",keepcase~=false)
   else
      local f = file..".lua"
      if keepcase~=false then f=upper(f) end
      local mychunk = love.filesystem.load(f)
	    return mychunk()
	 end    
end

return s
