      * STARTOPT:
      * DB2OISO: CS
      * DB2OEXP: YES
      * DB2OACQ: ALLOCATE
      * DB2OREL: DEALLOCATE
      * DB2OVAL: BIND
      * ENDOPT:
      * Shut down for now
      * test case- how to resolve dclgen with same name as
      * cpybk? conclusion - not supported.  see my tips doc
       ID DIVISION.
       PROGRAM-ID. DB2PGM
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * a dclge name just like a cpy
      *     EXEC SQL
      *          INCLUDE PRODUCTS
      *     END-EXEC.
      * a test of a reg cpy
      *     COPY PRODUCTS.
       01 TESTM2                                PIC X.
       01 TESTM                                 PIC X(32).
           EXEC SQL
                INCLUDE SQLCA
            END-EXEC.

      *     EXEC SQL
      *          INCLUDE MYTEST
      *     END-EXEC.
       PROCEDURE DIVISION.
            EXEC SQL
                SELECT CURRENT_DATE
                INTO :TESTM
                FROM SYSIBM.DUMMY1
               END-EXEC.

