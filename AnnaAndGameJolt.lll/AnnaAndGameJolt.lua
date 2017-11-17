-- *import md5
-- *import stringmapfile
-- *localimport gjapi

local http = require("socket.http")


AGJError = ""

local anna_debug = false

local function chat(a)
   if anna_debug then print("\27[34mANNADEBUG: \27[36m"..a.."\27[0m") end
end

local annadomain = 'http://utbbs.tbbs.nl' -- Makes it easy. If I ever move Anna, all I gotta do is change this line.
local gjdomain   = 'http://gamejolt.com/api/game/v1/'

local networkstuff = {
         ['Game Jolt'] = { domain=gjdomain, gj=gjapi, tab='gamejolt' },
         Anna =          { domain=annadomain, tab='anna' }
      }
      
local ngj = networkstuff['Game Jolt']
local nan = networkstuff['Anna']      

function AnnaCreate(username)
  AGJError = ""
  local u= {       
       username = username,     
       data = {secucode = left(md5.sumhexa(love.timer.getTime( ).."Anna"),6)}
     }
  local cnt,stat,header = http.request(annadomain.."/Game.php?HC=Game&A=BPC_Create&Secu="..u.data.secucode.."&name="..u.username)
  if not cnt then return false,"Counldn't get any data ("..valstr(stat)..")" end
  success='failed'
  local lines=mysplit(cnt,"\n")
  for i=1,#lines do lines[i]=trim(lines[i]) end
  local allowread
  local getdata = {}
  local didclose,d
  for i,cl in ipairs(lines) do 
    chat(cl)
    if cl=="HANDSHAKE" and lines[i-1]=="GREET:ANNA" then 
       allowread=true
    elseif cl=="BYEBYE:SEEYA" and allowread then
       allowread=false
       didclose=true
    elseif allowread then
       d = mysplit(cl,":")
       getdata[d[1]] = d[2]
       end       
    end
    if not didclose then return "FAILED","No valid data received, or data not properly closed! ("..valstr(stat)..")" end
    u.data.kenteken = getdata.KENT
    u.data.IP = getdata.IP
    u.data.Host = getdata.HOST
    u.data.onlineid = getdata.ID
    u.data.online = getdata.STATUS=="SUCCESS"
    if getdata.STATUS=="SUCCESS" then 
       love.system.openURL('http://utbbs.tbbs.nl/Game.php?HC=Game&A=BPC_Verify&id='..u.data.onlineid..'&secu='..u.data.secucode) 
       return true,u.data
    end    
    return false,getdata.REASON or "--"   
       
end

function Anna_Request(data)
  data.HC = data.HC or "Game"
  local query_string     
  for k,v in pairs(data) do
         if query_string then query_string = query_string .. "&" else query_string = "?" end
         query_string = query_string .. k .. "=" .. v
  end
  chat("Calling: "..annadomain.."/Game.php"..query_string) -- debug line
  local cnt,stat,header = http.request(annadomain.."/Game.php"..query_string) --?HC=Game&A=BPC_Create&Secu="..u.data.secucode.."&name="..u.username)
  if not cnt then return false,"Counldn't get any data ("..valstr(stat)..")" end
  local success='failed'
  local lines=mysplit(cnt,"\n")
  for i=1,#lines do lines[i]=trim(lines[i]) end
  local allowread
  local getdata = {}
  local didclose,d
  for i,cl in ipairs(lines) do 
    chat(i.."~t"..cl)
    if cl=="HANDSHAKE" and lines[i-1]=="GREET:ANNA" then 
       allowread=true
    elseif (cl=="BYEBYE:SEEYA" or cl=='BYBYE:SEEYA') and allowread then
       allowread=false
       didclose=true
    elseif allowread then
       d = mysplit(cl,":")
       getdata[d[1]] = d[2]
       end       
    end
    if not didclose then return false,"No valid data received, or data not properly closed! ("..valstr(stat)..")" end
    if getdata.STATUS=="SUCCESS" then
       return true,getdata 
    end   
    return false,getdata.REASON or "--" 
end

function GAHD_get(file)
    local ret = {data=readstringmap(file)}
    print ( serialize('GAHD',ret) ) -- debug line
    return ret
end    


-- login
function ngj.init(gdata,udata)
    local login = udata[ngj.tab]
    --print(sval(gdata.data['GAMEJOLT.ID']),sval(gdata.data['GAMEJOLT.KEY']),"\n"..serialize('gjdata',gdata)) -- debug line
    ngj.gj:init(gdata.data['GAMEJOLT.ID'],gdata.data['GAMEJOLT.KEY'])
    local s = ngj.gj:users_auth(login.username, login.token)
    local reason
    if s then reason='Ok!' else reason = "Something failed! Network issue!?\nWrong username!?\nWrong token!?\nI don't know, but I couldn't get in!" end
    return s == 'true'   , reason
end

function nan.init(gdata,udata)
     local login = udata[nan.tab]
     local query = {HC='Game',A='Auth',Game=gdata.data['ANNA.ID'],GameSecu=gdata.data['ANNA.KEY'],Version=mkl.newestversion(),id=login.id,secu=login.secu}
     local s,r = Anna_Request(query)
     local reason = "OK"
     if not s then reason = r end
     return s,reason
end

local lastattempts = {}

function NET_Login(gdata,udata)
     local success = true
     local results = {} 
     for netname,net in spairs(networkstuff) do
       if udata[net.tab] then
         local lr = {}
         results[netname] = lr
         print("Trying to login on: "..netname)
         lr.success,lr.reason = net.init(gdata,udata)
         print("= Succes: "..sval(lr.success))
         print("= Reason: "..sval(lr.reason))
         lastattempts[netname]=results --lr.success
         success = success and lr.success
       end
     end
     return success,results 
end         

          