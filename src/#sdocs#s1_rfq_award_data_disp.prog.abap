*&---------------------------------------------------------------------*
*& Report /SDOCS/S1_RFQ_AWARD_DATA_DISP
*&---------------------------------------------------------------------*
*& Developer:    K.Rupesh                                                        *
*& Created Date: 28.06.2022                                                      *
*& Description  : This program is for getting the Invoice and expenses submission
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
*&---------------------------------------------------------------------*
REPORT /sdocs/s1_rfq_award_data_disp.
INCLUDE /sdocs/sspy_incl_dispdata.
TYPES: BEGIN OF gs_ekko,
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
         ausnr type ekko-ausnr,
         ktwrt TYPE ekko-ktwrt,
       END OF gs_ekko.
 types : begin of ty_lfa11,
         lifnr type lfa1-lifnr,
        land1 type lfa1-land1,
       name1 type lfa1-name1,
   name2 type lfa1-name2,
    adrnr type lfa1-adrnr,
   end of ty_lfa11.
   data: lt_lfa1 type table of ty_lfa11.

TYPES: BEGIN OF ty_rfq_h,
         ebeln TYPE ekko-ebeln,
         bstyp TYPE ekko-bstyp,
         lifnr TYPE ekko-lifnr,
       END OF  ty_rfq_h.
types: begin of ty_ekko1,
     ebeln type ekko-ebeln,
     submi type ekko-submi,
  end of ty_ekko1.
  data: lt_ekko type table of gs_ekko.

TYPES: BEGIN OF gs_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         txz01 TYPE ekpo-txz01,
         matnr TYPE ekpo-matnr,
         matkl TYPE ekpo-matkl,
         ktmng TYPE ekpo-ktmng,
         meins TYPE ekpo-meins,
       END OF gs_ekpo.

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
         manfr_part_no   TYPE char20,
       END OF ty_rfq_ln.

TYPES: BEGIN OF ty_vendors,
         vendor TYPE lfa1-lifnr,
       END OF ty_vendors.

TYPES: BEGIN OF ty_cdpos,
        OBJECTID TYPE CDOBJECTV,
       END OF ty_cdpos.


TYPES: BEGIN OF ty_bidder_details,
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

DATA:BEGIN OF gt_output1 OCCURS 0,
       rfq_no TYPE ekko-ebeln,
     END OF gt_output1.

DATA:BEGIN OF lt_objid OCCURS 0,
       object_id TYPE	toa01-object_id,
     END OF lt_objid.

TYPES: BEGIN OF ts_eket,
         ebeln TYPE eket-ebeln,
         ebelp TYPE eket-ebelp,
         etenr TYPE eket-etenr,
         eindt TYPE eket-eindt,
         menge type eket-menge,
       END OF ts_eket.




DATA: t_bidders  TYPE TABLE OF ty_bidder_details,
      gt_ekko    TYPE TABLE OF gs_ekko,
      gt_rmails  TYPE TABLE OF gs_reqmail,
      gt_attach  TYPE TABLE OF   ty_attach,
      gt_toaat   TYPE TABLE OF toaat,
      gt_eket    TYPE TABLE OF ts_eket,
      t_rfq_h    TYPE TABLE OF ty_rfq_h,
      t_rfq_ln   TYPE TABLE OF ty_rfq_ln,
      lt_vendors TYPE TABLE OF ty_vendors,
      t_attach   TYPE TABLE OF ty_attach,
      gt_uname   TYPE TABLE OF v_usr_name,
      lt_cdpos   TYPE TABLE OF ty_cdpos,
      gt_ln      TYPE TABLE OF gs_ekpo.

DATA:wa_ln       TYPE gs_ekpo,
     wa_job_slog TYPE /sdocs/sspy_jlog,
     wa_ekko     TYPE gs_ekko,
     wa_attach   TYPE ty_attach,
     l_rfq_h     TYPE ty_rfq_h,
     l_rfq_ln    TYPE ty_rfq_ln,
     l_vendors   TYPE ty_vendors,
     l_attach    TYPE ty_attach,
     l_bidders   TYPE ty_bidder_details.

DATA:lv_flag,
     lv_config_value TYPE /sdocs/sspy_sgc-config_value,
     gv_ebeln        TYPE ekko-ebeln,
     gv_aedat        TYPE ekpo-aedat.

RANGES:lr_date FOR sy-datum,
       lr_time FOR sy-uzeit.
TYPES: BEGIN OF ty_adr6,
         addrnumber TYPE ad_addrnum,
         persnumber TYPE ad_persnum,
         date_from  TYPE ad_date_fr,
         consnumber TYPE ad_consnum,
         smtp_addr  TYPE ad_smtpadr,
       END OF ty_adr6.
DATA:lt_adr6 TYPE TABLE OF ty_adr6,
      lv_db_table type char50.

types : begin of ty_award,
*{   INSERT         S4HK903108                                        1
ebeln type ebeln,
  lifnr type lifnr,
        award type char1,
  end of ty_award.
 data: lt_awarded TYPE STANDARD TABLE OF ty_award,
       lv_ausnr type ekko-ausnr.
*}   INSERT
*{   DELETE         S4HK903108                                        2
*\  ebeln type ebeln,
*\        award type char1,
*\  end of ty_award.
*}   DELETE
  data: lt_buy_hd type table of ty_award.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:p_profle TYPE /sdocs/sspy_sprf-profile_id OBLIGATORY,
             p_tk_ext TYPE /sdocs/sspy_http_ext DEFAULT '',
             p_ext    TYPE /sdocs/sspy_http_ext DEFAULT '',
             p_bsize  TYPE int4 DEFAULT 5,
             p_retry  TYPE int4 DEFAULT 1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  SELECT-OPTIONS:s_rfq FOR gv_ebeln,
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
  WRITE:/ ''.
  WRITE:/ ''.
  WRITE:/ 'Program completed successfully'.
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
             utime  IN lr_time   AND change_ind IN ('U' , 'I'). "#EC CI_NOFIRST "#EC CI_NO_TRANSFORM .

*      IF lt_cdhdr IS NOT INITIAL.
*        lv_db_table = 'cdpos'.
*        SELECT objectid FROM (lv_db_table)
*          INTO TABLE @lt_cdpos
*          FOR ALL ENTRIES IN @lt_cdhdr
*          WHERE objectid = @lt_cdhdr-objectid
*          AND fname = 'ABSKZ'
*          AND value_new = 'X'. "#EC CI_NO_TRANSFORM "#EC CI_NOFIRST  .
*      ENDIF.
      LOOP AT lt_cdhdr INTO DATA(l_cdhdr).
        MOVE l_cdhdr-objectid TO l_po-ebeln.
        APPEND l_po TO lt_po.
        CLEAR: l_po,l_cdhdr.
      ENDLOOP.


      CLEAR: lt_cdpos.
*{   INSERT         S4HK903108                                        2
lv_db_table = '/SDOCS/S1_BUY_HD'.
select ebeln,
     lifnr,
      award from (lv_db_table) into table @lt_buy_hd  for all entries in @lt_po where ebeln = @lt_po-ebeln and award = 'X' and psuccess = '' .

*}   INSERT
*{   DELETE         S4HK903108                                        7
*\      lv_db_table = '/SDOCS/S1_BUY_HD'.
*}   DELETE
*{   DELETE         S4HK903108                                        1
*\ select ebeln, award from (lv_db_table) into table @lt_buy_hd  for all entries in @lt_po where ebeln = @lt_po-ebeln and award = 'X' and psuccess = '' .
*}   DELETE
      IF lt_po[] IS NOT INITIAL.


      lv_db_table = 'ekko'.
*        SELECT ebeln   FROM (lv_db_table) INTO CORRESPONDING FIELDS OF TABLE @lt_ekko FOR ALL ENTRIES IN @lt_po[] WHERE ebeln = @lt_po-ebeln AND bstyp = 'O' and PROCSTAT = '03'. "#EC CI_NO_TRANSFORM                         "#EC CI_NO_TRANSFORM
*           bstyp,
*           aedat,
*           ernam,
*           lifnr,
*           ekorg,
*           ekgrp,
*           waers,
*           kdatb,
*           kdate,
*           ausnr,
*           ktwrt,
*           procstat FROM (lv_db_table) INTO CORRESPONDING FIELDS OF TABLE @lt_ekko FOR ALL ENTRIES IN @lt_po[] WHERE ebeln = @lt_po-ebeln AND bstyp = 'O' and PROCSTAT = '03'. "#EC CI_NO_TRANSFORM

*{   DELETE         S4HK903108                                        4
*\        SELECT ebeln,                              "#EC CI_NO_TRANSFORM
*\           bstyp,
*\           aedat,
*\           ernam,
*\           lifnr,
*\           ekorg,
*\           ekgrp,
*\           waers,
*\           kdatb,
*\           kdate,
*\          ausnr,
*}   DELETE
*{   INSERT         S4HK903108                                        3

loop at lt_buy_hd into data(ls_buy_hd) where award = 'X'.
* append ls_buy_hd to lt_awarded.

lv_ausnr = ls_buy_hd-ebeln.
ls_buy_hd-lifnr = |{ ls_buy_hd-lifnr ALPHA = IN }|.
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
         ausnr,
         ktwrt
    FROM (lv_db_table)
    INTO TABLE @lt_ekko
*    FOR ALL ENTRIES IN @lt_awarded
    WHERE  ausnr = @lv_ausnr
      AND lifnr = @ls_buy_hd-lifnr  .

 endloop.

*   FOR ALL ENTRIES IN @lt_buy_hd WHERE ausnr = @lt_buy_hd-ebeln. " and bstyp = 'A'."#EC CI_NO_TRANSFORM #EC CI_NO_TRANSFORM

  endif.
*}   INSERT
*{   DELETE         S4HK903108                                        5
*\           ktwrt  FROM (lv_db_table) INTO TABLE @lt_ekko FOR ALL ENTRIES IN @lt_buy_hd WHERE ausnr = @lt_buy_hd-ebeln." and bstyp = 'A'."#EC CI_NO_TRANSFORM #EC CI_NO_TRANSFORM
*}   DELETE

*{   DELETE         S4HK903108                                        6
*\      ENDIF.
*}   DELETE
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
               ausnr,
                ktwrt FROM (lv_db_table) INTO TABLE @lt_ekko  WHERE ebeln IN @s_rfq AND aedat IN @s_cdate AND bstyp = 'O' and PROCSTAT = '03'.

*      IF lt_ekko[] IS NOT INITIAL.
*        SELECT ebeln,
*               bstyp,
*               aedat,
*               ernam,
*               lifnr,
*               ekorg,
*               ekgrp,
*               waers,
*               kdatb,
*               kdate,
*               ktwrt  FROM (lv_db_table) FOR ALL ENTRIES IN @lt_ekko
*                      WHERE ebeln = @lt_ekko-ebeln
*                      INTO TABLE  @gt_ekko .       "#EC CI_NO_TRANSFORM
*      ENDIF.

  ENDCASE.

  IF lt_ekko IS NOT INITIAL.
    lv_db_table = 'ekpo'.
    SELECT ebeln,
           ebelp,
           matnr,
           txz01,
           matkl,
           ktmng,
           meins
           FROM (lv_db_table) INTO TABLE @gt_ln FOR ALL ENTRIES IN @lt_ekko WHERE ebeln = @lt_ekko-ebeln AND loekz = ' '. "#EC CI_NO_TRANSFORM
    IF sy-subrc = 0.
      lv_db_table = 'eket'.
      SELECT ebeln,
             ebelp,
             etenr,
             eindt ,
             menge FROM (lv_db_table) INTO TABLE @gt_eket FOR ALL ENTRIES IN @gt_ln WHERE ebeln  = @gt_ln-ebeln AND ebelp = @gt_ln-ebelp.

    ENDIF.
    lv_db_table = 'lfa1'.
    SELECT lifnr,land1,name1,name2,adrnr FROM (lv_db_table) INTO TABLE @lt_lfa1 FOR ALL ENTRIES IN @lt_ekko WHERE lifnr = @lt_ekko-lifnr. "#EC CI_NO_TRANSFORM
     IF lt_lfa1 IS NOT INITIAL.
      lv_db_table = 'adr6'.
      SELECT addrnumber,persnumber,date_from,consnumber,smtp_addr FROM (lv_db_table) INTO TABLE @lt_adr6 FOR ALL ENTRIES IN @lt_lfa1 WHERE addrnumber = @lt_lfa1-adrnr. "#EC CI_NO_TRANSFORM
    ENDIF.

    LOOP AT lt_lfa1 INTO DATA(l_lfa1).
      READ TABLE lt_adr6 INTO DATA(l_adr6) WITH KEY addrnumber = l_lfa1-Adrnr.
      l_bidders-vendor        =  l_lfa1-lifnr.
      CONCATENATE l_lfa1-Name1 l_lfa1-name2 INTO l_bidders-vendor_name  SEPARATED BY space.
      l_bidders-contact_email   = l_adr6-smtp_addr.
      l_bidders-country         = l_lfa1-land1.
      APPEND l_bidders TO t_bidders.
      CLEAR:l_bidders,l_lfa1,l_adr6.
    ENDLOOP.

  ENDIF.

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
if gv_success = 'X'.
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
 LOOP AT lt_ekko INTO  DATA(wa_ekko)   FROM gv_from TO gv_to.
   lv_db_table = '/sdocs/s1_buy_hd'.
   update (lv_db_table) set psuccess = 'X' where ebeln = @wa_ekko-ausnr and award = 'X'.
  endloop.
  enddo.

  endif.
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
*&      Form  PUSH_DATA_TO_PORTAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM push_data_to_portal .
  DATA:lv_objectid   TYPE saeobjid,
       lv_amount(30) TYPE c.
  CLEAR:gv_cnt,gv_div,gv_from,gv_to,lv_objectid,lv_amount.

  DESCRIBE TABLE gt_ekko LINES gv_cnt.

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
    gs_xml-line = '<RFX_AWARDDATA_TRANSMIT>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.
    gs_xml-line = '<RFX_AWARDDATA>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    LOOP AT lt_ekko INTO  DATA(wa_ekko)   FROM gv_from TO gv_to.
      READ TABLE t_bidders INTO l_bidders WITH KEY vendor = wa_ekko-lifnr.
      CONCATENATE '<GUID>'  '</GUID>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.
    CONCATENATE '<RFX_NO>' wa_ekko-ausnr '</RFX_NO>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      CONCATENATE '<RFX_NAME>'  '</RFX_NAME>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      APPEND wa_ekko-ebeln TO gt_output1.
      gs_xml-line = '<AWARDS>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.
       gs_xml-line = '<AWARD>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.



      SHIFT wa_ekko-lifnr LEFT DELETING LEADING '0'.
      CONCATENATE '<BIDDER_ID>' wa_ekko-lifnr '</BIDDER_ID>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.
 CONCATENATE '<BIDDER_Company>' wa_ekko-lifnr '</BIDDER_Company>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.
      CONCATENATE '<BIDDER_CONTACT>'  '</BIDDER_CONTACT>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      CONCATENATE '<BID_CNCTC_EMAIL>' l_bidders-contact_email '</BID_CNCTC_EMAIL>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR:gs_xml,l_bidders.
       CONCATENATE '<QUOT_NO>' wa_ekko-ebeln '</QUOT_NO>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      gs_xml-line = '<LINEITEMS>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.

      LOOP AT gt_ln INTO DATA(wa_ln) WHERE ebeln = wa_ekko-ebeln.
        READ TABLE gt_eket INTO DATA(wa_eket) WITH KEY ebeln = wa_ln-ebeln ebelp = wa_ln-ebelp.
        gs_xml-line = '<LINEITEM>'.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.
  CONCATENATE '<LGUID>' '</LGUID>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.
        SHIFT wa_ln-ebelp LEFT DELETING LEADING '0'.
        CONCATENATE '<LINENO>' wa_ln-ebelp '</LINENO>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<ITM_TYPE>' wa_ekko-bstyp'</ITM_TYPE>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<PRDCT_ID>'  wa_ln-matnr '</PRDCT_ID>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.


        CONCATENATE '<PRDCT_DES>' wa_ln-txz01 '</PRDCT_DES>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<PRDCT_CAT>' wa_ln-matkl '</PRDCT_CAT>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        lv_amount = conv string( wa_eket-menge ).
        CONDENSE lv_amount  NO-GAPS.
        CONCATENATE '<QTY>' lv_amount '</QTY>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<UOM>' wa_ln-meins '</UOM>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<CURRENCY>'  '</CURRENCY>' INTO gs_xml-line. "l_rfq_ln-currency
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<DEL_DATE>' wa_eket-eindt '</DEL_DATE>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        CONCATENATE '<MPN>'  '</MPN>' INTO gs_xml-line.
        APPEND gs_xml TO gt_xml.CLEAR gs_xml.

        gs_xml-line = '</LINEITEM>'.
        APPEND gs_xml TO gt_xml.CLEAR:wa_eket,gs_xml.
      ENDLOOP.

      gs_xml-line = '</LINEITEMS>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.
            gs_xml-line = '</AWARD>'.
      APPEND gs_xml TO gt_xml.CLEAR:l_bidders,gs_xml.

      gs_xml-line = '</AWARDS>'.
      APPEND gs_xml TO gt_xml.CLEAR:l_bidders,gs_xml.
    ENDLOOP.
    gs_xml-line = '</RFX_AWARDDATA>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.
    gs_xml-line = '</RFX_AWARDDATA_TRANSMIT>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.
    PERFORM dispatch_data_to_portal.
  ENDDO.
  IF p_delta IS NOT INITIAL AND lv_flag IS NOT INITIAL.
    wa_job_slog-prog_name = '/SDOCS/S1_RFQ_AWARD_DATA_DISP'.
    wa_job_slog-prog_type = 'HTTP_CALL'.
    wa_job_slog-jlog_date    = gv_curr_date.
    wa_job_slog-jlog_time    = gv_curr_time.
    lv_db_table = '/sdocs/sspy_jlog'.
    MODIFY (lv_db_table) FROM wa_job_slog.
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
*&      Form  GET_JOB_INTERVAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_job_interval .
  lv_db_table = '/sdocs/sspy_jlog'.
  SELECT SINGLE * FROM (lv_db_table) INTO @wa_job_slog WHERE prog_name = '/SDOCS/S1_RFQ_AWARD_DATA_DISP'
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
      IF gv_scode = '200' OR gv_scode = '201'.
        WRITE:/2 'Job run date & time:' COLOR 3,26 sy-datum COLOR 3,38 sy-uzeit COLOR 3.
        SKIP 2.
        WRITE:/2 'Below are the RFQ Award Data Dispatched:'.
      ELSE.
        LOOP AT gt_output1 INTO DATA(wa_output).
          WRITE:/2 wa_output-rfq_no.
          CLEAR:wa_output.
        ENDLOOP.
        REFRESH gt_output[].
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
