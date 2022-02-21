       ID DIVISION.
       PROGRAM-ID. DATDEMO.
      *    THIS DEMONSTRATES Impact build with CICS/BMS
      *
      * cics IS 3270 session zdt_cics ON T6031
      * enter 'D tvt6031' no userid/pass then 'logon applid(CICS01)'
      * Tran is 'DAT0' in rpl NLOPEZ.IDZ.LOAD  v4.1
      * 
      * zapp is placed in my tmp by the pipeline process
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *
      *    COPY DFHAID.
      *
      * My test with my pre-built map 
           COPY DATMAPM.
       PROCEDURE DIVISION.
           DISPLAY 'Sending a test map'.
           EXEC CICS
                SEND MAP ('DATMLIS')
                     MAPSET('DATMAPM')
                     FROM(DATMLISO)
           END-EXEC.
      *
           CALL 'DATSUB'.
           STOP RUN.
