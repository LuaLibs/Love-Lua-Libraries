--[[
        lunamorica.lua
	(c) 2017 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 17.07.27
]]

-- *import mkl_version
-- *import strings

-- *if ignore
local mkl = {}
-- *fi
mkl.version("Love Lua Libraries (LLL) - lunamorica.lua","17.07.27")
mkl.lic    ("Love Lua Libraries (LLL) - lunamorica.lua","Mozilla Public License 2.0")


-- Note if you do not want to use the mkl library, just copy the version number into the VERSION field below and turn the mkl related field above into comments.

-- Lib info
local lunamorica = {
  _VERSION     = mkl.data["Love Lua Libraries (LLL) - lunamorica.lua"].version,
  _DESCRIPTION = "Lunamorica -- GUI set for Love2d",
  _URL         = "<< comes later >>",
  _LICENSE     = [[

            This Source Code Form is subject to the terms of the 
            Mozilla Public License, v. 2.0. 
            
            If a copy of the MPL was not distributed with this file, 
            you can obtain one at https://mozilla.org/MPL/2.0/.
            
  ]]
}



--[[ 

      Lunamorica is a User Interface library I've set up 
      for my own Love Builder.
      
      It can be used to make it easier to set up a GUI like interface.
      
      Of course, since Love2D is meant to be "above" the OS, and thus
      to be completely platform independent, Lunamoria does NOT use
      the standard GUI sets that come with an OS. 
      
      You should as such not expect the same functionality from it
      not that it works as "professional" as the OS UI, as I did
      take simpliclicity in mind when I set this up.and
      
]]

--[[

      WARNING!
      When you are reading this, lunarmorica is still in development
      and will therefore be completely buggy or lots of features 
      not yet being working, at all.
      
      This is very pre-alpha.
      
]]      

lun_active = nil

local defaultconfig = {
                        -- F = Foreground, B = Background
                        -- R = Red, G=Greem, B=Blue
                        -- So RF = Foreground Red, and BF = Background Red.
                        General = { FR = 0, FG=0, FB=0, BR=127, BG=127, BB=127 }
                      }
local config = defaultconfig


local screen = { x =0, y=0, ax=0, ay=0, w=love.graphics.getWidth(),h=love.graphics.getHeight(), kind='Screen'}

local loadedfonts = { ['default:12'] = love.graphics.newFont( 12 ) }

local function LNOTHING(self) end -- This function will serve as crash preventor.

local function lv_show(self) -- to use in the "love.draw" function 
   if self.visible then
      local overwrite = self:adraw()
      if not overwrite then self:lf_draw() end
      self:pdraw()
      for id,kid in self.serial(self.kids) do kid:show() end
   end   
end

local function lv_update(self) -- to use in the "love.update" function. If no gadget features using this are there, best not to use this one to save performance.
   if self.visible and self.enabled then
      if self.lf_lupdate then self:lf_lupdate() end
      for id,kid in self.serial(self.kids) do kid:lupdate() end
   end
end

-- Can be used in the love.keypressed function. If no gadgets requiring the keyboad are there, best to leave it be to save performance. 
-- If you have gadgets using this (like textfields) you need this routine or the keys will be ignored.
-- You can also set "donotrecurse" if you have a very limited number of textfields or other gadgets requiring keyboard control in order to have optimal performance.  
local function lv_keypressed(self,k,sc,donotrecurse)
   if self.visible and self.enabled then
      if self.lf_kpressed then self:lf_kpressed(k,sc) end
      if not donotrecurse then for id,kid in self.serial(self.kids) do kid:kpressed(k,sc) end end
      
   end
end

-- I've set this up just in case, but I don't expect to need it.
local function lv_keyreleased(self,k,sc,donotrecurse)
   if self.visible and self.enabled then
      if self.lf_kreleased then self:lf_kreleased(k,sc) end
      if not donotrecurse then for id,kid in self.serial(self.kids) do kid:kreleased(k,sc) end end
   end
end


-- Whenever you click a gadget. 
local function lv_mousehit(self,x,y,b,t)
   if self.visible and self.enabled then
      if self.lf_mpressed then self:lf_mpressed(x,y,b,t) end
      for id,kid in self.serial(self.kids) do kid:mpressed(x,y,b,t) end       
   end
end

-- Not expected to be needed, but just in case
local function lv_mousehit(self,x,y,b,t)
   if self.visible and self.enabled then
      if self.lf_mreleased then self:lf_mreleased(x,y,b,t) end
      for id,kid in self.serial(self.kids) do kid:mreleased(x,y,b,t) end       
   end
end

local function gadgetcolor(self,back)
   if back=='pic' then
     love.graphics.setColor( self.PR, self.PG , self.PB, self.alpha )      
   elseif back then
     love.graphics.setColor( self.BR, self.BG , self.BB, self.alpha )
   else  
     love.graphics.setColor( self.FR, self.FG , self.FB, self.alpha )
   end  
end   

local function gcaption(self)
   return self.acaption or self.caption or ""
end   

local function lv_font(self)
    local f = (self.font or "Default"):lower()
    local s = self.fontsize or 12
    local t = f..":"..s
    if (self.font or "default"):lower()=="default" then
       loadedfonts[f] = loadedfonts[f] or love.graphics.newFont(s)
    else   
       loadedfonts[f] = loadedfonts[f] or love.graphics.newFont(f:upper(),s)
    end   
    love.graphics.setFont(loadedfonts[f])
end    

-- This will tell Lunamorica how to deal with certain events triggered by gadgets.
-- This table may NOT be called directly. Lunamorica uses it to attach the proper functions to their proper locations.
local gadgets = { Screen = {} }

local list = love.filesystem.getDirectoryItems( "$$mydir$$" )
for f in each(list) do
    local gn = lower(f)
    if prefixed(f,"GADGET_") and suffixed(f,".LUA") then
       gn = left(gn,len(gn)-4)
       gn = right(gn,len(gn)-7)
       print("Initating gadget: "..gn)
       gadgets[gn]=j_love_import("$$mydir$$/"..f)
    end
end
list = nil       


-- This function will set the config settings.
-- It expects a table variable, and it will store the pointer so if you change the config variable afterward Lunamorica will need no update with this function.
-- Setting 'nil' or ovalue at all will reset to the default config
function lunamorica.config(cfg)
   config = cfg or defaultconfig
   assert(type(config)=='table','Invalid config')
end   


-- Can be used to add customized gadgets
-- Only for advanced users who KNOW what they are doing!!!
-- (All customized gadgets will be prefixed with a "$" and are case sensitive)
function lunamorica.addgadget(ptag,gadget)
  local tag = ptag
  if not prefixed(tag,"$") then tag = "$"..tag end
  gadgets[tag] = gadget
end

-- This function will attach all proper functions and other stuff to the gadgets
function lunamorica.update(gadget,parent)
     assert(gadget      , 'I got a "nil" for a gadget')
     assert(gadget.kind , 'Gadget without kind')
     assert(gadgets[gadget.kind],"Unknown kind: "..gadget.kind)
     screen.w=love.graphics.getWidth() screen.h=love.graphics.getHeight()
     gadget.parent  = parent or screen
     gadget.funcs   = gadgets[gadget.kind]
     gadget.update  = gadget.update or LNOTHING
     gadget.adraw   = gadget.adraw  or LNOTHING
     gadget.pdraw   = gadget.pdraw  or LNOTHING
     gadget.action  = gadget.action or LNOTHING
     gadget.serial  = gadget.serial or pairs
     gadget.visible = gadget.visible ~= false
     gadget.enabled = gadget.enabled ~= false
     gadget.ax      = (gadget.parent.ax or 0) + (gadget.x or 0)
     gadget.ay      = (gadget.parent.ay or 0) + (gadget.y or 0)        
     gadget.FR      = gadget.FR or (config[gadget.kind] or config.General).FR  or 100                                 
     gadget.FG      = gadget.FG or (config[gadget.kind] or config.General).FG  or 100                                  
     gadget.FB      = gadget.FB or (config[gadget.kind] or config.General).FB  or 100                                    
     gadget.BR      = gadget.BR or (config[gadget.kind] or config.General).BR  or 100                                         
     gadget.BG      = gadget.BG or (config[gadget.kind] or config.General).BG  or 100                                         
     gadget.BB      = gadget.BB or (config[gadget.kind] or config.General).BB  or 100  
     gadget.alpha   = gadget.alpha or 255
     gadget.kids    = gadget.kids or {}                                       
     for fn,f in pairs(gadget.funcs) do gadget['lf_'..fn] = f end gadget.funcs=nil
     for _,kid in pairs(gadget.kids) do lunamorica.update(kid,gadget) end
     gadget.show    = lv_show
     gadget.draw    = lv_show
     gadget.update  = lv_update     
     gadget.color   = gadgetcolor
     gadget.getcaption
                    = gcaption
     gadget.setfont = lv_font               
     ;(gadget.lf_init or LNOTHING)(gadget,config)
     --[[ Debug
     for k,v in spairs(gadget) do
         local xt = ""
         if type(v)=="boolean" then
            xt = " = "..({[true]='true',[false]='false'})[v]
         elseif type(v)~='function' and type(v)~='table' then 
         xt = ({['string']=' = "'..v..'"',
                ['table']=' = {...}',
                ['function']='()',
                ['number']=' = '..v
                --['boolean']=' = '..(({[true]='true',[false]='false'})[v] or "nobool")
              })[type(k)]
         end      
         print(type(v).." "..k..xt..";")
     end    
     --]]
end

function lunamorica.updateall()
     lunamorica.update(screen)
end
          

return lunamorica
