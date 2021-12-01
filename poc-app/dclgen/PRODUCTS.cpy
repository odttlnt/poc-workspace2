      ******************************************************************
      * DCLGEN TABLE(Q.PRODUCTS)                                       *
      *        LIBRARY(NLOPEZ.IDZ.DCLGEN(PRODUCTS))                    *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        STRUCTURE(PRODUCTS)                                     *
      *        APOST                                                   *
      *        LABEL(YES)                                              *
      *        DBCSDELIM(NO)                                           *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE Q.PRODUCTS TABLE
           ( PRODNUM                        SMALLINT NOT NULL,
             PRODNAME                       VARCHAR(11),
             PRODGRP                        VARCHAR(10),
             PRODPRICE                      DECIMAL(5, 2)
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE Q.PRODUCTS                         *
      ******************************************************************
       01  PRODUCTS.
      *    *************************************************************
           10 PRODNUM              PIC S9(4) USAGE COMP.
      *    *************************************************************
           10 PRODNAME.
              49 PRODNAME-LEN      PIC S9(4) USAGE COMP.
              49 PRODNAME-TEXT     PIC X(11).
      *    *************************************************************
           10 PRODGRP.
              49 PRODGRP-LEN       PIC S9(4) USAGE COMP.
              49 PRODGRP-TEXT      PIC X(10).
      *    *************************************************************
           10 PRODPRICE            PIC S9(3)V9(2) USAGE COMP-3.
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  IPRODUCTS.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 4 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 4       *
      ******************************************************************