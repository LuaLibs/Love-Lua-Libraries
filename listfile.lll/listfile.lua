--[[
  listfile.lua
  
  version: 17.08.17
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
-- *import mkl_version
mkl.version("Love Lua Libraries (LLL) - listfile.lua","17.08.17")
mkl.lic    ("Love Lua Libraries (LLL) - listfile.lua","ZLib License")

local linebreaks = {
                       '\r\n', -- DOS family (MS-DOS, PC-DOS, FreeDOS, DR-DOS,Windows, etc)
                       '\n\r', -- Acorn BBC and RISC OS spooled text output. Worth anything?
                       '\n',   -- Unix family (MacOS, Linux, BSD)
                       '\r'    -- Commodore 8-bit machines, Acorn BBC, ZX Spectrum, TRS-80, Apple II family, Oberon, the classic Mac OS up to version 9, MIT Lisp Machine and OS-9
                   }

return function (file,real)
 
   local str

   if real then
      local bt = io.open(file)
      str = bt:read('*all')
      bt:close()
   else
      str = love.filesystem.read(file)
   end
   
   for brk in each(linebreaks) do
       local p,l = str:find(brk,1,true)
       if p then return mysplit(str,brk) end
   end
   
   return {str} -- If all else fails, let's do this.         

end
