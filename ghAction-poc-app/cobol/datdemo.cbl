       ID DIVISION.
       PROGRAM-ID. DATDEMO.
      *
      * Simple demo code (NLopez)
      * Use GITHUB project's DEVELOP branch
      * v1.0
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
      *
      *=============
      *
       PROCEDURE DIVISION.
      * MAIN PGM DISPLAY
      *
           DISPLAY 'DATDEMO Via 3.5'.
      *
      *    PERFORM FEATURE1-NEW.
      *
      *========= include copy book
           DISPLAY 'CPYBK=DATDEPND' WS-VER.
           STOP RUN.
      *====================

