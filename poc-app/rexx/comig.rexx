/* REXX TO MIGRATE CM CBL FILE WITH -INC  (NLOPEZ) `
   SAVE; TSO EX 'NLOPEZ.DAT.EXEC(CMMIG)'
   look for "-INC" in col 1 and convert to standard cobol copy stmt
   COPY must start in margin A (col 8)
   See groovy script to dd allocs
*/
say "dbb post migration processor "
"execio * diskr in (stem l.)"
newFile.0= null
nfx = 1

rewrite=no
do x = 1 to l.0
    if left(l.x,4) = '-INC' then do
       parse var l.x . copymem .
       new = "       COPY " copymem||"."
       newFile.nfx = new
       nfx = nfx + 1
       new = "      * Converted old text in col 1="l.x
       newFile.nfx = new
       nfx = nfx + 1
    /*
       say "old line =>"l.x
       say "new line =>"new
       say "cols       ----+-*A-1-B-->"
    */
       rewrite = yes
       end
    else do
       newFile.nfx = l.x
       nfx = nfx+1
       end
end
"execio 0 diskr in (FINIS"

if rewrite=yes then do
   say "Rewriting to cmfixed"
   "execio * diskw out (finis stem newFile.)"
   exit 2
end
exit 0