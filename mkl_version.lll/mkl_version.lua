--[[
  mkl_version.lua
  mkl_version
  version: 16.04.17
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

local ret = {}

     ret.data = {}
     
     ret.version = function (file,version)
                    if not file then return end
                    ret.data[file]=ret.data[file] or {}
                    ret.data[file].version = version
                    ret.data[file].array = mysplit(version,".")
                    for i = 1,#ret.data[file].array do ret.data[file].array[i] = tonumber(ret.data[file].array[i]) end
                    ret.data[file].grand = (ret.data[file].array[1]*10000)+(ret.data[file].array[2]*100)+(ret.data[file].array[3])
               end
               
     ret.lic    = function (file,version)
                    if not file then return end
                    ret.data[file]=ret.data[file] or {}
                    ret.data[file].license = version
               end
               
     ret.newestversion = function()
                    local grand,cva,cvv = 0,{0,0,0},"00.00.00"
                    for k,d in pairs(ret.data) do
                        if d.grand>grand then
                           grand = d.grand
                           cva   = d.array
                           cvv   = d.version
                        end
                    end
                    return cvv,cva,grand
               end          
               
     



local function me(mkl)
mkl.version("Love Lua Libraries (LLL) - mkl_version.lua","16.04.17")
mkl.lic    ("Love Lua Libraries (LLL) - mkl_version.lua","ZLib License")
end; me(ret)

mkl = ret
return ret
