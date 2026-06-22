FUNCTION /SDOCS/SSPAY_HTTP_GET_N.
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
DATA: L_URL               TYPE                   STRING          ,
         L_PARAMS_STRING     TYPE                   STRING          ,
         L_HTTP_CLIENT       TYPE REF TO            IF_HTTP_CLIENT  ,
         L_RESULT            TYPE                   STRING          ,
         L_STATUS_TEXT       TYPE                   STRING          ,
         L_HTTP_STATUS_CODE  TYPE                   I               ,
         L_HTTP_LENGTH       TYPE                   I               ,
         L_PARAMS_XSTRING    TYPE                   XSTRING         ,
         L_XSTRING           TYPE                   XSTRING         ,
         L_IS_XML_TABLE      TYPE STANDARD TABLE OF SMUM_XMLTB      ,
         L_IS_RETURN         TYPE STANDARD TABLE OF BAPIRET2        ,
         L_OUT_TAB           TYPE STANDARD TABLE OF TBL1024,
         lv_rhttp_enable     type c,
         lv_dest             type LOGSYS.
  DATA: L_ENCODE_STR TYPE STRING,
        L_ENCODE TYPE STRING,
        L_APP_SECRET_STR TYPE STRING,
        L_APP_SECRET TYPE STRING,
        L_PROFILE TYPE /SDOCS/SSPY_SPRF,
        LV_URL TYPE STRING,
        lv_uri type string.

  CLEAR:L_PROFILE,L_ENCODE_STR,L_ENCODE,LV_URL,lv_uri,lv_rhttp_enable,lv_dest.

  SELECT SINGLE * FROM /SDOCS/SSPY_SPRF INTO L_PROFILE WHERE PROFILE_ID = I_PROFILE.

   select single config_value into lv_rhttp_enable from /SDOCS/SSPY_SGC where config = 'HTTP_RFC_ENABLE'.

  if lv_rhttp_enable is not INITIAL. "Http connection via RFC destination

    select single config_value into lv_dest from /SDOCS/SSPY_SGC where config = 'HTTP_RFC_LDEST'.

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

  IF L_PROFILE IS NOT INITIAL.
*    TRANSLATE L_PROFILE-SERVER_ID TO LOWER CASE.
    CONCATENATE L_PROFILE-SERVER_ID I_EXT INTO LV_URL.
  ENDIF.

  CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_URL
    EXPORTING
      URL                = LV_URL
    IMPORTING
      CLIENT             = L_HTTP_CLIENT
    EXCEPTIONS
      ARGUMENT_NOT_FOUND = 1
      PLUGIN_NOT_ACTIVE  = 2
      INTERNAL_ERROR     = 3
      OTHERS             = 4.
  endif.


  CALL METHOD L_HTTP_CLIENT->REQUEST->SET_HEADER_FIELD
    EXPORTING
      NAME  = 'Receive'
      VALUE = 'text/xml'.  "

  CALL METHOD L_HTTP_CLIENT->REQUEST->SET_HEADER_FIELD
    EXPORTING
      NAME  = '~response_method'
      VALUE = I_INPUT_METHOD.

  CALL METHOD L_HTTP_CLIENT->REQUEST->SET_CONTENT_TYPE
    EXPORTING
      CONTENT_TYPE = 'text/xml'. "application/scim+json


  IF I_TOKEN_FLG IS NOT INITIAL.
    L_APP_SECRET = L_PROFILE-APP_SECRET_ID.
    CALL METHOD CL_HTTP_UTILITY=>IF_HTTP_UTILITY~DECODE_BASE64
      EXPORTING
        ENCODED = L_APP_SECRET
      RECEIVING
        DECODED = L_APP_SECRET_STR.

    CONCATENATE L_PROFILE-APP_ID ':' L_APP_SECRET_STR INTO L_ENCODE_STR.

    CALL METHOD CL_HTTP_UTILITY=>IF_HTTP_UTILITY~ENCODE_BASE64
      EXPORTING
        UNENCODED = L_ENCODE_STR
      RECEIVING
        ENCODED   = L_ENCODE.
    CONCATENATE 'Basic' L_ENCODE INTO L_ENCODE SEPARATED BY SPACE.

    CALL METHOD L_HTTP_CLIENT->REQUEST->SET_HEADER_FIELD
      EXPORTING
        NAME  = 'Authorization'
        VALUE = L_ENCODE. "INPUT_METHOD .
  ENDIF.
  IF C_TOKEN_ID IS NOT INITIAL AND I_TOKEN_FLG IS INITIAL.
    CLEAR L_ENCODE.
    CONCATENATE 'Bearer' C_TOKEN_ID INTO L_ENCODE SEPARATED BY SPACE.
    CALL METHOD L_HTTP_CLIENT->REQUEST->SET_HEADER_FIELD
      EXPORTING
        NAME  = 'Authorization'
        VALUE = L_ENCODE. "INPUT_METHOD .

    IF I_INPUT_XML IS NOT INITIAL.
      CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
        EXPORTING
          TEXT   = I_INPUT_XML
        IMPORTING
          BUFFER = L_PARAMS_XSTRING
        EXCEPTIONS
          FAILED = 1
          OTHERS = 2.

      CALL METHOD L_HTTP_CLIENT->REQUEST->SET_DATA
        EXPORTING
          DATA = L_PARAMS_XSTRING.
    ENDIF.
  ENDIF.

  "  SEND HTTP REQUEST
  CALL METHOD L_HTTP_CLIENT->SEND
    EXCEPTIONS
      HTTP_COMMUNICATION_FAILURE = 1
      HTTP_INVALID_STATE         = 2.

  " GET HTTP RESPONSE
  CALL METHOD L_HTTP_CLIENT->RECEIVE
    EXCEPTIONS
      HTTP_COMMUNICATION_FAILURE = 1
      HTTP_INVALID_STATE         = 2
      HTTP_PROCESSING_FAILED     = 3.

  " Read HTTP RETURN CODE
  CALL METHOD L_HTTP_CLIENT->RESPONSE->GET_STATUS
    IMPORTING
      CODE   = L_HTTP_STATUS_CODE
      REASON = L_STATUS_TEXT.

  E_SCODE = L_HTTP_STATUS_CODE.
  E_STEXT = L_STATUS_TEXT.


  IF L_HTTP_STATUS_CODE = '200'.
    E_SUCCESS = 'X'.
    CALL METHOD L_HTTP_CLIENT->RESPONSE->GET_CDATA
      RECEIVING
        DATA = L_RESULT.
    E_RESULT = L_RESULT.
    IF I_TOKEN_FLG IS NOT INITIAL.
      C_TOKEN_ID = L_RESULT.
    ENDIF.
  ELSE.
    CALL METHOD L_HTTP_CLIENT->RESPONSE->GET_CDATA
      RECEIVING
        DATA = L_RESULT.
    E_RESULT = L_RESULT.

  ENDIF.
  " CLOSE CONNECTION
  CALL METHOD L_HTTP_CLIENT->CLOSE
    EXCEPTIONS
      HTTP_INVALID_STATE = 1
      OTHERS             = 2.
*}   INSERT
*{   DELETE         S4HK903116                                        1
*\  DATA: L_URL               TYPE                   STRING          ,
*\         L_PARAMS_STRING     TYPE                   STRING          ,
*\         L_HTTP_CLIENT       TYPE REF TO            IF_HTTP_CLIENT  ,
*\         L_RESULT            TYPE                   STRING          ,
*\         L_STATUS_TEXT       TYPE                   STRING          ,
*\         L_HTTP_STATUS_CODE  TYPE                   I               ,
*\         L_HTTP_LENGTH       TYPE                   I               ,
*\         L_PARAMS_XSTRING    TYPE                   XSTRING         ,
*\         L_XSTRING           TYPE                   XSTRING         ,
*\         L_IS_XML_TABLE      TYPE STANDARD TABLE OF SMUM_XMLTB      ,
*\         L_IS_RETURN         TYPE STANDARD TABLE OF BAPIRET2        ,
*\         L_OUT_TAB           TYPE STANDARD TABLE OF TBL1024,
*\         lv_rhttp_enable     type c,
*\         lv_dest             type LOGSYS.
*\  DATA: L_ENCODE_STR TYPE STRING,
*\        L_ENCODE TYPE STRING,
*\        L_APP_SECRET_STR TYPE STRING,
*\        L_APP_SECRET TYPE STRING,
*\        L_PROFILE TYPE /SDOCS/SSPY_SPRF,
*\        LV_URL TYPE STRING,
*\        lv_uri type string.
*\
*\  CLEAR:L_PROFILE,L_ENCODE_STR,L_ENCODE,LV_URL,lv_uri,lv_rhttp_enable,lv_dest.
*\
*\  SELECT SINGLE * FROM /SDOCS/SSPY_SPRF INTO L_PROFILE WHERE PROFILE_ID = I_PROFILE.
*\
*\   select single config_value into lv_rhttp_enable from /SDOCS/SSPY_SGC where config = 'HTTP_RFC_ENABLE'.
*\
*\  if lv_rhttp_enable is not INITIAL. "Http connection via RFC destination
*\
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
*\
*\  IF L_PROFILE IS NOT INITIAL.
*\*    TRANSLATE L_PROFILE-SERVER_ID TO LOWER CASE.
*\    CONCATENATE L_PROFILE-SERVER_ID I_EXT INTO LV_URL.
*\  ENDIF.
*\
*\  CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_URL
*\    EXPORTING
*\      URL                = LV_URL
*\    IMPORTING
*\      CLIENT             = L_HTTP_CLIENT
*\    EXCEPTIONS
*\      ARGUMENT_NOT_FOUND = 1
*\      PLUGIN_NOT_ACTIVE  = 2
*\      INTERNAL_ERROR     = 3
*\      OTHERS             = 4.
*\  endif.
*\
*\
*\  CALL METHOD L_HTTP_CLIENT->REQUEST->SET_HEADER_FIELD
*\    EXPORTING
*\      NAME  = 'Receive'
*\      VALUE = 'text/xml'.  "
*\
*\  CALL METHOD L_HTTP_CLIENT->REQUEST->SET_HEADER_FIELD
*\    EXPORTING
*\      NAME  = '~response_method'
*\      VALUE = I_INPUT_METHOD.
*\
*\  CALL METHOD L_HTTP_CLIENT->REQUEST->SET_CONTENT_TYPE
*\    EXPORTING
*\      CONTENT_TYPE = 'text/xml'. "application/scim+json
*\
*\
*\  IF I_TOKEN_FLG IS NOT INITIAL.
*\    L_APP_SECRET = L_PROFILE-APP_SECRET_ID.
*\    CALL METHOD CL_HTTP_UTILITY=>IF_HTTP_UTILITY~DECODE_BASE64
*\      EXPORTING
*\        ENCODED = L_APP_SECRET
*\      RECEIVING
*\        DECODED = L_APP_SECRET_STR.
*\
*\    CONCATENATE L_PROFILE-APP_ID ':' L_APP_SECRET_STR INTO L_ENCODE_STR.
*\
*\    CALL METHOD CL_HTTP_UTILITY=>IF_HTTP_UTILITY~ENCODE_BASE64
*\      EXPORTING
*\        UNENCODED = L_ENCODE_STR
*\      RECEIVING
*\        ENCODED   = L_ENCODE.
*\    CONCATENATE 'Basic' L_ENCODE INTO L_ENCODE SEPARATED BY SPACE.
*\
*\    CALL METHOD L_HTTP_CLIENT->REQUEST->SET_HEADER_FIELD
*\      EXPORTING
*\        NAME  = 'Authorization'
*\        VALUE = L_ENCODE. "INPUT_METHOD .
*\  ENDIF.
*\  IF C_TOKEN_ID IS NOT INITIAL AND I_TOKEN_FLG IS INITIAL.
*\    CLEAR L_ENCODE.
*\    CONCATENATE 'Bearer' C_TOKEN_ID INTO L_ENCODE SEPARATED BY SPACE.
*\    CALL METHOD L_HTTP_CLIENT->REQUEST->SET_HEADER_FIELD
*\      EXPORTING
*\        NAME  = 'Authorization'
*\        VALUE = L_ENCODE. "INPUT_METHOD .
*\
*\    IF I_INPUT_XML IS NOT INITIAL.
*\      CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
*\        EXPORTING
*\          TEXT   = I_INPUT_XML
*\        IMPORTING
*\          BUFFER = L_PARAMS_XSTRING
*\        EXCEPTIONS
*\          FAILED = 1
*\          OTHERS = 2.
*\
*\      CALL METHOD L_HTTP_CLIENT->REQUEST->SET_DATA
*\        EXPORTING
*\          DATA = L_PARAMS_XSTRING.
*\    ENDIF.
*\  ENDIF.
*\
*\  "  SEND HTTP REQUEST
*\  CALL METHOD L_HTTP_CLIENT->SEND
*\    EXCEPTIONS
*\      HTTP_COMMUNICATION_FAILURE = 1
*\      HTTP_INVALID_STATE         = 2.
*\
*\  " GET HTTP RESPONSE
*\  CALL METHOD L_HTTP_CLIENT->RECEIVE
*\    EXCEPTIONS
*\      HTTP_COMMUNICATION_FAILURE = 1
*\      HTTP_INVALID_STATE         = 2
*\      HTTP_PROCESSING_FAILED     = 3.
*\
*\  " Read HTTP RETURN CODE
*\  CALL METHOD L_HTTP_CLIENT->RESPONSE->GET_STATUS
*\    IMPORTING
*\      CODE   = L_HTTP_STATUS_CODE
*\      REASON = L_STATUS_TEXT.
*\
*\  E_SCODE = L_HTTP_STATUS_CODE.
*\  E_STEXT = L_STATUS_TEXT.
*\
*\
*\  IF L_HTTP_STATUS_CODE = '200'.
*\    E_SUCCESS = 'X'.
*\    CALL METHOD L_HTTP_CLIENT->RESPONSE->GET_CDATA
*\      RECEIVING
*\        DATA = L_RESULT.
*\    E_RESULT = L_RESULT.
*\    IF I_TOKEN_FLG IS NOT INITIAL.
*\      C_TOKEN_ID = L_RESULT.
*\    ENDIF.
*\  ELSE.
*\    CALL METHOD L_HTTP_CLIENT->RESPONSE->GET_CDATA
*\      RECEIVING
*\        DATA = L_RESULT.
*\    E_RESULT = L_RESULT.
*\
*\  ENDIF.
*\  " CLOSE CONNECTION
*\  CALL METHOD L_HTTP_CLIENT->CLOSE
*\    EXCEPTIONS
*\      HTTP_INVALID_STATE = 1
*\      OTHERS             = 2.
*}   DELETE

*}   INSERT
ENDFUNCTION.
