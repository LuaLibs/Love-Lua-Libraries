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