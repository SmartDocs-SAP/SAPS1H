

*-------------------------------------------------------------*
************************Copied from LnT NPL***********************
*&---------------------------------------------------------------------*
*& Report  /SDOCS/SSPAY_PO_DATA_DISPATCH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT /sdocs/sspay_contract_dispatch.


INCLUDE /sdocs/sspy_incl_dispdata.
TABLES:ekko.
DATA:BEGIN OF gt_sta OCCURS 0.
        INCLUDE STRUCTURE  jstat.
DATA:  txt30 TYPE tj02t-txt30,
       END OF gt_sta.

DATA:BEGIN OF po_dis OCCURS 0,
       ebeln TYPE ekko-ebeln,
     END OF po_dis.

TYPES:BEGIN OF po_eket,
        ebeln TYPE eket-ebeln,
        ebelp TYPE eket-ebelp,
        eindt TYPE eket-eindt,
      END OF po_eket.

TYPES:BEGIN OF tt_nast,
        kappl TYPE nast-kappl,
        objky TYPE nast-objky,
        nacha TYPE nast-nacha,
      END OF tt_nast.

DATA:BEGIN OF t_toa01 OCCURS 0,
       object_id TYPE toa01-object_id,
     END OF t_toa01.

DATA:BEGIN OF it_toa01 OCCURS 0,
       object_id  TYPE toa01-object_id,
       archiv_id  TYPE toa01-archiv_id,
       arc_doc_id TYPE toa01-arc_doc_id,
       ar_object  TYPE toa01-ar_object,
       ar_date    TYPE toa01-ar_date,
       reserve    TYPE toa01-reserve,
     END OF it_toa01.


types : begin of ty_usr21,
  bname type usr21-bname,
  persnumber type usr21-persnumber,
  end of ty_usr21.
data: lt_usr21 type table of ty_usr21.

types : begin of ty_adr6,
   persnumber type adr6-persnumber,
   smtp_addr type adr6-smtp_addr,
  end of ty_adr6.
data: lt_adr6 type table of ty_adr6.
DATA:BEGIN OF it_t001k OCCURS 0,
       bukrs TYPE t001k-bukrs,
       bwkey TYPE t001k-bwkey,
     END OF it_t001k.

DATA:BEGIN OF it_t001w OCCURS 0,
       werks      TYPE t001w-werks,
       j_1bbranch TYPE t001w-j_1bbranch,
     END OF it_t001w.

DATA:BEGIN OF it_1bbranch OCCURS 0,
       bukrs  TYPE j_1bbranch-bukrs,
       branch TYPE j_1bbranch-branch,
       stcd1  TYPE j_1bbranch-stcd1,
       stcd2  TYPE j_1bbranch-stcd2,
*       GSTIN  TYPE J_1BBRANCH-GSTIN,
     END OF it_1bbranch.

DATA:BEGIN OF lt_lifnr OCCURS 0,
       lifnr TYPE lfa1-lifnr,
     END OF lt_lifnr.

TYPES:BEGIN OF tt_t024,
        ekgrp     TYPE t024-ekgrp,
        smtp_addr TYPE t024-smtp_addr,
      END OF tt_t024.

TYPES:BEGIN OF tt_t007s,
        mwskz TYPE t007s-mwskz,
        text1 TYPE t007s-text1,
      END OF tt_t007s.

TYPES: BEGIN OF tt_ekpo,
         ebeln   TYPE ekpo-ebeln,
         ebelp   TYPE ekpo-ebelp,
         loekz   TYPE ekpo-loekz,
         txz01   TYPE ekpo-txz01,
         matnr   TYPE ekpo-matnr,
         bukrs   TYPE ekpo-bukrs,
         werks   TYPE ekpo-werks,
         lgort   TYPE ekpo-lgort,
         ktmng   TYPE ekpo-ktmng,
         menge   TYPE ekpo-menge,
         meins   TYPE ekpo-meins,
         bprme   TYPE ekpo-bprme,
         bpumz   TYPE ekpo-bpumz,
         bpumn   TYPE ekpo-bpumn,
         netpr   TYPE ekpo-netpr,
         peinh   TYPE ekpo-peinh,
         netwr   TYPE ekpo-netwr,
         mwskz   TYPE ekpo-mwskz,
         elikz   TYPE ekpo-elikz,
         erekz   TYPE ekpo-erekz,
         pstyp   TYPE ekpo-pstyp,
         wepos   TYPE ekpo-wepos,
         adrnr   TYPE ekpo-adrnr,
         packno  TYPE ekpo-packno,
         j_1bnbm TYPE ekpo-j_1bnbm,
         mfrpn   TYPE ekpo-mfrpn,
         webre   TYPE ekpo-webre,
       END OF tt_ekpo.

TYPES: BEGIN OF tt_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         bsart TYPE ekko-bsart,
         aedat TYPE ekko-aedat,
         ernam TYPE ekko-ernam,
         lifnr TYPE ekko-lifnr,
         zterm TYPE ekko-zterm,
         ekorg TYPE ekko-ekorg,
         ekgrp TYPE ekko-ekgrp,
         waers TYPE ekko-waers,
         kdatb TYPE ekko-kdatb,
         kdate TYPE ekko-kdate,
         inco1 TYPE ekko-inco1,
         inco2 TYPE ekko-inco2,
         frggr TYPE ekko-frggr,
         frgrl TYPE ekko-frgrl,
         rettp TYPE ekko-rettp,
       END OF tt_ekko.


TYPES:BEGIN OF tt_attach,
        ebeln     TYPE ebeln,
        arc_id    TYPE /sdocs/sspy_atta-arc_id,
        arc_docid TYPE /sdocs/sspy_atta-arc_docid,
        file_type TYPE /sdocs/sspy_atta-file_type,
        file_name TYPE /sdocs/sspy_atta-file_name,
*        CREATOR   TYPE /SDOCS/SSPY_ATTA-CREATOR,
        cr_date   TYPE /sdocs/sspy_atta-cr_date,
        cr_time   TYPE /sdocs/sspy_atta-cr_time,
      END OF tt_attach.

TYPES: BEGIN OF tt_lfa1,
         lifnr TYPE lfa1-lifnr,
         land1 TYPE lfa1-land1,
         name1 TYPE lfa1-name1,
         ort01 TYPE lfa1-ort01,
         pstlz TYPE lfa1-pstlz,
         regio TYPE lfa1-regio,
         stras TYPE lfa1-stras,
         adrnr TYPE lfa1-adrnr,
       END OF tt_lfa1.
 types : begin of ty_esll,
       sub_packno type sub_packno,
   end of ty_esll.
  data: lt_esll type table of ty_esll.

TYPES: BEGIN OF ty_ekbe,
         ebeln TYPE ekbe-ebeln,
         ebelp TYPE ekbe-ebelp,
         zekkn TYPE ekbe-zekkn,
         vgabe TYPE ekbe-vgabe,
         gjahr TYPE ekbe-gjahr,
         belnr TYPE ekbe-belnr,
         buzei TYPE ekbe-buzei,
         bewtp TYPE ekbe-bewtp,
         bwart TYPE ekbe-bwart,
         menge TYPE ekbe-menge,
         bpmng TYPE ekbe-bpmng,
         shkzg TYPE ekbe-shkzg,
       END OF ty_ekbe.

DATA:gt_ekbe1 TYPE TABLE OF ty_ekbe,
     wa_ekbe1 TYPE ty_ekbe.

DATA:qt_lfa1 TYPE TABLE OF tt_lfa1.

DATA: gv_selected_value(10) TYPE c,
      gv_changed_str_to     TYPE string,
      gv_amount             TYPE char20,
      gv_supplierid         TYPE lifnr,
      gv_supplierid1        TYPE lifnr,
      gv_val2               TYPE char32,
      gv_out                TYPE string,
      gv_ecc_lsystem        TYPE /sdocs/sspy_sgc-config_value, "CRMT_LOGSYS,
      gv_buyer              TYPE adr6-smtp_addr,
      gv_po_crdate          TYPE sy-datum.

DATA: gt_values  TYPE TABLE OF dynpread,
      gt_tj02t   TYPE TABLE OF tj02t,
      gt_options TYPE TABLE OF rfc_db_opt,
      gt_fields  TYPE TABLE OF rfc_db_fld,
      gt_return  TYPE STANDARD TABLE OF ddshretval,
      gt_data1   TYPE TABLE OF tab512,
      gt_list    TYPE vrm_values,
      gt_polist  TYPE STANDARD TABLE OF tt_ekko, "EKKO,
      gt_nast    TYPE TABLE OF tt_nast,
      gt_nast2   TYPE TABLE OF tt_nast,
      gt_items   TYPE STANDARD TABLE OF tt_ekpo, "EKPO,
      gt_eket    TYPE TABLE OF po_eket,
      gt_t024    TYPE TABLE OF tt_t024, "T024,
      wa_t024    TYPE tt_t024. "T024.


DATA:wa_list          TYPE vrm_value,
     wa_values        TYPE dynpread,
     wa_tj02t         TYPE tj02t,
     wa_options       TYPE rfc_db_opt,
     wa_fields        TYPE rfc_db_fld,
     wa_data          TYPE tab512,
     wa_polist        TYPE tt_ekko, "EKKO,
     wa_items         TYPE tt_ekpo, "EKPO,
     wa_eket          TYPE po_eket,
     wa_return        LIKE LINE OF gt_return,
     gv_http_sflag    TYPE flag,
     gv_flag          TYPE char1,
     wa_sta           LIKE LINE OF gt_sta,
     gs_nast          TYPE tt_nast,
     gv_cur_date      TYPE sy-datum,
     gv_cur_time      TYPE sy-uzeit,
     gv_noemail_notif ,
     lv_oa_clear      TYPE /sdocs/sspy_sgc-config_value, "CHAR1,
     lv_add(3)        TYPE c,
     gt_t007s         TYPE TABLE OF tt_t007s.

TYPES:BEGIN OF fs_stat,
        stat  TYPE jstat-stat,
        inact TYPE jstat-inact,
      END OF fs_stat.
types : begin of ty_temp_esll,
     packno type packno,
     menge type mengev,
  end of ty_temp_esll.
 data: it_temp_esll type table of ty_temp_esll.

DATA:wa_stat TYPE fs_stat,
     it_stat TYPE TABLE OF fs_stat.

DATA:r_ebeln TYPE ekko-ebeln,
     r_aedat TYPE ekko-aedat.

DATA:t_attach TYPE TABLE OF tt_attach,
     l_attach TYPE tt_attach.

TYPES:BEGIN OF fs_usrlist,
        bname     TYPE usr21-bname,
        smtp_addr TYPE adr6-smtp_addr,
      END OF fs_usrlist.
DATA:wa_usrlist TYPE fs_usrlist,
     t_usrlist  TYPE TABLE OF fs_usrlist.
DATA:lv_config_value TYPE /sdocs/sspy_sgc-config_value.
RANGES:lr_date FOR sy-datum,
       lr_time FOR sy-uzeit.
DATA:wa_job_slog TYPE /sdocs/sspy_jlog.
DATA:wa_po_sf TYPE /sdocs/s1_st_archpo.
DATA:it_po_sf TYPE TABLE OF /sdocs/s1_st_archpo.
DATA:gv_sf_fmname TYPE rs38l_fnam."/sdocs/sspy_sgc-config_value.
DATA:gv_sf_taxfm    TYPE rs38l_fnam,
     gv_tax_input   TYPE /sdocs/s1_tax_input,
     gv_bg_objid    TYPE thead-tdid,
     gv_ld_objid    TYPE thead-tdid,
     gt_tax_output  TYPE TABLE OF /sdocs/s1_tax_output WITH HEADER LINE,
     lv_tax_per(18) TYPE c.
TYPES:BEGIN OF fs_ekbe,
        ebeln TYPE ekbe-ebeln,
        ebelp TYPE ekbe-ebelp,
        vgabe TYPE ekbe-vgabe,
        bewtp TYPE ekbe-bewtp,
        menge TYPE ekbe-menge,
        dmbtr TYPE ekbe-dmbtr,
      END OF fs_ekbe.
types : begin of ty_essr,
    packno type packno,
  end of ty_essr.
 data: lt_essr type table of ty_essr.
DATA:wa_ekbe TYPE fs_ekbe,
     gt_ekbe TYPE TABLE OF fs_ekbe.
DATA:lt_t163y TYPE TABLE OF t163y,
     wa_t163y TYPE t163y.

DATA:lv_tax_code  TYPE mwskz,
     lv_tax_amt   TYPE mwsbp,
     lv_tax_prcnt TYPE kbetr_kond,
     lv_db_table type char50.

DATA:lv_tdid   TYPE thead-tdid,
     lv_ebeln  TYPE thead-tdname,
     lv_flag   TYPE flag,
     gv_sdtext TYPE string.
DATA:t_lines TYPE TABLE OF tline,
     l_lines TYPE tline.
DATA:lv_characters  TYPE string VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:p_profle TYPE /sdocs/sspy_sprf-profile_id OBLIGATORY,
           p_tk_ext TYPE /sdocs/sspy_http_ext DEFAULT '',
           p_ext    TYPE /sdocs/sspy_http_ext DEFAULT '',
           p_bsize  TYPE int4 DEFAULT 5,
           p_retry  TYPE int4 DEFAULT 1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
SELECT-OPTIONS:s_ebeln FOR r_ebeln,
               s_aedat FOR r_aedat.
*                 S_EPO   FOR EKKO-EBELN NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b2.
PARAMETERS:p_delta AS CHECKBOX.

INITIALIZATION.
  CLEAR:gv_server,gv_ecc_lsystem,gv_sf_fmname,gv_sf_taxfm.
  REFRESH: gt_polist,gt_items,gt_eket,gt_t007s[].
  CLEAR wa_eket.

AT SELECTION-SCREEN OUTPUT.
  p_profle = sy-sysid.
  LOOP AT SCREEN.
    IF screen-name = 'P_PROFLE'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_sf_fmname
                                                  WHERE config = 'FMNAME_FORSF_FROMPO'.
  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_sf_taxfm
                                                  WHERE config = 'PO_TAX_FM'.
  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_bg_objid
                                                  WHERE config = 'BG_EXISTS_OBJECTID'.
  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_ld_objid
                                                  WHERE config = 'LD_EXISTS_OBJECTID'.

  PERFORM get_data.

  IF p_bsize IS INITIAL.
    p_bsize = 10.
  ENDIF.

  IF p_bsize GT 50.
    MESSAGE s000(/sdocs/sspay_msg) WITH 'Please maintain batch size less than or equal to 50'.
    EXIT.
  ENDIF.

  CLEAR:gv_enable_token.
  SELECT SINGLE config_value INTO gv_enable_token FROM /sdocs/sspy_sgc WHERE config = 'HTTP_TOKEN_ENABLE'.
  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_data_to_file WHERE config = 'DATA_TRANSFER_VIA_FILE'.
  IF gv_enable_token IS NOT INITIAL.
    IF gt_polist[] IS NOT INITIAL.
      PERFORM portal_authitication.
      IF gv_token IS NOT INITIAL AND ( gv_scode = '200' OR gv_scode = '201' ).
        PERFORM push_data_to_portal.
      ELSE.
        MESSAGE s001(/sdocs/sspay_msg).
      ENDIF.
    ELSE.
      MESSAGE s002(/sdocs/sspay_msg).
    ENDIF.
  ELSE.
    IF gt_polist[] IS INITIAL.
      MESSAGE s002(/sdocs/sspay_msg).
    ELSE.
      PERFORM push_data_to_portal.
    ENDIF.
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
  DATA:gv_cnt    TYPE i,
       lv_add(3) TYPE c.
  TYPES:BEGIN OF fs_cdhdr,
          objectclas TYPE cdhdr-objectclas,
          objectid   TYPE cdhdr-objectid,
        END OF fs_cdhdr.
  DATA:it_cdhdr TYPE TABLE OF fs_cdhdr WITH HEADER LINE.
  DATA:BEGIN OF lt_po OCCURS 0 ,
        ebeln TYPE ekko-ebeln,
       END OF lt_po.
  DATA:l_po LIKE LINE OF  lt_po,
       lv_db_table type char50.

  REFRESH:gt_nast2,gt_nast,t_attach,lt_lifnr[],gt_polist[],qt_lfa1[],gt_ekbe,t_toa01[].
  CLEAR:lv_config_value.

  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO lv_config_value WHERE config = 'DEFAULT_ARCHIV_ID'.
  IF s_aedat IS NOT INITIAL OR s_ebeln IS NOT INITIAL.
    p_delta = ''.
  ENDIF.
  CASE p_delta.
    WHEN 'X'.
      REFRESH:it_cdhdr,lt_po,gt_polist.
      CLEAR:it_cdhdr.
      PERFORM get_job_interval.
      gv_curr_date = sy-datum.
      gv_curr_time = sy-uzeit.
      lv_db_table = 'cdhdr'.
      SELECT objectclas
             objectid FROM (lv_db_table) INTO TABLE it_cdhdr WHERE objectclas = 'EINKBELEG' AND udate IN lr_date AND
             utime  IN lr_time   AND change_ind IN ('U' , 'I').
*       SELECT * FROM CDHDR INTO TABLE LT_CDHDR WHERE OBJECTCLAS = 'EINKBELEG' AND UDATE = SY-DATUM AND TCODE = 'ME22N'.
      lv_db_table = 'ekbe'.
      SELECT ebeln INTO TABLE @lt_po FROM (lv_db_table) WHERE vgabe = '1' AND cpudt IN @lr_date AND  cputm  IN @lr_time. "#EC CI_NOFIRST
      LOOP AT it_cdhdr.
        MOVE it_cdhdr-objectid TO l_po-ebeln.
        APPEND l_po TO lt_po.
        CLEAR: l_po,it_cdhdr.
      ENDLOOP.

      IF lt_po[] IS NOT INITIAL.
        lv_db_table = 'ekko'.
       SELECT ebeln
               bukrs
               bsart
               aedat
               ernam
               lifnr
               zterm
               ekorg
               ekgrp
               waers
               kdatb
               kdate
               inco1
               inco2
               frggr
               frgrl
               rettp
          FROM (lv_db_table) INTO TABLE gt_polist[]
          FOR ALL ENTRIES IN lt_po[]
          WHERE ebeln = lt_po-ebeln
          AND   bstyp = 'K' ."AND FRGRL EQ ''.       "#EC CI_NO_TRANSFORM
      ENDIF.

      IF gt_polist[] IS NOT INITIAL.
        lv_db_table = 'ekpo'.
        SELECT ebeln
               ebelp
               loekz
               txz01
               matnr
               bukrs
               werks
               lgort
               ktmng
               menge
               meins
               bprme
               bpumz
               bpumn
               netpr
               peinh
               netwr
               mwskz
               elikz
               erekz
               pstyp
               wepos
               adrnr
               packno
               j_1bnbm
               mfrpn
               webre
           FROM (lv_db_table)
          INTO TABLE gt_items[]
          FOR ALL ENTRIES IN gt_polist
          WHERE ebeln = gt_polist-ebeln.           "#EC CI_NO_TRANSFORM

        lv_db_table = 'ekbe'.
        SELECT ebeln ebelp zekkn vgabe gjahr belnr buzei bewtp bwart menge bpmng shkzg FROM (lv_db_table)
        INTO TABLE gt_ekbe1 FOR ALL ENTRIES IN gt_polist[] WHERE ebeln = gt_polist-ebeln AND bewtp = 'Q'. "#EC CI_NO_TRANSFORM
      ENDIF.

    WHEN ''.
      lv_db_table = 'ekko'.
      SELECT ebeln
             bukrs
             bsart
             aedat
             ernam
             lifnr
             zterm
             ekorg
             ekgrp
             waers
             kdatb
             kdate
             inco1
             inco2
             frggr
             frgrl
             rettp
        FROM (lv_db_table)
        INTO TABLE gt_polist[]
        WHERE ebeln IN s_ebeln
        AND   aedat IN s_aedat AND bstyp = 'K'.

      IF sy-subrc NE 0.
        lv_db_table = 'ekko'.
        SELECT ebeln
               bukrs
               bsart
               aedat
               ernam
               lifnr
               zterm
               ekorg
               ekgrp
               waers
               kdatb
               kdate
               inco1
               inco2
               frggr
               frgrl
               rettp
          FROM (lv_db_table)
          INTO TABLE gt_polist[]
          WHERE ebeln IN s_ebeln
          AND   aedat IN s_aedat AND frgrl EQ ''.  "#EC CI_NO_TRANSFORM
      ENDIF.

      IF gt_polist[] IS NOT INITIAL.
        lv_db_table = 'ekpo'.
        SELECT ebeln
               ebelp
               loekz
               txz01
               matnr
               bukrs
               werks
               lgort
               ktmng
               menge
               meins
               bprme
               bpumz
               bpumn
               netpr
               peinh
               netwr
               mwskz
               elikz
               erekz
               pstyp
               wepos
               adrnr
               packno
               j_1bnbm
               mfrpn
               webre
           FROM (lv_db_table)
          INTO TABLE gt_items[]
          FOR ALL ENTRIES IN gt_polist
          WHERE ebeln = gt_polist-ebeln.           "#EC CI_NO_TRANSFORM
        lv_db_table = 'ekbe'.
        SELECT ebeln ebelp zekkn vgabe gjahr belnr buzei bewtp bwart menge bpmng shkzg FROM (lv_db_table)
        INTO TABLE gt_ekbe1 FOR ALL ENTRIES IN gt_polist[] WHERE ebeln = gt_polist-ebeln AND  bewtp = 'Q'. "#EC CI_NO_TRANSFORM

*        PERFORM PO_OPN_STATUS_PROCESS.
      ENDIF.
  ENDCASE.
*
*  LOOP AT S_EPO.
*    DELETE GT_POLIST WHERE EBELN = S_EPO-LOW.
*  ENDLOOP.

  IF gt_polist[] IS NOT INITIAL.

    LOOP AT gt_polist INTO wa_polist.
      gs_nast-objky     = wa_polist-ebeln.
      t_toa01-object_id = wa_polist-ebeln.
      APPEND gs_nast TO gt_nast2.
      APPEND t_toa01 TO t_toa01[].
      CLEAR:gs_nast,t_toa01.
    ENDLOOP.

    IF t_toa01[] IS NOT INITIAL.
      lv_db_table = 'toa01'.
      SELECT object_id,
             archiv_id,
             arc_doc_id,
             ar_object,
             ar_date,
             reserve
        FROM (lv_db_table)
        INTO TABLE @it_toa01[]
        FOR ALL ENTRIES IN @t_toa01[]
        WHERE object_id = @t_toa01-object_id.
    ENDIF.

*    select ebeln
*           ebelp
*           loekz
*           txz01
*           matnr
*           bukrs
*           werks
*           lgort
*           menge
*           meins
*           netpr
*           peinh
*           netwr
*           mwskz
*           elikz
*           pstyp
*           wepos
*           adrnr
*           j_1bnbm
*           mfrpn
*       from ekpo
*      into table gt_items[]
*      for all entries in gt_polist
*      where ebeln = gt_polist-ebeln.

    IF gt_polist[] IS NOT INITIAL.
      lv_db_table = 't001k'.
      SELECT bukrs,
             bwkey
        FROM (lv_db_table)
        INTO TABLE @it_t001k[]
        FOR ALL ENTRIES IN @gt_polist[]
        WHERE bukrs = @gt_polist-bukrs.
    ENDIF.

    IF it_t001k[] IS NOT INITIAL.
      lv_db_table = 't001w'.
      SELECT werks,
             j_1bbranch
        FROM (lv_db_table)
        INTO TABLE @it_t001w[]
        FOR ALL ENTRIES IN @it_t001k[]
        WHERE werks = @it_t001k-bwkey.
    lv_db_table = 'j_1bbranch'.
      SELECT bukrs,
             branch,
             stcd1,
             stcd2
*             GSTIN
        FROM (lv_db_table)
        INTO TABLE @it_1bbranch[]
        FOR ALL ENTRIES IN @it_t001k[]
        WHERE bukrs = @it_t001k-bukrs.
    ENDIF.
lv_db_table = 't024'.
     SELECT ekgrp smtp_addr FROM (lv_db_table) INTO TABLE gt_t024  FOR ALL ENTRIES IN gt_polist[] WHERE ekgrp = gt_polist-ekgrp.
lv_db_table = 'lfa1'.
    SELECT lifnr
         land1
         name1
         ort01
         pstlz
         regio
         stras
         adrnr
    FROM (lv_db_table)
    INTO TABLE qt_lfa1[]
    FOR ALL ENTRIES IN gt_polist[]
    WHERE lifnr = gt_polist-lifnr.
       ENDIF.


  IF gt_items[] IS NOT INITIAL.
    lv_db_table = 'eket'.
    SELECT ebeln
           ebelp
           eindt
      FROM (lv_db_table)
      INTO TABLE gt_eket
      FOR ALL ENTRIES IN gt_items[]
      WHERE ebeln = gt_items-ebeln
      AND   ebelp = gt_items-ebelp.
lv_db_table = 'ekbe'.
    SELECT ebeln
           ebelp
           vgabe
           bewtp
           menge
           dmbtr
      FROM (lv_db_table)
      INTO TABLE gt_ekbe[]
      FOR ALL ENTRIES IN gt_items[]
      WHERE ebeln = gt_items-ebeln
      AND  ebelp = gt_items-ebelp.
   lv_db_table = 't163y'.
    SELECT * FROM (lv_db_table) INTO TABLE lt_t163y WHERE spras = sy-langu.
lv_db_table = 't007s'.
    SELECT mwskz,
           text1
      FROM (lv_db_table)
      INTO TABLE @gt_t007s[]
      FOR ALL ENTRIES IN @gt_items[]
      WHERE spras = @sy-langu
      AND   mwskz = @gt_items-mwskz.
  ENDIF.

  REFRESH t_usrlist.
  IF gt_polist[] IS NOT INITIAL.
*    SELECT a~bname
*           b~smtp_addr INTO TABLE t_usrlist FROM ( adr6 AS b JOIN usr21 AS a ON a~persnumber = b~persnumber )
*                     FOR ALL ENTRIES IN gt_polist
*                                       WHERE a~bname = gt_polist-ernam.

lv_db_table = 'usr21'.
SELECT bname,
   persnumber
  INTO TABLE @lt_usr21
  FROM (lv_db_table)
  FOR ALL ENTRIES IN @gt_polist
  WHERE bname = @gt_polist-ernam.

lv_db_table = 'adr6'.
SELECT persnumber,
  smtp_addr
  INTO TABLE @lt_adr6
  FROM (lv_db_table)
  FOR ALL ENTRIES IN @lt_usr21
  WHERE persnumber = @lt_usr21-persnumber.


LOOP AT lt_usr21 ASSIGNING FIELD-SYMBOL(<fs_usr21>).
  READ TABLE lt_adr6 ASSIGNING FIELD-SYMBOL(<fs_adr6>)
    WITH KEY persnumber = <fs_usr21>-persnumber.
  IF sy-subrc = 0.
    APPEND VALUE #( bname = <fs_usr21>-bname
                    smtp_addr = <fs_adr6>-smtp_addr ) TO t_usrlist.
  ENDIF.
ENDLOOP.


*    SELECT SINGLE ADR6~SMTP_ADDR INTO T_LOG-ACTUAL_USER FROM ( ADR6 JOIN USR21 ON USR21~PERSNUMBER = ADR6~PERSNUMBER )
*                                   WHERE USR21~BNAME = LV_USER.
  ENDIF.

  IF p_delta IS NOT INITIAL AND  gt_polist[] IS INITIAL .
    wa_job_slog-prog_name = '/SDOCS/SSPAY_CONTRACT_DISPATCH'.
    wa_job_slog-prog_type = 'HTTP_CALL'.
    wa_job_slog-jlog_date    = gv_curr_date.
    wa_job_slog-jlog_time    = gv_curr_time.
    lv_db_table = '/sdocs/sspy_jlog'.
    MODIFY (lv_db_table) FROM wa_job_slog.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GENERATE_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM generate_xml .

  DATA: BEGIN OF address_groups OCCURS 0.
          INCLUDE STRUCTURE adagroups.
  DATA: END OF address_groups.

  DATA:lv_char(18) TYPE c.
  DATA:lv_supplierid(30)    TYPE c,
       lv_requestor(50)     TYPE c,
       lv_location(30)      TYPE c,
       lv_email             TYPE ad_smtpadr,
       lv_shipment_type(50) TYPE c,
       lv_delcount          TYPE sy-tabix,
       lv_delcount1         TYPE sy-tabix,
       lv_dlvry_cnt         TYPE sy-tabix,
       lv_erdat             TYPE sy-datum,
       lv_ezeit             TYPE sy-uzeit,
       ls_lfa1              TYPE tt_lfa1, "LFA1,
       ls_adrc              TYPE adrc,
       ls_addr1_val         TYPE addr1_val,
       lv_inv_qty           TYPE ekpo-menge,
       lv_inv_amt           TYPE ekpo-netpr,
       lv_no_posf           TYPE c,
       lv_status(25)        TYPE c,
       lv_netwr             TYPE netwr,
       l_status.

  CLEAR:lv_supplierid,lv_requestor,lv_location,lv_delcount,lv_inv_qty,lv_netwr,
        lv_delcount1,ls_lfa1,ls_adrc,lv_dlvry_cnt,lv_no_posf,lv_status,l_status.
  REFRESH: address_groups[],it_po_sf[].

  gs_xml-line = '<CONTRACT_DATA>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  gs_xml-line = '<HEADER>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<SYSTEM_ID>' sy-sysid '</SYSTEM_ID>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml.
  CLEAR gs_xml.

  CONCATENATE '<CLIENT_ID>' sy-mandt '</CLIENT_ID>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml.
  CLEAR: gs_xml.

  DATA(lv_po) = wa_polist-ebeln.
  SHIFT lv_po LEFT DELETING LEADING '0'.
  CONCATENATE '<CONTRACT>' lv_po '</CONTRACT>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.
  po_dis-ebeln = wa_polist-ebeln.
  APPEND po_dis.CLEAR po_dis.

  CLEAR gv_desc.
  CONCATENATE 'Cntr_' lv_po INTO gv_desc.

  CONCATENATE '<CONTRACT_NAME>' gv_desc '</CONTRACT_NAME>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<CONTRACT_TYPE>'  '</CONTRACT_TYPE>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<CONTRACT_OWNER>'  '</CONTRACT_OWNER>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<VALID_FROM>' wa_polist-kdatb  '</VALID_FROM>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.


  CONCATENATE '<VALID_TO>' wa_polist-kdate '</VALID_TO>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.


  CONCATENATE '<CCODE>' wa_polist-bukrs '</CCODE>' INTO  gs_xml-line."ps_company_code
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<PORG>' wa_polist-ekorg '</PORG>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<PGRP>' wa_polist-ekgrp '</PGRP>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<CONTRACT_TYPE>' wa_polist-bsart '</CONTRACT_TYPE>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

*  CONCATENATE '<DLVRY_DATE>' WA_EKET-EINDT '</DLVRY_DATE>' INTO  GS_XML-LINE.
*  APPEND GS_XML TO GT_XML.CLEAR GS_XML.

  CONCATENATE '<CR_DATE>' wa_polist-aedat '</CR_DATE>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR:lv_netwr,gs_xml.


  LOOP AT gt_items INTO wa_items WHERE ebeln = wa_polist-ebeln.
    DATA(lv_netwr1) = wa_items-netpr * wa_items-ktmng.
    lv_netwr  = lv_netwr + lv_netwr1.
  ENDLOOP.

  gv_amount  = lv_netwr.
  CONDENSE gv_amount.
  CONCATENATE '<TARGET_VALUE>' gv_amount '</TARGET_VALUE>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CLEAR:lv_shipment_type,gv_desc.
  CONCATENATE wa_polist-inco1 wa_polist-inco2 INTO lv_shipment_type SEPARATED BY space.
  gv_desc = lv_shipment_type.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<SHIPMENT_TYPE>' gv_desc '</SHIPMENT_TYPE>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<CURRENCY>' wa_polist-waers '</CURRENCY>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<PAY_TERMS>' wa_polist-zterm '</PAY_TERMS>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.


*  clear gv_buyer.
*  clear:wa_t024, gv_desc.
*  if wa_polist-ekgrp is not initial.
*    read table gt_t024 into wa_t024 with key ekgrp = wa_polist-ekgrp.
*  endif.

*  gv_desc =  wa_t024-smtp_addr.
  CLEAR wa_usrlist.
  READ TABLE t_usrlist INTO wa_usrlist WITH KEY bname = wa_polist-ernam.
  gv_desc = wa_usrlist-smtp_addr.
  IF NOT gv_desc IS INITIAL.
    PERFORM replace_sym USING gv_desc.
  ENDIF.
  CONCATENATE '<BUYER>' gv_desc  '</BUYER>' INTO  gs_xml-line."lv_email 'buyer@smartdocs.ai' GV_BUYER
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

*  read table gt_items into data(ps_items) with key ebeln = wa_polist-ebeln."index 1
**15.02.2022
  READ TABLE gt_items INTO DATA(ps_items) WITH KEY ebeln = wa_polist-ebeln loekz = ''."index 1
*****

  READ TABLE it_t001k INTO DATA(wa_t001k) WITH KEY bukrs = ps_items-bukrs bwkey = ps_items-werks.
  READ TABLE it_t001w INTO DATA(wa_t001w) WITH KEY werks = wa_t001k-bwkey.
  READ TABLE it_1bbranch INTO DATA(wa_lbbranch) WITH KEY bukrs = wa_t001k-bukrs branch = wa_t001w-j_1bbranch.
*  IF SY-SUBRC EQ 0.
*    DATA(LV_COMP_GST) = WA_LBBRANCH-GSTIN.
*  ENDIF.
*********************************************************************   ---- open for primary plant
  CONCATENATE '<PRIMARY_PLANT>'  ps_items-werks  '</PRIMARY_PLANT>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.
  CLEAR:gs_xml.
*********************************************************************  ----- close for primary plant
  CONCATENATE '<COMP_GST>'    '</COMP_GST>' INTO  gs_xml-line. "LV_COMP_GST
  APPEND gs_xml TO gt_xml.
  CLEAR:gs_xml,ps_items,wa_t001k,wa_t001w,wa_lbbranch. "LV_COMP_GST

********************
  CLEAR:lv_status.
*  if ( (  wa_polist-frggr is not initial and wa_polist-frgrl is initial ) or ( wa_polist-frggr is initial ) ).
  PERFORM po_status USING wa_polist-ebeln lv_status.

  gv_desc = wa_usrlist-smtp_addr.
  IF NOT gv_desc IS INITIAL.
    PERFORM replace_sym USING gv_desc.
  ENDIF.

  CONCATENATE '<STATUS>' 'Open' '</STATUS>' INTO  gs_xml-line."LV_STATUS
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<REQUESTOR>' gv_desc '</REQUESTOR>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

*  SELECT SINGLE * FROM LFA1 INTO LS_LFA1  WHERE LIFNR = WA_POLIST-LIFNR.
  CLEAR:ls_lfa1.
  READ TABLE qt_lfa1 INTO ls_lfa1 WITH KEY lifnr = wa_polist-lifnr.
  lv_db_table = 'adrc'.
  SELECT SINGLE * FROM (lv_db_table) INTO ls_adrc WHERE addrnumber = ls_lfa1-adrnr. "#EC CI_NO_TRANSFORM

  WRITE:wa_polist-lifnr TO lv_supplierid.
  lt_lifnr-lifnr = wa_polist-lifnr.
  APPEND lt_lifnr.CLEAR lt_lifnr.

  IF lv_supplierid CA lv_characters.

  ELSE.
    SHIFT lv_supplierid LEFT DELETING LEADING '0'.
  ENDIF.

  CONCATENATE '<SUPPLIER>' lv_supplierid '</SUPPLIER>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<LOCATION>' lv_location '</LOCATION>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.
  IF lv_oa_clear IS NOT INITIAL.
  ENDIF.

  CLEAR:lv_erdat,lv_ezeit.
  lv_db_table = 'ekes'.
  SELECT SINGLE erdat ezeit FROM (lv_db_table) INTO (lv_erdat,lv_ezeit) WHERE ebeln = wa_polist-ebeln.
*  CONCATENATE '<ORDER_ACK_DATE>' LV_ERDAT '</ORDER_ACK_DATE>' INTO GS_XML-LINE. "WA_HEADER-Z_PO_ACK_DATE
*  APPEND GS_XML TO GT_XML.CLEAR GS_XML.
*
*  CONCATENATE '<ORDER_ACK_TIME>' LV_EZEIT  '</ORDER_ACK_TIME>' INTO GS_XML-LINE.
*  APPEND GS_XML TO GT_XML.CLEAR GS_XML.

  CLEAR gv_desc.
  IF lv_erdat IS INITIAL.
    gv_desc = 'false'.
  ELSE.
    gv_desc = 'true'.
  ENDIF.

*  CONDENSE GV_DESC NO-GAPS.
*  CONCATENATE '<ORDER_ACK_STATUS>' GV_DESC  '</ORDER_ACK_STATUS>' INTO GS_XML-LINE.
*  APPEND GS_XML TO GT_XML.CLEAR GS_XML.

*  GS_XML-LINE = '<RMT_ADDRESSES>'.
*  APPEND GS_XML TO GT_XML.CLEAR GS_XML.

  gs_xml-line = '<RMT_ADDRESS>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<REF_ID>' '</REF_ID>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CLEAR gv_desc.
  gv_desc =  ls_lfa1-name1.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<NAME>' gv_desc '</NAME>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.
  CLEAR gv_desc.
  gv_desc = ls_adrc-name_co.                       "#EC CI_NO_TRANSFORM
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<ADDRESS1>' gv_desc '</ADDRESS1>' INTO  gs_xml-line. "'MP 154.2'
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CLEAR gv_desc.
  gv_desc = ls_lfa1-stras.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<ADDRESS2>' gv_desc '</ADDRESS2>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<ADDRESS3>'  '</ADDRESS3>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CLEAR gv_desc.
  gv_desc = ls_lfa1-ort01.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<CITY>' gv_desc '</CITY>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<STATE>' ls_lfa1-regio '</STATE>' INTO  gs_xml-line. "WA_PARTNER1-REGION
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<CNTRY>' ls_lfa1-land1 '</CNTRY>' INTO  gs_xml-line. "WA_PARTNER1-COUNTRY
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<ZIP>' ls_lfa1-pstlz  '</ZIP>' INTO  gs_xml-line. "WA_PARTNER1-POSTL_COD1
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  gs_xml-line = '</RMT_ADDRESS>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

*  GS_XML-LINE = '</RMT_ADDRESSES>'.
*  APPEND GS_XML TO GT_XML.CLEAR GS_XML.
  CLEAR wa_items.
  READ TABLE gt_items INTO wa_items WITH KEY ebeln = wa_polist-ebeln loekz = ''."index 1.
  PERFORM get_delivery_address USING ls_addr1_val.
  gs_xml-line = '<SHP_ADDRESSES>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  gs_xml-line = '<SHP_ADDRESS>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<REF_ID>' '</REF_ID>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CLEAR gv_desc.
  gv_desc =  ls_addr1_val-name1.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<NAME>' gv_desc '</NAME>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CLEAR gv_desc.
  IF ls_addr1_val-name_co IS NOT INITIAL.
    gv_desc = ls_addr1_val-name_co.
  ELSE.
    gv_desc = ls_addr1_val-name2.
  ENDIF.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<ADDRESS1>' gv_desc '</ADDRESS1>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CLEAR gv_desc.
  CONCATENATE  ls_addr1_val-house_num1 ls_addr1_val-street INTO gv_desc SEPARATED BY space.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<ADDRESS2>'  '</ADDRESS2>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<ADDRESS3>'   '</ADDRESS3>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CLEAR gv_desc.
  gv_desc = ls_addr1_val-city1.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<CITY>' gv_desc '</CITY>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<STATE>' ls_addr1_val-region '</STATE>' INTO  gs_xml-line. "WA_DET-REGION
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<CNTRY>' ls_addr1_val-country '</CNTRY>' INTO  gs_xml-line."WA_DET-COUNTRY
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<ZIP>' ls_addr1_val-post_code1 '</ZIP>' INTO  gs_xml-line."WA_DET-POSTL_COD1
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CLEAR gv_desc.
  gv_desc = ls_addr1_val-location.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<LOCATION>'  gv_desc '</LOCATION>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  gs_xml-line = '</SHP_ADDRESS>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  gs_xml-line = '</SHP_ADDRESSES>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  gs_xml-line = '</HEADER>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<RESET_OA>' 'false' '</RESET_OA>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<RESET_ASN>' 'false' '</RESET_ASN>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  CONCATENATE '<NOTIFY>' 'false' '</NOTIFY>' INTO  gs_xml-line.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  gs_xml-line = '<LINEITEMS>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  SORT gt_items[] BY ebelp.
  CLEAR:wa_items.
  LOOP AT gt_items INTO wa_items WHERE ebeln = wa_polist-ebeln.

    gs_xml-line = '<LINEITEM>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CONCATENATE '<CONTRACT_ITEM>' wa_items-ebelp '</CONTRACT_ITEM>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    SHIFT wa_items-matnr LEFT DELETING LEADING '0'.
    CLEAR gv_desc.
    gv_desc = wa_items-matnr.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<PRODUCT_CODE>' gv_desc '</PRODUCT_CODE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CLEAR gv_desc.
    gv_desc = wa_items-txz01.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<PRODUCT_DES>' gv_desc '</PRODUCT_DES>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CONCATENATE '<HSN_CODE>' wa_items-j_1bnbm '</HSN_CODE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    lv_char = wa_items-ktmng.
    CONDENSE lv_char.
    CONCATENATE '<TARGET_QTY>' lv_char '</TARGET_QTY>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CLEAR lv_char.
    lv_char = wa_items-netpr.
    CONDENSE lv_char.

    CONCATENATE '<PRICE_UNIT>' lv_char '</PRICE_UNIT>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

*    if lv_char is INITIAL.

    CONCATENATE '<UNT_PRICE>' lv_char '</UNT_PRICE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    wa_items-netwr  = wa_items-ktmng * wa_items-netpr.
    lv_char = wa_items-netwr.
    CONDENSE lv_char.
    CONCATENATE '<TARGET_VALUE>' lv_char '</TARGET_VALUE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.


****Order Unit & PO order unit is different - open
    IF wa_items-bprme IS NOT INITIAL.
      IF wa_items-bprme NE wa_items-meins.
        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
          EXPORTING
            input          = wa_items-bprme
            language       = sy-langu
          IMPORTING
*           LONG_TEXT      =
            output         = wa_items-bprme
*           SHORT_TEXT     =
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
        ELSE.
          wa_items-meins = wa_items-bprme.
        ENDIF.
      ELSE.
        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
          EXPORTING
            input          = wa_items-meins
            language       = sy-langu
          IMPORTING
*           LONG_TEXT      =
            output         = wa_items-meins
*           SHORT_TEXT     =
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
        ENDIF.
      ENDIF.
    ELSE.
      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
        EXPORTING
          input          = wa_items-meins
          language       = sy-langu
        IMPORTING
*         LONG_TEXT      =
          output         = wa_items-meins
*         SHORT_TEXT     =
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
      ENDIF.
    ENDIF.


    CLEAR wa_t163y.
    READ TABLE lt_t163y INTO wa_t163y WITH KEY pstyp = wa_items-pstyp.
    CONCATENATE '<ITM_CAT>' wa_t163y-epstp '</ITM_CAT>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR: gs_xml,wa_ekbe,wa_t163y.

    CLEAR gv_desc.
    gv_desc = wa_t163y-ptext.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<ITM_CAT_DES>' gv_desc '</ITM_CAT_DES>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR: gs_xml,wa_ekbe.



    CONCATENATE '<UOM>' wa_items-meins '</UOM>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CONCATENATE '<PER_UOM>' wa_items-meins '</PER_UOM>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CLEAR lv_char.
    lv_char = wa_items-peinh.
    CONDENSE lv_char NO-GAPS.

    CONCATENATE '<PER>' lv_char '</PER>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CONCATENATE '<PLANT>' wa_items-werks '</PLANT>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CONCATENATE '<SLOCATION>' wa_items-lgort '</SLOCATION>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CLEAR gv_desc.
    CONCATENATE '<SPARTNO>' gv_desc '</SPARTNO>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CLEAR wa_eket.
    READ TABLE gt_eket INTO wa_eket WITH KEY ebeln = wa_items-ebeln ebelp = wa_items-ebelp.

    CONCATENATE '<DLVRY_DATE>' wa_eket-eindt '</DLVRY_DATE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    CLEAR lv_char.
    CONDENSE lv_char.
    CONCATENATE '<DIS_AMT>' lv_char '</DIS_AMT>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.



    CLEAR:gv_desc.
    gv_desc = wa_items-mfrpn.
    PERFORM replace_sym USING gv_desc.

    CONCATENATE '<MNFC_PART>' gv_desc '</MNFC_PART>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.

    gs_xml-line = '</LINEITEM>'.
    APPEND gs_xml TO gt_xml.CLEAR gs_xml.
    CLEAR:wa_items.
  ENDLOOP.

  gs_xml-line = '</LINEITEMS>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  gs_xml-line = '<ATTCHMNTS>'.
  APPEND gs_xml TO gt_xml.
  CLEAR gs_xml.

  LOOP AT it_toa01 INTO DATA(wa_toa01) WHERE object_id = wa_polist-ebeln.

    gs_xml-line = '<ATTCHMNT>'.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<AR_ID>' wa_toa01-archiv_id '</AR_ID>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<AR_DOCID>' wa_toa01-arc_doc_id '</AR_DOCID>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<VERSION_NO>' ''  '</VERSION_NO>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<VERSION_TYPE>' '' '</VERSION_TYPE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CLEAR:gv_desc.
    gv_desc =  |PO_{ wa_polist-ebeln }|.
    PERFORM replace_sym USING gv_desc.

    CONCATENATE '<FL_NAME>' gv_desc  '</FL_NAME>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    wa_toa01-reserve = to_lower( wa_toa01-reserve ).
    CONCATENATE '<FL_TYPE>' wa_toa01-reserve  '</FL_TYPE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<CR_DATE>' wa_toa01-ar_date '</CR_DATE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<CR_TIME>' '' '</CR_TIME>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<CREATOR>' '' '</CREATOR>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<DOC_TYPE>' wa_toa01-ar_object '</DOC_TYPE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<UPLOAD>' '' '</UPLOAD>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<DOC_EXPIRY_DATE>' '' '</DOC_EXPIRY_DATE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<DOC_EXPIRY_TIME>' ''  '</DOC_EXPIRY_TIME>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    gs_xml-line = '</ATTCHMNT>'.
    APPEND gs_xml TO gt_xml.
    CLEAR:wa_toa01,gs_xml.
  ENDLOOP.

  gs_xml-line = '</ATTCHMNTS>'.
  APPEND gs_xml TO gt_xml.
  CLEAR gs_xml.

  gs_xml-line = '<ORIGINAL_DOCUMENTS>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  IF gv_sf_fmname IS NOT INITIAL.
    PERFORM get_attachments."po smartform's
  ENDIF.

  LOOP AT it_po_sf INTO wa_po_sf.
    gs_xml-line = '<ORIGINAL_DOCUMENT>'.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<AR_ID>'  wa_po_sf-arc_id '</AR_ID>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<AR_DOCID>' wa_po_sf-arc_docid '</AR_DOCID>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<VERSION_NO>' '' '</VERSION_NO>' INTO  gs_xml-line."lv_char
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<VERSION_TYPE>' '' '</VERSION_TYPE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<FL_NAME>' wa_po_sf-file_name '</FL_NAME>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<FL_TYPE>' wa_po_sf-file_type '</FL_TYPE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<CREATED_DATE>' sy-datum '</CREATED_DATE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<CREATED_TIME>' sy-uzeit '</CREATED_TIME>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<CREATOR>'  '</CREATOR>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<DOC_TYPE>'  '</DOC_TYPE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<UPLOAD>'  '</UPLOAD>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<DOC_EXPIRY_DATE>' '</DOC_EXPIRY_DATE>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    CONCATENATE '<DOC_EXPIRY_TIME>'  '</DOC_EXPIRY_TIME>' INTO  gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR gs_xml.

    gs_xml-line = '</ORIGINAL_DOCUMENT>'.
    APPEND gs_xml TO gt_xml.
    CLEAR:wa_po_sf,gs_xml.
  ENDLOOP.

  gs_xml-line = '</ORIGINAL_DOCUMENTS>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.

  gs_xml-line = '</CONTRACT_DATA>'.
  APPEND gs_xml TO gt_xml.CLEAR gs_xml.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_URL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_url .
  CLEAR gv_url_str.
  CONCATENATE gv_server '/' p_ext INTO gv_url_str.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_URL  text
*      -->P_GV_TOKEN  text
*      <--P_gV_SUBRC  text
*----------------------------------------------------------------------*
FORM update  USING    p_url
                      p_token
             CHANGING p_subrc.

  DATA:gv_xml_str TYPE string,
       gv_res_str TYPE string,
       gv_xmlcnt  TYPE i.

  CLEAR :gv_xml_str,gv_xmlcnt.
  DESCRIBE TABLE gt_xml[] LINES gv_xmlcnt.
  LOOP AT gt_xml INTO gs_xml.
    CONCATENATE gv_xml_str gs_xml INTO gv_xml_str.
  ENDLOOP.

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
    IF p_token IS INITIAL.
      p_token = 'notoken'.
    ENDIF.

    IF gv_xmlcnt > '2'.
      CALL FUNCTION '/SDOCS/SSPAY_HTTP_POST_N'
        EXPORTING
          i_profile            = p_profle
          i_ext                = p_ext
          i_input_xml          = gv_xml_str
          i_token_flg          = ''
          i_input_method       = 'POST'
        IMPORTING
          e_success            = gv_success
          e_result             = gv_res_str
          e_scode              = gv_scode
          e_stext              = gv_stext
        CHANGING
          c_token_id           = p_token
        EXCEPTIONS
          ex_internal_error    = 1
          ex_connection_failed = 2
          OTHERS               = 3.
      IF gv_scode <> '200'.
        gv_http_sflag = 'X'.
        WRITE:/2 'Job run date & time:' COLOR 3,26 sy-datum COLOR 3,38 sy-uzeit COLOR 3.
        SKIP 1.
        MESSAGE s000(/sdocs/sspay_msg) WITH 'Invalid XML!'.
        WRITE:/2 'Contract data sync failed'.
        LOOP AT po_dis.
          WRITE:/2 po_dis-ebeln.
          CLEAR:po_dis.
        ENDLOOP.

      ELSEIF gv_scode = '200' OR gv_scode = '201'.
        LOOP AT po_dis.
          IF gv_flag IS INITIAL.
            gv_flag = 'X'.
            WRITE:/2 'Job run date & time:' COLOR 3,26 sy-datum COLOR 3,38 sy-uzeit COLOR 3.
            SKIP 1.
            WRITE:/2 'Contract dispatched successfully for :',po_dis-ebeln.
          ELSE.
            WRITE:/35 po_dis-ebeln.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
  REFRESH:po_dis[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PORTAL_AUTHITICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM portal_authitication.

*CONCATENATE GV_SERVER  '/' P_TK_EXT INTO GV_URL_STR.
  CLEAR:wa_profile.
  SELECT SINGLE * FROM /sdocs/sspy_sprf INTO wa_profile WHERE profile_id = p_profle.

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
  ENDIF.

  IF gv_token IS INITIAL.
    MESSAGE s000(/sdocs/sspay_msg) WITH gv_res_str.
    WRITE:/ gv_res_str.
    EXIT.
  ENDIF.
ENDFORM.                    " PORTAL_AUTHITICATION
*&---------------------------------------------------------------------*
*&      Form  REPLACE_SYM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_DESC  text
*----------------------------------------------------------------------*
FORM replace_sym  USING    p_gv_desc.
  gv_sym_k = 0.CLEAR :gv_sym_s_str,gv_str_len.
  gv_str_len = strlen( p_gv_desc ).
  conv = cl_abap_conv_out_ce=>create( encoding = 'UTF-8'
                                        endian   = 'L'
                                        ignore_cerr = 'X'
                                        replacement = '#' ).
  DO gv_str_len TIMES.
    CLEAR: gv_sym_str,gv_ch.
    gv_ch = p_gv_desc+gv_sym_k(1).
    CASE gv_ch.
      WHEN ''.
        CONCATENATE gv_sym_str '%20' INTO gv_sym_str.
      WHEN '<'.
        CONCATENATE gv_sym_str '&lt;' INTO gv_sym_str.
      WHEN '>'.
        CONCATENATE gv_sym_str '&gt;' INTO gv_sym_str.
      WHEN ''''.
        CONCATENATE gv_sym_str '&apos;' INTO gv_sym_str.
      WHEN '"'.
        CONCATENATE gv_sym_str '&quot;' INTO gv_sym_str.
      WHEN '&'.
        CONCATENATE gv_sym_str '&amp;' INTO gv_sym_str.
      WHEN OTHERS.
        CLEAR:gv_buffer,gv_buffer1,gv_int1,gv_int,gv_ch1.
        gv_ch1 = gv_ch.
        CALL METHOD conv->write( data = gv_ch ).
        gv_buffer = conv->get_buffer( ).
        gv_buffer1 = gv_buffer.
        CONCATENATE '0x' gv_buffer1 INTO gv_buffer1.
        CONDENSE gv_buffer1.
        IF gv_buffer1 > '0x7E'.
          TRY.
              CALL METHOD cl_abap_conv_out_ce=>uccpi
                EXPORTING
                  char = gv_ch1
                RECEIVING
                  uccp = gv_int.
            CATCH cx_sy_codepage_converter_init .
            CATCH cx_sy_conversion_codepage .
            CATCH cx_parameter_invalid_range .
          ENDTRY.
          gv_int1 = gv_int.
          CONCATENATE '&#' gv_int1 ';' INTO gv_sym_str.
          CONDENSE gv_sym_str NO-GAPS.
        ELSE.
          gv_sym_str = gv_ch1.
        ENDIF.
        CALL METHOD conv->reset( ).
    ENDCASE.
    CONCATENATE gv_sym_s_str gv_sym_str INTO gv_sym_s_str.
    gv_sym_k = gv_sym_k + 1.
  ENDDO.
  p_gv_desc = gv_sym_s_str.

ENDFORM.                    "REPLACE_SYM
*&---------------------------------------------------------------------*
*&      Form  GET_ATTACH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_ATTACH  text
*----------------------------------------------------------------------*
FORM get_attachments.

  CLEAR:wa_po_sf.
*  IF wa_polist-ebeln IS NOT INITIAL AND gv_sf_fmname IS NOT INITIAL .
*    CALL FUNCTION gv_sf_fmname
*      EXPORTING
*        i_ebeln      = wa_polist-ebeln
*      TABLES
*        et_posf      = it_po_sf[]
*      EXCEPTIONS
*        sf_not_found = 1.
*  ENDIF.
ENDFORM.                    " GET_ATTACH
*&---------------------------------------------------------------------*
*&      Form  GET_DELIVERY_ADDRESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_ADDR1_VAL  text
*----------------------------------------------------------------------*
FORM get_delivery_address USING ls_addr1_val.
  DATA: g_address_number  LIKE adrc-addrnumber,
        g_address_handle  LIKE szad_field-handle,
        g_nation          LIKE adrc-nation,
        g_date_from       LIKE adrc-date_from,
        address_selection LIKE addr1_sel,
*       ls_addr1_val    type addr1_val,
        ls_ad1_flags      TYPE ad1_flags,
        ls_addr1_text     TYPE addr1_text,
        lv_db_table type char50.

  CLEAR:g_address_number,g_address_handle,ls_addr1_val.

  IF wa_items-adrnr IS INITIAL AND wa_items-werks IS NOT INITIAL.
    lv_db_table = 't001w'.
    SELECT SINGLE adrnr FROM (lv_db_table) INTO wa_items-adrnr WHERE werks = wa_items-werks.
  ENDIF.

  IF wa_items-adrnr IS NOT INITIAL.
    g_address_number = wa_items-adrnr.
    lv_db_table = 'adrc'.
    SELECT SINGLE date_from FROM (lv_db_table)  INTO address_selection-date WHERE addrnumber = wa_items-adrnr.
  ELSE.
    CONCATENATE 'T001W' wa_items-werks INTO g_address_handle.
  ENDIF.

  MOVE g_address_number   TO  address_selection-addrnumber .
  MOVE g_address_handle   TO  address_selection-addrhandle .

  IF address_selection-date IS INITIAL.
    address_selection-date  = '00010101'.
  ENDIF.

  CLEAR gv_desc.

  IF address_selection IS NOT INITIAL.

    data(lv_fm) = 'ADDR_GET'.
   CALL FUNCTION lv_fm
      EXPORTing
        address_selection = address_selection
      IMPORTing
        address_value     = ls_addr1_val
      EXCEPTIONS
        parameter_error   = 01
        address_not_exist = 02
        version_not_exist = 03
        internal_error    = 04
        OTHERS            = 99.
*    lv_db_table = 'adrc'.
*    select single * from (lv_db_table) into CORRESPONDING FIELDS OF ls_addr1_val where addr_number = address_selection-addrnumber.
  ENDIF.
ENDFORM.                    " GET_DELIVERY_ADDRESS
*&---------------------------------------------------------------------*
*&      Form  PUSH_DATA_TO_PORTAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM push_data_to_portal.
  PERFORM prepare_po_xml.
ENDFORM.                    " PUSH_DATA_TO_PORTAL
*&---------------------------------------------------------------------*
*&      Form  PREPARE_PO_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_po_xml.
 data : lv_db_table type char50.
  IF gt_polist[] IS NOT INITIAL.
    CLEAR:gv_cnt.
    DESCRIBE TABLE gt_polist[] LINES gv_cnt.

    IF gv_cnt GT p_bsize.
      gv_div = ( gv_cnt / p_bsize ).
      gv_mod = ( gv_cnt MOD p_bsize ).
      IF gv_mod => 1.
        gv_div = gv_div + 1.
      ENDIF.
    ELSE.
      gv_div = 1.
    ENDIF.

    DO gv_div TIMES.
      gv_from = gv_to + 1.
      gv_to   = gv_from + p_bsize - 1.

      REFRESH: gt_xml[].
      CLEAR gv_http_sflag.
      gs_xml-line = '<CONTRACT_DATA_TRANSMIT>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.


      LOOP AT gt_polist INTO wa_polist FROM gv_from TO gv_to.
        CLEAR:gv_po_crdate,gv_noemail_notif.
        PERFORM generate_xml.
        CLEAR: wa_polist.
      ENDLOOP.
      gs_xml-line = '</CONTRACT_DATA_TRANSMIT>'.
      APPEND gs_xml TO gt_xml.CLEAR gs_xml.


      PERFORM get_url.
      PERFORM update USING gv_uri gv_token CHANGING gv_subrc.
    ENDDO.
    IF p_delta IS NOT INITIAL AND   gv_http_sflag IS INITIAL.
      wa_job_slog-prog_name = '/SDOCS/SSPAY_CONTRACT_DISPATCH'.
      wa_job_slog-prog_type = 'HTTP_CALL'.
      wa_job_slog-jlog_date    = gv_curr_date.
      wa_job_slog-jlog_time    = gv_curr_time.
      lv_db_table = '/sdocs/sspy_jlog'.
      MODIFY (lv_db_table) FROM wa_job_slog.
    ENDIF.
  ENDIF.

  IF lt_lifnr[] IS NOT INITIAL.
    SORT lt_lifnr[] BY lifnr.
    DELETE ADJACENT DUPLICATES FROM lt_lifnr[] COMPARING lifnr.
  ENDIF.
ENDFORM.                    " PREPARE_PO_XML
*&---------------------------------------------------------------------*
*& Form GET_JOB_INTERVAL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_job_interval .
data : lv_db_table type char50.
  CLEAR wa_job_slog.
  lv_db_table = '/sdocs/sspy_jlog'.
  SELECT SINGLE * FROM (lv_db_table) INTO wa_job_slog WHERE prog_name = '/SDOCS/SSPAY_CONTRACT_DISPATCH'
                                                          AND prog_type = 'HTTP_CALL'.
  IF sy-subrc EQ 0 AND wa_job_slog-jlog_date IS NOT INITIAL AND wa_job_slog-jlog_time  IS NOT INITIAL.

    IF  wa_job_slog-jlog_date <> sy-datum.
      lr_date-low = wa_job_slog-jlog_date.
      lr_date-high = wa_job_slog-jlog_date.
      lr_date-option = 'BT'.
      lr_date-sign   = 'I'.
      APPEND lr_date.
      lr_time-low = wa_job_slog-jlog_time.
      lr_time-high = '235959'.
      lr_time-option = 'BT'.
      lr_time-sign   = 'I'.
      APPEND lr_time.
    ENDIF.

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
    lr_time-low = '000000'."( sy-uzeit - 1200 ).
    lr_time-high = sy-uzeit.
    lr_time-option = 'BT'.
    lr_time-sign   = 'I'.
    APPEND lr_time.
  ENDIF.
  gv_curr_date = lr_date-high.
  gv_curr_time = lr_time-high.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form read_standard_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_POLIST_EBELN
*&      --> LV_TDID
*&---------------------------------------------------------------------*
FORM read_standard_text  USING  p_ebeln LIKE thead-tdname
                                p_tdid  LIKE thead-tdid
                         CHANGING p_flag gv_sdtext.
  REFRESH:t_lines[].
  CLEAR:p_flag,gv_sdtext.
  IF p_tdid IS NOT INITIAL AND p_ebeln IS NOT INITIAL.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = p_tdid
        language                = sy-langu
        name                    = p_ebeln
        object                  = 'EKKO'
      TABLES
        lines                   = t_lines[]
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
  ENDIF.

  IF t_lines[] IS NOT INITIAL.
    p_flag = 'X'.
    LOOP AT t_lines INTO l_lines.
      CONCATENATE gv_sdtext l_lines-tdline INTO gv_sdtext SEPARATED BY space.
      CLEAR l_lines.
    ENDLOOP.
  ELSE.
    p_flag = ''.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PO_OPN_STATUS_PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM po_opn_status_process .
  DATA:BEGIN OF lt_sqty OCCURS 0,
         packno TYPE esll-packno,
         introw TYPE  esll-introw,
         menge  TYPE esll-menge,
       END OF lt_sqty.
  DATA:lv_menge1   TYPE ekpo-menge,
       lv_menge    TYPE ekpo-menge,
       lv_inv_qty  TYPE ekpo-menge,
       lv_packno   TYPE esll-packno,
       lv_del      TYPE i,
       lv_del1     TYPE i,
       l_lines     TYPE i,
       lv_tabix1   TYPE sy-tabix,
       lv_tabix    TYPE sy-tabix,
       lv_qty_esll TYPE esll-menge,
       lv_inv_opn,
       lv_inv_comp,
       lv_inv_del,
       lv_db_table type char50.
  CLEAR:lv_menge1,lv_menge,lv_inv_qty,lv_inv_opn,lv_inv_comp,lv_inv_del,lv_del1,lv_del,l_lines,lv_qty_esll.
  LOOP AT gt_polist INTO wa_polist.
    CLEAR:lv_del, lv_del1.
    LOOP AT gt_items INTO wa_items WHERE ebeln = wa_polist-ebeln ."AND loekz = ' ' .
      lv_del = lv_del + 1.
      IF wa_items-loekz IS INITIAL.
        IF wa_items-pstyp = '9'.
          CLEAR:lv_packno,lt_sqty,wa_items-menge,l_lines,lv_qty_esll.
          REFRESH lt_sqty[].
          lv_db_table = 'esll'.
          SELECT SINGLE sub_packno FROM (lv_db_table) INTO lv_packno WHERE packno = wa_items-packno.
            lv_db_table = 'essr'.
          SELECT packno FROM (lv_db_table) INTO TABLE @lt_essr WHERE ebeln = @wa_polist-ebeln AND ebelp = @wa_items-ebelp. "#EC CI_GENBUFF
          DESCRIBE TABLE lt_essr[] LINES l_lines.
          IF lt_essr[] IS NOT INITIAL.
            lv_db_table = 'esll'.
            SELECT sub_packno FROM (lv_db_table) INTO TABLE @lt_esll FOR ALL ENTRIES IN @lt_essr[] WHERE packno = @lt_essr-packno.
          ENDIF.
          IF lt_esll[] IS NOT INITIAL.
            lv_db_table = 'esll'.
            SELECT packno, menge FROM (lv_db_table) INTO TABLE @it_temp_esll FOR ALL ENTRIES IN @lt_esll[] WHERE packno = @lt_esll-sub_packno.
          ENDIF.
          LOOP AT it_temp_esll INTO DATA(wa_temp_esll).
            lv_qty_esll = lv_qty_esll + wa_temp_esll-menge.
          ENDLOOP.

          IF lv_packno IS NOT INITIAL.
            lv_db_table = 'esll'.
            SELECT packno introw menge INTO TABLE lt_sqty FROM (lv_db_table) WHERE packno = lv_packno.
          ENDIF.

          LOOP AT lt_sqty .
            wa_items-menge = wa_items-menge +  lt_sqty-menge.
          ENDLOOP.
          CLEAR:lv_tabix1,lv_tabix.
          LOOP AT gt_ekbe1 INTO wa_ekbe1 WHERE ebeln = wa_items-ebeln AND ebelp = wa_items-ebelp AND shkzg = 'S'."Invoice Processed
            lv_tabix1 = lv_tabix1 + 1.
*            lv_menge = wa_ekbe1-menge + lv_menge.
          ENDLOOP.

          LOOP AT gt_ekbe1 INTO wa_ekbe1 WHERE ebeln = wa_items-ebeln AND ebelp = wa_items-ebelp AND shkzg = 'H'."Invoice Reversed
            lv_tabix = lv_tabix + 1.
*            lv_menge1 = wa_ekbe1-menge + lv_menge1.
          ENDLOOP.
          IF lv_tabix > 0.
            lv_tabix1 = lv_tabix1 - lv_tabix.
          ENDIF.
          IF ( wa_items-menge = lv_qty_esll AND lv_tabix1 EQ l_lines ).
            lv_inv_comp = 'X'.
          ELSE.
            lv_inv_opn = 'X'.
          ENDIF.
          CONTINUE.
        ENDIF.

        IF wa_items-erekz IS INITIAL.
          LOOP AT gt_ekbe1 INTO wa_ekbe1 WHERE ebeln = wa_items-ebeln AND ebelp = wa_items-ebelp AND shkzg = 'S'."Invoice Processed
            lv_menge = wa_ekbe1-menge + lv_menge.
          ENDLOOP.
          LOOP AT gt_ekbe1 INTO wa_ekbe1 WHERE ebeln = wa_items-ebeln AND ebelp = wa_items-ebelp AND shkzg = 'H'."Invoice Reversed
            lv_menge1 = wa_ekbe1-menge + lv_menge1.
          ENDLOOP.
          IF lv_menge1  > 0.
            lv_inv_qty = lv_menge - lv_menge1.
          ELSE.
            lv_inv_qty = lv_menge.
          ENDIF.
          IF lv_inv_qty = wa_items-menge.
            lv_inv_comp = 'X'.
          ELSE.
            lv_inv_opn = 'X'.
            CLEAR :lv_inv_comp.
            EXIT.
          ENDIF.
        ELSE.
          lv_inv_comp = 'X'.
        ENDIF.
      ELSE.
        lv_del1 = lv_del1 + 1.
      ENDIF.
      CLEAR:lv_menge,lv_menge1.
    ENDLOOP.

    IF lv_inv_opn = 'X'.
    ELSEIF (  lv_del1 = lv_del OR lv_inv_comp = 'X' ).
      DELETE gt_polist WHERE ebeln = wa_polist-ebeln.
    ENDIF.
    CLEAR:lv_inv_opn,lv_inv_comp,lv_menge,lv_menge1,lv_del, lv_del1.
  ENDLOOP.
  REFRESH:lt_sqty[],lt_essr,lt_esll,it_temp_esll[].
ENDFORM.                    " PO_OPN_STATUS_PROCESS
*&---------------------------------------------------------------------*
*&      Form  PO_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_POLIST_EBELN  text
*      -->P_L_STATUS  text
*----------------------------------------------------------------------*
FORM po_status  USING    p_ebeln
                         p_status.
  DATA:BEGIN OF lt_sqty OCCURS 0,
         packno TYPE esll-packno,
         introw TYPE  esll-introw,
         menge  TYPE esll-menge,
       END OF lt_sqty.

  DATA:lv_menge1   TYPE ekpo-menge,
       lv_menge    TYPE ekpo-menge,
       lv_inv_qty  TYPE ekpo-menge,
       lv_packno   TYPE esll-packno,
       lv_qty_esll TYPE esll-menge,
       lv_tabix1   TYPE i,
       lv_tabix    TYPE i,
       lv_del      TYPE i,
       lv_del1     TYPE i,
       lv_inv_opn,
       lv_inv_comp,
       lv_inv_del,
       lv_db_table type char50.

  CLEAR:lv_menge1,lv_menge,lv_inv_qty,lv_inv_opn,lv_inv_comp,lv_inv_del,lv_del1,lv_del,lv_packno.
  LOOP AT gt_items INTO wa_items WHERE ebeln = p_ebeln ."AND loekz = ' ' .
    lv_del = lv_del + 1.
    IF wa_items-loekz IS INITIAL.
      IF wa_items-pstyp = '9'.
        CLEAR:lv_packno,lt_sqty,wa_items-menge,l_lines,lv_qty_esll.
        REFRESH lt_sqty[].
        lv_db_table = 'esll'.
        SELECT SINGLE sub_packno FROM (lv_db_table) INTO lv_packno WHERE packno = wa_items-packno.
          lv_db_table = 'essr'.
        SELECT packno FROM  (lv_db_table) INTO TABLE @lt_essr WHERE ebeln = @wa_polist-ebeln AND ebelp = @wa_items-ebelp. "#EC CI_GENBUFF
        DESCRIBE TABLE lt_essr[] LINES l_lines.
        IF lt_essr[] IS NOT INITIAL.
          lv_db_table = 'esll'.
          SELECT sub_packno FROM (lv_db_table) INTO TABLE @lt_esll FOR ALL ENTRIES IN @lt_essr[] WHERE packno = @lt_essr-packno.
        ENDIF.
        IF lt_esll[] IS NOT INITIAL.
          lv_db_table = 'esll'.
          SELECT packno, menge FROM (lv_db_table) INTO TABLE @it_temp_esll FOR ALL ENTRIES IN @lt_esll[] WHERE packno = @lt_esll-sub_packno.
        ENDIF.
        LOOP AT it_temp_esll INTO DATA(wa_temp_esll).
          lv_qty_esll = lv_qty_esll + wa_temp_esll-menge.
        ENDLOOP.

        IF lv_packno IS NOT INITIAL.
          lv_db_table = 'esll'.
          SELECT packno introw menge INTO TABLE lt_sqty FROM (lv_db_table) WHERE packno = lv_packno.
        ENDIF.

        LOOP AT lt_sqty .
          wa_items-menge = wa_items-menge +  lt_sqty-menge.
        ENDLOOP.
        CLEAR:lv_tabix1,lv_tabix.
        LOOP AT gt_ekbe1 INTO wa_ekbe1 WHERE ebeln = wa_items-ebeln AND ebelp = wa_items-ebelp AND shkzg = 'S'."Invoice Processed
          lv_tabix1 = lv_tabix1 + 1.
*            lv_menge = wa_ekbe1-menge + lv_menge.
        ENDLOOP.

        LOOP AT gt_ekbe1 INTO wa_ekbe1 WHERE ebeln = wa_items-ebeln AND ebelp = wa_items-ebelp AND shkzg = 'H'."Invoice Reversed
          lv_tabix = lv_tabix + 1.
*            lv_menge1 = wa_ekbe1-menge + lv_menge1.
        ENDLOOP.
        IF lv_tabix > 0.
          lv_tabix1 = lv_tabix1 - lv_tabix.
        ENDIF.
        IF ( wa_items-menge = lv_qty_esll AND lv_tabix1 EQ l_lines ).
          lv_inv_comp = 'X'.
        ELSE.
          lv_inv_opn = 'X'.
        ENDIF.
        CONTINUE.
      ENDIF.

      IF wa_items-erekz IS INITIAL.
        LOOP AT gt_ekbe1 INTO wa_ekbe1 WHERE ebeln = wa_items-ebeln AND ebelp = wa_items-ebelp AND shkzg = 'S'."Invoice Processed
          lv_menge = wa_ekbe1-menge + lv_menge.
        ENDLOOP.
        LOOP AT gt_ekbe1 INTO wa_ekbe1 WHERE ebeln = wa_items-ebeln AND ebelp = wa_items-ebelp AND shkzg = 'H'."Invoice Reversed
          lv_menge1 = wa_ekbe1-menge + lv_menge1.
        ENDLOOP.
        IF lv_menge1  > 0.
          lv_inv_qty = lv_menge - lv_menge1.
        ELSE.
          lv_inv_qty = lv_menge.
        ENDIF.
        IF lv_inv_qty = wa_items-menge.
          lv_inv_comp = 'X'.
        ELSE.
          lv_inv_opn = 'X'.
          CLEAR :lv_inv_comp.
          EXIT.
        ENDIF.
      ELSE.
        lv_inv_comp = 'X'.
      ENDIF.
    ELSE.
      lv_del1 = lv_del1 + 1.
    ENDIF.
    CLEAR:lv_menge,lv_menge1.
  ENDLOOP.

  IF lv_del1 = lv_del.
    p_status  = 'Deleted'.
  ELSEIF lv_inv_opn = 'X'.
    p_status = 'Open'.
  ELSE.
    p_status = 'Close'.
  ENDIF.
  REFRESH:lt_sqty[],lt_essr,lt_esll,it_temp_esll[].
ENDFORM.                    " PO_STATUS
