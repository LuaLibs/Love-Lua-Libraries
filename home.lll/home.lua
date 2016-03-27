--[[
  home.lua
  home
  version: 16.03.27
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

mkl.version("Love Lua Libraries (LLL) - home.lua","16.03.27")
mkl.lic    ("Love Lua Libraries (LLL) - home.lua","ZLib License")

local mydir = "Phantasar Productions"  -- You're free to rename this to your own name in or order to get the right folder!

local rhome = {
      
      -- *if $LINUX
      mycompanydir = love.filesystem.getUserDirectory() .. "/." .. mydir,
      -- *if !$LINUX
      mycompanydir = love.filesystem.getAppdataDirectory() .. "/".. mydir,
      -- *fi
      
      home = love.filesystem.getUserDirectory(),
      appsupport = love.filesystem.getAppdataDirectory(),      
      save = love.filesystem.getSaveDirectory( )

}

rhome.mydatadir = rhome.mycompanydir.."/"..(gametitle or "mylovegame")
print("Love save="..rhome.save)

function rhome.createmydatadir(suf)
assert( love.filesystem.createDirectory( rhome.mydatadir .. (suf or "") ) , "Could not create: "..rhome.mydatadir..(suf or "") )
print("Created: "..rhome.mydatadir..(suf or ""))
end

function rhome.createsavedir(suf)
assert( love.filesystem.createDirectory( rhome.save .. (suf or "") ) , "Could not create: "..rhome.save..(suf or "") )
print("Created: "..rhome.save..(suf or ""))
end


return rhome
