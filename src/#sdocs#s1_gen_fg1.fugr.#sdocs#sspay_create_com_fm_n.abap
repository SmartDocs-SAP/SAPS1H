function /SDOCS/SSPAY_CREATE_COM_FM_N.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DOCID) TYPE  /SDOCS/SSPY_DOCID
*"     REFERENCE(I_LOG) LIKE  /SDOCS/SSPY_LOG
*"  STRUCTURE  /SDOCS/SSPY_LOG OPTIONAL
*"     REFERENCE(I_ACT_CODE) TYPE  /SDOCS/SSPY_ACT_CODE OPTIONAL
*"  EXPORTING
*"     REFERENCE(E_FCODE) TYPE  SY-UCOMM
*"  TABLES
*"      T_COMMENTS TYPE  TLINETAB OPTIONAL
*"  EXCEPTIONS
*"      EX_DOCID_NOT_FOUND
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1

  "if I_DOCID is not INITIAL.
  clear:gv_com_code.
  g_docid = i_docid.
  gv_com_code = e_fcode.
  gv_activity = i_act_code.
  comments1 = t_comments[].
  perform read_comments using i_log.
  perform get_comments using  i_log changing comments1.
  t_comments[] = comments1[].
  e_fcode = gv_okcode.
  "endif.



*}   INSERT
endfunction.
