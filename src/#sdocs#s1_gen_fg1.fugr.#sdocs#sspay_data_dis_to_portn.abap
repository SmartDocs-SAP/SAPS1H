function /SDOCS/SSPAY_DATA_DIS_TO_PORTN.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DOCID) TYPE  /SDOCS/SSPY_DOCID
*"     REFERENCE(I_ACTIVITY) TYPE  /SDOCS/SSPY_ACT_CODE OPTIONAL
*"     REFERENCE(I_EXT) TYPE  /SDOCS/SSPY_HTTP_EXT OPTIONAL
*"     REFERENCE(I_LOG) LIKE  /SDOCS/SSPY_LOG
*"  STRUCTURE  /SDOCS/SSPY_LOG OPTIONAL
*"     REFERENCE(I_TYPE) TYPE  /SDOCS/S1_PRCS_TYPE OPTIONAL
*"     REFERENCE(I_AACT) TYPE  /SDOCS/S1_AACT OPTIONAL
*"  EXPORTING
*"     REFERENCE(E_SUCCESS) TYPE  SUCCESS
*"  TABLES
*"      T_MSG STRUCTURE  /SDOCS/SSPY_ST_MSG OPTIONAL
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
*{   INSERT         S4HK903116                                        2
 data:p_profle type /sdocs/sspy_sprf-profile_id,
        lv_db_table type char50,
        LV_DISP_FM type  char100.
  refresh:gt_hd[],gt_flog[],gt_ln[],gt_atta,gt_latta,gt_err_msg.
  clear:wa_hd,wa_ln,wa_atta,wa_flog,p_profle,wa_otv.
  if i_docid is not initial.
    perform get_data using i_docid.
    wa_hd = value #( gt_hd[ 1 ] optional ).
    clear gv_enable_token.
    if  wa_hd-doctype = 'SSPAY_EXP'.
      p_profle = 'S1D_EXP'.
    else.
      p_profle = sy-sysid.

    endif.
    lv_db_table = '/sdocs/sspy_sprf'.
    select single * from (lv_db_table) into wa_profile where profile_id = p_profle.
lv_db_table = ' /SDOCS/SSPY_SGC'.
    SELECT SINGLE CONFIG_VALUE INTO LV_DISP_FM FROM (lv_db_table) WHERE CONFIG = 'INVOICE_DISP_ENABLE_FM'.
    select single config_value from (lv_db_table) into gv_enable_token where config = 'HTTP_TOKEN_ENABLE'.
    if gv_enable_token is not initial.
      if gt_hd[] is not initial.
        perform portal_authitication using p_profle.
        if gv_token is not initial and ( gv_scode = '200' or gv_scode = '201' ).
        else.
          message s001(/sdocs/sspay_msg).
          exit.
        endif.
      else.
        message s002(/sdocs/sspay_msg).
      endif.
    else.
      if gt_hd[] is initial.
        message s002(/sdocs/sspay_msg).
      endif.
    endif.
    refresh:gt_xml[].
    clear:lv_ref_id,gs_xml.

    if lv_disp_fm is initial.

      if wa_hd-doctype = 'SSPAY_EXP'.
*        perform expence_data using i_log.
      else.

        gs_xml-line = '<INVOICE_CONTAINER>'.
        append gs_xml to gt_xml.
        clear:gs_xml.

        lv_ref_id = i_docid.
        shift lv_ref_id left deleting leading '0'.
        concatenate '<REF_ID>' lv_ref_id '</REF_ID>' into gs_xml-line.
        append gs_xml to gt_xml.
        clear:gs_xml.

        loop at gt_hd into wa_hd.
*      from gv_from to gv_to.
          clear:lv_docid,wa_batch.

          gs_xml-line = '<INVOICE_DATA>'.
          append gs_xml to gt_xml.
          clear:gs_xml.



          lv_docid = wa_hd-docid.
          wa_batch-docid = wa_hd-docid.
          append wa_batch to gt_batch.

          concatenate '<REF_ID>' lv_ref_id '</REF_ID>' into gs_xml-line.
          append gs_xml to gt_xml.
          clear:gs_xml.

*          perform prepare_hdata_xml using i_activity.
*          perform prepare_otv_xml.
*          perform prepare_ldata_xml.
*          perform prepare_attach_xml.
*          perform prepare_log_xml.
*          pERFORM PREPARE_VRR_POST_ERRORS_XML.

          gs_xml-line = '</INVOICE_DATA>'.
          append gs_xml to gt_xml.
          clear: gs_xml.

*          perform prepare_actions_log using i_log.
        endloop.
        IF I_AACT IS NOT INITIAL.
          CONCATENATE '<POST_ERP_STATUS>' 'Success' '</POST_ERP_STATUS>' INTO GS_XML-LINE.
          APPEND GS_XML TO GT_XML.  CLEAR:GS_XML.
        ELSE.
          CONCATENATE '<POST_ERP_STATUS>' 'Failed' '</POST_ERP_STATUS>' INTO GS_XML-LINE.
          APPEND GS_XML TO GT_XML.  CLEAR:GS_XML.
        ENDIF.

        gs_xml-line = '</INVOICE_CONTAINER>'.
        append gs_xml to gt_xml.
        clear gs_xml.
         endif.
      else.
       call function lv_disp_fm   "'ZSDOCS_VRR_DATA_DSP'
          exporting
            i_docid = i_docid
            i_log   = i_log
          tables
            t_xml   = gt_xml[].

    endif.

*    perform update using e_success i_ext i_activity i_type
*                   changing gv_subrc.
    clear:wa_hd,wa_otv.

  endif.
*}   INSERT
*{   DELETE         S4HK903116                                        1
*\  data:p_profle type /sdocs/sspy_sprf-profile_id.
*\  refresh:gt_hd[],gt_flog[],gt_ln[],gt_atta,gt_latta,gt_err_msg.
*\  clear:wa_hd,wa_ln,wa_atta,wa_flog,p_profle,wa_otv.
*\  if i_docid is not initial.
*\    perform get_data using i_docid.
*\    wa_hd = value #( gt_hd[ 1 ] optional ).
*\    clear gv_enable_token.
*\    if  wa_hd-doctype = 'SSPAY_EXP'.
*\      p_profle = 'S1D_EXP'.
*\    else.
*\      p_profle = sy-sysid.
*\
*\    endif.
*\    select single * from /sdocs/sspy_sprf into wa_profile where profile_id = p_profle.
*\    SELECT SINGLE CONFIG_VALUE INTO @DATA(LV_DISP_FM) FROM /SDOCS/SSPY_SGC WHERE CONFIG = 'INVOICE_DISP_ENABLE_FM'.
*\    select single config_value from /sdocs/sspy_sgc into gv_enable_token where config = 'HTTP_TOKEN_ENABLE'.
*\    if gv_enable_token is not initial.
*\      if gt_hd[] is not initial.
*\        perform portal_authitication using p_profle.
*\        if gv_token is not initial and ( gv_scode = '200' or gv_scode = '201' ).
*\        else.
*\          message s001(/sdocs/sspay_msg).
*\          exit.
*\        endif.
*\      else.
*\        message s002(/sdocs/sspay_msg).
*\      endif.
*\    else.
*\      if gt_hd[] is initial.
*\        message s002(/sdocs/sspay_msg).
*\      endif.
*\    endif.
*\    refresh:gt_xml[].
*\    clear:lv_ref_id,gs_xml.
*\
*\    if lv_disp_fm is initial.
*\
*\      if wa_hd-doctype = 'SSPAY_EXP'.
*\        perform expence_data using i_log.
*\      else.
*\
*\        gs_xml-line = '<INVOICE_CONTAINER>'.
*\        append gs_xml to gt_xml.
*\        clear:gs_xml.
*\
*\        lv_ref_id = i_docid.
*\        shift lv_ref_id left deleting leading '0'.
*\        concatenate '<REF_ID>' lv_ref_id '</REF_ID>' into gs_xml-line.
*\        append gs_xml to gt_xml.
*\        clear:gs_xml.
*\
*\        loop at gt_hd into wa_hd.
*\*      from gv_from to gv_to.
*\          clear:lv_docid,wa_batch.
*\
*\          gs_xml-line = '<INVOICE_DATA>'.
*\          append gs_xml to gt_xml.
*\          clear:gs_xml.
*\
*\
*\
*\          lv_docid = wa_hd-docid.
*\          wa_batch-docid = wa_hd-docid.
*\          append wa_batch to gt_batch.
*\
*\          concatenate '<REF_ID>' lv_ref_id '</REF_ID>' into gs_xml-line.
*\          append gs_xml to gt_xml.
*\          clear:gs_xml.
*\
*\          perform prepare_hdata_xml using i_activity.
*\          perform prepare_otv_xml.
*\          perform prepare_ldata_xml.
*\          perform prepare_attach_xml.
*\          perform prepare_log_xml.
*\          pERFORM PREPARE_VRR_POST_ERRORS_XML.
*\
*\          gs_xml-line = '</INVOICE_DATA>'.
*\          append gs_xml to gt_xml.
*\          clear: gs_xml.
*\
*\          perform prepare_actions_log using i_log.
*\        endloop.
*\        IF I_AACT IS NOT INITIAL.
*\          CONCATENATE '<POST_ERP_STATUS>' 'Success' '</POST_ERP_STATUS>' INTO GS_XML-LINE.
*\          APPEND GS_XML TO GT_XML.  CLEAR:GS_XML.
*\        ELSE.
*\          CONCATENATE '<POST_ERP_STATUS>' 'Failed' '</POST_ERP_STATUS>' INTO GS_XML-LINE.
*\          APPEND GS_XML TO GT_XML.  CLEAR:GS_XML.
*\        ENDIF.
*\
*\        gs_xml-line = '</INVOICE_CONTAINER>'.
*\        append gs_xml to gt_xml.
*\        clear gs_xml.
*\         endif.
*\      else.
*\       call function lv_disp_fm   "'ZSDOCS_VRR_DATA_DSP'
*\          exporting
*\            i_docid = i_docid
*\            i_log   = i_log
*\          tables
*\            t_xml   = gt_xml[].
*\
*\    endif.
*\
*\    perform update using e_success i_ext i_activity i_type
*\                   changing gv_subrc.
*\    clear:wa_hd,wa_otv.
*\
*\  endif.
*}   DELETE
*}   INSERT
endfunction.
