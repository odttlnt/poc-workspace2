       ID DIVISION.
       PROGRAM-ID. DATDEMO.
      *
      * Simple demo code (NLopez) on local zDT v2.c
      * Use Pub GITHUB project's DEVELOP branch
      *
       ENVIRONMENT DIVISION.
       DATA DIVISION.
      * start of working storage
      *
       WORKING-STORAGE SECTION.
       01 WK-AREA1.
          05  FILLER       PIC X(80).
          05  num1         PIC 9(3) value zeros.
          05  num2         PIC 9(3) value is 005.
      *
       COPY DATDEPND.
       COPY DATSHARE.
      *
      *=============
      *
       PROCEDURE DIVISION.
      * MAIN PGM DISPLAY
      *
           DISPLAY 'DATDEMO here- v1.2209'.
      *
      *    PERFORM FEATURE1-NEW.
      *
      *========= include copy book
           DISPLAY 'CPYBK=DATDEPND' WS-VER.
      * do some looping
           PERFORM VARYING num1 FROM 0 BY 1 UNTIL num1 > num2
                IF num1 > 1  THEN
                    perform dump_num1
                END-IF
           END-PERFORM.
      *========== static call
           CALL 'DATSUB'.
           STOP RUN.
      *====================
      *==================== add new features down here
      *====================
       dump_num1.
           display 'Tracing num1=' num1.

      *somme commit A
      *some other commit B
      *some chg C for feature "testing_flows"
