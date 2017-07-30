local function cleartable(table)
   assert ( type(table)=='table', 'cleartable ONLY works on table variables, dummy!')
   local elements = {}
   for k,_ in pairs(table) do elements[#elements+1]=k end
   for _,k in ipairs(elements) do table[k]=nil end
   -- This double approach is eating extra RAM and speed, I know, but experience taught me that doing this directly does spook up iterators causing very nasty effects (and half of the table not being emptied)
end

ClearTable = cleartable

return cleartable