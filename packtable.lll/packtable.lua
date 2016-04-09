--[[
  packtable.lua
  PackTable
  version: 16.04.09
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

mkl_version
mkl_lic

local function pt(table)
    --[[
    
          This function will remove all missing numbers from a table in order to make all numbers in a straight line again.
          any alpha-nummeric keys will be left the way the way.
          
          Please note that this routine may not be exactly "quick", so use it with care.
          Also note.... the parameter table will not be altered, but a new table will be returned in stead (this to guarantee faster performance).
          
          
    ]]
    local ret = {}
    local max = 0
    local cur = 0
    -- I need to analyse first. Alpha-nummeric keys will be copied to the new table in the process since we needed not to alter those.
    for k,v in pairs(table) do
        if type(k)=="number" then
            if k>max then max=k end
        else
            ret[k]=v
        end
    end    
    -- That has been settled, now let's just copy all numbers to their new spots, shall we?
    for i=1,max do
        if table[i] then
           cur=cur+1
           ret[cur]=table[i]
        end
    end
    -- All done... let's return this shit!
    return ret
end
