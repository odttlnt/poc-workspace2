       ID DIVISION.
       PROGRAM-ID. DATXCICS.
      *    THIS DEMONSTRATES Impact build with aCICS/BMS
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *
      *    COPY DFHAID.
      *
      * My test map
           COPY DATMAP.
       PROCEDURE DIVISION.
            DISPLAY 'Sending a test map'.
            EXEC CICS
                SEND MAP ('DATMAP')
                     MAPSET('DATMLIS')
                     FROM(DATMLISO)
            END-EXEC.
