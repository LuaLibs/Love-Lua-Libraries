--[[
  binread.lua
  
  version: 17.11.17
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
-- * import mkl_version

mkl.version("Love Lua Libraries (LLL) - binread.lua","17.11.17")
mkl.lic    ("Love Lua Libraries (LLL) - binread.lua","ZLib License")


local function gbyte(d)
     d.pos = d.pos + 1
     assert(d.pos<#d.data,"Reading past EOF")
     return string.byte(mid(d.data,d.pos,1))
end     

local function ghighnum(d,l)
    local ret = 0
    for i=0,l-1 do
        local a = d:getbyte()
        if i>0 then a = a * (256^i) end
        ret = ret + a
    end
    return ret
end

local function gint(d)  return d:ghighnum(4) end
local function glong(d) return d:ghighnum(8) end 

local function gstring(d,l)
    local ln = l or d:getint()
    local ret = ""
    for i=1,ln do ret = ret .. string.char(d:getbyte()) end
    return ret
end

local function dseek(d,pos)
    assert(pos<#d.data,"Seeking beyond EOF")
    d.pos = pos
end

local function deof(d)
    return d.pos>=#d.data
end

return function(file)
    local ret = {}
    ret.data = love.filesystem(file)
    ret.pos  = 0
    ret.size = #ret.data
    ret.getbyte = gbyte
    ret.gethighnum = ghighnum
    ret.getint = gint
    ret.getlong = glong
    ret.getstring = gstring
    ret.seek = dseek
    ret.eof = deof
    return ret
end
