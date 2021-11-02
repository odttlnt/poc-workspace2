       ID DIVISION.
       PROGRAM-ID. DATSUB.
      * Test sample static call c2 imp with main v2
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 MYDATA              PIC X(1).
       01 MYDATA2             PIC X(1).
       PROCEDURE DIVISION.
           MOVE MYDATA TO MYDATA2.
           DISPLAY 'DAT SUB HERE  v45'.