/* DBB Groovy Class to demo how to convert a file with Rexx using DBB's TSOExec  api (NLOPEZ)   
 *
 *  runs a rexx exec to convert cobol code with changeman "-INC  xxx" in col 1 to normal cobol "COPY xxx" in col 8
 *  uses 2 pds's and a rexx exec on MVS
 *  PDS DD=in  source with potential -INC
 *  PDS DD=out converted members PDS (prealloacted on 3.2) 
 *  RC=0 nothing found 
 *  RC=2 conversions made and output to DD=out       
 *  Run under Groovyz
 */   
import com.ibm.dbb.build.* 

TSOExec exec = new TSOExec()
	exec.setCommand("ex 'NLOPEZ.DAT.EXEC(CMMIG)'")
	exec.confDir('/u/nlopez/IBM/dbb/conf')					// points to the runIspf.sh interface 
	
	exec.logFile(new File('/u/nlopez/tmp/TSOExec.log'))  	// has log fo ispf gateway interface	
	exec.keepCommandScript(true)  				// does not delete the file below. Goo for tracing errors
    	exec.addDDStatement("CMDSCP", "NLOPEZ.ISPFGWY.EXEC", "RECFM(F,B) LRECL(80) TRACKS SPACE(1,1) DSORG(PS)", false);

 	exec.addDDStatement("IN",  "NLOPEZ.DAT.COBOL(CMINC)", "SHR", false);
 	exec.addDDStatement("OUT", "NLOPEZ.DAT.COBOL2(CMINC)", "SHR", false);
 
	int rc = exec.execute()
			
if (rc == 2) println "**! Member Converted. See OUT DD PDS"
	
println "RC = $rc"
System.exit(rc)
	 