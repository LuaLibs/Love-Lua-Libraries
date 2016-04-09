local function pt(table)
    --[[
    
          This function will remove all missing numbers from a table in order to make all numbers in a straight line again.
          any alpha-nummeric keys will be left the way the way.
          
          Please note that this routine may not be exactly "quick", so use it with care.
          Also note.... the parameter table will not be altered, but a new table will be returned in stead (this to guarantee faster performance).
          
          
    ]]
    local ret = {}
    local max = 0
    local cur = 0
    -- I need to analyse first. Alpha-nummeric keys will be copied to the new table in the process since we needed not to alter those.
    for k,v in pairs(table) do
        if type(k)=="number" then
            if k>max then max=k end
        else
            ret[k]=v
        end
    end    
    -- That has been settled, now let's just copy all numbers to their new spots, shall we?
    for i=1,max do
        if table[i] then
           cur=cur+1
           ret[cur]=table[i]
        end
    end
    -- All done... let's return this shit!
    return ret
end