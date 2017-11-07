--[[
  sec2time.lua
  
  version: 17.11.07
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
return function(secs)
  local ret = ''
  local s=secs
  local m,h
  while s>=60 do
        s = s - 60
        m = (m or 0) + 1
        while m>=60 do
              m = m - 60
              h = (h or 0) + 1
        end
  end
  ret = right("0"..s,2)
  if m then ret = right("0"..m,2)..":"..ret end
  if h then ret = h..":"..ret end
  return ret
end
