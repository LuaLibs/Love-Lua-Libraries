-- *import md5
http = require("socket.http")


AGJError = ""

local annadomain = 'http://utbbs.tbbs.nl' -- Makes it easy. If I ever move Anna, all I gotta do is change this line.

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
  print("Calling: "..annadomain.."/Game.php"..query_string) -- debug line
  local cnt,stat,header = http.request(annadomain.."/Game.php"..query_string) --?HC=Game&A=BPC_Create&Secu="..u.data.secucode.."&name="..u.username)
  if not cnt then return false,"Counldn't get any data ("..valstr(stat)..")" end
  local success='failed'
  local lines=mysplit(cnt,"\n")
  for i=1,#lines do lines[i]=trim(lines[i]) end
  local allowread
  local getdata = {}
  local didclose,d
  for i,cl in ipairs(lines) do 
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
    if not didclose then return false,"No valid data received, or data not properly closed! ("..valstr(stat)..")" end
    if getdata.STATUS=="SUCCESS" then
       return true,getdata 
    end   
    return false,getdata.REASON or "--" 
end