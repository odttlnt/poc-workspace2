       ID DIVISION.
       PROGRAM-ID. DATBATCH.
      *
      * Simple demo code (NLopez) on local zDT v6.8
      * Use Pub GITHUB project's DEVELOP branch
      * References COMMON Copybook  DATSHARE
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WK-AREA1.
          05  FILLER       PIC X(80).
          05  num1         PIC 9(3) value zeros.
          05  num2         PIC 9(3) value is 006.
      *
        COPY DATDEPND.
      * COPY DATSHARE.
      *
       PROCEDURE DIVISION.
           DISPLAY 'DATBATCH Demo for demo'.
      *
      *========= display copybook literals
      *     DISPLAY 'CPYBK=DATDEPND -> ' WS-VER.
      *     DISPLAY 'CPYBK=DATEMBED -> ' EMBED-VER.
      *     DISPLAY 'CPYBK=DATSHARE -> ' shared-f1.

      * do something ...
           PERFORM VARYING num1 FROM 0 BY 1 UNTIL num1 > num2
                IF num1 > 1  THEN
                    perform dump_num1
                END-IF
           END-PERFORM.
      *========== static call example
      *     CALL 'DATSUB'.
           STOP RUN.
      *==========  v2
       dump_num1.
           display 'Tracing num1=' num1.
