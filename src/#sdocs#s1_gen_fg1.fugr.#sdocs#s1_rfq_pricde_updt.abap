FUNCTION /SDOCS/S1_RFQ_PRICDE_UPDT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(P_SPLR) TYPE  LIFNR
*"     REFERENCE(P_RFQ) TYPE  EBELN
*"     REFERENCE(LV_DATE_STR) TYPE  SY-DATUM
*"  EXPORTING
*"     REFERENCE(LV_RESPONSE) TYPE  INT4
*"----------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
TYPES: BEGIN OF ty_lfa1,
         lifnr TYPE lifnr,
       END OF ty_lfa1.

*--- INTERNAL TABLE FOR F4 HELP ---
DATA: lt_lfa1 TYPE TABLE OF ty_lfa1.
DATA: lv_status_code TYPE i,
      lv_status_text TYPE string.
*      lv_response    TYPE string.
*--- PARAMETERS ---
*PARAMETERS: p_date TYPE sy-datum,
*            p_rfq  TYPE ebeln,
*            p_splr type string,
*            p_ebelp type ebelp,
*             p_netamt  TYPE string OBLIGATORY, " Net Amount
*            p_total   TYPE string OBLIGATORY, " Net Price Amount
*            p_nqty    TYPE string OBLIGATORY. " Net Price Quantity
**--- F4 Help for Supplier ---
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_splr.
*  PERFORM f4_supplier_help.

*--- VARIABLES ---
DATA: lo_http_client TYPE REF TO if_http_client,
      lo_rest_client TYPE REF TO cl_rest_http_client,
      lo_request     TYPE REF TO if_rest_entity,
      lo_response    TYPE REF TO if_rest_entity,
      lv_url_post    TYPE string,
*      lv_date_str    TYPE string,
      lv_csrf_token  TYPE string,
      http_status    TYPE string,
      reason         TYPE string,
      response       TYPE string,
      lv_url         TYPE string,
      lv_payload     TYPE string,
      lv_qty_str    TYPE string,
      lv_amount_str TYPE string,
      lv_price_str  TYPE string,
      lv_nqty_str   TYPE string,
      lv_auth_base64 type string.

*--- FORMAT DATE (YYYY-MM-DD) ---
*lv_date_str = |{ p_date+0(4) }-{ p_date+4(2) }-{ p_date+6(2) }T00:00|.
data(lv_date_str1) = |{ lv_date_str date = ISO }T00:00|.
*{   INSERT         S4HK903118                                        2
data : lv_db_table type char50.
lv_db_table = '/sdocs/sspy_sgc'.
    select single config_value from (lv_db_table) into lv_url_post where config = 'SUPPLIER_QTN_CREATE'.
      Replace '{ lv_date_str1 }' in lv_url_post with lv_date_str1.
      Replace '{ p_splr }' in lv_url_post with p_splr .
      Replace '{ p_rfq }' in lv_url_post with p_rfq .
*}   INSERT
*--- STEP 1: SET POST URL ---
*{   DELETE         S4HK903118                                        1
*\lv_url_post = |https://VHCALS4HCS.DUMMY.NODOMAIN:443/sap/opu/odata/sap/API_QTN_PROCESS_SRV/CreateFromRFQ?QuotationSubmissionDate=datetime'{ lv_date_str1 }'&Supplier='{ p_splr }'&RequestForQuotation='{ p_rfq }'|.
*}   DELETE

*--- STEP 2: CREATE HTTP CLIENT FOR CSRF TOKEN FETCH ---
CALL METHOD cl_http_client=>create_by_url
  EXPORTING
    url    = lv_url_post
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

*CALL METHOD cl_http_utility=>encode_base64
*  EXPORTING
*    unencoded = |ramakrishna:Rk@282000| " Correct parameter and value
*  RECEIVING
*    encoded   = lv_auth_base64.
select single config_value from /sdocs/sspy_sgc into @data(lv_user) where config = 'AUTHENTICATE_USER'.
select single config_value from /sdocs/sspy_sgc into @data(lv_PSWD) where config = 'AUTHENTICATE_PSWD'.
lo_http_client->authenticate(
EXPORTING
  username = CONV STRING( lv_user )
  password = CONV STRING( lv_PSWD )
).

*--- FETCH CSRF TOKEN ---
lo_http_client->request->set_method( if_http_request=>co_request_method_get ).
lo_http_client->request->set_header_field( name = 'x-csrf-token' value = 'Fetch' ).
* lo_http_client->request->set_header_field( name = 'Authorization' value = |Basic cmFtYWtyaXNobmE6UmtAMjgyMDAw| ).

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

*--- STEP 3: EXECUTE POST REQUEST ---
lo_http_client->request->set_method( if_http_request=>co_request_method_post ).
lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).
lo_http_client->request->set_header_field( name = 'Accept'       value = 'application/json' ).
lo_http_client->request->set_header_field( name = 'x-csrf-token' value = lv_csrf_token ).

CREATE OBJECT lo_rest_client
  EXPORTING io_http_client = lo_http_client.

lo_request = lo_rest_client->if_rest_client~create_request_entity( ).

lo_rest_client->if_rest_resource~post( lo_request ).

*--- READ RESPONSE ---
lo_response = lo_rest_client->if_rest_client~get_response_entity( ).
http_status = lo_response->get_header_field( '~status_code' ).
reason      = lo_response->get_header_field( '~status_reason' ).
response    = lo_response->get_string_data( ).

*--- OUTPUT ---
lv_response = http_status.

*if http_status = 200.
*  wait up to 2 SECONDS.
*
*
*endif.
*}   INSERT





ENDFUNCTION.
