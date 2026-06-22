FUNCTION /SDOCS/SSPAY_LOCK_PROGRAM_N.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_PROG_NAME) TYPE  PROGNAME
*"  EXPORTING
*"     REFERENCE(E_PROG_LOCKED)
*"  EXCEPTIONS
*"      EX_PROGRAM_LOCKED
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
*{   INSERT         S4HK903116                                        2
DATA:  WA_LOCK             TYPE  /SDOCS/SSPY_PLOC ,
       LV_LOCK_WAIT        TYPE INT4,
       LV_LOCK_WAIT_C      TYPE CHAR255,
       LV_DIFF             TYPE INT4,
       LV_DIFF_DATE        TYPE P,
       LV_DIFF_TIME        TYPE P,
       LV_ENABLE_SINGLETON,
       lv_db_table type char50.

  CLEAR: WA_LOCK,LV_LOCK_WAIT,LV_DIFF_DATE,LV_DIFF_TIME,LV_ENABLE_SINGLETON,LV_LOCK_WAIT_C.
lv_db_table = '/SDOCS/SSPY_SGC'.
  SELECT SINGLE CONFIG_VALUE INTO LV_ENABLE_SINGLETON FROM (lv_db_table) WHERE CONFIG = 'ENABLE_PROG_SINGLETON'.
  IF LV_ENABLE_SINGLETON IS NOT INITIAL.
    IF I_PROG_NAME IS NOT INITIAL.
      lv_db_table = '/SDOCS/SSPY_SGC'.
      SELECT SINGLE CONFIG_VALUE INTO LV_LOCK_WAIT_C FROM (lv_db_table)  WHERE CONFIG = 'PROG_LOCK_WAIT_TIME'.
      LV_LOCK_WAIT =  LV_LOCK_WAIT_C.
      IF LV_LOCK_WAIT IS INITIAL.
        LV_LOCK_WAIT = 60.
      ENDIF.
      lv_db_table = '/SDOCS/SSPY_PLOC'.
      SELECT SINGLE * FROM (lv_db_table)  INTO WA_LOCK WHERE PROG_NAME = I_PROG_NAME.
      IF SY-SUBRC EQ 0.
        LV_DIFF = ( ( SY-DATUM -  WA_LOCK-START_DATE ) * 86400 + ( SY-UZEIT - WA_LOCK-START_TIME ) ) .
        IF LV_DIFF GT LV_LOCK_WAIT.
          WA_LOCK-PROG_NAME = I_PROG_NAME.
          WA_LOCK-START_DATE = SY-DATUM.
          WA_LOCK-START_TIME = SY-UZEIT.
          WA_LOCK-STATUS     = 'STARTED'.
          lv_db_table = '/SDOCS/SSPY_PLOC'.
          MODIFY (lv_db_table)  FROM WA_LOCK.
          COMMIT WORK AND WAIT.
        ELSE.
          E_PROG_LOCKED = 'X'.

        ENDIF.
      ELSE.
        WA_LOCK-PROG_NAME = I_PROG_NAME.
        WA_LOCK-START_DATE = SY-DATUM.
        WA_LOCK-START_TIME = SY-UZEIT.
        WA_LOCK-STATUS     = 'STARTED'.
        lv_db_table = '/SDOCS/SSPY_PLOC'.
        MODIFY (lv_db_table)  FROM WA_LOCK.
        COMMIT WORK AND WAIT.
      ENDIF.
   ENDIF.
  ENDIF.
*}   INSERT
*{   DELETE         S4HK903116                                        1
*\DATA:  WA_LOCK             TYPE  /SDOCS/SSPY_PLOC ,
*\       LV_LOCK_WAIT        TYPE INT4,
*\       LV_LOCK_WAIT_C      TYPE CHAR255,
*\       LV_DIFF             TYPE INT4,
*\       LV_DIFF_DATE        TYPE P,
*\       LV_DIFF_TIME        TYPE P,
*\       LV_ENABLE_SINGLETON.
*\
*\  CLEAR: WA_LOCK,LV_LOCK_WAIT,LV_DIFF_DATE,LV_DIFF_TIME,LV_ENABLE_SINGLETON,LV_LOCK_WAIT_C.
*\
*\  SELECT SINGLE CONFIG_VALUE INTO LV_ENABLE_SINGLETON FROM /SDOCS/SSPY_SGC WHERE CONFIG = 'ENABLE_PROG_SINGLETON'.
*\  IF LV_ENABLE_SINGLETON IS NOT INITIAL.
*\    IF I_PROG_NAME IS NOT INITIAL.
*\      SELECT SINGLE CONFIG_VALUE INTO LV_LOCK_WAIT_C FROM /SDOCS/SSPY_SGC WHERE CONFIG = 'PROG_LOCK_WAIT_TIME'.
*\      LV_LOCK_WAIT =  LV_LOCK_WAIT_C.
*\      IF LV_LOCK_WAIT IS INITIAL.
*\        LV_LOCK_WAIT = 60.
*\      ENDIF.
*\      SELECT SINGLE * FROM /SDOCS/SSPY_PLOC  INTO WA_LOCK WHERE PROG_NAME = I_PROG_NAME.
*\      IF SY-SUBRC EQ 0.
*\        LV_DIFF = ( ( SY-DATUM -  WA_LOCK-START_DATE ) * 86400 + ( SY-UZEIT - WA_LOCK-START_TIME ) ) .
*\        IF LV_DIFF GT LV_LOCK_WAIT.
*\          WA_LOCK-PROG_NAME = I_PROG_NAME.
*\          WA_LOCK-START_DATE = SY-DATUM.
*\          WA_LOCK-START_TIME = SY-UZEIT.
*\          WA_LOCK-STATUS     = 'STARTED'.
*\          MODIFY /SDOCS/SSPY_PLOC  FROM WA_LOCK.
*\          COMMIT WORK AND WAIT.
*\        ELSE.
*\          E_PROG_LOCKED = 'X'.
*\
*\        ENDIF.
*\      ELSE.
*\        WA_LOCK-PROG_NAME = I_PROG_NAME.
*\        WA_LOCK-START_DATE = SY-DATUM.
*\        WA_LOCK-START_TIME = SY-UZEIT.
*\        WA_LOCK-STATUS     = 'STARTED'.
*\        MODIFY /SDOCS/SSPY_PLOC  FROM WA_LOCK.
*\        COMMIT WORK AND WAIT.
*\      ENDIF.
*\   ENDIF.
*\  ENDIF.
*\
*}   DELETE



*}   INSERT
ENDFUNCTION.
