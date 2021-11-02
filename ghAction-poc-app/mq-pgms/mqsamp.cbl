       IDENTIFICATION DIVISION.
       PROGRAM-ID. MQSAMP.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
      * how topic with MQ Stub - need to split the source by folder
      * add groovy code to include syslib stub see my tips
       WORKING-STORAGE SECTION.
       01  W00-RETURN-CODE             PIC S9(4) BINARY VALUE ZERO.
       01  W00-LOOP                    PIC S9(9) BINARY VALUE 0.
       01  W00-NUMPUTS                 PIC S9(9) BINARY VALUE 0.
       01  W00-ERROR-MESSAGE           PIC X(48) VALUE SPACES.
       01  W00-QMGR                    PIC X(48).
       01  W00-QNAME                   PIC X(48).
       01  W00-PADCHAR                 PIC X(1) VALUE '*'.
       01  W00-MSGBUFFER.
         02  W00-MSGBUFFER-ARRAY       PIC X(1) OCCURS 65535 TIMES.
       01  W00-NUMMSGS-NUM             PIC 9(4) VALUE  0.
       01  W00-NUMMSGS                 PIC S9(9) BINARY VALUE 1.
       01  W00-MSGLENGTH-NUM           PIC 9(4) VALUE 0.
       01  W00-MSGLENGTH               PIC S9(9) BINARY VALUE 100.
       01  W00-PERSISTENCE             PIC X(1) VALUE 'N'.
           88 PERSISTENT     VALUE 'P'.
           88 NOT-PERSISTENT VALUE 'N'.
       01  W03-HCONN                   PIC S9(9) BINARY VALUE 0.
       01  W03-HOBJ                    PIC S9(9) BINARY VALUE 0.
       01  W03-OPENOPTIONS             PIC S9(9) BINARY.
       01  W03-COMPCODE                PIC S9(9) BINARY.
       01  W03-REASON                  PIC S9(9) BINARY.
      * 01  MQM-OBJECT-DESCRIPTOR.
      *     COPY CMQODV.
      * 01  MQM-MESSAGE-DESCRIPTOR.
      *     COPY CMQMDV.
      * 01  MQM-PUT-MESSAGE-OPTIONS.
      *     COPY CMQPMOV SUPPRESS.
      * 01  MQM-CONSTANTS.
      *     COPY CMQV SUPPRESS.
      *
      *
       PROCEDURE DIVISION.
           DISPLAY 'HELLO'.
           CALL 'MQCONN' USING W00-QMGR
                 W03-HCONN
                 W03-COMPCODE
                 W03-REASON.

