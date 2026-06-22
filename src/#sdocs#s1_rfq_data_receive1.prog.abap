*&---------------------------------------------------------------------*
*& Report /SDOCS/S1_RFQ_DATA_RECEIVE1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /sdocs/s1_rfq_data_receive1.

*{   INSERT         S4HK903047                                        1


INCLUDE /sdocs/sspay_incl_recdata.
TYPES:BEGIN OF ty_hrfq,
        id(255)              TYPE c,
        title(255)           TYPE c,
        company_code(255)    TYPE c,
        rfx_no(255)          TYPE c,
        type(255)            TYPE c,
        visibility(255)      TYPE c,
        purchasing_org(255)  TYPE c,
        purchasing_grp(255)  TYPE c,
        requestor(255)       TYPE c,
        buyer(255)           TYPE c,
        sub_strt_date(255)   TYPE c,
        sub_end_date(255)    TYPE c,
        q_and_a_deadlin(255) TYPE c,
        pub_date(255)        TYPE c,
        status(255)          TYPE c,
        created_by(255)      TYPE c,
        created_date(255)    TYPE c,
      END OF ty_hrfq.

TYPES:BEGIN OF ty_lrfq,
        line_no(255)      TYPE c,
        item_no(255)      TYPE c,
        item_name(255)    TYPE c,
        uom(255)          TYPE c,
        del_date(255)     TYPE c,
        qty(255)          TYPE c,
        mater_grp(255)    TYPE c,
        itm_cat(255)      TYPE c,
        plnt(255)         TYPE c,
        stor_loc(255)     TYPE c,
        suplir_id(255)    TYPE c,
        gl_acnt(255)      TYPE c,
        unt_prc(255)      TYPE c,
        cur(255)          TYPE c,
        per(255)          TYPE c,
        tot_prc(255)      TYPE c,
        acc_ass_cat(255)  TYPE c,
        cost_cnt(255)     TYPE c,
        categy(255)       TYPE c,
        sup_unit_pri(255) TYPE c,
        rfx_no(255)       TYPE c,
        mat_code(255)     TYPE c,
      END OF ty_lrfq.

TYPES:BEGIN OF ty_attach,
        ref_id(255)          TYPE c,
        ar_id(255)           TYPE c,
        ar_docid(255)        TYPE c,
        fl_name(255)         TYPE c,
        fl_type(255)         TYPE c,
        attid(255)           TYPE c,
        document_no(255)     TYPE c,
        doc_expiry_date(255) TYPE c,
        doc_expiry_time(255) TYPE c,
        created_date(255)    TYPE c,
        created_time(255)    TYPE c,
        creator(255)         TYPE c,
        doc_type(255)        TYPE c,
        upload(255)          TYPE c,
        rfx_no(255)          TYPE c,
      END OF ty_attach.

TYPES:BEGIN OF ty_bid,
        suppir_id(255) TYPE c,
        rfx_no(255)    TYPE c,
      END OF ty_bid.
   data :    ls_buy_hd type /sdocs/s1_buy_hd.

TYPES:BEGIN OF ty_cnt,
        eml(255) TYPE c,
      END OF ty_cnt.

TYPES:BEGIN OF ty_rdt,
        docmnt_nam(255)  TYPE c,
        max_siz(255)     TYPE c,
        max_siz_unt(255) TYPE c,
        mandtry(255)     TYPE c,
        rfx_no(255)      TYPE c,
      END OF ty_rdt.

TYPES:BEGIN OF ty_ffmts,
        fil_formt(255) TYPE c,
      END OF ty_ffmts.

TYPES:BEGIN OF ty_rqnf,
        rfx_no(255)  TYPE c,
        ques(255)    TYPE c,
        mandtry(255) TYPE c,
      END OF ty_rqnf.

TYPES:BEGIN OF ty_hdata,
        rfxno(255)        TYPE c,
        selected_bid(255) TYPE c,
      END OF ty_hdata.

TYPES:BEGIN OF ty_lhdata,
        rfxno(255)            TYPE c,
        ref_id(255)           TYPE c,
        bid_no(255)           TYPE c,
        bid_company(255)      TYPE c,
        bid_cntct_person(255) TYPE c,
        bid_cntct_email(255)  TYPE c,
        total_amount(255)     TYPE c,
      END OF ty_lhdata.

TYPES:BEGIN OF ty_ldata,
        ref_id(255)            TYPE c,
        lineno(255)            TYPE c,
        prdct_id(255)          TYPE c,
        prdct_des(255)         TYPE c,
        prdct_cat(255)         TYPE c,
        qty(255)               TYPE c,
        uom(255)               TYPE c,
        del_date(255)          TYPE c,
        substitute_prt_no(255) TYPE c,
        submitted_qty(255)     TYPE c,
        unit_price(255)        TYPE c,
      END OF ty_ldata.

TYPES: BEGIN OF ls_att,
         ref_id(50)           TYPE c,
         ar_id(2)             TYPE c,
         ar_docid(40)         TYPE c,
         fl_name(255)         TYPE c,
         fl_type(255)         TYPE c,
         attid(20)            TYPE c,
         doc_type(255)        TYPE c,
         doc_expiry_date(255) TYPE c,
         doc_expiry_time(255) TYPE c,
         creator(255)         TYPE c,
         created_date(255)    TYPE c,
         created_time(255)    TYPE c,
       END OF ls_att.
DATA:gt_phd      TYPE TABLE OF ty_hrfq,
     gt_hd       TYPE TABLE OF /sdocs/s1_buy_hd,
     gt_ln       TYPE TABLE OF /sdocs/s1_buy_ln,
     gt_att      TYPE STANDARD TABLE OF /sdocs/sspy_atta,
     gt_bvndr    TYPE STANDARD TABLE OF /sdocs/s1_bvndr,
     gt_attach   TYPE TABLE OF ty_attach,
     gt_pln      TYPE TABLE OF ty_lrfq,
     gt_bid      TYPE STANDARD TABLE OF ty_bid,
     gt_cnt      TYPE TABLE OF ty_cnt,
     gt_rdt      TYPE TABLE OF ty_rdt,
     gt_ffmts    TYPE TABLE OF ty_ffmts,
     gt_rqnf     TYPE TABLE OF ty_rqnf,
     gt_return   TYPE TABLE OF bapiret2,
     gt_rwfusr   TYPE TABLE OF /sdocs/s1_rwfusr,
     gt_hdata    TYPE TABLE OF ty_hdata,
     gt_lhdata   TYPE TABLE OF ty_lhdata,
     wa_lhdata   TYPE    ty_lhdata,
     gt_ldata    TYPE TABLE OF ty_ldata,
     wa_rwfusr   TYPE /sdocs/s1_rwfusr,
     gt_ract     TYPE TABLE OF /sdocs/sspy_ract,
     lt_att      TYPE TABLE OF ls_att,
     wa_ract     TYPE /sdocs/sspy_ract,
     wa_addr     TYPE bapiaddr3,
     wa_rdt      TYPE ty_rdt,
     wa_ffmts    TYPE ty_ffmts,
     wa_hdata    TYPE ty_hdata,
     wa_rqnf     TYPE ty_rqnf,
     wa_hd       TYPE /sdocs/s1_buy_hd,
     wa_ln       TYPE /sdocs/s1_buy_ln,
     wa_att      TYPE /sdocs/sspy_atta,
     wa_bvndr    TYPE /sdocs/s1_bvndr,
     wa_bid      TYPE ty_bid,
     wa_cnt      TYPE ty_cnt,
     wa_phd      TYPE ty_hrfq,
     lv_db_table TYPE char50.
DATA:l_usr        TYPE bapibname-bapibname,
     gv_rfq_agent TYPE /sdocs/sspy_sgc-config_value.
**for f4 help to path
DATA: it_file TYPE STANDARD TABLE OF file_table INITIAL SIZE 1,
      lv_rc   TYPE i.
TYPES : BEGIN OF ty_file,
          line(3000) TYPE c,
        END OF ty_file.

DATA : it_tab TYPE STANDARD TABLE OF ty_file INITIAL SIZE 1.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:p_profle TYPE /sdocs/sspy_sprf-profile_id OBLIGATORY,
             p_tk_ext TYPE /sdocs/sspy_http_ext DEFAULT '',
             p_ext    TYPE /sdocs/sspy_http_ext DEFAULT '',
             p_ac_ext TYPE /sdocs/sspy_http_ext DEFAULT '',
             p_bsize  TYPE int4 DEFAULT 5,
             p_retry  TYPE int4 DEFAULT 1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-t01.
  SELECTION-SCREEN : BEGIN OF LINE .
    PARAMETERS p_chk AS CHECKBOX.
    SELECTION-SCREEN : COMMENT 3(20) TEXT-p01 FOR FIELD p_chk.
  SELECTION-SCREEN : END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.

INITIALIZATION.
  CLEAR:wa_hd,wa_ln,gv_rfq_agent.
  REFRESH:gt_hd,gt_ln,gs_ack[],it_file.

AT SELECTION-SCREEN OUTPUT." p_profle .
  p_profle = sy-sysid.
  LOOP AT SCREEN.
    IF screen-name = 'P_PROFLE'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.



START-OF-SELECTION.
  CLEAR: gv_prog_locked.
  CALL FUNCTION '/SDOCS/SSPAY_LOCK_PROGRAM_N'
    EXPORTING
      i_prog_name   = sy-repid
    IMPORTING
      e_prog_locked = gv_prog_locked.

  IF  gv_prog_locked  IS NOT INITIAL.
    WRITE:/1 gv_run_ins_msg, 50 sy-datum ,65  sy-uzeit.
    MESSAGE s005(/sdocs/sspay_msg).
    EXIT.
  ENDIF.

  CLEAR gv_enable_token.
  SELECT SINGLE config_value INTO gv_enable_token FROM /sdocs/sspy_sgc WHERE config = 'HTTP_TOKEN_ENABLE'.
  IF gv_enable_token IS NOT INITIAL.
    PERFORM portal_authitication.
    IF gv_token IS NOT INITIAL AND ( gv_scode = '200' OR gv_scode = '201' ).
      PERFORM get_data.
    ELSE.
      MESSAGE s006(/sdocs/sspy_msg) WITH 'Please check the Profile Setup'.
    ENDIF.
  ELSE.
    PERFORM get_data.
  ENDIF.
  PERFORM unlock_run_instance.
  WRITE:/ ''.
  WRITE:/ ''.
  WRITE:/ 'Program completed successfully'.
*&---------------------------------------------------------------------*
*&      Form  PORTAL_AUTHITICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM portal_authitication .
  SELECT SINGLE * FROM /sdocs/sspy_sprf INTO wa_profile WHERE profile_id = p_profle.
  IF p_profle IS NOT INITIAL.
    DO p_retry TIMES.
      CALL FUNCTION '/SDOCS/SSPAY_HTTP_GET_N'
        EXPORTING
          i_profile            = p_profle
          i_ext                = p_tk_ext
          i_input_xml          = ''
          i_token_flg          = 'X'
          i_input_method       = 'GET'
        IMPORTING
          e_success            = gv_success
          e_result             = gv_res_str
          e_scode              = gv_scode
          e_stext              = gv_stext
        CHANGING
          c_token_id           = gv_token
        EXCEPTIONS
          ex_internal_error    = 1
          ex_connection_failed = 2
          OTHERS               = 3.
      IF gv_token IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDDO.

    IF gv_token IS INITIAL.
      MESSAGE s006(/sdocs/sspay_msg) WITH gv_res_str.
      WRITE:/ gv_res_str.
      EXIT.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RECEIVE_PORTAL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM receive_portal_data .

  PERFORM update USING gv_token.
  CASE gv_scode.
    WHEN '200'.
      MESSAGE s006(/sdocs/sspay_msg) WITH 'Data Received Successfully!' gv_scode gv_stext.
    WHEN OTHERS.
      MESSAGE e006(/sdocs/sspay_msg) WITH gv_scode '-' gv_stext.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_TOKEN  text
*----------------------------------------------------------------------*
FORM update  USING    p_gv_token.
  CLEAR gv_xml_str.
  IF gv_token IS INITIAL.
    gv_token = 'notoken'.
  ENDIF.

  CALL FUNCTION '/SDOCS/SSPAY_HTTP_GET_N'
    EXPORTING
      i_profile            = p_profle
      i_ext                = p_ext
      i_input_xml          = ''
      i_token_flg          = ''
      i_input_method       = 'GET'
    IMPORTING
      e_success            = gv_success
      e_result             = gv_res_str
      e_scode              = gv_scode
      e_stext              = gv_stext
    CHANGING
      c_token_id           = gv_token
    EXCEPTIONS
      ex_internal_error    = 1
      ex_connection_failed = 2
      OTHERS               = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*  wa_result_xml-name = 'HEADER'.
*  GET REFERENCE OF gt_phd INTO wa_result_xml-value.
*  APPEND wa_result_xml TO gt_result_xml.
*  CLEAR wa_result_xml.
*
*  wa_result_xml-name = 'LINEITEMS'.
*  GET REFERENCE OF gt_pln INTO wa_result_xml-value.
*  APPEND wa_result_xml TO gt_result_xml.
*  CLEAR wa_result_xml.
*
*  wa_result_xml-name = 'SUPPORTING_DOCS'.
*  GET REFERENCE OF gt_attach INTO wa_result_xml-value.
*  APPEND wa_result_xml TO gt_result_xml.
*  CLEAR wa_result_xml.
*
*  wa_result_xml-name = 'BIDDERS'.
*  GET REFERENCE OF gt_bid INTO wa_result_xml-value.
*  APPEND wa_result_xml TO gt_result_xml.
*  CLEAR wa_result_xml.
*
*  wa_result_xml-name = 'CONTCT_PERSONS'.
*  GET REFERENCE OF gt_cnt INTO wa_result_xml-value.
*  APPEND wa_result_xml TO gt_result_xml.
*  CLEAR wa_result_xml.
*
*  wa_result_xml-name = 'REQ_DOC_TYPES'.
*  GET REFERENCE OF gt_rdt INTO wa_result_xml-value.
*  APPEND wa_result_xml TO gt_result_xml.
*  CLEAR wa_result_xml.
*
*  wa_result_xml-name = 'FIL_FORMTS'.
*  GET REFERENCE OF gt_ffmts INTO wa_result_xml-value.
*  APPEND wa_result_xml TO gt_result_xml.
*  CLEAR wa_result_xml.
*
*  wa_result_xml-name = 'REQUIRD_INFO'.
*  GET REFERENCE OF gt_rqnf INTO wa_result_xml-value.
*  APPEND wa_result_xml TO gt_result_xml.
*  CLEAR wa_result_xml.


  CLEAR gv_xml_str.
  IF gv_token IS INITIAL.
    gv_token = 'notoken'.
  ENDIF.

  CALL FUNCTION '/SDOCS/SSPAY_HTTP_GET_N'
    EXPORTING
      i_profile            = p_profle
      i_ext                = p_ext
      i_input_xml          = ''
      i_token_flg          = ''
      i_input_method       = 'GET'
    IMPORTING
      e_success            = gv_success
      e_result             = gv_res_str
      e_scode              = gv_scode
      e_stext              = gv_stext
    CHANGING
      c_token_id           = gv_token
    EXCEPTIONS
      ex_internal_error    = 1
      ex_connection_failed = 2
      OTHERS               = 3.


  wa_result_xml-name = 'RFX_BID'.
  GET REFERENCE OF gt_hdata INTO wa_result_xml-value.
  APPEND wa_result_xml TO gt_result_xml.
  CLEAR wa_result_xml.

  wa_result_xml-name = 'BIDDERS'.
  GET REFERENCE OF gt_lhdata INTO wa_result_xml-value.
  APPEND wa_result_xml TO gt_result_xml.
  CLEAR wa_result_xml.

  wa_result_xml-name = 'LINEITEMS'.
  GET REFERENCE OF gt_ldata INTO wa_result_xml-value.
  APPEND wa_result_xml TO gt_result_xml.
  CLEAR wa_result_xml.

  wa_result_xml-name = 'ATTCHMNTS'.
  GET REFERENCE OF lt_att INTO wa_result_xml-value.
  APPEND wa_result_xml TO gt_result_xml.
  CLEAR wa_result_xml.

  TRY.
      CALL TRANSFORMATION /sdocs/s1_rfq_rvc_trfmn_N
        SOURCE XML gv_res_str
        RESULT (gt_result_xml).
    CATCH cx_root INTO gs_ex.
      gv_var_text = gs_ex->get_text( ).
      MESSAGE gv_var_text TYPE 'E'.
  ENDTRY.
  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_rfq_agent WHERE config = 'EXCP_AGENT_RFQ'.

  LOOP AT gt_lhdata INTO wa_lhdata.
    PERFORM get_rfx_header_data.
    PERFORM get_rfx_item_data.
    PERFORM rfq_attachment.
    MOVE: wa_lhdata-ref_id TO gs_ack-ref_id.
    APPEND gs_ack.

    IF wa_hd IS NOT INITIAL.
      lv_db_table = '/sdocs/s1_buy_hd'.
      MODIFY (lv_db_table) FROM wa_hd.
*      ls_buy_hd = CORRESPONDING #( wa_hd ).
*      Modify (lv_db_table) from ls_buy_hd.
   ENDIF.

    IF gt_ln IS NOT INITIAL.
       lv_db_table = '/sdocs/s1_buy_ln'.
      MODIFY (lv_db_table) FROM TABLE gt_ln.
    ENDIF.
    IF gt_att IS NOT INITIAL.
       lv_db_table = '/sdocs/sspy_atta'.
      MODIFY (lv_db_table) FROM TABLE gt_att.
    ENDIF.
    IF NOT gt_bvndr IS INITIAL .
       lv_db_table = '/sdocs/s1_bvndr'.
      MODIFY (lv_db_table) FROM TABLE gt_bvndr.
    ENDIF.
    COMMIT WORK AND WAIT.

    PERFORM rfq_creation_and_price_update.
    CLEAR:wa_ract,wa_hd,l_usr,wa_addr,wa_rwfusr.
    REFRESH : gt_ln,gt_att,gt_ract,gt_return[],gt_rwfusr[].
  ENDLOOP.

  SORT gs_ack BY ref_id.
  DELETE ADJACENT DUPLICATES FROM gs_ack COMPARING ref_id.

  IF gs_ack[] IS NOT INITIAL.

    gs_xml-line = '<ACK_DATA>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    LOOP AT gs_ack.
      CONCATENATE '<REF_ID>' gs_ack-ref_id '</REF_ID>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    ENDLOOP.
    gs_xml-line = '</ACK_DATA>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CLEAR gv_xml_str.
    LOOP AT gt_xml INTO gs_xml.
      CONCATENATE gv_xml_str gs_xml-line  INTO gv_xml_str.
    ENDLOOP.

    CLEAR :gv_url_str,gv_res_str.


    IF  gv_enable_token IS INITIAL.
      gv_token = 'notoken'.
    ENDIF.

    CALL FUNCTION '/SDOCS/SSPAY_HTTP_POST_N'
      EXPORTING
        i_profile            = p_profle
        i_ext                = p_ac_ext
        i_input_xml          = gv_xml_str
        i_token_flg          = ''
        i_input_method       = 'POST'
      IMPORTING
        e_success            = gv_success
        e_result             = gv_res_str
        e_scode              = gv_scode
        e_stext              = gv_stext
      CHANGING
        c_token_id           = gv_token
      EXCEPTIONS
        ex_internal_error    = 1
        ex_connection_failed = 2
        OTHERS               = 3.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF gv_success = 'X'.
      LOOP AT gs_ack.
        WRITE:/1 'Ref_id :',20 gs_ack-ref_id.
      ENDLOOP.
      MESSAGE s000(/sdocs/sspay_msg) WITH 'Data Received Successfully!' gv_scode gv_stext.
    ELSE.
      LOOP AT gs_ack.
        WRITE:/1 'Ref_id :',20 gs_ack-ref_id.
      ENDLOOP.
      MESSAGE w006(/sdocs/sspay_msg) WITH 'acknowledgement Failed with' gv_scode '-' gv_stext.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UNLOCK_RUN_INSTANCE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM unlock_run_instance .
  CALL FUNCTION '/SDOCS/SSPAY_UNLOCK_PROGRAM_N'
    EXPORTING
      i_prog_name = sy-repid.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HEADER_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM header_data .
*  wa_hd-docid = wa_pir-ref_id.
*  wa_hd-ekorg = wa_pir-porg.
*  wa_hd-lifnr = wa_pir-supplr_id.
*  wa_hd-kdatb = wa_pir-validity_from.
*  wa_hd-kdate = wa_pir-validity_to.
*  wa_hd-aplfz = wa_pir-delivery_days.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ITEM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM item_data .
*
*  wa_ln-docid = wa_pir-ref_id.
*  wa_ln-line_no = 1.
*  wa_ln-matnr = wa_pir-mat_code.
*  wa_ln-netpr = wa_pir-price.
*  wa_ln-ebeln = wa_pir-info_record.
*  wa_ln-uom = wa_pir-uom.
*  wa_ln-werks = wa_pir-plant.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RFQ_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rfq_header .

*  SELECT SINGLE * FROM /sdocs/s1_buy_hd INTO wa_hd WHERE docid = wa_phd-id.
*  IF sy-subrc = 0.
*    DELETE /sdocs/s1_buy_hd WHERE docid = wa_phd-id.
*  ENDIF.

***for test case
  SELECT MAX( docid ) FROM /sdocs/s1_bvndr INTO @DATA(lv_docid) .
******
  wa_hd-docid = lv_docid + 1.   "docid
  wa_hd-doctype = 'S1_RFQ'.  " doctype
  wa_hd-bukrs = wa_phd-company_code.  "bukrs
*  wa_hd-ebeln = wa_phd-rfx_no   .    "ebeln
  IF wa_phd-type = 'RFQ'.
    wa_hd-bbsrt = 'AN'.
  ELSE.
    wa_hd-bbsrt = 'AN'.
  ENDIF.
*  wa_hd-coll_num = wa_phd-visibility.  ""old one
  wa_hd-coll_num = wa_phd-rfx_no.
  wa_hd-ekorg = wa_phd-purchasing_org.  "ekorg
  wa_hd-ekgrp = wa_phd-purchasing_grp.   "ekgrp
  wa_hd-req_email = wa_phd-requestor.    "REQ_EMAIL
*  wa_hd- = wa_phd-buyer.
*  wa_hd- = wa_phd-sub_strt_date.
*  wa_hd- = wa_phd-sub_end_date.
  wa_hd-ebdat = wa_phd-q_and_a_deadlin.
*  wa_hd- = wa_phd-pub_date.
*  wa_hd- = wa_phd-status.
  wa_hd-creator = wa_phd-created_by.   "creator
  wa_hd-cr_date = wa_phd-created_date .  "cr_date

***read internal table for vendor.

*  TRY.
*      wa_bid = gt_bid[ rfx_no = wa_phd-rfx_no ].
*    CATCH cx_sy_itab_line_not_found INTO gs_ex.
*  ENDTRY.
*  READ TABLE gt_bid INTO wa_bid WITH KEY rfx_no = wa_phd-rfx_no.

*  wa_hd-lifnr = wa_bid-suppir_id.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RFQ_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rfq_item .


  LOOP AT gt_pln INTO DATA(wa_pln) WHERE rfx_no = wa_phd-rfx_no.

    IF wa_pln-unt_prc = 'NaN'.
      CLEAR wa_pln-unt_prc.
    ENDIF.

    IF wa_pln-unt_prc CA 'E'.
      PERFORM correct_amt_value CHANGING wa_pln-unt_prc.
    ENDIF.

    IF wa_pln-tot_prc = 'NaN'.
      CLEAR wa_pln-tot_prc.
    ENDIF.

    IF wa_pln-tot_prc CA 'E'.
      PERFORM correct_amt_value CHANGING wa_pln-unt_prc.
    ENDIF.

    wa_ln-docid = wa_hd-docid.
    wa_ln-line_no = wa_pln-line_no. "line_no
*    wa_ln-line_no = wa_pln-item_no. "line_no
    wa_ln-txz01 = wa_pln-item_name .
    wa_ln-uom = wa_pln-uom.
    wa_ln-eeind = wa_pln-del_date.  " delivery date
    wa_ln-bamng = wa_pln-qty.      "quantity
    wa_ln-matkl = wa_pln-mater_grp. "material group
    wa_ln-mtart = wa_pln-itm_cat .
    wa_ln-werks = wa_pln-plnt.
    wa_ln-lgort = wa_pln-stor_loc.
    wa_ln-lifnr = wa_pln-suplir_id .
    wa_ln-saknr = wa_pln-gl_acnt.
    wa_ln-ebeln = wa_pln-rfx_no.  "ref no
    wa_ln-netpr = wa_pln-unt_prc.
    wa_ln-waers = wa_pln-cur.
    wa_ln-peinh = wa_pln-per.
    wa_ln-netwr = wa_pln-tot_prc.
    wa_ln-matnr = wa_pln-mat_code.  "material
*    wa_ln- = wa_pln-sup_unit_pri.

    APPEND wa_ln TO gt_ln.
    CLEAR :wa_ln,wa_pln.


  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RFQ_ATTACHMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rfq_attachment .

  LOOP AT lt_att  INTO DATA(wa_attach) WHERE ref_id = wa_lhdata-ref_id.

    AT NEW ref_id.
      wa_att-primary_doc = 'X'.
      DATA(lv_c) = 1.
    ENDAT.

    wa_att-docid = wa_hd-docid.
    wa_att-arc_id = wa_attach-ar_id.
    wa_att-file_name = wa_attach-fl_name.
    wa_att-file_type = wa_attach-fl_type.
*    wa_att- = wa_attach-attid.
*    wa_att- = wa_attach-document_no.
*    wa_att- = wa_attach-doc_expiry_date.
*    wa_att- = wa_attach-doc_expiry_time.
    wa_att-cr_date = wa_attach-created_date.
    wa_att-cr_time = wa_attach-created_time.
    wa_att-creator = wa_attach-creator.
    wa_att-ar_doctype = wa_attach-doc_type.
    wa_att-arc_docid = wa_attach-ar_docid.
*    wa_att- = wa_attach-rfx_no.
    IF  lv_c IS INITIAL.
      wa_att-primary_doc = ' '.
    ENDIF.

    APPEND wa_att TO gt_att.
    CLEAR : wa_att, wa_attach,lv_c.


  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RFQ_CREATION_AND_PRICE_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rfq_creation_and_price_update .
  DATA:l_success TYPE INT4.
  DATA : lv_angdt TYPE ekko-angdt.
  DATA : lv_qtn TYPE ekko-ebeln.
  CLEAR:l_success.
 data(lv_bid) = |{ wa_HD-lifnr ALPHA = IN }|.
  lv_db_table = 'ekko'.
  SELECT SINGLE angdt FROM (lv_db_table) INTO @lv_angdt WHERE ebeln = @wa_HD-ebeln.
  CALL FUNCTION '/SDOCS/S1_RFQ_PRICDE_UPDT'
    EXPORTING
      p_splr      = wa_HD-lifnr
      p_rfq       = wa_HD-ebeln
      lv_date_str = lv_angdt
    IMPORTING
      lv_response = l_success.
  IF L_success = 200.
    WAIT UP TO 2 SECONDS.
    lv_db_table = 'EKKO'.
    SELECT SINGLE ebeln FROM (lv_db_table) INTO @lv_qtn WHERE LIFNR = @lv_bid AND ausnr = @wa_HD-ebeln.
    CLEAR l_success.
    IF lv_qtn IS NOT INITIAL.
      LOOP AT gt_ln INTO wa_ln.
        CALL FUNCTION '/SDOCS/S1_RFQ_PRICDE_UPDT_ITM'
          EXPORTING
            p_qtn       = lv_qtn
            p_item      = wa_ln-line_no
            p_netwr     = wa_ln-netpr
            p_quan      = wa_ln-bamng
            p_rfq       = wa_ln-ebeln
            p_rfq_itm   = wa_ln-line_no
          IMPORTING
            lv_response = l_success.
      ENDLOOP.
      IF L_success = 204 OR L_success = 200.
        CLEAR l_success.
        CALL FUNCTION '/SDOCS/S1_QTN_SUBMIT'
          EXPORTING
            p_qtn        = lv_qtn
          IMPORTING
            lv_response1 = l_success.
        IF L_success = 200 AND wa_hdata-selected_bid = wa_lhdata-bid_no.
          CALL FUNCTION '/SDOCS/S1_QTN_AWARD'
            EXPORTING
              p_qtn        = lv_qtn
            IMPORTING
              lv_response1 = l_success.

        ENDIF.
      ELSE.
        MESSAGE 'Line Items are not Updated ' TYPE 'I'.
      ENDIF.
    ELSE.
      MESSAGE 'Supplier Quotation is not created' TYPE 'I'.
    ENDIF.
  ENDIF.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_WF_USERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_wf_users .


  SELECT * FROM /sdocs/s1_cpoagt INTO TABLE @DATA(lt_agt_user) WHERE agent = @gv_rfq_agent
                                                          AND   bukrs = @wa_hd-bukrs
                                                          AND   ekorg = @wa_hd-ekorg.
  IF sy-subrc NE 0.
    SELECT * FROM /sdocs/s1_cpoagt INTO TABLE lt_agt_user[] WHERE agent = gv_rfq_agent
                                                        AND   bukrs = wa_hd-bukrs
                                                        AND   ekorg = '*'.
    IF lt_agt_user[] IS INITIAL.
      SELECT * FROM /sdocs/s1_cpoagt INTO TABLE lt_agt_user[] WHERE agent = gv_rfq_agent
                                                    AND   bukrs = '*'
                                                    AND   ekorg = wa_hd-ekorg.
      IF lt_agt_user[] IS INITIAL.
        SELECT * FROM /sdocs/s1_cpoagt INTO TABLE lt_agt_user[] WHERE agent = gv_rfq_agent
                                                                AND   bukrs = '*'
                                                                AND   ekorg = '*'.
      ENDIF.
    ENDIF.
  ENDIF.

  LOOP AT lt_agt_user INTO DATA(wa_agt_user).
    wa_rwfusr-docid   = wa_hd-docid.
    wa_rwfusr-c_user  = wa_agt_user-userid.
    wa_rwfusr-stl     = 'X'.
    l_usr =  wa_rwfusr-c_user.
    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username      = l_usr
        cache_results = 'X'
      IMPORTING
        address       = wa_addr
      TABLES
        return        = gt_return.
    wa_rwfusr-c_email = wa_addr-e_mail.
    wa_rwfusr-ldate   = sy-datum.
    wa_rwfusr-ltime   = sy-uzeit.

    APPEND wa_rwfusr TO gt_rwfusr[].
    CLEAR:wa_rwfusr,wa_agt_user.
  ENDLOOP.
  REFRESH lt_agt_user[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_WF_ACTIVITIES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_wf_activities .
  DATA:lv_act_code TYPE /sdocs/sspy_act_code.
  CLEAR:lv_act_code.

  DO 2 TIMES.
    CASE sy-index.
      WHEN '1'.
        lv_act_code = '4001'."Create RFQ
      WHEN '2'.
        lv_act_code = '1005'."'."Cancel WF
    ENDCASE.

    IF lv_act_code IS NOT INITIAL.
      wa_ract-docid    = wa_hd-docid.
      wa_ract-act_code = lv_act_code.
      APPEND wa_ract TO gt_ract[].
      CLEAR:wa_ract.
    ENDIF.
    CLEAR:lv_act_code.
  ENDDO.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RFQ_BVNDR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM rfq_bvndr .

  LOOP AT gt_bid INTO DATA(wa_bid) WHERE rfx_no = wa_phd-rfx_no.

    wa_bvndr-docid = wa_hd-docid.
    wa_bvndr-lifnr = wa_bid-suppir_id.
    wa_bvndr-prfq_no = wa_bid-rfx_no.

    DATA(lv_lifnr) = |{ wa_bvndr-lifnr ALPHA = IN  } |.
    lv_db_table = 'lfa1'.
    SELECT SINGLE name1 FROM (lv_db_table) INTO @wa_bvndr-name1 WHERE lifnr = @lv_lifnr.

    APPEND wa_bvndr TO gt_bvndr.
    CLEAR :wa_bvndr,wa_bid.

  ENDLOOP.


ENDFORM.

FORM correct_amt_value  CHANGING p_sub_total.
  DATA:lv_flvalue TYPE qsollwerte,
       lv_flout   TYPE cha_class_view-sollwert.
  CLEAR:lv_flvalue,lv_flout.

  lv_flvalue = p_sub_total.
  CLEAR:p_sub_total.
  data(lv_fm) = 'QSS0_FLTP_TO_CHAR_CONVERSION'.
  CALL FUNCTION lv_fm
    EXPORTING
      i_number_of_digits = 2
      i_fltp_value       = lv_flvalue
*     I_VALUE_NOT_INITIAL_FLAG       = 'X'
*     I_SCREEN_FIELDLENGTH           = 16
    IMPORTING
      e_char_field       = lv_flout.

  p_sub_total = lv_flout.
  CONDENSE p_sub_total NO-GAPS.
ENDFORM.
*}   INSERT

*{   INSERT         S4HK903047                                        2
*&---------------------------------------------------------------------*
*& Form get_rx_header_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_rfx_header_data .
    READ TABLE   gt_hdata INTO wa_hdata  WITH KEY rfxno = wa_lhdata-rfxno selected_bid = wa_lhdata-bid_no.
  DATA:lv_lifnr TYPE lifnr.
  lv_lifnr = wa_lhdata-bid_company.
  gv_g_docid  = wa_lhdata-bid_no.
  WA_HD-DOCID  = gv_g_docid.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = lv_lifnr
    IMPORTING
      output = lv_lifnr.
  wa_hd-lifnr = wa_lhdata-bid_company.
  wa_hd-rfq_no = wa_lhdata-rfxno.
  wa_hd-EBELN = wa_lhdata-rfxno.
  wa_hd-collab_apr = wa_lhdata-bid_cntct_email.
  wa_hd-req_email = wa_lhdata-ref_id.
  IF wa_hdata-selected_bid = wa_lhdata-bid_no.
    wa_hd-AWARD = ABAP_TRUE.
  ENDIF.

  WA_bvndr-docid = wa_lhdata-bid_no.
  WA_bvndr-lifnr = wa_lhdata-bid_company.
  WA_bvndr-name1 = wa_lhdata-bid_cntct_person.
  WA_bvndr-prfq_no = wa_lhdata-rfxno.
  APPEND WA_bvndr TO gt_bvndr.
ENDFORM.
*}   INSERT

*{   INSERT         S4HK903047                                        3
*&---------------------------------------------------------------------*
*& Form get_rfx_item_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_rfx_item_data .
  LOOP AT gt_ldata INTO DATA(wa_ldata) WHERE ref_id = wa_lhdata-ref_id.
    wa_ln-ebeln = wa_lhdata-rfxno.
    wa_ln-ebelp = wa_ldata-lineno.
    wa_ln-line_no = wa_ldata-lineno.
    wa_ln-netpr = wa_ldata-unit_price.
    wa_ln-bamng = wa_ldata-qty.
    IF wa_ln-bamng <= 0.
      wa_ln-bamng = wa_ldata-submitted_qty.
    ENDIF.
    wa_ln-netwr = ( wa_ln-bamng * wa_ln-netpr ).
    wa_ln-matnr = wa_ldata-prdct_id.
    wa_ln-uom = wa_ldata-uom.
    wa_ln-eindt = wa_ldata-del_date.
    wa_ln-DOCID = gv_g_docid.
    APPEND wa_ln TO gt_ln.
    CLEAR:wa_ldata,wa_ln.
  ENDLOOP.
ENDFORM.
*}   INSERT
