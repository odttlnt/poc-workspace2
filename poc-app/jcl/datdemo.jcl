//NLOPEZ1Z JOB CLASS=A,MSGCLASS=H,NOTIFY=NLOPEZ
//* Sample jcl to run batch DATDEMO pgm v22.f zDt
//S EXEC PGM=DATDEMO
//*STEPLIB  DD  DISP=SHR,DSN=DAT.DEV.LOAD     UCD Loadlib
//STEPLIB  DD  DISP=SHR,DSN=NLOPEZ.IDZ.LOAD   IDz Loadlib
//*STEPLIB  DD  DISP=SHR,DSN=DAT.POC.LOAD
//         DD DSN=EQAE20.SEQAMOD,DISP=SHR
//         DD DSN=FELE20.SFEKAUTH,DISP=SHR
//SYSOUT   DD SYSOUT=*
//*
//* Debug sample jcl
//CEEDUMP  DD SYSOUT=*
//**
//*NOTE on local zDT box start the debuger STC /s DBGMGR
//* zapp needs alloc the same file during the compile
//* dd below is needed when compileing with TEST(SOURECE,SEP) only
//EQADEBUG DD DSN=NLOPEZ.IDZ.DEBUG(DATADEMO),DISP=SHR  Sep file
//CEEOPTS  DD *
  TEST(,,,TCPIP&192.168.88.113:*)
/*
//*
//* Use TEST to start the IDz debbugger Prespective
//* TEST(,,,DBMDT%NLOPEZ:)
//*
//* Or run this to generate the code coverage rpt
//*ENVAR("EQA_STARTUP_KEY=CC")
/*