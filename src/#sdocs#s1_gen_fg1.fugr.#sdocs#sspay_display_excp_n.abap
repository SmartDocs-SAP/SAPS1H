function /SDOCS/SSPAY_DISPLAY_EXCP_N.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DOCID) TYPE  /SDOCS/SSPY_DOCID OPTIONAL
*"     REFERENCE(I_NODISP) TYPE  CHAR1 OPTIONAL
*"  EXCEPTIONS
*"      EX_DOCID_NOT_FOUND
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
  data:gt_excpns type table of /sdocs/sspy_excp,
       gs_excpns type /sdocs/sspy_excp.
  data:lt_recxp type table of /sdocs/sspy_rexp with header line.
  data:gt_excpnst type table of /sdocs/sspy_exct,
       gs_excpnst type /sdocs/sspy_exct.
  data:l_log     like /sdocs/sspy_log.
  data:l_check_act type /sdocs/sspy_sgc-config_value.
  data:lv_activity type /sdocs/sspy_act_code.
  data:lv_adocid type char25.
  data:lv_ext1 type  /sdocs/sspy_http_ext.
  data:lt_aexcp1 type  /SDOCS/S1_EXCP_TAB.
  data:w_cellcolor TYPE lvc_s_scol.
  constants :lv_ext type  /sdocs/sspy_http_ext value '/spayInvoice/action'.
  refresh:gt_excep[].

  if i_docid is not initial and I_NODISP is INITIAL.
    clear:l_hdr,g_docid,lt_recxp,l_check_act,lv_activity,l_log,gv_check_rule,gs_excpns,gs_excpnst.
    refresh:gt_excpns[],gt_excpnst[],lt_recxp[],gt_excep[].
    select single config_value from /sdocs/sspy_sgc into l_check_act where config = 'CHECK_RULE_ACTIVITY'.

    lv_activity = l_check_act.
    g_docid = i_docid.
    l_log-mandt          = sy-mandt.
    l_log-docid          = g_docid.
    l_log-actvty_id      = lv_activity."'149'.
    l_log-actual_user    = sy-uname.
    l_log-end_date       = sy-datum.
    l_log-end_time       = sy-uzeit.
    gv_check_rule  = 'X'.
     g_docid = i_docid.
    call function '/SDOCS/SSPAY_DATA_DISP_TO_PORTN'
      exporting
        i_docid = i_docid
        i_ext   = lv_ext
        i_log   = l_log
        i_type  = 'C'.
elseif i_docid is not initial and I_NODISP is not INITIAL.
select single config_value from /sdocs/sspy_sgc into lv_ext1 where config = 'ALL_CHECK_RULE_EXT'.
  lv_adocid = i_docid.
    g_docid = i_docid.
shift lv_adocid left deleting leading '0'.
CONCATENATE lv_ext1 lv_adocid into lv_ext1.
  call function '/SDOCS/S1_PAR_CHECK_RULE_N'
   exporting
     i_docid        = i_docid
     i_ext          = lv_ext1
     I_TYPE         = 'A'
   tables
     t_excpns       = lt_aexcp1[].
*
*  SELECT SINGLE WF_STAGE INTO @DATA(LV_WFSTAGE) FROM /SDOCS/SSPY_HD WHERE DOCID = @I_DOCID.
*    CLEAR gs_excep.
*  READ TABLE gt_excep INTO gs_excep WITH KEY EXCP_TXT = LV_WFSTAGE.
*  IF SY-SUBRC = 0.
*    "5
*
*     append w_cellcolor TO GS_EXCEP-ccolor.
*    MODIFY gt_excep FROM gs_excep INDEX SY-TABIX TRANSPORTING FCOLOR ccolor.
*  ENDIF.
  endif.

   if gt_excep[] is not initial.
*      sort gt_excep[] by index.
      IF I_NODISP is  INITIAL or I_NODISP  = 'A'.
      call screen 800 starting at 25 5.
      ENDIF.
    endif.
    clear:l_log,gv_check_rule.
*}   INSERT
endfunction.
