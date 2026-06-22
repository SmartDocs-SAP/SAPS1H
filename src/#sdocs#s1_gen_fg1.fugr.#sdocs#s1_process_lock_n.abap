FUNCTION /SDOCS/S1_PROCESS_LOCK_N.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DOCID) TYPE  /SDOCS/SSPY_HD-DOCID
*"     REFERENCE(I_LOCK) TYPE  /SDOCS/S1_LCKIND
*"  EXPORTING
*"     REFERENCE(E_LOCK) TYPE  /SDOCS/S1_LCKIND
*"     REFERENCE(E_LUSER) TYPE  SY-UNAME
*"  EXCEPTIONS
*"      DOCID_NOT_FOUND
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
*{   INSERT         S4HK903116                                        2
data:ls_rwfusr type /sdocs/s1_rwfusr,
     LV_LOCK_WAIT        TYPE INT4,
     LV_LOCK_WAIT_C      TYPE CHAR255,
     LV_DIFF             TYPE INT4,
     lv_db_table type char50.

clear: ls_rwfusr,LV_LOCK_WAIT,LV_LOCK_WAIT_C,LV_DIFF.

if I_docid is not initial.
  if I_LOCK = 'L'." Workitem locking
    lv_db_table = '/sdocs/s1_rwfusr'.
     select single * from (lv_db_table) into ls_rwfusr where docid = I_docid
                                            and LOCK_IND = 'X'.
          if sy-subrc ne 0.
            lv_db_table = '/sdocs/s1_rwfusr'.
           update (lv_db_table) set lock_ind = 'X'
                                       reserved = 'X'
                                       LDATE    = sy-datum
                                       Ltime    = sy-uzeit where DOCID  = i_docid
                                                             and C_USER = sy-uname.
          else.
            lv_db_table = '/SDOCS/SSPY_SGC'.
         SELECT SINGLE CONFIG_VALUE INTO LV_LOCK_WAIT_C FROM (lv_db_table) WHERE CONFIG = 'WI_LOCK_WAIT_TIME'.
           LV_LOCK_WAIT =  LV_LOCK_WAIT_C.
          IF LV_LOCK_WAIT IS INITIAL.
            LV_LOCK_WAIT = 60.
          ENDIF.
         LV_DIFF = ( ( ( SY-DATUM -  ls_rwfusr-LDATE ) * 86400 ) + ( SY-UZEIT - ls_rwfusr-Ltime ) ) .
         if LV_DIFF gt LV_LOCK_WAIT.
           lv_db_table = '/sdocs/s1_rwfusr'.
            update (lv_db_table) set lock_ind = '' where DOCID  = i_docid
                                                        and C_USER = sy-uname.
          else.
           E_LOCK   = 'X'.
           e_luser  = ls_rwfusr-c_user.
          endif.
          endif.
          commit work and WAIT.
  elseif i_lock = 'U'."workitem unlocking
    lv_db_table = '/sdocs/s1_rwfusr'.
       update (lv_db_table) set lock_ind = '' where DOCID  = i_docid
                                                        and C_USER = sy-uname.
            commit work and WAIT.

  endif.

else.
  raise docid_not_found.
endif.
*}   INSERT
*{   DELETE         S4HK903116                                        1
*\data:ls_rwfusr type /sdocs/s1_rwfusr,
*\     LV_LOCK_WAIT        TYPE INT4,
*\     LV_LOCK_WAIT_C      TYPE CHAR255,
*\     LV_DIFF             TYPE INT4.
*\
*\clear: ls_rwfusr,LV_LOCK_WAIT,LV_LOCK_WAIT_C,LV_DIFF.
*\
*\if I_docid is not initial.
*\  if I_LOCK = 'L'." Workitem locking
*\     select single * from /sdocs/s1_rwfusr into ls_rwfusr where docid = I_docid
*\                                            and LOCK_IND = 'X'.
*\          if sy-subrc ne 0.
*\           update /sdocs/s1_rwfusr set lock_ind = 'X'
*\                                       reserved = 'X'
*\                                       LDATE    = sy-datum
*\                                       Ltime    = sy-uzeit where DOCID  = i_docid
*\                                                             and C_USER = sy-uname.
*\          else.
*\         SELECT SINGLE CONFIG_VALUE INTO LV_LOCK_WAIT_C FROM /SDOCS/SSPY_SGC WHERE CONFIG = 'WI_LOCK_WAIT_TIME'.
*\           LV_LOCK_WAIT =  LV_LOCK_WAIT_C.
*\          IF LV_LOCK_WAIT IS INITIAL.
*\            LV_LOCK_WAIT = 60.
*\          ENDIF.
*\         LV_DIFF = ( ( ( SY-DATUM -  ls_rwfusr-LDATE ) * 86400 ) + ( SY-UZEIT - ls_rwfusr-Ltime ) ) .
*\         if LV_DIFF gt LV_LOCK_WAIT.
*\            update /sdocs/s1_rwfusr set lock_ind = '' where DOCID  = i_docid
*\                                                        and C_USER = sy-uname.
*\          else.
*\           E_LOCK   = 'X'.
*\           e_luser  = ls_rwfusr-c_user.
*\          endif.
*\          endif.
*\          commit work and WAIT.
*\  elseif i_lock = 'U'."workitem unlocking
*\       update /sdocs/s1_rwfusr set lock_ind = '' where DOCID  = i_docid
*\                                                        and C_USER = sy-uname.
*\            commit work and WAIT.
*\
*\  endif.
*\
*\else.
*\  raise docid_not_found.
*\endif.
*}   DELETE


*data:ls_rwfusr type /sdocs/s1_rwfusr,
*     LV_LOCK_WAIT        TYPE INT4,
*     LV_LOCK_WAIT_C      TYPE CHAR255,
*     LV_DIFF             TYPE INT4.
*clear: ls_rwfusr,LV_LOCK_WAIT,LV_LOCK_WAIT_C,LV_DIFF.
*
*if I_docid is not initial.
*  if I_LOCK = 'L'." Workitem locking
*     select single * from /sdocs/s1_rwfusr into ls_rwfusr where docid = I_docid
*                                            and LOCK_IND = 'X'.
*          if sy-subrc ne 0.
*           update /sdocs/s1_rwfusr set lock_ind = 'X'
*                                       reserved = 'X'
*                                       LDATE    = sy-datum
*                                       Ltime    = sy-uzeit where DOCID  = i_docid
*                                                             and C_USER = sy-uname.
*          else.
*            if ls_rwfusr-c_user = sy-uname.
*              E_LOCK   = 'X'.
*              e_luser  = ls_rwfusr-c_user.
*            else.
*
*         SELECT SINGLE CONFIG_VALUE INTO LV_LOCK_WAIT_C FROM /SDOCS/SSPY_SGC WHERE CONFIG = 'WI_LOCK_WAIT_TIME'.
*           LV_LOCK_WAIT =  LV_LOCK_WAIT_C.
*          IF LV_LOCK_WAIT IS INITIAL.
*            LV_LOCK_WAIT = 60.
*          ENDIF.
*         LV_DIFF = ( ( ( SY-DATUM -  ls_rwfusr-LDATE ) * 86400 ) + ( SY-UZEIT - ls_rwfusr-Ltime ) ) .
*         if LV_DIFF gt LV_LOCK_WAIT.
*            update /sdocs/s1_rwfusr set lock_ind = '' where DOCID  = i_docid
*                                                        and C_USER = sy-uname.
*          else.
*           E_LOCK   = 'X'.
*           e_luser  = ls_rwfusr-c_user.
*          endif.
*          endif.
*          commit work and WAIT.
*         endif.
*  elseif i_lock = 'U'."workitem unlocking
*       update /sdocs/s1_rwfusr set lock_ind = '' where DOCID  = i_docid
*                                                        and C_USER = sy-uname.
*            commit work and WAIT.
*
*  endif.
*
*else.
*  raise docid_not_found.
*endif.





*}   INSERT
ENDFUNCTION.
