       ID DIVISION.
       PROGRAM-ID. DATDEMO.
      *    THIS DEMONSTRATES Impact build with CICS/BMS
      * Tran DAT0 in rpl NLOPEZ.IDZ.LOAD  v4.1
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *
      *    COPY DFHAID.
      *
      * My test map
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
