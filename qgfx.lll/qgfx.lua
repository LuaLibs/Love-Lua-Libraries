--[[
  qgfx.lua
  quick graphics
  version: 16.03.26
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

local shit = {}

assets = assets or {}

mkl.version("","")
mkl.lic("","")

function LoadImage(file)
local ret = { ox = 0, oy = 0, t="image", file=file,
              image = love.graphics.newImage(upper(file))
            }
return ret
end             

DrawLine = love.graphics.line
Line     = love.graphics.line


function DrawRect(x,y,w,h,ftype,segs)
love.graphics.rectangle(ftype or "fill",x,y,w,h,segs or 0)
end Rect=DrawRect


Color = love.graphics.setColor
SetColor = Color

shit.LoadImage = LoadImage -- = love.graphics.newImage,love.graphics.newImage
CLS = love.graphics.clear
shit.CLS,shit.cls,shit.Cls,cls,Cls = CLS,CLS,CLS,CLS,CLS

function DrawImage(img,x,y)
local i = (({ ['string'] = function() return assets[img] end,
              ['table']  = function() return img end })[type(img)])()
love.graphics.push()
love.graphics.origin(i.ox,i.oy)
love.graphics.draw(i.image,x,y)
love.graphics.pop()                   
end 

function HotCenter(img)
local i = (({ ['string'] = function() return assets[img] end,
              ['table']  = function() return img end })[type(img)])()
i.ox=i.image:getWidth()/2
i.oy=i.image:getHeight()/2
end; shit.HotCenter = HotCenter
return shit
