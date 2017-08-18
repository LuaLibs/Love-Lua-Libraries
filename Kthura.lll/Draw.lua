--[[
        Draw.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.08.19
]]

mkl.version("Love Lua Libraries (LLL) - Draw.lua","17.08.19")
mkl.lic    ("Love Lua Libraries (LLL) - Draw.lua","Mozilla Public License 2.0")


-- *if ignore
local kthura={} -- This makes it easier to use my outliner, otherwise it won't outline and these functions are too important for me. 
-- *fi

kthura.showzones = false -- Should only be true when debugging.

local loadedtextures = {}

local function genloadtexture(o)
   loadedtextures[o.KIND] = loadedtextures[o.KIND] or {}
   local lto = loadedtextures[o.KIND]
   local tfl = o.TEXTURE:upper()
   lto[tfl] = lto[tfl] or LoadImage(tfl)
   return lto[tfl]
end

local function niets() end

local function animate(o)
   -- content comes later 
end

local function ktcolor(o)
   Color(o.COLOR.r,o.COLOR.g,o.COLOR.b,255*o.ALPHA)
end

local drawclass = {

    Pic = {
        draw = function(self,camx,camy)
           animate(self)
           ktcolor(self)
           self.X = self.COORD.x
           self.Y = self.COORD.y
           if self.SIZE.width==0 or self.SIZE.height==0 then
              DrawImage(self.LoadedTexture,self.X-(camx or 0),self.Y-(camy or 0),self.FRAME,self.ROTATION,self.SCALE.x/1000,self.SCALE.y/1000)
           else
              local pw,ph=ImageSizes(self.LoadedTexture)
              for x=0,self.SIZE.width-1 do for y=0,self.SIZE.height-1 do
                 local mdx=x*pw
                 local mdy=y*ph
                 DrawImage(self.LoadedTexture,(mdx+self.X)-(camx or 0),(mdy+self.Y)-(camy or 0),self.FRAME,self.ROTATION,self.SCALE.x/1000,self.SCALE.y/1000)
              end end
           end   
        end
    },    
    Obstacle = {
       LoadTexture=function(o)
          local r = genloadtexture(o)
          local w,h = ImageSizes(r)
          Hot(r,w/2,h)
          return r
       end,
       draw = function(self,camx,camy)
          
       end,
    },
    Zone = { -- Here everyhting just has to be empty
       LoadTexture=niets,
       draw=function(o) end
    
    },
    Exit = {LoadTexture=niets,draw=niets}

}



function kthura.drawobject(self,camx,camy)
     assert(self.KIND,errortag("kthura.drawobject",{self,camx,camy}," Object has no kind"))
     local c = drawclass[self.KIND]
     assert(c,errortag("kthura.drawobject",{self,camx,camy}," kind '"..self.KIND.."' not supported in this version of the Kthura Drawing Engine"))
     self.LoadedTexture = (c.LoadTexture or genloadtexture)(self)
     c.draw(self,camx,camy)    
end


function kthura.drawmap(self,layer,camx,camy)
    --[[ test code
    if type(layer)=='string' then 
       for o in each(self.MapObjects[layer]) do 
           if not o.draw then kthura.classobject(o) end
           if o.VISIBLE then o:draw(camx,camy) end
       end        
    elseif type(layer)=='table' then
       for o in each(layer) do
           if not o.draw then kthura.classobject(o) end
           if o.VISIBLE then o:draw(camx,camy) end
        end
    
    else
       error(errortag("kthura.drawmap",{},"Illegal layer ("..type(layer)..")"))    
    end
    ]]
    assert(self.MapObjects[layer],errortag('kthura.drawmap',{self,layer,camx,camy},"Invalid layer"))
    if not self.dominancemap then
       print("WARNING! Dominance was not mapped. This must be done before drawing so let's do that now anyway") 
       kthura.remapdominance(self) 
    end
       for _,dm in spairs(self.dominancemap[layer]) do
         for o in each(dm) do 
           if not o.draw then kthura.classobject(o) end
           if o.VISIBLE then o:draw(camx,camy) end
         end  
       end            
end