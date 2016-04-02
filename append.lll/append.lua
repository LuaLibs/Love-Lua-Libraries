--[[
  append.lua
  Append
  version: 16.04.02
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

mkl.version("Love Lua Libraries (LLL) - append.lua","16.04.02")
mkl.lic    ("Love Lua Libraries (LLL) - append.lua","ZLib License")

local function wanttable(tbl,v)
assert (type(tbl),"I expected atable to "..({[1]=" append to", [2]="get items from to append"})[v or 1].." but I received "..type(tbl))
end

local function appendvalue(tbl,value)
wanttable(tbl)
tbl[#tbl+1]=value
end

local function appenditems(tbl,tbla)
wanttable(tbl)
wanttable(tbla,2)
for i,v in ipairs(tbla) do appendvalue(tbs,v) end
end

local function append(tbl,value,byitems)
({ [false]=appendvalue, [true]=appenditems })[v==true]()
end

return append



--[[


   Contrary to most modules where you have to do <module name>.<function>(), the module itself just only adds one function: "append"
   any questions?
   
]]   
