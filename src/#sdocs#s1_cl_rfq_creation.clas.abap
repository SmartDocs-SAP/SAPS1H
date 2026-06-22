class /SDOCS/S1_CL_RFQ_CREATION definition
  public
  final
  create public .

public section.

  data MV_URL type STRING .

  methods CREATE_RFQ
    importing
      !LV_JSON_PAYLOAD type STRING
    exporting
      !EV_QUOT_NO type EBELN
      !ES_NO_TOKEN type CHAR50 .
protected section.
private section.

  data MO_HTTP_CLIENT type ref to IF_HTTP_CLIENT .
  data MV_TOKEN type STRING .
  data MV_FINAL_URL type STRING .
  data MO_REST_CLIENT type ref to CL_REST_HTTP_CLIENT .
  data MO_REQUEST type ref to IF_REST_ENTITY .
  data MO_RESPONSE type ref to IF_REST_ENTITY .

  methods GET_CSRF_TOKEN .
ENDCLASS.



CLASS /SDOCS/S1_CL_RFQ_CREATION IMPLEMENTATION.


  method CREATE_RFQ.
*{   INSERT         S4HK903048                                        1
* data:
**       lv_http_body type string,
*      lv_http_status type string,
*      lv_reason type string,
*      lv_response type string.
**Concatenate '{"d": {'
**'"CompanyCode": " ' lv_bukrs ' ", '
**'"PurchasingOrganization": "' lv_ekorg '", '
**'"PurchasingGroup": "' lv_ekgrp '", '
**'"DocumentCurrency": "' lv_waers '", '
**'"PurchasingDocumentType": "' lv_bsart '", '
**'"RequestForQuotationName": "' lv_rfqname '", '
**'"QuotationLatestSubmissionDate": "' lv_qtn_sdate '", '
**'"BindingPeriodValidityEndDate": "' lv_bin_valdate '", '
**'"to_RequestForQuotationItem": { "results": [   { '
**'"PurchaseRequisition": "' lv_pur_req '", '
**'"PurchaseRequisitionItem": "' lv_purreq_item '", '
**'"ScheduleLineDeliveryDate": "' lv_sldeldate '", '
**'"ScheduleLineOrderQuantity": "' lv_slorqty '", '
**'"OrderQuantityUnit": "' lv_ordqty_unit '", '
**'"Plant": "' lv_plant '", '
**'"MaterialGroup": "' lv_matgrp '", '
**'"Material": "' lv_matnr '" '
**'} ] },  '
**'"to_RequestForQuotationBidder": { "results": [ { '
**'"Supplier": "' lv_lifnr '" '
**'} ] } '
**INTO lv_http_body.
*  me->GET_CSRF_TOKEN( ).
*  if MV_TOKEN is not INITIAL.
*   MV_FINAL_URL = |{ MV_URL }/sap/opu/odata/sap/API_RFQ_PROCESS_SRV/A_RequestForQuotation|.
**if mo_http_client is INITIAL.
**   clear mo_http_client.
**   free mo_http_client.
**endif.
**CALL METHOD cl_http_client=>create_by_url
**  EXPORTING
**    url    = MV_FINAL_URL
**  IMPORTING
**    client = mo_http_client
**  EXCEPTIONS
**    OTHERS = 1.
**
**IF sy-subrc <> 0.
**else.
**mo_http_client->request->set_header_field( name = 'Request-URI' value = mv_final_url ).
*
*mo_http_client->request->set_method( if_http_request=>co_request_method_post ).
*mo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).
*mo_http_client->request->set_header_field( name = 'Accept'       value = 'application/json' ).
*mo_http_client->request->set_header_field( name = 'x-csrf-token' value = MV_TOKEN ).
*  mo_http_client->request->set_cdata( lv_json_payload ).
*CREATE OBJECT mo_rest_client
*  EXPORTING io_http_client = mo_http_client.
*
*mo_request = mo_rest_client->if_rest_client~create_request_entity( ).
*
*mo_rest_client->if_rest_resource~post( mo_request ).
*
**--- READ RESPONSE ---
*mo_response = mo_rest_client->if_rest_client~get_response_entity( ).
*lv_http_status = mo_response->get_header_field( '~status_code' ).
*lv_reason      = mo_response->get_header_field( '~status_reason' ).
*lv_response    = mo_response->get_string_data( ).
* ev_quot_no =  lv_response.
*
* else.
*    es_no_token = 'CSRF Token is not generated'.
* endif.
*

  data: lv_http_status type string,
        lv_reason      type string,
        lv_response    type string,
             lv_auth_base64     TYPE string.

  " Step 1: Get CSRF Token
*  me->GET_CSRF_TOKEN( ).

*  if MV_TOKEN is not INITIAL.

    " Step 2: Create new HTTP client for POST
*{   INSERT         S4HK903119                                        2
data : lv_url type string,
       lv_db_table type char50.
    lv_db_table = '/sdocs/sspy_sgc'.
select single config_value into lv_url from (lv_db_table) where config = 'RFQ_CREATE'.
 lv_url = |{ MV_URL }{ lv_url }|.
call method cl_http_client=>create_by_url
      exporting
        url    = lv_url
      importing
        client = mo_http_client
      exceptions
        others = 1.
*}   INSERT
*{   DELETE         S4HK903119                                        1
*\    call method cl_http_client=>create_by_url
*\      exporting
*\        url    = |{ MV_URL }/sap/opu/odata/sap/API_RFQ_PROCESS_SRV/A_RequestForQuotation|
*\      importing
*\        client = mo_http_client
*\      exceptions
*\        others = 1.
*}   DELETE

    if sy-subrc = 0.

      mo_http_client->propertytype_accept_cookie = if_http_client=>co_enabled.
select single config_value from /sdocs/sspy_sgc into @data(lv_user) where config = 'AUTHENTICATE_USER'.
select single config_value from /sdocs/sspy_sgc into @data(lv_PSWD) where config = 'AUTHENTICATE_PSWD'.
mo_http_client->authenticate(
EXPORTING
  username = CONV STRING( lv_user )
  password = CONV STRING( lv_PSWD ) ).


 mo_http_client->request->set_method( if_http_request=>co_request_method_get ).
    mo_http_client->request->set_header_field( name = 'x-csrf-token' value = 'Fetch' ).
*    mo_http_client->request->set_header_field( name = 'Authorization' value = |Basic { lv_auth_base64 }| ).

    try.
      mo_http_client->send( ).
      mo_http_client->receive( ).
    catch cx_root into data(lx_err).
      write: / 'Error fetching CSRF token:', lx_err->get_text( ).
      return.
    endtry.

    MV_TOKEN = mo_http_client->response->get_header_field( 'x-csrf-token' ).

    if MV_TOKEN is not initial.


      " Set headers
      mo_http_client->request->set_method( if_http_request=>co_request_method_post ).
      mo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).
      mo_http_client->request->set_header_field( name = 'Accept' value = 'application/json' ).
      mo_http_client->request->set_header_field( name = 'x-csrf-token' value = MV_TOKEN ).

      " Set payload
      mo_http_client->request->set_cdata( lv_json_payload ).

      " Send request
      try.
        mo_http_client->send( ).
        mo_http_client->receive( ).
      catch cx_root into lx_err.
        write: / 'Error sending RFQ:', lx_err->get_text( ).
        return.
      endtry.

      " Read response
      lv_http_status = mo_http_client->response->get_header_field( '~status_code' ).
      lv_reason      = mo_http_client->response->get_header_field( '~status_reason' ).
      lv_response    = mo_http_client->response->get_cdata( ).

      ev_quot_no = lv_response.

    else.
      write: / 'Error creating HTTP client for POST'.
    endif.

  else.
    write: / 'Error creating HTTP client'.
  endif.




*}   INSERT
  endmethod.


  method GET_CSRF_TOKEN.

*{   INSERT         S4HK903120                                        1
  clear MV_FINAL_URL.
  if mo_http_client is not INITIAL.
    clear mo_http_client.
    free mo_http_client.
  endif.
  MV_FINAL_URL = |{ MV_URL }/sap/opu/odata/sap/API_RFQ_PROCESS_SRV/A_RequestForQuotation|.

*--- STEP 2: CREATE HTTP CLIENT FOR CSRF TOKEN FETCH ---
CALL METHOD cl_http_client=>create_by_url
  EXPORTING
    url    = MV_FINAL_URL
  IMPORTING
    client = mo_http_client
  EXCEPTIONS
    OTHERS = 1.

IF sy-subrc <> 0.
else.
*--- ENABLE COOKIES ---
mo_http_client->propertytype_accept_cookie = if_http_client=>co_enabled.

*--- FETCH CSRF TOKEN ---
mo_http_client->request->set_method( if_http_request=>co_request_method_get ).
mo_http_client->request->set_header_field( name = 'x-csrf-token' value = 'Fetch' ).

TRY.
    mo_http_client->send( ).
    mo_http_client->receive( ).
  CATCH cx_root INTO DATA(lx_err).
    WRITE: / 'Error fetching CSRF token:', lx_err->get_text( ).
    RETURN.
ENDTRY.

MV_TOKEN = mo_http_client->response->get_header_field( 'x-csrf-token' ).
endif.
*}   INSERT
  endmethod.
ENDCLASS.
