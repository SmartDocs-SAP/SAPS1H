FUNCTION /SDOCS/S1_PO_CR_FRM_RFQ_BAPI1.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_DOCID) TYPE  /SDOCS/SSPY_DOCID OPTIONAL
*"     REFERENCE(IV_RFQNO) TYPE  EBELN OPTIONAL
*"  EXPORTING
*"     REFERENCE(EV_SUCCESS) TYPE  CHAR1
*"----------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1

  IF iv_docid IS NOT INITIAL.
    DATA: wa_pohd  TYPE bapimepoheader,
          wa_pohdx TYPE bapimepoheaderx,
          lv_po    TYPE bapimepoheader-po_number,
          lv_item  TYPE ekpo-ebelp,
          lv_msg   type string,
          lv_test.
    types : begin of ty_fin,
            ebeln type ebeln,
            bukrs type BUKRS,
            lifnr type ELIFN,
            ekorg type EKORG,
            ekgrp type BKGRP,
      end of ty_fin.
    data: wa_fin type ty_fin.
  types : begin of ty_ln,
         ebeln type ebeln,
         ebelp type ebelp,
    end of ty_ln.
    data: lt_ln type table of ty_ln.


    DATA: it_return   TYPE TABLE OF bapiret2,
          it_poitems  TYPE TABLE OF bapimepoitem,
          it_err      TYPE TABLE OF /sdocs/s1_er_msg,
          wa_err      TYPE  /sdocs/s1_er_msg,
          wa_poitems  TYPE  bapimepoitem,
          it_poitemsx TYPE TABLE OF bapimepoitemx.
    CLEAR: wa_pohd, lv_po,lv_item,lv_test,wa_err,lv_msg.
    REFRESH: it_return[], it_poitems[],it_poitemsx,it_err.
    lv_db_table = '/sdocs/s1_buy_ln'.
    SELECT  ebeln,ebelp FROM (lv_db_table) INTO TABLE @lt_ln WHERE docid = @iv_docid AND ebeln = @IV_RFQNO.
    IF sy-subrc = 0.
      SORT lt_ln BY ebeln ebelp.
      DATA(wa_ln) = VALUE #( lt_ln[ 1 ] OPTIONAL ).
      SELECT SINGLE   PurchaseOrder,
                      CompanyCode,
                       Supplier,
                        PurchasingOrganization,
                       PurchasingGroup INTO @wa_fin FROM I_PurchaseOrderAPI01 WHERE PurchaseOrder = @IV_RFQNO.
    ENDIF.
    lv_db_table = '/sdocs/s1_er_msg'.
   delete from (lv_db_table) where docid = iv_docid.
    wa_pohd-vendor = wa_fin-lifnr.
    wa_pohd-purch_org = wa_fin-ekorg.
    wa_pohd-pur_group = wa_fin-ekgrp.
    wa_pohd-comp_code = wa_fin-bukrs.
    wa_pohd-doc_type = 'NB'.

    wa_pohdx-vendor = 'X'.
    wa_pohdx-purch_org = 'X'.
    wa_pohdx-pur_group = 'X'.
    wa_pohdx-comp_code = 'X'.
    wa_pohdx-doc_type = 'X'.

    LOOP AT lt_ln INTO wa_ln.
      lv_item = ( sy-tabix * 10 ).
      it_poitems = VALUE #( BASE it_poitems ( po_item = lv_item rfq_no = wa_ln-ebeln rfq_item =  wa_ln-ebelp ) ).
      it_poitemsx = VALUE #( base it_poitemsx ( po_item = lv_item  rfq_no = 'X' rfq_item =  'X' ) ).
    ENDLOOP.
    CALL FUNCTION 'BAPI_PO_CREATE1'
      EXPORTING
        poheader         = wa_pohd
        poheaderx        = wa_pohdx
        testrun          = lv_test
      IMPORTING
        exppurchaseorder = lv_po
      TABLES
        return           = it_return
        poitem           = it_poitems
        poitemx          = it_poitemsx.


    IF lv_po IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      DATA(l_award) = iv_docid.
      SHIFT l_award LEFT DELETING LEADING '0'.
      lv_db_table = '/sdocs/s1_buy_hd'.
      UPDATE (lv_db_table) SET rfq_no = lv_po  psuccess = 'X' WHERE docid  = iv_docid.
      ev_success  = 'X'.
*      ev_ebeln = wa_mess-msgv2.
    ELSE.
      LOOP AT it_return INTO DATA(wa_mess).
        wa_err-counter = sy-tabix.
        wa_err-docid = iv_docid.
*        CALL FUNCTION 'FORMAT_MESSAGE'
*          EXPORTING
*            id        = wa_mess-number
*            lang      = sy-langu
*            no        = wa_mess-number
*            v1        = wa_mess-message_v1
*            v2        = wa_mess-message_v2
*            v3        = wa_mess-message_v3
*            v4        = wa_mess-message_v4
*          IMPORTING
*            msg       = lv_message
*          EXCEPTIONS
*            not_found = 1
*            OTHERS    = 2.
         MESSAGE ID wa_mess-number
          TYPE wa_mess-type
          NUMBER wa_mess-number
          WITH wa_mess-message_v1 wa_mess-message_v2 wa_mess-message_v3 wa_mess-message_v4
          INTO lv_message.
        wa_err-msg_txt = lv_message.
        wa_err-msg_typ = wa_mess-type.

        CONCATENATE lv_message lv_msg INTO lv_msg SEPARATED BY space .
        APPEND wa_err TO it_err.
        CLEAR :wa_err,lv_message,wa_mess.

      ENDLOOP.
      IF lv_msg IS NOT INITIAL.
        MESSAGE lv_msg TYPE 'I'.
      ENDIF.
      lv_db_table = '/sdocs/s1_er_msg'.
      MODIFY (lv_db_table) FROM TABLE it_err.
      COMMIT WORK AND WAIT.
      REFRESH it_err.
    ENDIF.
  ENDIF.
  REFRESH:lt_ln,it_err.
  CLEAR:lv_item,wa_ln,lv_test,lv_msg,lv_message.
*}   INSERT
ENDFUNCTION.
