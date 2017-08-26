--[[
  Scenario.lua
  
  version: 17.08.26
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


--[[

  This file was taken over from the Fairy Tale Project.
  Since this is only a data loader and processor, the fact that Love2D is callback based and LAURA II is merely cycle and order based, should not matter.
  I did do some adaptions from the original lib for LAURA II. This to prevent conflicts.    
  
]]

-- GALE replacements
local CSay = print
local Sys = { Error = function(A1,A2) error(A1.."\n"..A2) end }
local function JCR6ListFile(f)
      return mysplit(love.filesystem.read(f:upper()),"\n")
end      


-- Library 
local scen = {}

local btdata
local portret = {}

scen.portret = portret

scen.data = btdata

local function RemoveData(file) btdata = btdata or {} btdata[file] = nil end
scen.RemoveData = RemoveData

local function ProcessBLine(Rec,Prefix,DLine)
local Processes = {
    ["ERROR"] = function() Sys.Error("Unknown scenario prefix") end,  -- error
    ["!"] = function(Rec,DLine) Rec.Header = DLine end,               -- header
    ["*"] = function(Rec,DLine) Rec.PicDir = DLine end,               -- Picture directory
    [":"] = function(Rec,DLine) Rec.PicSpc = DLine end,               -- Picture File
    ["%"] = function(Rec,DLine) Rec.AltTxtFont = "Fonts/"..DLine..".ttf"; CSay("Font: "..DLine)  end, -- Alternate font
    ["#"] = function(Rec,DLine) table.insert(Rec.Lines,DLine) end,    -- content
    ["$"] = function(Rec,DLine) Rec.SoundFile = DLine end,            -- sound (if not present the system will try to autodetect it)
    ["-"] = function() end
    }
local P = Processes[Prefix]
if not P then Sys.Error("Unknown scenario prefix - "..Prefix) end
P(Rec,DLine)    
end
-- scen.ProcessBLine = ProcessBLine -- Just in case, but should not be needed... right?


local function LoadData(file,loadas,merge)
local lang = scen.lang or "English" --Var.C("$LANG")
local LineNumber,Line
local crap = JCR6ListFile("Languages/"..lang.."/Scenario/"..file)
local ret = {}
local section = "[rem]"
local L
local Prefix,DLine,WorkRec
btdata = btdata or {}
scen.data = btdata
if merge then ret = btdata[loadas or file] or {} end
CSay("Loading BoxText Data: "..file)
for LineNumber,Line in ipairs(crap) do
    L = trim(Line)
    if L~="" then
       if left(L,1)=="[" and right(L,1=="]") then
          section = L
       else
          -- The select statement below is provided through the pre-processor built in the GALE system.
          -- @SELECT section
          if section=='[rem]' then-- @CASE   "[rem]"
          elseif section=='[tags]' then -- @CASE   "[tags]"
             ret[L] = {}
          elseif section=='[scenario]' then -- @CASE   "[scenario]"
             Prefix = left(L,1)
             DLine = right(L,len(L)-1)
             -- CSay("ReadLine: "..L.." >> Prefix: "..Prefix) -- Debug line.
             if (not WorkRec) and Prefix~="@" and Prefix~="-" then Sys.Error("Trying to assign data, while no boxtext\nrecord has yet been created","Line,"..LineNumber) end
             if Prefix=="@" then
                WorkRec = { Lines = {} }
                table.insert(ret[DLine],WorkRec)                
             else
                ProcessBLine(WorkRec,Prefix,DLine)   
                end
          else -- @DEFAULT
             Sys.Error("Unknown language section: "..section,"Line,"..LineNumber)   
          end -- @ENDSELECT          
          end
       end
    end
-- Load Images
local k,i,tag,rec
local picfile,picref
--[[ Set on rem as this contains code too specific to LAURA II. 
for k,tag in pairs(ret) do for i,rec in pairs(tag) do
     picfile = "GFX/Boxtext/Portret/"..sval(rec.PicDir).."/"..sval(rec.PicSpc)..".png"
     picref = upper(rec.PicDir).."."..upper(rec.PicSpc)
     if Image.Exist(picref)==0 and JCR6.Exists(picfile)==1 then 
        Image.AssignLoad(picref,picfile) 
        portret[picref]=true 
        CSay('Loaded '..picfile..' on '..picref.." (BoxText)") 
     elseif Image.Exist(picref)~=0 then
        portret[picref]=true
        end
     if portret[picref] then rec.PicRef=picref; end 
     end end
-- Auto Tie Sound Files
for k,tag in pairs(ret) do for i,rec in pairs(tag) do
    if JCR6.Exists("VOCALS/"..file.."/"..k.."_"..i..".ogg")==1 then 
      rec.SoundFile = "Vocals/"..file.."/"..k.."_"..i..".ogg" 
      CSay("Got sound for "..k.." #"..i)
    else
      -- CSay("no sound for "..k.." #"..i.."   (VOCALS/"..file.."/"..k.."_"..i..".ogg)",255,0,0) -- Only annoying. Can be unremmed if needed (which I doubt).  
    end
end end    
]] 
-- closure
btdata[loadas or file] = ret    
-- print(serialize("btdata",btdata)) -- Debug Line, must be on rem in release
return ret
end
scen.LoadData = LoadData

return scen

