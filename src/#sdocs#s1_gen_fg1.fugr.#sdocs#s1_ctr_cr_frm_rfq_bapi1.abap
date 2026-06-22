FUNCTION /SDOCS/S1_CTR_CR_FRM_RFQ_BAPI1.
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
    DATA: wa_pohd     TYPE BAPIMEOUTHEADER,
          wa_pohdx    TYPE BAPIMEOUTHEADERX,
          lv_contract TYPE bapimeoutheader-number,
          lv_item     TYPE ekpo-ebelp,
          lv_msg      TYPE string,
          lv_test.
    DATA: it_return   TYPE TABLE OF bapiret2,
          it_poitems  TYPE TABLE OF BAPIMEOUTITEM,
          it_err      TYPE TABLE OF /sdocs/s1_er_msg,
          wa_err      TYPE  /sdocs/s1_er_msg,
          wa_poitems  TYPE  bapimepoitem,
          it_poitemsx TYPE TABLE OF BAPIMEOUTITEMx.
    types : begin of ty_ln,
      ebeln type ebeln,
      ebelp type ebelp,
     end of ty_ln.
     data : lt_ln type table of ty_ln.
    CLEAR: wa_pohd, lv_contract,lv_item,lv_test,wa_err,lv_msg.
    REFRESH: it_return[], it_poitems[],it_poitemsx,it_err.
    lv_db_table = '/sdocs/s1_buy_LN'.
    SELECT  ebeln,ebelp FROM (lv_db_table) INTO TABLE @lt_ln WHERE docid = @iv_docid AND ebeln = @IV_RFQNO.
    IF sy-subrc = 0.
      SORT lt_ln BY ebeln ebelp.
      DATA(wa_ln) = VALUE #( lt_ln[ 1 ] OPTIONAL ).
      SELECT SINGLE PurchaseOrder,Companycode,CreationDate,Supplier,PurchasingOrganization,Purchasinggroup INTO @data(wa_fin) FROM I_PurchaseOrderAPI01 WHERE PurchaseOrder = @IV_RFQNO.
      select    ScheduleLineDeliveryDate from I_PurOrdScheduleLineAPI01 into @data(lv_enddate) where PurchaseOrder = @IV_RFQNO  ORDER BY ScheduleLineDeliveryDate DESCENDING.
        if lv_enddate is not INITIAL.
        exit.
        endif.
      ENDSELECT.
    ENDIF.
  lv_db_table = '/sdocs/s1_er_msg'.
    DELETE FROM (lv_db_table) WHERE docid = iv_docid.
    wa_pohd-vendor = wa_fin-Supplier.
    wa_pohd-purch_org = wa_fin-PurchasingOrganization.
    wa_pohd-pur_group = wa_fin-Purchasinggroup.
    wa_pohd-comp_code = wa_fin-Companycode.
    wa_pohd-doc_type = 'MK'.
    wa_pohd-vper_start = wa_fin-CreationDate.
    wa_pohd-vper_end =  lv_enddate.

    wa_pohdx-vendor = 'X'.
    wa_pohdx-purch_org = 'X'.
    wa_pohdx-pur_group = 'X'.
    wa_pohdx-comp_code = 'X'.
    wa_pohdx-doc_type = 'X'.
    wa_pohdx-vper_start = 'X'.
    wa_pohdx-vper_end =  'X'.


    LOOP AT lt_ln INTO wa_ln.
      lv_item = ( sy-tabix * 10 ).
      it_poitems = VALUE #( BASE it_poitems ( ITEM_NO = lv_item rfq_no = wa_ln-ebeln rfq_item =  wa_ln-ebelp ) ).
      it_poitemsx = VALUE #( BASE it_poitemsx ( ITEM_NO = lv_item  rfq_no = 'X' rfq_item =  'X' ) ).
    ENDLOOP.
    CALL FUNCTION 'BAPI_CONTRACT_CREATE'
      EXPORTING
        header             = wa_pohd
        headerx            = wa_pohdx
        testrun            = LV_TEST
      IMPORTING
        purchasingdocument = lv_contract
      TABLES
        return             = it_return
        item               = it_poitems
        itemx              = it_poitemsx.



    IF lv_contract IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      DATA(l_award) = iv_docid.
      SHIFT l_award LEFT DELETING LEADING '0'.
      lv_db_table = '/sdocs/s1_buy_hd'.
      UPDATE (lv_db_table) SET contract = lv_contract  psuccess = 'X' WHERE docid  = iv_docid.
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
        MESSAGE ID wa_mess-id
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
  CLEAR:lv_item,wa_ln,lv_test,lv_msg,lv_message,lv_contract.
*}   INSERT
ENDFUNCTION.
