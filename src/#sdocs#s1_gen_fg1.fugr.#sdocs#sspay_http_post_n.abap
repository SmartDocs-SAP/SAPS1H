function /SDOCS/SSPAY_HTTP_POST_N.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_PROFILE) TYPE  /SDOCS/SSPY_SPRF-PROFILE_ID
*"         OPTIONAL
*"     REFERENCE(I_EXT) TYPE  /SDOCS/SSPY_HTTP_EXT
*"     REFERENCE(I_INPUT_XML) TYPE  STRING
*"     REFERENCE(I_TOKEN_FLG) TYPE  FLAG
*"     REFERENCE(I_INPUT_METHOD) TYPE  STRING
*"  EXPORTING
*"     REFERENCE(E_SUCCESS) TYPE  CHAR1
*"     REFERENCE(E_RESULT) TYPE  STRING
*"     REFERENCE(E_SCODE) TYPE  I
*"     REFERENCE(E_STEXT) TYPE  STRING
*"  CHANGING
*"     REFERENCE(C_TOKEN_ID) TYPE  STRING OPTIONAL
*"  EXCEPTIONS
*"      EX_INTERNAL_ERROR
*"      EX_CONNECTION_FAILED
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1

*{   INSERT         S4HK903116                                        2
data: l_url               type                   string,
        l_params_string     type                   string,
        l_http_client       type ref to            if_http_client,
        l_result            type                   string,
        l_status_text       type                   string,
        l_http_status_code  type                   i,
        l_http_length       type                   i,
        l_params_xstring    type                   xstring,
        l_xstring           type                   xstring,
        l_is_xml_table      type standard table of smum_xmltb,
        l_is_return         type standard table of bapiret2,
        l_out_tab           type standard table of tbl1024,
        lv_rhttp_enable     type c,
        lv_dest             type LOGSYS.

  data: l_encode_str type string,
        l_encode     type string.

  data: l_app_secret_str type string,
        l_app_secret     type string,
        l_profile        type /sdocs/sspy_sprf,
        lv_url           type string,
        lv_uri            type string,
        lv_db_table type char50.

  clear:l_profile,l_encode_str,l_encode,lv_url,lv_rhttp_enable,lv_dest,lv_uri,lv_rhttp_enable,lv_dest.
lv_db_table = '/sdocs/sspy_sprf'.
  select single * from (lv_db_table) into l_profile where profile_id = i_profile.
    lv_db_table = '/sdocs/sspy_SGC'.
  select single config_value into lv_rhttp_enable from (lv_db_table) where config = 'HTTP_RFC_ENABLE'.

  if lv_rhttp_enable is not INITIAL. " Http connection via RFC destination
     lv_db_table = '/sdocs/sspy_SGC'.
    select single config_value into lv_dest from (lv_db_table) where config = 'HTTP_RFC_LDEST'.

    if lv_dest is INITIAL.
       lv_dest = 'SMARTDOCS'.
    endif.

     CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_DESTINATION
      EXPORTING
        DESTINATION              = lv_dest
      IMPORTING
        CLIENT                   = l_http_client
      EXCEPTIONS
        ARGUMENT_NOT_FOUND       = 1
        DESTINATION_NOT_FOUND    = 2
        DESTINATION_NO_AUTHORITY = 3
        PLUGIN_NOT_ACTIVE        = 4
        INTERNAL_ERROR           = 5
        others                   = 6
            .
    IF SY-SUBRC <> 0.
*     Implement suitable error handling here
    ENDIF.
    lv_uri = i_ext.
     call method l_http_client->request->set_header_field
    exporting
      name  = '~request_uri'
      value = lv_uri.

  else." Direct http call
     if l_profile-server_id is not initial.
*    translate l_profile-server_id to lower case.
    concatenate l_profile-server_id i_ext into lv_url.
  endif.

  call method cl_http_client=>create_by_url
    exporting
      url                = lv_url
    importing
      client             = l_http_client
    exceptions
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      others             = 4.
  endif.

  call method l_http_client->request->set_header_field
    exporting
      name  = 'Accept'
      value = 'application/xml'."application/json'.  "      'text/xml' "

  call method l_http_client->request->set_header_field
    exporting
      name  = '~request_method'
      value = i_input_method.

  call method l_http_client->request->set_content_type
    exporting
      content_type = 'text/xml'."'text/xml'. "application/scim+json "text/plain

  if i_token_flg is not initial.

  endif.

  if c_token_id is not initial and i_token_flg is initial.
    clear:l_encode.

    concatenate 'Bearer' c_token_id into l_encode separated by space.
    call method l_http_client->request->set_header_field
      exporting
        name  = 'Authorization'
        value = l_encode. "INPUT_METHOD .
  endif.

  if i_input_xml is not initial.
    data(lv_fm) = 'SCMS_STRING_TO_XSTRING'.
      call function lv_fm
        exporting
          text   = i_input_xml
        importing
          buffer = l_params_xstring
        exceptions
          failed = 1
          others = 2.

      call method l_http_client->request->set_data
        exporting
          data = l_params_xstring.
    endif.

  "  SEND HTTP REQUEST
  call method l_http_client->send
    exceptions
      http_communication_failure = 1
      http_invalid_state         = 2.

  " GET HTTP RESPONSE
  call method l_http_client->receive
    exceptions
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3.

  " Read HTTP RETURN CODE
  call method l_http_client->response->get_status
    importing
      code   = l_http_status_code
      reason = l_status_text.

  e_scode = l_http_status_code.
  e_stext = l_status_text.


  if l_http_status_code = '200'.
    e_success = 'X'.
    call method l_http_client->response->get_cdata
      receiving
        data = l_result.
    e_result = l_result.

  else.
    call method l_http_client->response->get_cdata
      receiving
        data = l_result.
    e_result = l_result.

  endif.

  " CLOSE CONNECTION
  call method l_http_client->close
    exceptions
      http_invalid_state = 1
      others             = 2.
*}   INSERT
*{   DELETE         S4HK903116                                        1
*\  data: l_url               type                   string,
*\        l_params_string     type                   string,
*\        l_http_client       type ref to            if_http_client,
*\        l_result            type                   string,
*\        l_status_text       type                   string,
*\        l_http_status_code  type                   i,
*\        l_http_length       type                   i,
*\        l_params_xstring    type                   xstring,
*\        l_xstring           type                   xstring,
*\        l_is_xml_table      type standard table of smum_xmltb,
*\        l_is_return         type standard table of bapiret2,
*\        l_out_tab           type standard table of tbl1024,
*\        lv_rhttp_enable     type c,
*\        lv_dest             type LOGSYS.
*\
*\  data: l_encode_str type string,
*\        l_encode     type string.
*\
*\  data: l_app_secret_str type string,
*\        l_app_secret     type string,
*\        l_profile        type /sdocs/sspy_sprf,
*\        lv_url           type string,
*\        lv_uri            type string.
*\
*\  clear:l_profile,l_encode_str,l_encode,lv_url,lv_rhttp_enable,lv_dest,lv_uri,lv_rhttp_enable,lv_dest.
*\
*\  select single * from /sdocs/sspy_sprf into l_profile where profile_id = i_profile.
*\  select single config_value into lv_rhttp_enable from /SDOCS/SSPY_SGC where config = 'HTTP_RFC_ENABLE'.
*\
*\  if lv_rhttp_enable is not INITIAL. " Http connection via RFC destination
*\    select single config_value into lv_dest from /SDOCS/SSPY_SGC where config = 'HTTP_RFC_LDEST'.
*\
*\    if lv_dest is INITIAL.
*\       lv_dest = 'SMARTDOCS'.
*\    endif.
*\
*\     CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_DESTINATION
*\      EXPORTING
*\        DESTINATION              = lv_dest
*\      IMPORTING
*\        CLIENT                   = l_http_client
*\      EXCEPTIONS
*\        ARGUMENT_NOT_FOUND       = 1
*\        DESTINATION_NOT_FOUND    = 2
*\        DESTINATION_NO_AUTHORITY = 3
*\        PLUGIN_NOT_ACTIVE        = 4
*\        INTERNAL_ERROR           = 5
*\        others                   = 6
*\            .
*\    IF SY-SUBRC <> 0.
*\*     Implement suitable error handling here
*\    ENDIF.
*\    lv_uri = i_ext.
*\     call method l_http_client->request->set_header_field
*\    exporting
*\      name  = '~request_uri'
*\      value = lv_uri.
*\
*\  else." Direct http call
*\     if l_profile-server_id is not initial.
*\*    translate l_profile-server_id to lower case.
*\    concatenate l_profile-server_id i_ext into lv_url.
*\  endif.
*\
*\  call method cl_http_client=>create_by_url
*\    exporting
*\      url                = lv_url
*\    importing
*\      client             = l_http_client
*\    exceptions
*\      argument_not_found = 1
*\      plugin_not_active  = 2
*\      internal_error     = 3
*\      others             = 4.
*\  endif.
*\
*\  call method l_http_client->request->set_header_field
*\    exporting
*\      name  = 'Accept'
*\      value = 'application/xml'."application/json'.  "      'text/xml' "
*\
*\  call method l_http_client->request->set_header_field
*\    exporting
*\      name  = '~request_method'
*\      value = i_input_method.
*\
*\  call method l_http_client->request->set_content_type
*\    exporting
*\      content_type = 'text/xml'."'text/xml'. "application/scim+json "text/plain
*\
*\  if i_token_flg is not initial.
*\
*\  endif.
*\
*\  if c_token_id is not initial and i_token_flg is initial.
*\    clear:l_encode.
*\
*\    concatenate 'Bearer' c_token_id into l_encode separated by space.
*\    call method l_http_client->request->set_header_field
*\      exporting
*\        name  = 'Authorization'
*\        value = l_encode. "INPUT_METHOD .
*\  endif.
*\
*\  if i_input_xml is not initial.
*\      call function 'SCMS_STRING_TO_XSTRING'
*\        exporting
*\          text   = i_input_xml
*\        importing
*\          buffer = l_params_xstring
*\        exceptions
*\          failed = 1
*\          others = 2.
*\
*\      call method l_http_client->request->set_data
*\        exporting
*\          data = l_params_xstring.
*\    endif.
*\
*\  "  SEND HTTP REQUEST
*\  call method l_http_client->send
*\    exceptions
*\      http_communication_failure = 1
*\      http_invalid_state         = 2.
*\
*\  " GET HTTP RESPONSE
*\  call method l_http_client->receive
*\    exceptions
*\      http_communication_failure = 1
*\      http_invalid_state         = 2
*\      http_processing_failed     = 3.
*\
*\  " Read HTTP RETURN CODE
*\  call method l_http_client->response->get_status
*\    importing
*\      code   = l_http_status_code
*\      reason = l_status_text.
*\
*\  e_scode = l_http_status_code.
*\  e_stext = l_status_text.
*\
*\
*\  if l_http_status_code = '200'.
*\    e_success = 'X'.
*\    call method l_http_client->response->get_cdata
*\      receiving
*\        data = l_result.
*\    e_result = l_result.
*\
*\  else.
*\    call method l_http_client->response->get_cdata
*\      receiving
*\        data = l_result.
*\    e_result = l_result.
*\
*\  endif.
*\
*\  " CLOSE CONNECTION
*\  call method l_http_client->close
*\    exceptions
*\      http_invalid_state = 1
*\      others             = 2.
*}   DELETE

*}   INSERT
endfunction.
