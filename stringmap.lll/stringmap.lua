-- *import mkl

mkl.version('','')
mkl.lic    ('','')


--[[

   this routine is fake... Lua doesn't need it at all.
   I used to to make it easier to convert BlitzCode into Lua.
   That's all.
   
   
]]

local function v(self,key) return self.tab[key] end

function newStringMap()
  return { Value = v, value=v, tab={}}
end
NewStringMap=newStringMap
newstringmap=newStringMap  
NewTMap = newStringMap
newtmap = newStringmap



function MapInsert(map,key,value) map.tab[key]=value  end -- This makes convertation from Blitz sooo much easier.
function MapValueForKey(map,key)  return map.tab[key] end 

function MapKeys(map)
  local t={}
  local i=0
  for k,_ in spairs(map.tab) do t[#t+1]=k end
  return function()
      i = i + 1
      return t[i]
  end
end  

function MapValues(map)
  local t={}
  local i=0
  for _,v in spairs(map.tab) do t[#t+1]=v end
  return function()
      i = i + 1
      return t[i]
  end
end  

function MapRemove(map,key)
  map.tab[key]=nil
end

function MapContains(map,key)
  return map.tab  [key] ~= nil
end


function ListContains(list,what)
    for w in each(list) do
        if w==what then return true end
    end
    return false
end

function ListAddLast(list,item)
    list[#list+1]=item
end        
        