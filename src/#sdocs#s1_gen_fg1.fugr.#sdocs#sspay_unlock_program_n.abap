FUNCTION /SDOCS/SSPAY_UNLOCK_PROGRAM_N.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_PROG_NAME) TYPE  PROGNAME
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
*{   INSERT         S4HK903116                                        2
if i_prog_name is not initial.
  lv_db_table = '/SDOCS/SSPY_PLOC'.
   delete from (lv_db_table) where prog_name = i_prog_name.
    commit work and wait.
  endif.
*}   INSERT
*{   DELETE         S4HK903116                                        1
*\if i_prog_name is not initial.
*\   delete from /SDOCS/SSPY_PLOC where prog_name = i_prog_name.
*\    commit work and wait.
*\  endif.
*\
*}   DELETE




*}   INSERT
ENDFUNCTION.
