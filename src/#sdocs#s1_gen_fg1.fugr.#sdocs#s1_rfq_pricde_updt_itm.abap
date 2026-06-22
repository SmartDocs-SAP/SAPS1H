FUNCTION /SDOCS/S1_RFQ_PRICDE_UPDT_ITM.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(P_QTN) TYPE  EBELN
*"     REFERENCE(P_ITEM) TYPE  EBELP
*"     REFERENCE(P_NETWR) TYPE  NETPR
*"     REFERENCE(P_QUAN) TYPE  BAMNG
*"     REFERENCE(P_RFQ) TYPE  EBELN
*"     REFERENCE(P_RFQ_ITM) TYPE  EBELP
*"  EXPORTING
*"     REFERENCE(LV_RESPONSE) TYPE  INT4
*"----------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
DATA: lv_status_code TYPE int4,
      lv_status_text TYPE string.
*      lv_response    TYPE string.

*---------------------------------------------------------------------*
* PARAMETERS
*---------------------------------------------------------------------*
*PARAMETERS: p_qtn   TYPE string OBLIGATORY, " SupplierQuotation
*            p_item  TYPE string OBLIGATORY, " SupplierQuotationItem
*            p_eindt TYPE sy-datum OBLIGATORY, " EINDT
*            p_netwr TYPE netwr OBLIGATORY.    " NETWR

*---------------------------------------------------------------------*
* DATA DECLARATIONS
*---------------------------------------------------------------------*
DATA: lo_http_client TYPE REF TO if_http_client,
      lv_url         TYPE string,
      lv_csrf_token  TYPE string,
      lv_payload     TYPE string,
*      lv_date_str    TYPE string,
      http_status    TYPE i,
      reason         TYPE string,
      response       TYPE string,
      lv_auth_base64 type string,
      LV_NETPR       TYPE STRING,
      LV_QTY         TYPE STRING.

*---------------------------------------------------------------------*
* FORMAT DATE FOR ODATA (YYYY-MM-DDT00:00:00)
*---------------------------------------------------------------------*
*lv_date_str = |{ p_eindt+0(4) }-{ p_eindt+4(2) }-{ p_eindt+6(2) }T00:00:00|.
*data(lv_date_str1) = |{ lv_date_str date = ISO }T00:00|.
LV_NETPR  = p_netwr.
LV_QTY = CONV i( p_quan ).
CONDENSE: LV_NETPR,LV_QTY.
CONCATENATE
  '{"d": {'
*  '"NetAmount":"'            p_netwr   '",'
  '"NetPriceAmount":"'     LV_NETPR     '",'
  '"NetPriceQuantity":"'     LV_QTY      '",'
  '"RequestForQuotation":"'  p_rfq  '",'
  '"RequestForQuotationItem":"'  p_rfq_itm  '"' " FIX: Using p_item here for consistency with URL
  '}}'
  INTO lv_payload.


*---------------------------------------------------------------------*
* BUILD API URL
*{   INSERT         S4HK903118                                        2
data : lv_db_table type char50.
lv_db_table = '/sdocs/sspy_sgc'.
select single config_value from (lv_db_table) into lv_url where config = 'SPLR_QTN_LN_UPD'.
 replace '{ p_qtn }' in lv_url with p_qtn.
 replace '{ p_item }' in lv_url with p_item.
*}   INSERT
*---------------------------------------------------------------------*
*{   DELETE         S4HK903118                                        1
*\lv_url = |https://VHCALS4HCS.DUMMY.NODOMAIN:443/sap/opu/odata/sap/API_QTN_PROCESS_SRV/A_SupplierQuotationItem(SupplierQuotation='{ p_qtn }',SupplierQuotationItem='{ p_item }')|.
*}   DELETE

*---------------------------------------------------------------------*
* CREATE HTTP CLIENT
*---------------------------------------------------------------------*
CALL METHOD cl_http_client=>create_by_url
  EXPORTING
    url    = lv_url
  IMPORTING
    client = lo_http_client
  EXCEPTIONS
    OTHERS = 1.


IF sy-subrc <> 0 OR lo_http_client IS INITIAL.
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

* Fetch CSRF token
lo_http_client->request->set_method( if_http_request=>co_request_method_get ).
lo_http_client->request->set_header_field( name = 'x-csrf-token' value = 'Fetch' ).

TRY.
    lo_http_client->send( ).
    lo_http_client->receive( ).

  CATCH cx_root INTO DATA(lx_err_csrf).
    WRITE: / 'Error fetching CSRF token:', lx_err_csrf->get_text( ).
    RETURN.
ENDTRY.
    lv_csrf_token = lo_http_client->response->get_header_field( 'x-csrf-token' ).
IF lv_csrf_token IS INITIAL.
  WRITE: / 'Failed to fetch CSRF token.'.
  RETURN.
ENDIF.

* Set PATCH method and headers
lo_http_client->request->set_method( 'PATCH' ).
lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).
lo_http_client->request->set_header_field( name = 'Accept'       value = 'application/json' ).
lo_http_client->request->set_header_field( name = 'x-csrf-token' value = lv_csrf_token ).

* Set payload
lo_http_client->request->set_cdata( lv_payload ).

* Send PATCH request
TRY.
    lo_http_client->send( ).
    lo_http_client->receive( ).

    CALL METHOD lo_http_client->response->get_status
      IMPORTING
        code   = lv_status_code
        reason = lv_status_text.

*    lv_response = conv int4( lo_http_client->response->get_cdata( ) ).
DATA(lv_string) = lo_http_client->response->get_cdata( ).
DATA(lv_response1) = CONV int4( lv_string ).
*
*    WRITE: / 'HTTP Status:', lv_status_code,
*           / 'Reason:', lv_status_text,
*           / 'Response:', lv_response,
*           / 'Payload Sent:', lv_payload.
lv_response = lv_status_code.
  CATCH cx_root INTO DATA(lx_err_patch). " FIX: Unique error variable name
*    WRITE: / 'Error during PATCH request:', lx_err_patch->get_text( ).
    lv_response = lv_status_code.
ENDTRY.
*LV_RESPONSE = HTTP_STATUS.
*}   INSERT





ENDFUNCTION.
