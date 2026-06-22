*&-------------------------------------------------------------------------------*
*& Report /SDOCS/S1_RFQ_DATA_DISPATCH
*&-------------------------------------------------------------------------------*
*& Developer:    K.Jyothi                                                        *
*& Created Date: 28.06.2022                                                      *
*& Description  : This program is for getting the Invoice and expenses PurchasingCollectiveNumberssion
*& data from SSP and starts the smartdocs workflow.
*&                                                                               *
*&                                                                               *
*&                                                                               *
*&-------------------------------------------------------------------------------*
*& C H A N G E   L O G                                                           *
*&-------------------------------------------------------------------------------*
*& Date           Programmer          Request #        Description               *
*&-------------------------------------------------------------------------------*
*& mm/dd/yyyy     XXXXXXXXXX          XXXXXXXXX        XXXXXXXXXXXXXXXXXXXXXXXXX *



*&                                    transport(s)    XXXXXXXXXXXXX, XXXXXXXXXX  *
*&                                                                               *
*&-------------------------------------------------------------------------------*
REPORT /sdocs/s1_rfq_data_dispatch.
INCLUDE /sdocs/sspy_incl_dispdata.
TYPES: BEGIN OF ty_rfq_h,
         rfq_no              TYPE ekko-ebeln,
         rfq_type            TYPE ekko-bstyp,
         rfq_name            TYPE char20,
         purch_org           TYPE ekko-ekorg,
         purch_grp           TYPE ekko-ekgrp,
         buyer               TYPE char10,
         rfq_open_dt         TYPE ekko-aedat,
         rfq_start_dt        TYPE ekko-aedat,
         rfq_start_tm        TYPE uzeit,
         rfq_subdeadline_dt  TYPE datum,
         rfq_subdeadline_tme TYPE uzeit,
         qa_limit_date       TYPE datum,
         qa_limit_time       TYPE uzeit,
         rfq_valid_from      TYPE datum,
         rfq_valid_to        TYPE datum,
         target_value        TYPE ekko-ktwrt,
         currency            TYPE ekko-waers,
         requestor           TYPE ekko-ernam,
         requestor_name      TYPE char50,
         requestor_email     TYPE ad_smtpadr,
         vendor              TYPE ekko-lifnr,
         submi               TYPE ekko-submi,
       END OF  ty_rfq_h.
TYPES : BEGIN OF ty_adr6,
          addrnumber TYPE ad_addrnum,
          persnumber TYPE ad_persnum,
          date_from  TYPE ad_date_fr,
          consnumber TYPE ad_consnum,
          smtp_addr  TYPE ad_smtpadr,
        END OF ty_adr6.
DATA : lt_adr6    TYPE TABLE OF ty_adr6,
       lt_remails TYPE TABLE OF ty_adr6.
TYPES: BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         land1 TYPE lfa1-land1,
         name1 TYPE lfa1-name1,
         name2 TYPE lfa1-name2,
         adrnr TYPE lfa1-adrnr,
       END OF ty_lfa1.
DATA: lt_lfa1 TYPE TABLE OF ty_lfa1.

TYPES : BEGIN OF ty_adrc,
          addrnumber TYPE ad_addrnum,
          date_from  TYPE ad_date_fr,
          nation     TYPE ad_nation,
          tel_number TYPE ad_tlnmbr1,
        END OF ty_adrc.
DATA: lt_adrc TYPE TABLE OF ty_adrc.
TYPES : BEGIN OF ty_ekpo1,
          ebeln TYPE ekpo-ebeln,
          ebelp TYPE ekpo-ebelp,
          matnr TYPE ekpo-matnr,
          txz01 TYPE ekpo-txz01,
          matkl TYPE ekpo-matkl,
          ktmng TYPE ekpo-ktmng,
          meins TYPE ekpo-meins,
          mfrpn TYPE ekpo-mfrpn,
        END OF ty_ekpo1.
DATA: lt_ln TYPE TABLE OF ty_ekpo1.

TYPES: BEGIN OF ty_rfq_ln,
         rfq_no          TYPE ekko-ebeln,
         item_no         TYPE ekpo-ebelp,
         item_type       TYPE char10,
         material        TYPE ekpo-matnr,
         material_desc   TYPE ekpo-txz01,
         material_grp    TYPE ekpo-matkl,
         quantity        TYPE ekpo-menge,
         unit_of_measure TYPE ekpo-meins,
*         currency        type ekpo-waers,
         delivery_dt     TYPE eket-eindt,
         manfr_part_no   TYPE char40,
       END OF ty_rfq_ln.

TYPES: BEGIN OF ty_vendors,
         vendor TYPE lfa1-lifnr,
         rfq_no TYPE ekko-ebeln,
       END OF ty_vendors.


TYPES: BEGIN OF ty_bidder_details,
         rfq_no           TYPE ekko-ebeln,
         vendor           TYPE ekko-lifnr,
         vendor_name(100) TYPE c,
         contact_email    TYPE ad_smtpadr,
         contact_phone    TYPE ad_tlnmbr1,
         country          TYPE land1_gp,
       END OF ty_bidder_details.

TYPES:BEGIN OF ty_attach,
        sap_object TYPE	toa01-sap_object,
        object_id  TYPE	toa01-object_id,
        archiv_id  TYPE	toa01-archiv_id,
        arc_doc_id TYPE	toa01-arc_doc_id,
        ar_date    TYPE toa01-ar_date,
        reserve    TYPE saereserve,
      END OF ty_attach.


TYPES:BEGIN OF gs_reqmail,
        bname TYPE xubname,
        email TYPE ad_smtpadr,
      END OF gs_reqmail.

TYPES: BEGIN OF gs_toaat,
         arc_doc_id TYPE toaat-arc_doc_id,
         filename   TYPE toaat-filename,
         creator    TYPE toaat-creator,
       END OF gs_toaat.

TYPES : BEGIN OF ty_usr21,
          bname      TYPE xubname,
          addrnumber TYPE ad_addrnum,
        END OF ty_usr21.
DATA: lt_usr21 TYPE TABLE OF ty_usr21.


DATA:BEGIN OF gt_docid OCCURS 0,
       docid TYPE /sdocs/s1_buy_hd-docid,
       ebeln TYPE ebeln,
     END OF gt_docid.

DATA:BEGIN OF lt_objid OCCURS 0,
       object_id TYPE	toa01-object_id,
     END OF lt_objid.

TYPES: BEGIN OF ty_bhd,
         docid       TYPE /sdocs/s1_buy_hd-docid,
         ebdat       TYPE /sdocs/s1_buy_hd-ebdat,
         qa_ddate    TYPE /sdocs/s1_buy_hd-qa_ddate,
         rfx_private TYPE /sdocs/s1_buy_hd-rfx_private,
         rfx_qmode   TYPE /sdocs/s1_buy_hd-rfx_qmode,
         rfx_type    TYPE /sdocs/s1_buy_hd-rfx_type,
         qa_dtime    TYPE /sdocs/s1_buy_hd-qa_dtime,
         rfq_title   TYPE /sdocs/s1_buy_hd-rfq_title,
       END OF ty_bhd.
TYPES : BEGIN OF ty_rfq1,
          ebeln TYPE ekko-ebeln,
          bstyp TYPE ekko-bstyp,
          aedat TYPE ekko-aedat,
          ernam TYPE ekko-ernam,
          lifnr TYPE ekko-lifnr,
          ekorg TYPE ekko-ekorg,
          ekgrp TYPE ekko-ekgrp,
          waers TYPE ekko-waers,
          kdatb TYPE ekko-kdatb,
          kdate TYPE ekko-kdate,
          angdt TYPE ekko-angdt,
          ktwrt TYPE ekko-ktwrt,
          submi TYPE ekko-submi,
        END OF ty_rfq1.
DATA: lt_rfq  TYPE TABLE OF ty_rfq1,
      lt_rfq1 TYPE TABLE OF ty_rfq1.
TYPES: BEGIN OF ts_ekpa,
         ebeln TYPE ekpa-ebeln,
         ebelp TYPE ekpa-ebelp,
         lifn2 TYPE ekpa-lifn2,
       END OF ts_ekpa.

DATA:gt_rmails  TYPE TABLE OF gs_reqmail,
     gt_attach  TYPE TABLE OF   ty_attach,
     gt_ekpa    TYPE STANDARD TABLE OF ts_ekpa,
     gt_toaat   TYPE TABLE OF gs_toaat,
     gt_uname   TYPE TABLE OF v_usr_name,
     gt_bhd     TYPE TABLE OF ty_bhd,
     t_bidders  TYPE TABLE OF ty_bidder_details,
     t_rfq_h    TYPE TABLE OF ty_rfq_h,
     t_rfq_ln   TYPE TABLE OF ty_rfq_ln,
     t_attach   TYPE TABLE OF ty_attach,
     lt_vendors TYPE TABLE OF ty_vendors.

DATA: wa_job_slog TYPE /sdocs/sspy_jlog,
      wa_attach   TYPE ty_attach,
      l_rfq_h     TYPE ty_rfq_h,
      l_rfq_ln    TYPE ty_rfq_ln,
      l_bidders   TYPE ty_bidder_details,
      l_vendors   TYPE ty_vendors,
      l_attach    TYPE ty_attach,
      lv_db_table TYPE char50.
DATA:l_res TYPE i.
DATA:lt_fser TYPE REF TO cl_gui_frontend_services.
TYPES : BEGIN OF ty_eket1,
          ebeln TYPE eket-ebeln,
          ebelp TYPE eket-ebelp,
          etenr TYPE eket-etenr,
          eindt TYPE eket-eindt,
        END OF ty_eket1.
DATA: lt_eket TYPE TABLE OF ty_eket1.

DATA:lv_flag,
     lv_config_value TYPE /sdocs/sspy_sgc-config_value,
     gv_ebeln        TYPE ekko-ebeln,
     gv_aedat        TYPE ekko-aedat,
     gv_time         TYPE sy-uzeit.

RANGES:lr_date FOR sy-datum,
       lr_time FOR sy-uzeit.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:p_profle TYPE /sdocs/sspy_sprf-profile_id OBLIGATORY,
             p_tk_ext TYPE /sdocs/sspy_http_ext DEFAULT '',
             p_ext    TYPE /sdocs/sspy_http_ext DEFAULT '',
             p_bsize  TYPE int4 DEFAULT 5,
             p_retry  TYPE int4 DEFAULT 1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  SELECT-OPTIONS:s_rfq   FOR gv_ebeln,
                 s_cdate FOR gv_aedat.
SELECTION-SCREEN END OF BLOCK b2.
PARAMETERS:p_delta AS CHECKBOX.

INITIALIZATION.
  CLEAR: l_rfq_h,l_rfq_ln,l_attach,l_bidders.
  REFRESH:  t_rfq_h,t_rfq_ln,t_attach,t_bidders.

AT SELECTION-SCREEN OUTPUT.
  p_profle = sy-sysid.
  LOOP AT SCREEN.
    IF screen-name = 'P_PROFLE'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  CLEAR:gv_prog_locked.

  IF p_bsize IS INITIAL.
    p_bsize = 10.
  ENDIF.

  IF p_bsize GT 50.
    MESSAGE s000(/sdocs/sspay_msg) WITH 'Please maintain batch size less than or equal to 50'.
    EXIT.
  ENDIF.

  CALL FUNCTION '/SDOCS/SSPAY_LOCK_PROGRAM_N'
    EXPORTING
      i_prog_name       = sy-repid
    IMPORTING
      e_prog_locked     = gv_prog_locked
    EXCEPTIONS
      ex_program_locked = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF gv_prog_locked IS NOT INITIAL.
    WRITE:/1 gv_run_ins_msg, 50 sy-datum ,65  sy-uzeit.
    MESSAGE s005(/sdocs/sspay_msg).
    EXIT.
  ENDIF.

  SELECT SINGLE config_value INTO @DATA(lv_time) FROM /sdocs/sspy_sgc WHERE config = 'RFQ_ADJUST_TIME'.
  gv_time = lv_time.
  CLEAR lv_time.
  SELECT SINGLE config_value INTO gv_enable_token FROM /sdocs/sspy_sgc WHERE config = 'HTTP_TOKEN_ENABLE'.
  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_data_to_file WHERE config = 'DATA_TRANSFER_VIA_FILE'.
  PERFORM get_data.
  IF gv_enable_token IS NOT INITIAL.
    PERFORM portal_authentication.
    IF gv_token IS NOT INITIAL AND ( gv_scode = '200' OR gv_scode = '201' ).
      PERFORM push_data_to_portal.
    ELSE.
      MESSAGE s000(/sdocs/sspay_msg) WITH 'Please check the profile setup'.
    ENDIF.
  ELSE.
    PERFORM push_data_to_portal.
  ENDIF.

  PERFORM unlock_run_instance.
  IF l_res <> '0'.
    WRITE:/ ''.
    WRITE:/ ''.
    WRITE:/ 'Program completed successfully'.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  TYPES:BEGIN OF fs_cdhdr,
          objectclas TYPE cdhdr-objectclas,
          objectid   TYPE cdhdr-objectid,
        END OF fs_cdhdr.
  DATA:BEGIN OF lt_po OCCURS 0 ,
         ebeln TYPE ekko-ebeln,
       END OF lt_po.
  DATA:l_po     LIKE LINE OF  lt_po,
       lt_cdhdr TYPE TABLE OF fs_cdhdr WITH HEADER LINE.
  REFRESH:lt_cdhdr,lt_po[].
  IF s_cdate IS NOT INITIAL OR s_rfq IS NOT INITIAL.
    p_delta = ''.
  ENDIF.

  CASE p_delta.
    WHEN 'X'.
      REFRESH:lt_cdhdr.
      CLEAR:lt_cdhdr.
      PERFORM get_job_interval.
      gv_curr_date = sy-datum.
      gv_curr_time = sy-uzeit.
      lv_db_table = 'cdhdr'.
      SELECT objectclas
             objectid FROM (lv_db_table) INTO TABLE lt_cdhdr WHERE objectclas = 'EINKBELEG' AND udate IN lr_date AND
             utime  IN lr_time   AND change_ind IN ('U' , 'I')..
      LOOP AT lt_cdhdr INTO DATA(l_cdhdr).
        MOVE l_cdhdr-objectid TO l_po-ebeln.
        APPEND l_po TO lt_po.
        CLEAR: l_po,l_cdhdr.
      ENDLOOP.

      IF lt_po[] IS NOT INITIAL.
        lv_db_table = 'ekko'.
        SELECT ebeln,
           bstyp,
           aedat,
           ernam,
           lifnr,
           ekorg,
           ekgrp,
           waers,
           kdatb,
           kdate,
           angdt,
           ktwrt,
           submi FROM (lv_db_table) INTO TABLE @lt_rfq FOR ALL ENTRIES IN @lt_po WHERE ebeln = @lt_po-ebeln AND bstyp = 'R'.
      ENDIF.
    WHEN ''.
      lv_db_table = 'ekko'.
      SELECT ebeln,
            bstyp,
            aedat,
            ernam,
            lifnr,
            ekorg,
            ekgrp,
            waers,
            kdatb,
            kdate,
            angdt,
            ktwrt,
            submi  FROM (lv_db_table)
                   WHERE ebeln IN @s_rfq AND aedat IN @s_cdate AND bstyp = 'R'"  AND submi <> ' '
                   INTO TABLE  @lt_rfq.


  ENDCASE.


  IF lt_rfq IS NOT INITIAL.
    lv_db_table = 'ekpo'.
    SELECT ebeln,
           ebelp,
           matnr,
           txz01,
           matkl,
           ktmng,
           meins,
           mfrpn
           FROM (lv_db_table) INTO TABLE @lt_ln FOR ALL ENTRIES IN @lt_rfq WHERE ebeln = @lt_rfq-ebeln AND abskz = ' '. "#EC CI_NO_TRANSFORM
    DATA(lv_ekpa) = 'ekpa'.
    SELECT  ebeln ebelp lifn2 FROM (lv_ekpa) INTO TABLE gt_ekpa FOR ALL ENTRIES IN lt_rfq WHERE ebeln = lt_rfq-ebeln.
    IF lt_ln IS NOT INITIAL.
      lv_db_table = 'eket'.
      SELECT ebeln ,ebelp, etenr,eindt FROM (lv_db_table) INTO TABLE @lt_eket FOR ALL ENTRIES IN @lt_rfq WHERE ebeln = @lt_rfq-ebeln. "#EC CI_NO_TRANSFORM
    ENDIF.
    lv_db_table = 'V_USR_NAME'.
    SELECT * FROM (lv_db_table) INTO TABLE gt_uname FOR ALL ENTRIES IN lt_rfq WHERE bname = lt_rfq-ernam. "#EC CI_NO_TRANSFORM
    lv_db_table = 'usr21'.
    SELECT bname,addrnumber FROM (lv_db_table) INTO TABLE @lt_usr21 FOR ALL ENTRIES IN @lt_rfq WHERE bname = @lt_rfq-ernam.
    lv_db_table = 'adr6'.                          "#EC CI_NO_TRANSFORM
    SELECT addrnumber,persnumber,date_from,consnumber,smtp_addr FROM (lv_db_table) INTO TABLE  @lt_remails  FOR ALL ENTRIES IN @lt_usr21 WHERE addrnumber = @lt_usr21-addrnumber AND smtp_addr <> ' '. "#EC CI_NO_TRANSFORM
    lv_db_table = 'lfa1'.
    SELECT lifnr,land1,name1,name2,adrnr FROM (lv_db_table) INTO TABLE @lt_lfa1 FOR ALL ENTRIES IN @lt_rfq WHERE lifnr = @lt_rfq-lifnr. "#EC CI_NO_TRANSFORM
    SELECT lifnr land1 name1 name2 adrnr FROM (lv_db_table) APPENDING TABLE lt_lfa1 FOR ALL ENTRIES IN gt_ekpa
      WHERE lifnr = gt_ekpa-lifn2.                 "#EC CI_NO_TRANSFORM
    lv_db_table = 'adr6'.
    SELECT addrnumber,persnumber,date_from,consnumber,smtp_addr FROM (lv_db_table) INTO TABLE @lt_adr6 FOR ALL ENTRIES IN @lt_lfa1 WHERE addrnumber = @lt_lfa1-adrnr. "#EC CI_NO_TRANSFORM
    lv_db_table = 'adrc'.
    SELECT addrnumber,date_from,nation,tel_number FROM (lv_db_table) INTO TABLE @lt_adrc FOR ALL ENTRIES IN @lt_lfa1 WHERE addrnumber = @lt_lfa1-adrnr. "#EC CI_NO_TRANSFORM
    LOOP AT lt_rfq INTO DATA(l_rfq).
      LOOP AT gt_ekpa INTO DATA(wa_ekpa) WHERE ebeln = l_rfq-ebeln .
        READ TABLE lt_lfa1 INTO DATA(l_lfa1) WITH KEY lifnr = wa_ekpa-lifn2.
        READ TABLE lt_adr6 INTO DATA(l_adr6) WITH KEY addrnumber = l_lfa1-adrnr.
        READ TABLE lt_adrc INTO DATA(l_adrc) WITH KEY addrnumber = l_lfa1-adrnr.
        l_bidders-vendor        =  l_lfa1-lifnr.
        CONCATENATE l_lfa1-Name1 l_lfa1-Name2 INTO l_bidders-vendor_name  SEPARATED BY space.
        DATA(l_vendor) = l_lfa1-lifnr.
        SHIFT l_vendor LEFT DELETING LEADING '0'.
        l_bidders-contact_email   = l_adr6-smtp_addr.
        l_bidders-contact_phone   = l_adrc-tel_number.
        l_bidders-country         = l_lfa1-land1.
        l_bidders-rfq_no         = l_rfq-ebeln.
        gt_docid-docid = l_rfq-submi.
        gt_docid-ebeln = l_rfq-submi.
        APPEND gt_docid.
        APPEND l_bidders TO t_bidders.
      ENDLOOP.
      CLEAR:l_bidders,l_lfa1,l_adr6,l_adrc,gt_docid.
    ENDLOOP.


    LOOP AT  lt_ln INTO DATA(l_ln).
      READ TABLE lt_eket INTO DATA(l_eket) WITH KEY ebeln = l_ln-ebeln  ebelp = l_ln-ebelp.
      READ TABLE lt_rfq INTO l_rfq WITH KEY ebeln = l_ln-ebeln.
      l_rfq_ln-rfq_no            =   l_rfq-ebeln.
      l_rfq_ln-item_no           =   l_ln-ebelp.
      l_rfq_ln-material          =   l_ln-Matnr.
      l_rfq_ln-material_desc     =   l_ln-txz01.
      l_rfq_ln-material_grp      =   l_ln-Matkl.
      l_rfq_ln-quantity          =   l_ln-ktmng.
      l_rfq_ln-unit_of_measure   =   l_ln-meins.
      l_rfq_ln-manfr_part_no     =   l_ln-mfrpn.
      l_rfq_ln-delivery_dt       =   l_eket-eindt.
      APPEND l_rfq_ln TO t_rfq_ln.
      CLEAR:l_rfq_ln,l_eket.
    ENDLOOP.
    SORT t_rfq_ln BY rfq_no ASCENDING item_no ASCENDING.
    DELETE ADJACENT DUPLICATES FROM t_rfq_ln COMPARING rfq_no item_no.

    LOOP AT lt_rfq INTO l_rfq.
      READ TABLE lt_usr21 INTO DATA(l_usr21) WITH KEY bname = l_rfq-ernam.
      READ TABLE lt_remails INTO DATA(l_emails) WITH KEY  addrnumber = l_usr21-addrnumber.
      l_vendors-vendor     = l_rfq-lifnr.
      l_vendors-rfq_no     = l_rfq-ebeln.
      l_rfq_h-rfq_no       = l_rfq-ebeln.
      l_rfq_h-rfq_type     = l_rfq-bstyp.
      l_rfq_h-purch_org    = l_rfq-ekorg.
      l_rfq_h-purch_grp    = l_rfq-ekgrp.
      l_rfq_h-rfq_open_dt  = l_rfq-aedat.
      l_rfq_h-rfq_start_dt = l_rfq-aedat.
      l_rfq_h-target_value = l_rfq-ktwrt.
      l_rfq_h-currency     = l_rfq-waers.
      l_rfq_h-requestor    = l_rfq-ernam.
      l_rfq_h-vendor       = l_rfq-lifnr.
      l_rfq_h-requestor_email = l_emails-smtp_addr.
      l_rfq_h-rfq_valid_from    =   l_rfq-kdatb.
      l_rfq_h-rfq_valid_to      =   l_rfq-kdate.
      l_rfq_h-rfq_subdeadline_dt  =    l_rfq-angdt.
      l_rfq_h-qa_limit_date             =    l_rfq-angdt.
      l_rfq_h-submi             =    l_rfq-submi.
      APPEND l_rfq_h TO t_rfq_h.
      APPEND l_vendors TO lt_vendors.
      APPEND l_vendors-vendor TO lt_objid.
      CLEAR: l_rfq_h,l_vendors,lt_objid,l_usr21,l_emails.
    ENDLOOP.

    IF gt_docid[] IS NOT INITIAL.
      lv_db_table = '/sdocs/s1_buy_hd'.
      SELECT  docid ebdat qa_ddate rfx_private rfx_qmode  rfx_type qa_dtime rfq_title FROM (lv_db_table) INTO TABLE gt_bhd FOR ALL ENTRIES IN gt_docid
                                            WHERE docid = gt_docid-docid.






    ENDIF.

    IF lt_objid[]  IS NOT INITIAL.
      lv_db_table = 'toa01'.
      SELECT sap_object object_id archiv_id arc_doc_id ar_date reserve FROM (lv_db_table) INTO TABLE gt_attach FOR ALL ENTRIES IN lt_objid WHERE object_id = lt_objid-object_id. "#EC CI_NO_TRANSFORM
      IF gt_attach IS NOT INITIAL.
        lv_db_table = 'toaat'.
        SELECT arc_doc_id filename creator FROM (lv_db_table)  INTO TABLE gt_toaat FOR ALL ENTRIES IN gt_attach WHERE arc_doc_id = gt_attach-arc_doc_id. "#EC CI_NO_TRANSFORM
      ENDIF.
    ENDIF.
    SORT lt_vendors BY vendor.
    DELETE ADJACENT DUPLICATES FROM lt_vendors COMPARING vendor.
    SORT t_bidders BY vendor.
    DELETE ADJACENT DUPLICATES FROM t_bidders COMPARING vendor.
  ENDIF.
  SORT t_rfq_h BY rfq_no.
  DELETE ADJACENT DUPLICATES FROM t_rfq_h COMPARING rfq_no.

  "Checking execution of program via Fiori or not.
  CREATE OBJECT lt_fser.
  CALL METHOD lt_fser->is_valid
    IMPORTING
      result = l_res.

  DELETE t_rfq_h WHERE rfq_no = ' '.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PUSH_DATA_TO_PORTAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM push_data_to_portal .
  PERFORM prepare_rfq_xml.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PORTAL_AUTHENTICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM portal_authentication .
  lv_db_table = '/sdocs/sspy_sprf'.
  SELECT SINGLE * FROM (lv_db_table) INTO wa_profile WHERE profile_id = p_profle.
  IF wa_profile IS NOT INITIAL.
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
      MESSAGE s000(/sdocs/sspay_msg) WITH gv_res_str.
      WRITE:/ gv_res_str.
      EXIT.
    ENDIF.
  ELSE.
    MESSAGE s000(/sdocs/sspay_msg) WITH 'No Profile.Pls check Tcode:/SDOCS/SSPY_SPRF'.
    EXIT.
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
*&      Form  PREPARE_RFQ_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_rfq_xml .
  DATA:lv_objectid   TYPE saeobjid,
       lv_amount(30) TYPE c,
       lv_tim        TYPE sy-uzeit,
       lv_time(10)   TYPE c.
  CLEAR:gv_cnt,gv_div,gv_from,gv_to,lv_objectid,lv_amount.

  DESCRIBE TABLE t_rfq_h LINES gv_cnt.

  IF gv_cnt GT p_bsize.
    gv_div = gv_cnt / p_bsize.
    gv_mod = ( gv_cnt MOD p_bsize ).
    IF gv_mod => 1.
      gv_div = gv_div + 1.
    ENDIF.
  ELSE.
    gv_div = 1.
  ENDIF.


  DO gv_div TIMES.
    CLEAR:gs_xml,l_rfq_h.
    REFRESH:gt_xml.
    gv_from = gv_to + 1.
    gv_to   = gv_from + p_bsize - 1.

    gs_xml-line = '<RFX_DATA_TRANSMIT>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    LOOP AT t_rfq_h INTO  l_rfq_h   FROM gv_from TO gv_to.
      READ TABLE gt_docid WITH KEY ebeln = l_rfq_h-rfq_no.
*      select single ekgrp into @data(lv_ekgrp) from ekko where ebeln = @l_rfq_h-purch_grp.
      SELECT SINGLE   EmailAddress INTO @DATA(lv_smtp) FROM   I_PurchasingGroup WHERE   PurchasingGroup = @l_rfq_h-purch_grp.
      READ TABLE gt_bhd INTO DATA(wa_bhd) WITH KEY docid = gt_docid-docid.
      gs_xml-line = '<RFX_DATA>'.
      APPEND gs_xml TO gt_xml.CLEAR: gs_xml.

      CONCATENATE '<NOTIFY>' 'false' '</NOTIFY>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.


      gs_xml-line = '<HEADER>'.
      APPEND gs_xml TO gt_xml.CLEAR:gs_xml.

      CONCATENATE '<RFX_NO>' l_rfq_h-rfq_no '</RFX_NO>' INTO gs_xml-line."
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      APPEND l_rfq_h-rfq_no TO gt_output.

      IF wa_bhd-rfx_type IS INITIAL.
        wa_bhd-rfx_type = 'RFQ'.
      ENDIF.

      CONCATENATE '<RFX_TYPE>' wa_bhd-rfx_type '</RFX_TYPE>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      CONCATENATE '<STATUS>' 'Published' '</STATUS>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      IF wa_bhd-rfx_qmode IS NOT INITIAL.
        CONCATENATE '<QUICK_PUBLISH>' 'true' '</QUICK_PUBLISH>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      ELSE.
        CONCATENATE '<QUICK_PUBLISH>' 'false' '</QUICK_PUBLISH>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      ENDIF.

      CONCATENATE '<RFX_NAME>' wa_bhd-rfq_title '</RFX_NAME>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      SHIFT  l_rfq_h-purch_org  LEFT DELETING LEADING '0'.
      CONCATENATE '<PORG>' l_rfq_h-purch_org'</PORG>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      CONCATENATE '<PGRP>' l_rfq_h-purch_grp '</PGRP>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.


*      if l_rfq_h-buyer is INITIAL.
*       l_rfq_h-buyer   = 'buyer@smartdocs.ai'.
       lv_smtp   = 'buyer@smartdocs.ai'.
*       endif.
*      IF lv_smtp IS INITIAL.
*        lv_smtp   = 'rkandru@paturnpike.com'."'buyer1@smartdocs.ai'.
*      ENDIF.
      CONCATENATE '<BUYER>' lv_smtp '</BUYER>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      CONCATENATE '<RFX_OPEN_DT>' l_rfq_h-rfq_open_dt'</RFX_OPEN_DT>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      CONCATENATE '<RFX_START_DT>' l_rfq_h-rfq_start_dt'</RFX_START_DT>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      CONCATENATE '<RFX_START_TME>' l_rfq_h-rfq_start_tm'</RFX_START_TME>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

*      wa_bhd-ebdat = wa_bhd-ebdat - 2.
      CONCATENATE '<RFX_SUBDEADLINE_DT>' wa_bhd-ebdat  '</RFX_SUBDEADLINE_DT>' INTO gs_xml-line."l_rfq_h-rfq_subdeadline_dt
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      lv_tim = wa_bhd-qa_dtime." - gv_time ."2000. "28200.
      lv_time = lv_tim.
      CONCATENATE '<RFX_SUBDEADLINE_TME>' lv_time  '</RFX_SUBDEADLINE_TME>' INTO gs_xml-line."l_rfq_h-rfq_subdeadline_tme"lv_time
      APPEND gs_xml TO gt_xml.CLEAR:gs_xml,lv_time.

      CONCATENATE '<QA_LIMIT_DATE>' wa_bhd-qa_ddate '</QA_LIMIT_DATE>' INTO gs_xml-line."l_rfq_h-rfq_subdeadline_dt
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      IF wa_bhd-qa_ddate  = wa_bhd-ebdat.
        lv_tim = lv_tim - 120.
      ELSE.
        lv_tim  = '235959'.
      ENDIF.
      lv_time = lv_tim.
*      endif.
      CONCATENATE '<QA_LIMIT_TME>' lv_time  '</QA_LIMIT_TME>' INTO gs_xml-line."l_rfq_h-rfq_subdeadline_dt
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      CONCATENATE '<RFX_VALID_FROM>' l_rfq_h-rfq_valid_from'</RFX_VALID_FROM>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      CONCATENATE '<RFX_VALID_TO>' l_rfq_h-rfq_valid_to'</RFX_VALID_TO>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.


      lv_amount = l_rfq_h-target_value.
      CONDENSE lv_amount NO-GAPS.
      CONCATENATE '<TARGET_VALUE>' lv_amount '</TARGET_VALUE>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      IF l_rfq_h-currency IS INITIAL.
        l_rfq_h-currency = 'USD'.
      ENDIF.

      CONCATENATE '<CURRENCY>' l_rfq_h-currency '</CURRENCY>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.


      CONCATENATE '<REQUESTOR>' l_rfq_h-requestor '</REQUESTOR>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR:gs_xml.

      READ TABLE gt_uname INTO DATA(l_unme) WITH KEY bname = l_rfq_h-requestor.
      CONCATENATE '<REQUESTOR_NAME>' l_unme-name_text '</REQUESTOR_NAME>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR:gs_xml,l_unme.

      CONCATENATE '<REQUESTOR_EMAIL>' lv_smtp '</REQUESTOR_EMAIL>' INTO gs_xml-line. "l_rfq_h-requestor_email
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.


      "private
      IF wa_bhd-rfx_private IS NOT INITIAL.
        CONCATENATE '<EMAIL_TO_ALLVENDOR>' 'false' '</EMAIL_TO_ALLVENDOR>' INTO gs_xml-line. "l_rfq_h-requestor_email
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      ELSE.
        "Public
        CONCATENATE '<EMAIL_TO_ALLVENDOR>' 'true' '</EMAIL_TO_ALLVENDOR>' INTO gs_xml-line. "l_rfq_h-requestor_email
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      ENDIF.

      gs_xml-line = '</HEADER>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      gs_xml-line = '<LINEITEMS>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      LOOP AT t_rfq_ln INTO l_rfq_ln WHERE rfq_no = l_rfq_h-rfq_no.
        gs_xml-line = '<LINEITEM>'.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<LINENO>' l_rfq_ln-item_no '</LINENO>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<ITM_TYPE>' l_rfq_ln-item_type'</ITM_TYPE>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        SHIFT l_rfq_ln-material LEFT DELETING LEADING '0'.
        CONCATENATE '<PRDCT_ID>' l_rfq_ln-material '</PRDCT_ID>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.


        CONCATENATE '<PRDCT_DES>' l_rfq_ln-material_desc'</PRDCT_DES>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<PRDCT_CAT>' l_rfq_ln-material_grp'</PRDCT_CAT>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        lv_amount = l_rfq_ln-quantity.
        CONDENSE lv_amount NO-GAPS.
        CONCATENATE '<QTY>'  lv_amount '</QTY>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<UOM>' l_rfq_ln-unit_of_measure'</UOM>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<CURRENCY>' l_rfq_h-currency '</CURRENCY>' INTO gs_xml-line. "l_rfq_ln-currency
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<DEL_DATE>' l_rfq_ln-delivery_dt '</DEL_DATE>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<MPN>' l_rfq_ln-manfr_part_no '</MPN>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        gs_xml-line = '</LINEITEM>'.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      ENDLOOP.
      gs_xml-line = '</LINEITEMS>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      gs_xml-line = '<BIDDERS>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      LOOP AT  t_bidders INTO l_bidders WHERE rfq_no = l_rfq_h-rfq_no.
        gs_xml-line = '<BIDDER>'.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        SHIFT l_bidders-vendor LEFT DELETING LEADING '0'.
        CONCATENATE '<BID_COMPANY>' l_bidders-vendor '</BID_COMPANY>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<BID_COMPANY_NAME>' l_bidders-vendor_name '</BID_COMPANY_NAME>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<BID_CNTCT_EMAIL>' l_bidders-contact_email '</BID_CNTCT_EMAIL>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<BID_CNTCT_PHONE>' l_bidders-contact_phone '</BID_CNTCT_PHONE>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<COUNTRY>' l_bidders-country '</COUNTRY>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        gs_xml-line = '</BIDDER>'.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      ENDLOOP.
      gs_xml-line = '</BIDDERS>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.


      gs_xml-line = '<ATTCHMNTS>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      lv_objectid =  l_rfq_h-rfq_no.

      LOOP AT gt_attach INTO wa_attach WHERE object_id = lv_objectid.

        READ TABLE gt_toaat INTO DATA(wa_toaat) WITH KEY wa_attach-arc_doc_id.
        gs_xml-line = '<ATTCHMNT>'.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<AR_ID>' wa_attach-archiv_id '</AR_ID>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<AR_DOCID>' wa_attach-arc_doc_id '</AR_DOCID>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<FL_NAME>' wa_toaat-filename '</FL_NAME>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<FL_TYPE>' wa_attach-reserve '</FL_TYPE>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<CR_DATE>' wa_attach-ar_date '</CR_DATE>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<CREATOR>' wa_toaat-creator '</CREATOR>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        gs_xml-line = '</ATTCHMNT>'.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      ENDLOOP.
      gs_xml-line = '</ATTCHMNTS>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      gs_xml-line = '</RFX_DATA>'.
      APPEND gs_xml TO gt_xml.CLEAR:gt_docid,wa_bhd,gs_xml,lv_smtp.
    ENDLOOP.

    gs_xml-line = '</RFX_DATA_TRANSMIT>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    PERFORM dispatch_data_to_portal.
  ENDDO.
  IF p_delta IS NOT INITIAL.
    lv_db_table = '/sdocs/sspy_jlog'.
    wa_job_slog-prog_name = '/SDOCS/S1_RFQ_DATA_DISPATCH'.
    wa_job_slog-prog_type = 'HTTP_CALL'.
    wa_job_slog-jlog_date    = gv_curr_date.
    wa_job_slog-jlog_time    = gv_curr_time.
    MODIFY (lv_db_table) FROM wa_job_slog.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ACTUAL_URL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM actual_url .
  CLEAR gv_url_str.
  CONCATENATE  gv_server  '/' p_ext INTO gv_url_str."ex_url.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPATCH_DATA_TO_PORTAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dispatch_data_to_portal .
  DATA:lv_xml_str TYPE string,
       lv_res_str TYPE string.

  LOOP AT gt_xml INTO gs_xml.
    CONCATENATE lv_xml_str gs_xml-line  INTO lv_xml_str.
  ENDLOOP.

  IF gv_token IS INITIAL.
    gv_token = 'notoken'.
  ENDIF.

****FOR PUSHING DATA TO APPLICATION SERVER
  IF NOT gv_data_to_file IS INITIAL.
    DATA lv_flag1 TYPE flag.
    CALL FUNCTION '/SDOCS/S1_FTP_SAP_TO_EXTERNALN'
      EXPORTING
*       i_fname     =     " Char255
*       i_profile   =
        i_prog_name = sy-cprog    " CALL program
*       i_sec       =     " General Flag
        i_ftp       = space   " 'X' means data push to FTP servevr
      IMPORTING
        e_success   = lv_flag1   " General Flag
      TABLES
        i_data      = gt_xml.
********  END OF

  ELSE.
    CALL FUNCTION '/SDOCS/SSPAY_HTTP_POST_N'
      EXPORTING
        i_profile            = p_profle
        i_ext                = p_ext
        i_input_xml          = lv_xml_str
        i_token_flg          = ' '
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
    ELSE.
      IF ( ( gv_scode = '200' OR gv_scode = '201' ) AND  (  l_res <> 0 ) ).
        WRITE:/2 'Job run date & time:' COLOR 3,26 sy-datum COLOR 3,38 sy-uzeit COLOR 3.
        IF gt_output[] IS NOT INITIAL.
          WRITE:/2 'The Below RFQ Data Dispatched to Portal:'.
        ENDIF.
        LOOP AT gt_output INTO DATA(wa_output).
          WRITE:/2 wa_output-value.
          CLEAR:wa_output.
        ENDLOOP.
        REFRESH gt_output[].
      ELSE.
        IF ( ( gv_scode = '200' OR gv_scode = '201' ) AND  (  l_res = 0 ) ).
          MESSAGE 'RFQ data dispatched successfully!' TYPE 'S'.
        ELSEIF l_res = 0 AND gv_scode <> '200'.
          MESSAGE 'RFQ data dispatch failed!' TYPE 'S'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_JOB_INTERVAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_job_interval .
  lv_db_table = '/sdocs/sspy_jlog'.
  SELECT SINGLE * FROM (lv_db_table) INTO @wa_job_slog WHERE prog_name = '/SDOCS/S1_RFQ_DATA_DISPATCH'
                                                          AND prog_type = 'HTTP_CALL'.
  IF sy-subrc EQ 0 AND wa_job_slog-jlog_date IS NOT INITIAL AND wa_job_slog-jlog_time  IS NOT INITIAL.
    lr_date-low = wa_job_slog-jlog_date.
    lr_date-high = sy-datum.
    lr_date-option = 'BT'.
    lr_date-sign   = 'I'.
    APPEND lr_date.
    IF wa_job_slog-jlog_date <> sy-datum.
      wa_job_slog-jlog_time = '000000'.
    ENDIF.
    lr_time-low = wa_job_slog-jlog_time.
    lr_time-high = sy-uzeit.
    lr_time-option = 'BT'.
    lr_time-sign   = 'I'.
    APPEND lr_time.
  ELSE.
    lr_date-low = sy-datum.
    lr_date-high = sy-datum.
    lr_date-option = 'BT'.
    lr_date-sign   = 'I'.
    APPEND lr_date.
    lr_time-low = ( sy-uzeit - 1200 ).
    lr_time-high = sy-uzeit.
    lr_time-option = 'BT'.
    lr_time-sign   = 'I'.
    APPEND lr_time.
  ENDIF.
  gv_curr_date = lr_date-high.
  gv_curr_time = lr_time-high.
ENDFORM.
