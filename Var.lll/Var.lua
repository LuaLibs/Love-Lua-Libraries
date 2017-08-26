--[[
  Var.lua
  
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
local v = {}

local rv

local t = {['$']='string',['%']='number',['&']='boolean'}

function v.Reg(a)
   assert(type(a),"I can only register tables. Not a "..type(a))
   rv = a
end

function v.D(k,v)
    local want = t[left(k,1)] or 'string'
    local value=v
    if want=='string' then value=''..sval(v) 
    elseif want~=type(v) then error(type(want).."  wanted for key "..k..". Not "..type(v)) end -- ''.. is meant to enforce a string value
    
    rv[k]=value
end

function v.C(k)
    if not rv[k] then return '' end
    return ''..sval(rv[k])     
end


function CVV(k)
   return rv[k]
end v.CVV=CVV    

function Done(k)
   assert(left(k,1)=='&','Done wants booleans!')
   local ret = rv[k]==true
   rv[k]=true
   return ret
end v.Done=Done

function v.S(s)
  local ret = s
  for k,vl in spairs(rv) do
      ret = replace(ret,k,v.C(k))
  end
  return ret
end               



return v
