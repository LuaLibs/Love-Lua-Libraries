--[[
  quickmath.lua
  Quick math features for lazy people like me
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
sin = math.sin
cos = math.cos
sqr = math.sqrt
rand = love.math.random
abs = math.abs
floor = math.floor
ceil = math.ceil


function empower(value,exponent)
local ret = 0
for i=2,exponent do ret = ret * value end
return ret
end 

-- Yeah, I know.... I'm LAZY!


-- *import mkl_version
mkl.version("Love Lua Libraries (LLL) - quickmath.lua","16.04.17")
mkl.lic    ("Love Lua Libraries (LLL) - quickmath.lua","ZLib License")
