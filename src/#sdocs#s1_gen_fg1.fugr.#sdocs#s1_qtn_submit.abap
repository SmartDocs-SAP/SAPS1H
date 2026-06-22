FUNCTION /SDOCS/S1_QTN_SUBMIT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(P_QTN) TYPE  EBELN
*"  EXPORTING
*"     REFERENCE(LV_RESPONSE1) TYPE  INT4
*"----------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
DATA : lv_http_status type string,
           lv_reason type string,
           lv_response type string.
*--- VARIABLES ---
DATA: lo_http_client TYPE REF TO if_http_client,
      lo_rest_client TYPE REF TO cl_rest_http_client,
      lo_request     TYPE REF TO if_rest_entity,
      lo_response    TYPE REF TO if_rest_entity,
      lv_url_post    TYPE string,
      lv_date_str    TYPE string,
      lv_csrf_token  TYPE string,
      http_status    TYPE string,
      reason         TYPE string,
      response       TYPE string,
      lv_json_payload type string.
data(lv_status) = '03'.
CONCATENATE
  '{"d": {'
  '"Submit": {'
  '"QTNLifecycleStatus":"'  lv_status  '"'
  '}}}'
  INTO lv_json_payload.
*{   INSERT         S4HK903118                                        2
data : lv_db_table type char50,
       mv_final_url type string.
lv_db_table = '/sdocs/sspy_sgc'.
select single config_value into mv_final_url from (lv_db_table) where config = 'SPLR_QTN_SUBMIT'.
  replace '{ p_qtn }' in mv_final_url with p_qtn.
*}   INSERT
*{   DELETE         S4HK903118                                        1
*\data(MV_FINAL_URL) = |https://VHCALS4HCS.DUMMY.NODOMAIN:443/sap/opu/odata/sap/API_QTN_PROCESS_SRV/Submit?SupplierQuotation='{ p_qtn }'|.
*}   DELETE
     CALL METHOD cl_http_client=>create_by_url
  EXPORTING
    url    = MV_FINAL_URL
  IMPORTING
    client = lo_http_client
  EXCEPTIONS
    OTHERS = 1.

IF sy-subrc <> 0.
  WRITE: / 'Failed to create HTTP client.'.
  RETURN.
ENDIF.
*--- ENABLE COOKIES ---
lo_http_client->propertytype_accept_cookie = if_http_client=>co_enabled.
select single config_value from /sdocs/sspy_sgc into @data(lv_user) where config = 'AUTHENTICATE_USER'.
select single config_value from /sdocs/sspy_sgc into @data(lv_PSWD) where config = 'AUTHENTICATE_PSWD'.
lo_http_client->authenticate(
EXPORTING
  username = CONV STRING( lv_user )
  password = CONV STRING( lv_PSWD ) ).

*--- FETCH CSRF TOKEN ---
lo_http_client->request->set_method( if_http_request=>co_request_method_get ).
lo_http_client->request->set_header_field( name = 'x-csrf-token' value = 'Fetch' ).

TRY.
    lo_http_client->send( ).
    lo_http_client->receive( ).
  CATCH cx_root INTO DATA(lx_err).
    WRITE: / 'Error fetching CSRF token:', lx_err->get_text( ).
    RETURN.
ENDTRY.

lv_csrf_token = lo_http_client->response->get_header_field( 'x-csrf-token' ).

IF lv_csrf_token IS INITIAL.
  WRITE: / 'CSRF token not received.'.
  RETURN.
ENDIF.
     lo_http_client->request->set_method( if_http_request=>co_request_method_post ).
lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).
lo_http_client->request->set_header_field( name = 'Accept'       value = 'application/json' ).
lo_http_client->request->set_header_field( name = 'x-csrf-token' value = lv_csrf_token ).
* Set payload
lo_http_client->request->set_cdata( lv_json_payload ).
CREATE OBJECT lo_rest_client
  EXPORTING io_http_client = lo_http_client.

lo_request = lo_rest_client->if_rest_client~create_request_entity( ).

lo_rest_client->if_rest_resource~post( lo_request ).

*--- READ RESPONSE ---
lo_response = lo_rest_client->if_rest_client~get_response_entity( ).
lv_http_status = lo_response->get_header_field( '~status_code' ).
lv_reason      = lo_response->get_header_field( '~status_reason' ).
lv_response    = lo_response->get_string_data( ).
lv_response1  =  lv_http_status.
*}   INSERT





ENDFUNCTION.
