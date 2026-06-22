FUNCTION /SDOCS/S1_PAR_CHECK_RULE_N.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DOCID) TYPE  /SDOCS/SSPY_DOCID OPTIONAL
*"     REFERENCE(I_EXT) TYPE  /SDOCS/SSPY_HTTP_EXT OPTIONAL
*"     REFERENCE(I_TYPE) TYPE  CHAR1 OPTIONAL
*"  TABLES
*"      T_EXCPNS TYPE  /SDOCS/S1_EXCP_TAB OPTIONAL
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
*{   DELETE         S4HK903116                                        1
*\  DATA:p_profle TYPE /sdocs/sspy_sprf-profile_id.
*\  DATA:w_excpns        TYPE /sdocs/s1_excp_str,
*\       lv_enable_token.
*\  CLEAR:p_profle,gv_success,gv_res_str,gv_scode,gv_stext,gv_token,w_excpns,lv_enable_token.
*\  REFRESH:gt_excep[],t_excpns[].
*\  IF i_docid IS NOT INITIAL AND i_ext IS NOT INITIAL.
*\    p_profle = sy-sysid.
*\    SELECT * FROM /sdocs/sspy_hd INTO TABLE @gt_hd WHERE docid = @i_docid.
*\    SELECT SINGLE * FROM /sdocs/sspy_sprf INTO wa_profile WHERE profile_id = p_profle.
*\    IF sy-subrc = 0.
*\      CLEAR lv_enable_token.
*\      SELECT SINGLE config_value INTO lv_enable_token FROM /sdocs/sspy_sgc WHERE config = 'HTTP_TOKEN_ENABLE'.
*\      IF lv_enable_token IS NOT INITIAL.
*\        PERFORM portal_authitication USING p_profle.
*\        IF gv_token IS NOT INITIAL AND ( gv_scode = '200' OR gv_scode = '201' ).
*\        ENDIF.
*\      ENDIF.
*\
*\
*\      IF gv_token IS INITIAL.
*\        gv_token = 'noToken'.
*\      ENDIF.
*\      CALL FUNCTION '/SDOCS/SSPAY_HTTP_GET_N'
*\        EXPORTING
*\          i_profile            = p_profle
*\          i_ext                = i_ext
*\          i_input_xml          = ''
*\          i_token_flg          = ''
*\          i_input_method       = 'GET'
*\        IMPORTING
*\          e_success            = gv_success
*\          e_result             = gv_res_str
*\          e_scode              = gv_scode
*\          e_stext              = gv_stext
*\        CHANGING
*\          c_token_id           = gv_token
*\        EXCEPTIONS
*\          ex_internal_error    = 1
*\          ex_connection_failed = 2
*\          OTHERS               = 3.
*\
*\      IF sy-subrc = 0 AND gv_scode = '200'.
*\        PERFORM  get_checkruledata_from_portal USING I_TYPE.
*\        LOOP AT gt_excep[] INTO gs_excep.
*\          w_excpns-excp            = gs_excep-excp.
*\          w_excpns-icon_status     = gs_excep-ind.
*\          w_excpns-ind             = gs_excep-index.
*\          w_excpns-excp_clr_f      = gs_excep-clr_icon.
*\          w_excpns-agent_id        = gs_excep-AGENT.
*\          w_excpns-STAGE_NAME      = gs_excep-stage_name.
*\          APPEND w_excpns TO  t_excpns[].
*\          CLEAR:w_excpns,gs_excep,t_excpns.
*\        ENDLOOP.
*\      ENDIF.
*\    ENDIF.
*\
*\  ENDIF.
*\
*}   DELETE


*}   INSERT
ENDFUNCTION.
