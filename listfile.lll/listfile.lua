-- *import mkl_version
mkl.version('','')
mkl.lic('','')

local linebreaks = {
                       '\r\n', -- DOS family (MS-DOS, PC-DOS, FreeDOS, DR-DOS,Windows, etc)
                       '\n\r', -- Acorn BBC and RISC OS spooled text output. Worth anything?
                       '\n',   -- Unix family (MacOS, Linux, BSD)
                       '\r'    -- Commodore 8-bit machines, Acorn BBC, ZX Spectrum, TRS-80, Apple II family, Oberon, the classic Mac OS up to version 9, MIT Lisp Machine and OS-9
                   }

return function (file,real)
 
   local str

   if real then
      local bt = io.open(file)
      str = bt:read('*all')
      bt:close()
   else
      str = love.filesystem.read(file)
   end
   
   for brk in each(linebreaks) do
       local p,l = str:find(brk,1,true)
       if p then return mysplit(str,brk) end
   end
   
   return {str} -- If all else fails, let's do this.         

end