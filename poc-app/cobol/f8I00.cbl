      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. F5748I00.
       AUTHOR. UIS-AD.
       DATE-COMPILED. MAY 2021.
       SECURITY.
      ******************************************************************
      *                                                                *
      *  F5748I00:     UIS SERVICE CONTROL                             *
      *                                                                *
      *  FUNCTION:     THIS PROGRAM WILL BE THE POINT OF ENTRY FOR     *
      *                ALL UIS WEB SERVICES. IT WILL HANDLE LOGGING    *
      *                AND CALLING THE DESIRED SERVICE.                *
      *                                                                *
      *  ENVIRONMENT:  ONLINE                                          *
      *                                                                *
      *  PROCESSING:   THIS PROGRAM IS SENT THE REQUEST DATA BY A      *
      *                z/OS CONNECT API/WEB SERVICE FOR DATA REQUESTED *
      *                FROM THE MAINFRAME. THE REQUEST DATA WILL       *
      *                CONTAIN A STANDARD HEADER FOR LOGGING PURPOSES  *
      *                AND THE CALLING THE DESIRED SERVICE.            *
      *                THE PROGRAM WILL START BY LOGGING THE REQUEST   *
      *                DATA AND THEN CALL THE DESIRED SERVICE. ONCE    *
      *                SERVICE HAS FINISHED PROCESSING IT WILL RETURN  *
      *                TO THIS PROGRAM TO LOG THE RESPONSE DATA AND    *
      *                FINALLY RETURN TO THE CALLING USER.             *
      *                                                                *
      *  PARAMETERS:   1. F5748I00.CPY                                 *
      *                                                                *
      *  DB2 TABLES:   T_UIS_SRV_FN_PGM                                *
      *                                                                *
      ******************************************************************
      *
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
       01  FILLER                           PIC X(27)
                                  VALUE 'WORKING-STORAGE-BEGINS-HERE'.

      ******************************************************************
      *                                                                *
      *         VARIABLE DATA AREA                                     *
      *                                                                *
      ******************************************************************
      *
       01  WS-CONSTANTS.
           05  WS-NAME-OF-THIS-MODULE       PIC X(08) VALUE 'F5748I00'.
           05  WS-VERSION-NUMBER            PIC X(03) VALUE '001'.

       01  WS-WORKING-FIELDS.
           05  WS-SEGMENT-ID                PIC X(01) VALUE SPACE.
           05  WS-TIMESTAMP                 PIC X(26) VALUE SPACES.
           05  WS-UPDATED-INFORCE-TS        PIC 9(14) VALUE ZEROES.
           05  WS-INFORCE-TS-NINES          PIC 9(14) VALUE ZEROES.
           05  WS-TS-NINES                  PIC 9(14)
                                            VALUE 99999999999999.
           05  WS-REPLY-RESULT              PIC 9(02) VALUE ZEROES.
           05  WS-LOG-ID                    PIC X(50) VALUE SPACES.
           05  WS-USER-AUTH-LVL             PIC X(01) VALUE ' '.
               88  USER-HAS-UPDATE                    VALUE 'Y'.
               88  USER-HAS-INQUIRY                   VALUE 'I'.
               88  USER-HAS-NO-ACCESS                 VALUE 'N'.
           05  WS-RESPCODE                  PIC S9(9) USAGE COMP
                                                      VALUE ZEROS.
           05  WS-REPLY-CUST-NM             PIC X(50) VALUE SPACES.
           05  WS-REPLY-EMPLOYEE-NAME.
               10  WS-REPLY-EMPE-FRST-NM    PIC X(50) VALUE SPACES.
               10  WS-REPLY-EMPE-LST-NM     PIC X(50) VALUE SPACES.
ANKITV     05  WS-LOG-DATA                  PIC X(31600)
                                                      VALUE SPACES.

       01  WS-ERROR-AREA.
           05  WS-CUST-NOTPRVD-MSG          PIC X(60) VALUE
         'UIS CUSTOMER NUMBER NOT PROVIDED.                           '.
           05  WS-INVALID-CUST-MSG          PIC X(60) VALUE
         'UIS CUSTOMER NUMBER NOT VALID.                              '.
           05  WS-CUST-NOTFND-MSG           PIC X(60) VALUE
         'THE CUSTOMER NUMBER DOES NOT EXIST ON THE INFORCE CONTROL.  '.
           05  WS-INVALID-EMPE-MSG          PIC X(60) VALUE
         'THE EMPLOYEE DOES NOT EXIST ON THE INFORCE FILE.            '.
           05  WS-NO-CUST-MSG               PIC X(60) VALUE
         'CUSTOMER NUMBER NOT ENTERED. PLEASE TRY AGAIN.              '.
           05  WS-NO-EMPE-MSG               PIC X(60) VALUE
         'EMPLOYEE NUMBER NOT ENTERED.                                '.
           05  WS-NO-EMPE-INVALID           PIC X(60) VALUE
         'UIS EMPLOYEE ID IS NOT VALID.                               '.
           05  WS-NOT-AUTHORIZED-MSG        PIC X(60) VALUE
         'USER DOES NOT HAVE ACCESS AUTHORITY FOR THIS SERVICE.       '.
           05  WS-NO-USERID-MSG             PIC X(60) VALUE
         'USER ID NOT PROVIDED.                                       '.
           05  WS-INVALID-CUSTTYPE-MSG      PIC X(60) VALUE
         'CUSTOMER NUMBER-TYPE MUST BE UIS.                           '.
           05  WS-NO-SERVID-MSG             PIC X(60) VALUE
         'SERVICE ID NOT PROVIDED.                                    '.
           05  WS-SERVID-LEN-MSG            PIC X(60) VALUE
         'SERVICE ID EXCEEDS MAXIMUM LENGTH.                          '.
           05  WS-NO-SERVFUNC-MSG           PIC X(60) VALUE
         'SERVICE FUNCTION CODE NOT PROVIDED.                         '.
           05  WS-SERVFUNC-NOT-VLD-MSG      PIC X(60) VALUE
         'SERVICE FUNCTION CODE NOT VALID.                            '.
           05  WS-NO-SERVNAME-MSG           PIC X(60) VALUE
         'SERVICE NAME NOT PROVIDED.                                  '.
           05  WS-NO-SOURCE-MSG             PIC X(60) VALUE
         'SOURCE APPLICATION NAME NOT PROVIDED.                       '.
           05  WS-NO-OPER-MSG               PIC X(60) VALUE
         'REQUEST OPERATION NOT PROVIDED.                             '.

           05  WS-SYSTEM-ERROR-MSG.
               10  WS-SYSTEM-FAILURE        PIC X(30) VALUE
                                  'SERVICE HAD A SYSTEM FAILURE  '.
               10  FILLER                   PIC X(02) VALUE '- '.
               10  WS-SYSTEM-PGM            PIC X(08) VALUE SPACES.
               10  FILLER                   PIC X(03) VALUE ' - '.
               10  WS-SYSTEM-NUMBER         PIC 9(04) VALUE ZEROS.

           05  OPTIONAL-IO-MODULE-ERROR-MSG PIC X(80).

       01  WS-SWITCHES.
           05  WS-DB2-CUST                  PIC X(01) VALUE SPACE.
               88 DB2-CUST-FND                        VALUE 'Y'.
               88 DB2-CUST-NOT-FND                    VALUE 'N'.


       01  WS-COUNTER-AREA.
           05  WS-SPACE-COUNT               PIC 9(03) VALUE ZEROES.
           05  WS-SUB                       PIC 9(09) VALUE ZEROES.

      ******************************************************************
      *                                                                *
      *     COMMUNICATION VARIABLES                                    *
      *                                                                *
      ******************************************************************

       01 WS-COMM-VAR.
      *   05 WS-RESPCODE-2                  PIC S9(9) USAGE COMP
      *                                               VALUE ZEROS.
      *   05 WS-RESPCODE-VAL                PIC 9(09) VALUE ZEROS.
          05 REQUESTCONTAINER               PIC X(16) VALUE SPACES.
          05 RESPONSECONTAINER              PIC X(16) VALUE SPACES.
          05 CHANNELNAME                    PIC X(16) VALUE SPACES.
          05 CONTAINER-COUNT                PIC S9(08) COMP.

          05  WS-CONTAINER-NAME             PIC X(20) VALUE SPACES.
          05  WS-CONTAINER-TOKEN            PIC x(20) VALUE SPACES.
          05  WS-CHANNEL-NAME               PIC X(20) VALUE SPACES.
          05  WS-DEFAULT-CHANNEL            PIC X(16) VALUE
                                            'UISEXTCHANNEL'.
          05  WS-DEFAULT-PUT-CONTAINER      PIC X(16) VALUE
                                            'resContainer'.
       01  WS-SRV-PRG                       PIC X(08).
       01  WS-REQUEST-LENGTH                PIC S9(08) COMP.
       01  WS-REQUEST-FULL-LENGTH           PIC S9(08) COMP.
       01  WS-REPLY-LENGTH                  PIC S9(08) COMP.
       01  WS-REPLY-FULL-LENGTH             PIC S9(08) COMP.
      *
      ******************************************************************
      *                                                                *
      *      COPY BOOK AREA                                            *
      *                                                                *
      ******************************************************************
      *
       01  STANDARD-CES-USING-AREA.
           COPY F6412USE.

       01  ORIG-INFCNTRL-AREA.
           COPY F6412IC REPLACING ==:FD:== BY ==ORG==.

       01  ZQF-LINKAGE-AREA0.
           COPY F5748ZQF REPLACING ==:FD:== BY ==ZQF==.

       01  ZQH-LINKAGE-AREA1.
           COPY F5748IN0 REPLACING ==:FD:== BY ==ZQH==.

       01  ZQH-LINKAGE-AREA2.
           COPY F5748ZQH REPLACING ==:FD:== BY ==ZQH==.

       01  WS-400K-ONLINE-IO                PIC X(08) VALUE 'F5748ZQF'.


       REPLACE ==:FD:== BY ==ZQH==.
       COPY F5748INR.
       COPY F5748INM.
       COPY F5748INA.
       COPY F5748INE.
       COPY F5748INC.
       COPY F5748ING.
       COPY F5748IN1.
       COPY F5748IN2.
       COPY F5748IN3.
       COPY F5748IN4.
       REPLACE OFF.

       01  KZ1-TRANSACTION-DATA.
           COPY F5748KZ1 REPLACING ==:FD:== BY ==KZ1==.

       01  KZ6-SEGMENT-SERVICE-REQUEST.
           COPY F5748KZ6 REPLACING ==:FD:== BY ==KZ6==.

       01  KZ8-OLS-SERVICE-REQUEST.
           COPY F5748KZ8 REPLACING ==:FD:== BY ==KZ8==.

       01  KV0-VALIDATION-CONTROL.
           COPY F5748KV0 REPLACING ==:FD:== BY ==KV0==.
      *                                                                *
      ******************************************************************
      *                                                                *
      *     DB2 TABLES AREA                                            *
      *                                                                *
      ******************************************************************
      *
             EXEC SQL
                  INCLUDE SQLCA
             END-EXEC.

      * DCLGEN FOR  T_UIS_SRV_FN_PGM
             EXEC SQL
                  INCLUDE F5748SFP
             END-EXEC.

      * DCLGEN FOR  T_CUST_DATA
             EXEC SQL
                  INCLUDE F5748CST
             END-EXEC.

      ******************************************************************
      *                                                                *
      *     LOGGING VARIABLES                                          *
      *                                                                *
      ******************************************************************
       01  WS-PROGRAM-NAMES.
           COPY F5748KZ0.

     **USING AREA FOR LOGGING:
       01 KL1-USING-AREA.
           COPY F5748KL1 REPLACING ==:FD:== BY ==KL1==.

       01  KIQ-LOG-AREA.
           COPY F5748KIQ REPLACING ==:FD:== BY ==LF==.
      *
       01  FILLER                                PIC X(32) VALUE
           'F5748I00 WORKING STORAGE ENDS'.
      *
       LINKAGE SECTION.
       01 DFHCOMMAREA.
           COPY F5748I01.

       PROCEDURE DIVISION.
      ******************************************************************
       0000-BEGIN.
      *
           PERFORM 1000-INITIALIZE
              THRU 1000-EXIT.

ANKITV
ANKITV     MOVE WS-LOG-DATA                 TO LF-LOG-DATA.
ANKITV     MOVE ZEROES                      TO LF-LOG-DATA-LENGTH.
ANKITV
ANKITV     MOVE 'REQUEST'                   TO LF-LOG-TYPE
ANKITV     MOVE LENGTH OF ZOS-SRV-CNTRL-PGM-REQUEST
ANKITV                                      TO LF-LOG-DATA-LENGTH.
ANKITV
ANKITV     MOVE ZOS-SRV-CNTRL-PGM-REQUEST   TO LF-LOG-DATA.
ANKITV
ANKITV     PERFORM 9300-LOG-DATA
ANKITV        THRU 9300-EXIT.

           PERFORM 3000-VALIDATE-INPUT
              THRU 3000-EXIT.

           IF ZOS-SUCCESS
              PERFORM 5000-LINK-PROG
                 THRU 5000-EXIT
           END-IF.
ANKITV
ANKITV     MOVE WS-LOG-DATA                 TO LF-LOG-DATA.
ANKITV     MOVE ZEROES                      TO LF-LOG-DATA-LENGTH.
ANKITV
           MOVE 'RESPONSE'                  TO LF-LOG-TYPE
           MOVE LENGTH OF ZOS-SRV-CNTRL-PGM-RESPONSE
                                            TO LF-LOG-DATA-LENGTH.

ANKITV*    MOVE ZOS-SRV-CNTRL-PGM-RESPONSE  TO LF-LOG-DATA.
ANKITV     STRING WS-INFORCE-TS-NINES  '|' ZOS-SRV-CNTRL-PGM-RESPONSE
ANKITV                  DELIMITED BY SIZE INTO LF-LOG-DATA.

           PERFORM 9300-LOG-DATA
              THRU 9300-EXIT.


       0000-EXIT.
           GOBACK.
      ******************************************************************
      *                          1000-INITIALIZE                       *
      * THIS PARAGRAPH WILL INITIALIZE NECESSARY VARIABLES             *
      ******************************************************************
       1000-INITIALIZE.

           INITIALIZE DCLT-UIS-SRV-FN-PGM
                      DCLT-CUST-DATA
                      CONTAINER-COUNT
                      WS-LOG-ID
                      OPTIONAL-IO-MODULE-ERROR-MSG
           REPLACING NUMERIC BY ZEROES
           ALPHANUMERIC DATA BY SPACES.

           INITIALIZE ZQH-LINKAGE-AREA1
                      STANDARD-CES-USING-AREA
                      ORIG-INFCNTRL-AREA
                      KZ1-TRANSACTION-DATA
                      KZ6-SEGMENT-SERVICE-REQUEST
                      KZ8-OLS-SERVICE-REQUEST
                      KV0-VALIDATION-CONTROL.


           SET ZOS-SUCCESS                  TO TRUE.


           MOVE WS-NAME-OF-THIS-MODULE      TO WS-SYSTEM-PGM.

           MOVE LOW-VALUES                  TO ORG-INFCNTRL-KEY
                                               ZQH-KEY-EMPLOYEE.


           MOVE ZEROS                       TO ZQH-KEY-CUSTOMER-NUMBER.
           MOVE ZEROS                       TO WS-UPDATED-INFORCE-TS
                                               WS-INFORCE-TS-NINES.
           MOVE SPACES                      TO WS-LOG-DATA.

           EXEC SQL
               SET :ZOS-REQUEST-TIMESTAMP = CURRENT TIMESTAMP
           END-EXEC

           MOVE EIBTRNID                    TO WS-LOG-ID(1:4).
           MOVE EIBTASKN                    TO WS-LOG-ID(5:5).
           MOVE ZOS-REQUEST-TIMESTAMP       TO WS-LOG-ID(10:26).


           PERFORM VARYING ZOS-NUM-ERR FROM 1 BY 1
             UNTIL ZOS-NUM-ERR = 101
              MOVE ZEROS
                TO ZOS-FAILURE-CODE-N(ZOS-NUM-ERR)
                   ZOS-ERR-CODE-2(ZOS-NUM-ERR)

              MOVE SPACES
                TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                   ZOS-ERR-DESC-2(ZOS-NUM-ERR)
           END-PERFORM.

           MOVE ZEROS                       TO ZOS-NUM-ERR.

           MOVE SPACES                      TO ZOS-REPLY-CUST-NM
                                               ZOS-REPLY-EMPE-FRST-NM
                                               ZOS-REPLY-EMPE-LST-NM
                                               ZOS-REPLY-EMPE-FIRST-NM2
                                               ZOS-REPLY-EMPE-PRFIX
                                               ZOS-REPLY-EMPE-FULL-NAME
                                               ZOS-REPLY-TIMESTAMP.
ANKITV     MOVE SPACES                      TO ZOS-REPLY-ADDNTL-AREA.
           .
       1000-EXIT.
           EXIT.

      ******************************************************************
      *               2000-VALIDATE-INPUT
      * THIS PARAGRAPH WILL VALIDATE REQUEST DATA
      ******************************************************************
       3000-VALIDATE-INPUT.

           IF ZOS-SRC-RACF-ID = SPACES
               ADD 1                        TO ZOS-NUM-ERR
               SET ZOS-USER-NOT-AUTHORIZED  TO TRUE
               SET ZOS-USER-HAS-NO-ACCESS   TO TRUE
ANKITV*         MOVE 'USER ID NOT PROVIDED'
ANKITV          MOVE WS-NO-USERID-MSG
                  TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
               MOVE 92
                  TO ZOS-FAILURE-CODE-N(ZOS-NUM-ERR)
           ELSE
              PERFORM 3100-CHECK-OLS-SECURITY
                 THRU 3100-EXIT

              EVALUATE TRUE
                  WHEN KZ8-REQUEST-SUCCESSFUL
                     SET USER-HAS-UPDATE    TO TRUE
                  WHEN KZ8-USER-HAS-READ-ACCESS-ONLY
                     SET USER-HAS-INQUIRY   TO TRUE
                  WHEN OTHER
                     ADD 1                  TO ZOS-NUM-ERR
                     SET ZOS-USER-NOT-AUTHORIZED
                                            TO TRUE
                     SET ZOS-USER-HAS-NO-ACCESS
                                            TO TRUE
                     MOVE WS-NOT-AUTHORIZED-MSG
                       TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                     MOVE 98
                       TO ZOS-FAILURE-CODE-N(ZOS-NUM-ERR)
              END-EVALUATE

           END-IF.

           IF ZOS-REQUEST-OPERATION = SPACES
               ADD 1                        TO ZOS-NUM-ERR
               SET ZOS-VALIDATION-ERR       TO TRUE
ANKITV*        MOVE 'REQUEST OPERATION NOT PROVIDED'
ANKITV         MOVE WS-NO-OPER-MSG
                 TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
               MOVE 77
                 TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
           ELSE
              IF ZOS-REQUEST-OPERATION = 'UPDATE' AND  USER-HAS-INQUIRY
                 ADD 1                      TO ZOS-NUM-ERR
                 SET ZOS-VALIDATION-ERR     TO TRUE
                 MOVE WS-NOT-AUTHORIZED-MSG
                   TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                 MOVE 98
                   TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
              END-IF
           END-IF.

           IF ZOS-REQUEST-CUST-NUM = SPACES
              ADD 1                         TO ZOS-NUM-ERR
              SET ZOS-NO-CUST-NUM           TO TRUE
ANKITV*       MOVE 'UIS CUSTOMER NUMBER NOT PROVIDED'
ANKITV        MOVE WS-CUST-NOTPRVD-MSG
                TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
              MOVE 94
                TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
           ELSE
               MOVE ZEROS                   TO WS-SPACE-COUNT
               INSPECT FUNCTION REVERSE(ZOS-REQUEST-CUST-NUM)
               TALLYING WS-SPACE-COUNT FOR LEADING SPACES
               IF WS-SPACE-COUNT = 0
                   IF ZOS-REQUEST-CUST-NUM  IS NOT NUMERIC
                       ADD 1                TO ZOS-NUM-ERR
                       SET ZOS-INVALID-CUST TO TRUE
ANKITV*                MOVE 'UIS CUSTOMER NUMBER NOT VALID'
ANKITV                 MOVE WS-INVALID-CUST-MSG
                         TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                       MOVE 91
                         TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
                   ELSE
                      PERFORM 3200-VALIDATE-CUST
                         THRU 3200-EXIT
                   END-IF
               ELSE
                   ADD 1                    TO ZOS-NUM-ERR
                   SET ZOS-INVALID-CUST     TO TRUE
ANKITV*            MOVE 'UIS CUSTOMER NUMBER NOT VALID'
ANKITV             MOVE WS-INVALID-CUST-MSG
                     TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                   MOVE 91
                     TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
               END-IF
           END-IF.

           IF ZOS-REQUEST-EMPE-ID <= SPACES
              ADD 1                         TO ZOS-NUM-ERR
              SET ZOS-NO-EMPE-ID            TO TRUE
              MOVE WS-NO-EMPE-MSG
                TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
              MOVE 93
                TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
           ELSE
               MOVE ZEROS                   TO WS-SPACE-COUNT
               INSPECT FUNCTION REVERSE(ZOS-REQUEST-EMPE-ID)
               TALLYING WS-SPACE-COUNT FOR LEADING SPACES
               IF WS-SPACE-COUNT NOT = 0
                   ADD 1                    TO ZOS-NUM-ERR
                   SET ZOS-NO-EMPE-ID       TO TRUE
ANKITV*            MOVE 'UIS EMPLOYEE ID IS NOT VALID'
ANKITV             MOVE WS-NO-EMPE-INVALID
                     TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                   MOVE 90
                     TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
               ELSE
                   IF DB2-CUST-FND
ANKITV                PERFORM 3300-GET-EMPLOYEE-FAMILY
ANKITV                   THRU 3300-EXIT
ANKITV
ANKITV             END-IF
ANKITV             IF ZQF-SUCCESSFUL
ANKITV              MOVE ZQH-KEY-TIMESTAMP
                    TO WS-UPDATED-INFORCE-TS
ANKITV              COMPUTE WS-INFORCE-TS-NINES =
ANKITV                   WS-TS-NINES - WS-UPDATED-INFORCE-TS
ANKITV             END-IF
               END-IF
           END-IF.

           IF ZOS-REQUEST-ADDTNL-AREA NOT = 'UIS'
               SET ZOS-VALIDATION-ERR       TO TRUE
               ADD 1                        TO ZOS-NUM-ERR
ANKITV*        MOVE 'CUSTOMER NUMBER-TYPE MUST BE UIS'
ANKITV         MOVE WS-INVALID-CUSTTYPE-MSG
                 TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
               MOVE 89
                 TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
           END-IF.

           IF ZOS-SERVICE-ID = SPACES
               ADD 1                        TO ZOS-NUM-ERR
               SET ZOS-VALIDATION-ERR       TO TRUE
ANKITV*        MOVE 'SERVICE ID NOT PROVIDED'
ANKITV         MOVE WS-NO-SERVID-MSG
                 TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
               MOVE 88
                 TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
           ELSE
               IF LENGTH OF ZOS-SERVICE-ID > 50
                   ADD 1                    TO ZOS-NUM-ERR
                   SET ZOS-VALIDATION-ERR   TO TRUE
ANKITV*            MOVE 'SERVICE ID EXCEEDS MAXIMUM LENGTH'
ANKITV             MOVE WS-SERVID-LEN-MSG
                     TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                   MOVE 87
                     TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
               END-IF
           END-IF.

           IF ZOS-SRV-FUNC-CD = SPACES
               SET ZOS-VALIDATION-ERR       TO TRUE
               ADD 1                        TO ZOS-NUM-ERR
ANKITV*        MOVE 'SERVICE FUNCTION CODE NOT PROVIDED'
ANKITV         MOVE WS-NO-SERVFUNC-MSG
                 TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
               MOVE 86
                 TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
           ELSE
                PERFORM 3400-GET-SERVICE-PROG
                 THRU 3400-EXIT

              IF SQLCODE NOT = 0
                  ADD 1                     TO ZOS-NUM-ERR
                  SET ZOS-FAILURE           TO TRUE
ANKITV*          MOVE 'SERVICE FUNCTION CODE NOT VALID'
ANKITV           MOVE WS-SERVFUNC-NOT-VLD-MSG
                   TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                 MOVE 85
                   TO ZOS-FAILURE-CODE-N(ZOS-NUM-ERR)
              END-IF

              MOVE UIS-SRV-PGM-NM           TO WS-SRV-PRG
           END-IF.

           IF ZOS-SRV-NM = SPACES
               ADD 1                        TO ZOS-NUM-ERR
               SET ZOS-VALIDATION-ERR       TO TRUE
ANKITV*        MOVE 'SERVICE NAME NOT PROVIDED'
ANKITV         MOVE WS-NO-SERVNAME-MSG
                 TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
               MOVE 79
                 TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
           END-IF.

           IF ZOS-SRC-APP-NM = SPACES
               ADD 1                        TO ZOS-NUM-ERR
               SET ZOS-VALIDATION-ERR       TO TRUE
ANKITV*        MOVE 'SOURCE APPLICATION NAME NOT PROVIDED'
ANKITV         MOVE WS-NO-SOURCE-MSG
                 TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
               MOVE 78
                 TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
           END-IF.

       3000-EXIT.
           EXIT.
      ******************************************************************
      *5300-CHECK-OLS-SECURITY.
      * THIS PARAGRAPH WILL CALL THE OLS SECURITY ROUTINE              *
      ******************************************************************
       3100-CHECK-OLS-SECURITY.
           MOVE ZOS-SRC-RACF-ID             TO KZ1-US-UPDATE-USERID.
           SET KZ8-REQUEST-SUCCESSFUL       TO TRUE.
           SET KZ1-US-UPDATE-EMPLOYEE       TO TRUE.
           SET KZ8-USER-LVL-REQUEST         TO TRUE.

           CALL KZ0-OLS-SERVICES-PGM USING
               COPY F5748KU0.
               KV0-VALIDATION-CONTROL
               KZ1-TRANSACTION-DATA
               KZ8-OLS-SERVICE-REQUEST.
           .
       3100-EXIT.
           EXIT.
      ******************************************************************
      *                       3000-VALIDATE-CUST-EMP                   *
      * THIS PARGRAPH WILL GET THE UIS SEGMENT THAT THE CUSTOMER IS ON *
      ******************************************************************
       3200-VALIDATE-CUST.

ANKITV     MOVE ZOS-REQUEST-CUST-NUM        TO KZ1-US-CUSTOMER-NUMBER
HBERRY     MOVE ZOS-REQUEST-CUST-NUM        TO CUST-NUM
ANKITV      SET DB2-CUST-NOT-FND            TO TRUE
ANKITV
ANKITV     PERFORM 3210-GET-CUST-DTL
ANKITV        THRU 3210-END-GET-CUST-DTL
ANKITV
           .
       3200-EXIT.
           EXIT.

ANKITV******************************************************************
ANKITV* 3100-GET-CUST-DTL.                                             *
ANKITV* THIS PARAGRAPH WILL QUERY T_CUST_DATA AND                      *
ANKITV*      FETCH SEG-ID AND CUSTOMER-NAME                            *
ANKITV*                                                                *
ANKITV* IF ANY SQL ERROR -- SET THE CUSTOMER-INVALID TO TRUE           *
ANKITV******************************************************************
ANKITV 3210-GET-CUST-DTL.
ANKITV
ANKITV     EXEC SQL
ANKITV          SELECT  SEG_ID
ANKITV                 ,CUST_NM
ANKITV            INTO  :SEG-ID
ANKITV                 ,:CUST-NM
ANKITV            FROM T_CUST_DATA
HBERRY      WHERE CUST_NUM = :CUST-NUM
ANKITV           FETCH FIRST ROW ONLY
ANKITV     END-EXEC.
ANKITV
ANKITV     EVALUATE SQLCODE
ANKITV        WHEN 0
ANKITV             SET DB2-CUST-FND         TO TRUE
ANKITV             MOVE SEG-ID              TO KZ1-US-SEGMENT
ANKITV                                         WS-SEGMENT-ID
ANKITV             MOVE CUST-NM             TO WS-REPLY-CUST-NM
ANKITV        WHEN OTHER
ANKITV             SET DB2-CUST-NOT-FND     TO TRUE
ANKITV             SET ZOS-INVALID-CUST     TO TRUE
ANKITV             ADD 1                    TO ZOS-NUM-ERR
ANKITV             MOVE WS-CUST-NOTFND-MSG
ANKITV               TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
ANKITV             MOVE 97
ANKITV               TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
ANKITV     END-EVALUATE.
ANKITV     .
ANKITV 3210-END-GET-CUST-DTL.
ANKITV     EXIT.
      ******************************************************************
      *                      3500-GET-EMPLOYEE-FAMILY                  *
      * THIS PARAGRAPH WILL GET THE EMPLOYEE NAME FROM THE INFORCE FILE*
      ******************************************************************
      *
       3300-GET-EMPLOYEE-FAMILY.

           MOVE WS-NAME-OF-THIS-MODULE      TO ZQH-PASS-LAST-CONTROL
           MOVE ZOS-REQUEST-CUST-NUM        TO ZQH-KEY-CUSTOMER-NUMBER
           MOVE ZOS-REQUEST-EMPE-ID         TO ZQH-KEY-EMPLOYEE
           MOVE WS-SEGMENT-ID               TO ZQH-INF-DDNAME(8:1)
           MOVE 'F6405IN'                   TO ZQH-INF-DDNAME(1:7)

      *OPEN INFORCE FILE AT EMPLOYEE'S FAMILY
           SET ZQH-GETFAMILY                TO TRUE
           PERFORM 9000-CALL-INFORCE
              THRU 9000-EXIT.

ANKITV     IF NOT ZQF-SUCCESSFUL
ANKITV     OR ZQH-KEY-EMPLOYEE NOT = ZOS-REQUEST-EMPE-ID
ANKITV        ADD 1                       TO ZOS-NUM-ERR
ANKITV        SET ZOS-INVALID-EMPE        TO TRUE
ANKITV        MOVE WS-INVALID-EMPE-MSG
ANKITV          TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
ANKITV        MOVE 96
ANKITV          TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
ANKITV     END-IF
ANKITV
ANKITV     IF ZOS-SUCCESS
ANKITV        PERFORM 3310-GET-EMPLOYEE-MEMBER
ANKITV        THRU 3310-EXIT
ANKITV     END-IF
           .
       3300-EXIT.
           EXIT.
      *
      ******************************************************************
      *                      3510-GET-EMPLOYEE-MEMBER                  *
      * THIS PARAGRAPH WILL GET THE EMPLOYEE NAME FROM THE INFORCE FILE*
      ******************************************************************
      *
       3310-GET-EMPLOYEE-MEMBER.

           IF ZOS-SUCCESS
      *READ EMPLOYEE'S FAMILY MEMBERS
              SET ZQH-GETLISTOFMEMBERS      TO TRUE
              PERFORM 9000-CALL-INFORCE
                 THRU 9000-EXIT

                IF NOT ZQF-SUCCESSFUL
                    ADD 1                   TO ZOS-NUM-ERR
                    SET ZOS-FAILURE         TO TRUE
                    MOVE 0006               TO WS-SYSTEM-NUMBER
                    MOVE WS-SYSTEM-ERROR-MSG
                      TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                    MOVE ZQF-RETURN-CODE
                      TO ZOS-FAILURE-CODE(ZOS-NUM-ERR)
                END-IF
           END-IF.

           IF ZOS-SUCCESS
      *LOCATE EMPLOYEE IN FAMILY TO GET NAME OF EMPLOYEE
                PERFORM VARYING WS-SUB FROM 1 BY 1
                    UNTIL WS-SUB > ZQH-MBRTBL-NUMBER-OF-MEMBERS

                    IF ZQH-MBRTBL-MBR-RELATIONSHIP (WS-SUB) = 00
                      OR ZQH-MBRTBL-MBR-SRC-SEQ-NUM (WS-SUB)  = 01
                         MOVE ZQH-MBRTBL-FIRST-NAME(WS-SUB)
                           TO WS-REPLY-EMPE-FRST-NM
                         MOVE ZQH-MBRTBL-LAST-NAME(WS-SUB)
                           TO WS-REPLY-EMPE-LST-NM
                          ADD ZQH-MBRTBL-NUMBER-OF-MEMBERS
                           TO WS-SUB
                    END-IF
                END-PERFORM
           END-IF.
           .
       3310-EXIT.
           EXIT.
      *
      ******************************************************************
      *5100-GET-SERVICE-PROG
      * THIS PARAGRAPH WILL GET THE NAME OF THE SERVICE PROGRAM FROM DB*
      ******************************************************************
       3400-GET-SERVICE-PROG.

           EXEC SQL
                SELECT UIS_SRV_PGM_NM
                     , CUST_NUM_VLD_RQR_IND
                     , UIS_SRV_DSCR
                INTO   :UIS-SRV-PGM-NM
                     , :CUST-NUM-VLD-RQR-IND
                     , :UIS-SRV-DSCR
                FROM T_UIS_SRV_FN_PGM
                WHERE UIS_SRV_FN_CD = :ZOS-SRV-FUNC-CD
           END-EXEC.
           .
       3400-EXIT.
           EXIT.
      ******************************************************************
      *                        5000-LINK-PROG                          *
      * THIS PARAGRAPH WILL LINK TO THE SERVICE PROGRAM FOR THE REQUEST*
      * THE USER MADE                                                  *
      ******************************************************************
       5000-LINK-PROG.

           PERFORM 5500-CALL-SERVICE-PROG
              THRU 5500-EXIT

           IF WS-RESPCODE NOT = 0
                 ADD 1                      TO ZOS-NUM-ERR
                 SET ZOS-FAILURE            TO TRUE
                 MOVE 0008                  TO WS-SYSTEM-NUMBER
                 MOVE WS-SYSTEM-ERROR-MSG
                   TO ZOS-FAILURE-MESSAGE(ZOS-NUM-ERR)
                 MOVE WS-RESPCODE
                   TO ZOS-FAILURE-CODE-N(ZOS-NUM-ERR)
           END-IF.

           MOVE WS-REPLY-CUST-NM            TO ZOS-REPLY-CUST-NM
           MOVE WS-REPLY-EMPE-FRST-NM       TO ZOS-REPLY-EMPE-FRST-NM
           MOVE WS-REPLY-EMPE-LST-NM        TO ZOS-REPLY-EMPE-LST-NM
           MOVE WS-USER-AUTH-LVL            TO ZOS-REPLY-USER-AUTH-LEVEL

           EXEC SQL
              SET :WS-TIMESTAMP = CURRENT TIMESTAMP
           END-EXEC

           MOVE WS-TIMESTAMP                TO ZOS-REPLY-TIMESTAMP.
           .
       5000-EXIT.
           EXIT.
      ******************************************************************
      *5500-CALL-SERVICE-PROG
      * THIS PARAGRAPH WILL CALL THE SERVICE PROGRAM                   *
      ******************************************************************
       5500-CALL-SERVICE-PROG.

           EXEC CICS
                LINK PROGRAM(WS-SRV-PRG)
                COMMAREA(DFHCOMMAREA)
           END-EXEC.
           .
       5500-EXIT.
           EXIT.
      *
      ******************************************************************
      *                        9000-CALL-INFORCE                       *
      * THIS PARAGRAPH WILL CALL F5748ZQG TO HANDLE IO FOR INFORCE FILE*
      ******************************************************************
      *
       9000-CALL-INFORCE.

           CALL WS-400K-ONLINE-IO USING
                       DFHEIBLK
                       DFHCOMMAREA
                       ZQF-LINKAGE-AREA0
                       ZQH-LINKAGE-AREA1
                       ZQH-LINKAGE-AREA2.
           .
       9000-EXIT.
           EXIT.
      *
      ******************************************************************
      *                          9300-LOG-DATA                         *
      * THIS PARAGRAPH WILL CALL F5748KIQ TO WRITE LOG DATA TO DB2     *
      ******************************************************************
      *
       9300-LOG-DATA.

ANKITV*    SET KL1-LOG-WRITE                TO TRUE.
ANKITV*    SET KL1-LOG-IS-AUDIT             TO TRUE.
ANKITV*    MOVE WS-NAME-OF-THIS-MODULE      TO KL1-LOG-SOURCE-PROGRAM.
ANKITV*    MOVE KL1-LOG-TYPE                TO LF-LOG-TYPE
ANKITV*    MOVE KL1-LOG-DATA-LENGTH         TO LF-LOG-DATA-LENGTH
ANKITV     MOVE WS-NAME-OF-THIS-MODULE      TO LF-CALLING-PGM

           MOVE EIBTRNID                    TO LF-TRANID
           MOVE EIBTASKN                    TO LF-TASK-NBR
           MOVE ZOS-REQUEST-CUST-NUM        TO LF-CUSTOMER-NBR
           MOVE ZOS-REQUEST-EMPE-ID         TO LF-EMPLOYEE-NBR
           MOVE ZOS-SRC-APP-NM              TO LF-SOURCE-APPLIC
           MOVE ZOS-SRC-ENVRN-CD            TO LF-LOG-ENVIRONMENT
           MOVE WS-SEGMENT-ID               TO LF-SEGMENT-ID
           MOVE 'EXTENSION RECORDS'         TO LF-LOG-DESCRIPTION
           MOVE ZOS-SRV-NM                  TO LF-SERVICE-NAME
           MOVE ZOS-SERVICE-ID              TO LF-MQ-MESSAGE-ID
           MOVE WS-LOG-ID                   TO LF-CORRELATION-ID.

           CALL KZ0-DB2-LOG-PGM    USING
                COPY F5748KU0.
                KIQ-LOG-AREA.

           .
       9300-EXIT.
           EXIT.
      ******************************************************************
       END PROGRAM F5748I00.
