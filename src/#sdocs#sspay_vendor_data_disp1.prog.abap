*&---------------------------------------------------------------------*
*& Report /SDOCS/SSPAY_VENDOR_DATA_DISP1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /sdocs/sspay_vendor_data_disp1.

*{   INSERT         &$&$&$&$                                          1
TABLES:lfa1.
INCLUDE /sdocs/sspy_incl_dispdata.
TYPES: BEGIN OF gs_final,
         sup_id         TYPE lifnr,
         sup_name       TYPE char80,
         fname          TYPE char40,
         lname          TYPE char40,
         email          TYPE ad_smtpadr,
         contact        TYPE ad_persnum,
         bank_acc_no    TYPE bankn,
         bank_cntry_key TYPE banks,
         bankl          TYPE bankl,
         zahls          TYPE lfb1-zahls,
         address1       TYPE ad_strspp1,
         address2       TYPE ad_strspp2,
         address3       TYPE ad_strspp3,
         location       TYPE ad_lctn,
         city           TYPE ort01_gp,
         zip            TYPE pstlz,
         country        TYPE land1_gp,
         tel_number     TYPE char20,
         fax_number     TYPE char20,
         acc_group      TYPE char20,
         loevm          TYPE lfa1-loevm,
         sperr          TYPE lfa1-sperr,
       END OF gs_final.

TYPES:BEGIN OF gs_dbe,
        objek TYPE ksskausp-objek,
        atwrt TYPE ksskausp-atwrt,
        atwtb TYPE atwtb,
      END OF gs_dbe.

TYPES:BEGIN OF gs_kss,
        objek TYPE ksskausp-objek,
        clint TYPE ksskausp-clint,
        atzhl TYPE ksskausp-atzhl,
        atinn TYPE ksskausp-atinn,
        atwrt TYPE ksskausp-atwrt,
      END OF gs_kss.

TYPES: BEGIN OF gs_vndr,
         lifnr     TYPE lfa1-lifnr,
         land1     TYPE lfa1-land1,
         name1     TYPE lfa1-name1,
         name2     TYPE lfa1-name2,
         ort01     TYPE lfa1-ort01,
         pstl2     TYPE lfa1-pstl2,
         pstlz     TYPE lfa1-pstlz,
         adrnr     TYPE lfa1-adrnr,
         ktokk     TYPE lfa1-ktokk,
         stcd1     TYPE lfa1-stcd1,
         stcd2     TYPE lfa1-stcd2,
         stcd3     TYPE lfa1-stcd3,
         j_1kftind TYPE lfa1-j_1kftind,
         lnrza     TYPE lfa1-lnrza,
         loevm     TYPE lfa1-loevm,
         sperr     TYPE lfa1-sperr,
         sperm     TYPE lfa1-sperm,
         sperq     TYPE lfa1-sperq,
         sperz     TYPE lfa1-sperz,
       END OF gs_vndr.

TYPES: BEGIN OF gs_vndr1,
         lifnr TYPE lfa1-lifnr,
         land1 TYPE lfa1-land1,
         name1 TYPE lfa1-name1,
         name2 TYPE lfa1-name2,
         ort01 TYPE lfa1-ort01,
         pstlz TYPE lfa1-pstlz,
         adrnr TYPE lfa1-adrnr,
       END OF gs_vndr1.

TYPES: BEGIN OF gs_lfbk,
         lifnr TYPE lfbk-lifnr,
         banks TYPE lfbk-banks,
         bankl TYPE lfbk-bankl,
         bankn TYPE lfbk-bankn,
       END OF gs_lfbk.
TYPES: BEGIN OF gs_bnka,
         banks TYPE bnka-banks,
         bankl TYPE bnka-bankl,
         stras TYPE bnka-stras,
         swift TYPE bnka-swift,
         banka TYPE bnka-banka,
       END OF gs_bnka.

TYPES: BEGIN OF gs_adrc,
         addrnumber TYPE adrc-addrnumber,
         tel_number TYPE adrc-tel_number,
         tel_extens TYPE adrc-tel_extens,
         fax_number TYPE adrc-fax_number,
         fax_extens TYPE adrc-fax_extens,
         country    TYPE adrc-country,
         street     TYPE adrc-street,
         house_num1 TYPE adrc-house_num1,
         str_suppl3 TYPE adrc-str_suppl3,
         location   TYPE adrc-location,
         region     TYPE adrc-region,
         name_co    TYPE adrc-name_co,
         city1      TYPE adrc-city1,
         post_code1 TYPE adrc-post_code1,
       END OF gs_adrc.

TYPES: BEGIN OF gs_adrc1,
         addrnumber TYPE adrc-addrnumber,
         name_co    TYPE adrc-name_co,
         street     TYPE adrc-street,
         house_num1 TYPE adrc-house_num1,
         region     TYPE adrc-region,
       END OF gs_adrc1.

TYPES: BEGIN OF gs_knvk,
         parnr    TYPE knvk-parnr,
         kunnr    TYPE knvk-kunnr,
         namev    TYPE knvk-namev,
         name1    TYPE knvk-name1,
         titel_ap TYPE knvk-titel_ap,
         lifnr    TYPE knvk-lifnr,
         prsnr    TYPE knvk-prsnr,
         pafkt    TYPE knvk-pafkt,
       END OF gs_knvk.

TYPES: BEGIN OF gs_lfb1,
         lifnr TYPE lfb1-lifnr,
         bukrs TYPE lfb1-bukrs,
         sperr TYPE lfb1-sperr, "
         zahls TYPE lfb1-zahls,
         zterm TYPE lfb1-zterm,
         akont TYPE lfb1-akont,
*         mindk type lfb1-mindk,
       END OF gs_lfb1.

TYPES:BEGIN OF gs_t059t,
        mindk TYPE t059t-mindk,
        mtext TYPE t059t-mtext,
      END OF  gs_t059t.

TYPES:BEGIN OF gs_lfbw,
        lifnr     TYPE lfbw-lifnr,
        bukrs     TYPE lfbw-bukrs,
        witht     TYPE lfbw-witht,
        wt_withcd TYPE lfbw-wt_withcd,
      END OF gs_lfbw.

TYPES:BEGIN OF gs_lfm1,
        lifnr TYPE lfm1-lifnr,
        ekorg TYPE lfm1-ekorg,
        sperm TYPE lfm1-sperm,
      END OF gs_lfm1.

TYPES: BEGIN OF gs_adr3,
         addrnumber TYPE adr3-addrnumber,
         persnumber TYPE adr3-persnumber,
         country    TYPE adr3-country,
         fax_number TYPE adr3-fax_number,
         faxnr_long TYPE adr3-faxnr_long,
         faxnr_call TYPE adr3-faxnr_call,
       END OF gs_adr3.

TYPES: BEGIN OF gs_adr2,
         addrnumber TYPE adr2-addrnumber,
         persnumber TYPE adr2-persnumber,
         country    TYPE adr2-country,
         home_flag  TYPE adr2-home_flag,
         tel_number TYPE adr2-tel_number,
         tel_extens TYPE adr2-tel_extens,
         telnr_long TYPE adr2-telnr_long,
         telnr_call TYPE adr2-telnr_call,
       END OF gs_adr2.

TYPES: BEGIN OF gs_lfza,
         lifnr TYPE lfza-lifnr,
         bukrs TYPE lfza-bukrs,
         empfk TYPE lfza-empfk,
       END OF gs_lfza.

TYPES: BEGIN OF gs_adr6,
         addrnumber TYPE adr6-addrnumber,
         persnumber TYPE adr6-persnumber,
         smtp_addr  TYPE adr6-smtp_addr,
       END OF gs_adr6.

TYPES: BEGIN OF gs_/sdocs/sspy_atta,
         docid      TYPE /sdocs/sspy_atta-docid,
         arc_docid  TYPE /sdocs/sspy_atta-arc_docid,
         arc_id     TYPE /sdocs/sspy_atta-arc_id,
         file_name  TYPE /sdocs/sspy_atta-file_name,
         file_type  TYPE /sdocs/sspy_atta-file_type,
         cr_date    TYPE /sdocs/sspy_atta-cr_date,
         cr_time    TYPE /sdocs/sspy_atta-cr_time,
         ar_doctype TYPE  /sdocs/sspy_atta-ar_doctype,
       END OF gs_/sdocs/sspy_atta.

TYPES:BEGIN OF gs_act_supp,
        lifnr TYPE lfa1-lifnr,
        ktokk TYPE lfa1-ktokk,
        bukrs TYPE lfb1-bukrs,
      END OF gs_act_supp.

DATA:BEGIN OF gt_lnrzb OCCURS 0,
       lnrzb TYPE lfb1-lnrzb,
     END OF gt_lnrzb.

TYPES:BEGIN OF gs_lfa1,
        lifnr TYPE lfa1-lifnr,
      END OF gs_lfa1.

TYPES : BEGIN OF gs_but050,
          partner1 TYPE but050-partner1,
          partner2 TYPE but050-partner2,
        END OF gs_but050.

TYPES : BEGIN OF gs_but000,
          partner    TYPE but000-partner,
          name_first TYPE but000-name_first,
          name_last  TYPE but000-name_last,
          persnumber TYPE but000-persnumber,
        END OF gs_but000.


DATA: gt_final        TYPE STANDARD TABLE OF gs_final,
      gt_lifnr        TYPE STANDARD TABLE OF gs_lfa1 WITH HEADER LINE,
      gt_lfa1         TYPE STANDARD TABLE OF gs_vndr,
      gt_lfa1_v       TYPE STANDARD TABLE OF gs_vndr,
      gt_lfbk         TYPE STANDARD TABLE OF gs_lfbk,
      gt_bnka         TYPE STANDARD TABLE OF gs_bnka,
      gt_t001         TYPE STANDARD TABLE OF t001,
      gt_adrc         TYPE STANDARD TABLE OF gs_adrc,
      gt_adrc_v       TYPE STANDARD TABLE OF gs_adrc,
      gt_knvk         TYPE STANDARD TABLE OF gs_knvk,
      gt_adr2         TYPE STANDARD TABLE OF gs_adr2,
      gt_adr3         TYPE STANDARD TABLE OF gs_adr3,
      gt_adr6         TYPE TABLE OF adr6, "gs_adr6,
      gt_adr61        TYPE STANDARD TABLE OF adr6,
      gt_lfb1         TYPE STANDARD TABLE OF gs_lfb1,
      lt_t059t        TYPE STANDARD TABLE OF gs_t059t,
      gt_lfbw         TYPE STANDARD TABLE OF gs_lfbw,
      gt_lfm1         TYPE STANDARD TABLE OF gs_lfm1,
      gt_t059t        TYPE STANDARD TABLE OF t059t,
      gt_dbe          TYPE STANDARD TABLE OF gs_dbe,
      gt_prd          TYPE STANDARD TABLE OF gs_dbe,
      gt_actip_attach TYPE STANDARD TABLE OF /sdocs/sspy_atta,
      gt_kss          TYPE STANDARD TABLE OF gs_kss,
      gt_kss1         TYPE STANDARD TABLE OF gs_kss,
      gt_lfza         TYPE STANDARD TABLE OF gs_lfza,
      gt_but050       TYPE STANDARD TABLE OF gs_but050,
      gt_but000       TYPE STANDARD TABLE OF gs_but000,
      gt1_toa01       TYPE STANDARD TABLE OF toa01 WITH HEADER LINE,
      gt_toave        TYPE STANDARD TABLE OF toave WITH HEADER LINE,
      gt_toasp        TYPE STANDARD TABLE OF toasp WITH HEADER LINE,
      gt_toadv        TYPE STANDARD TABLE OF toadv WITH HEADER LINE,
      gt_attach       TYPE TABLE OF gs_/sdocs/sspy_atta,
      gt_act_supp     TYPE TABLE OF gs_act_supp,
      gt_act_supp1    TYPE TABLE OF gs_act_supp,
      gt_t006a        TYPE TABLE OF t006a,
      gt_curt         TYPE TABLE OF tcurt.

DATA: wa_final        TYPE  gs_final,
      wa_attach       TYPE gs_/sdocs/sspy_atta,
      wa_act_supp     TYPE gs_act_supp,
      wa_dbe          TYPE gs_dbe,
      wa_prd          TYPE gs_dbe,
      wa_lfa1         TYPE gs_vndr,
      wa_lfa1_v       TYPE gs_vndr1,
      wa_lfa2         TYPE lfa1,
      wa_lfbk         TYPE gs_lfbk,
      wa_t001         TYPE t001,
      wa_adrc         TYPE gs_adrc,
      wa_adrc_v       TYPE gs_adrc1,
      wa_adr6         TYPE adr6, "gs_adr6,
      wa_lfb1         TYPE gs_lfb1,
      wa_t059t        TYPE t059t,
      wa_toa01        TYPE toa01,
      wa_actip_attach TYPE /sdocs/sspy_atta,
      wa_kss1         TYPE gs_kss,
      wa_kss          TYPE gs_kss,
      wa_t006a        TYPE t006a,
      wa_curt         TYPE tcurt,
      wa_knvk         TYPE gs_knvk,
      wa_adr2         TYPE gs_adr2,
      wa_adr3         TYPE gs_adr3,
      wa_adr61        TYPE adr6,
      wa_bnka         TYPE gs_bnka,
      wa_lfza         TYPE gs_lfza,
      wa_lifnr        TYPE gs_lfa1,
      wa_but050       TYPE gs_but050,
      wa_but000       TYPE gs_but000,
      wa_lfbw         TYPE lfbw.

DATA: gv_atwtb     TYPE cawnt-atwtb,
      gv_atwtb1    TYPE cawnt-atwtb,
      gv_objid     TYPE toa01-object_id,
      gv_vname     TYPE char100,
      gv_file_name TYPE char128,
      gv_file_type TYPE char10,
      gv_count     TYPE sy-subrc,
      gv_block     TYPE char5,
      lv_all_comp  TYPE flag,
      gv_flag      TYPE char1.

DATA:wa_job_slog TYPE /sdocs/sspy_jlog,
     l_docid     TYPE /sdocs/s1_vndr_h-docid.
DATA:g_desc TYPE char255.
DATA:gv_http_sflag.
DATA: BEGIN OF it_lobj OCCURS 0,
        objid TYPE cdhdr-objectid,
      END OF it_lobj.
DATA: BEGIN OF it_oblfa1 OCCURS 0,
        lifnr TYPE lfa1-lifnr,
      END OF it_oblfa1.
DATA: BEGIN OF fs_cdhdr,
        objectclas TYPE cdhdr-objectclas,
        objectid   TYPE cdhdr-objectid,
      END OF fs_cdhdr.

TYPES:BEGIN OF tt_t059u,
        land1  TYPE t059u-land1,
        witht  TYPE t059u-witht,
        text40 TYPE t059u-text40,
      END OF tt_t059u.

TYPES:BEGIN OF tt_t059zt,
        land1     TYPE t059zt-land1,
        witht     TYPE t059zt-witht,
        wt_withcd TYPE t059zt-wt_withcd,
        text40    TYPE t059zt-text40,
      END OF tt_t059zt,
      BEGIN OF ty_lfa1,
        lifnr TYPE LFA1-lifnr,
        ktokk TYPE LFA1-ktokk,
      END OF ty_lfa1,
      BEGIN OF ty_lfb1,
        lifnr TYPE LFB1-lifnr,
        bukrs TYPE LFB1-bukrs,
      END OF ty_lfb1.


DATA: it_cdhdr LIKE TABLE OF fs_cdhdr WITH HEADER LINE.
DATA:lst_run_date TYPE char10,
     lst_run_time TYPE char10.

DATA v_nonpo          TYPE char10.
DATA:lv_bdate   TYPE sy-datum,
     lv_success.
RANGES:lr_date FOR sy-datum,
       lr_time FOR sy-uzeit.
TYPES:BEGIN OF fs_payeevendor,
        lifnr TYPE lfa1-lifnr,
        payee TYPE lfa1-lifnr,
      END OF fs_payeevendor.
DATA:wa_payeevendor TYPE fs_payeevendor,
     it_payeevendor TYPE TABLE OF fs_payeevendor.

DATA:gt_t059u  TYPE TABLE OF tt_t059u,
     gt_t059zt TYPE TABLE OF tt_t059zt,
     lt_lfa1   TYPE TABLE OF ty_lfa1,
     lt_lfb1   TYPE TABLE OF ty_lfb1.

DATA:BEGIN OF lt_config_vnd_block OCCURS 0,
       config_value TYPE /sdocs/sspy_sgc-config_value,
     END OF lt_config_vnd_block.

TYPES:BEGIN OF tt_comp,
        bukrs TYPE t001-bukrs,
      END OF tt_comp.
DATA:g_bukrs TYPE lfb1-bukrs.
DATA:lt_ccodes TYPE TABLE OF tt_comp.
DATA:lv_config_val  TYPE /sdocs/sspy_sgc-config_value.
DATA:lv_config_val1 TYPE /sdocs/sspy_sgc-config_value.
DATA:lv_characters  TYPE string VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.

***    code add on 08/09/2023
DATA : it_str       TYPE STANDARD TABLE OF line,
       wa_str       TYPE line,
       lv_pan_value TYPE char50,
       lv_db_table  TYPE char50,
       gv_wty       TYPE /sdocs/sspy_sgc-config_value.
*******

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS:p_profle TYPE /sdocs/sspy_sprf-profile_id OBLIGATORY, " MATCHCODE OBJECT /SDOCS/SH_PROFILE,
             p_tk_ext TYPE /sdocs/sspy_http_ext DEFAULT '',
             p_ext    TYPE /sdocs/sspy_http_ext DEFAULT '',
             p_bsize  TYPE int4   DEFAULT 5,
             p_retry  TYPE int4   DEFAULT 1,
             p_delta  TYPE c AS   CHECKBOX.

SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-003.

  SELECT-OPTIONS:s_lifnr  FOR lfa1-lifnr,
                 s_bukrs  FOR  g_bukrs,
                 s_cdate  FOR lfa1-erdat,
                 s_exvndr FOR lfa1-lifnr NO-EXTENSION.

SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  CLEAR:gv_server,gv_enable_token,gv_http_sflag,wa_str.
  REFRESH:it_str.


AT SELECTION-SCREEN OUTPUT." p_profle .
  p_profle = sy-sysid.
  LOOP AT SCREEN.
    IF screen-name = 'P_PROFLE'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

  CASE sy-tcode.
    WHEN '/SDOCS/S1_VEN_DISP'.
      LOOP AT SCREEN.
        IF screen-name CS 'S_CDATE' OR screen-name = 'P_DELTA'."_delta.
          screen-active = '0'.
          MODIFY SCREEN.
        ELSEIF  screen-name CS 'S_EXVNDR'.
          screen-active = '0'.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
  ENDCASE.

START-OF-SELECTION.
  CLEAR:gv_prog_locked.
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

  IF gv_prog_locked  IS NOT INITIAL.
    WRITE:/1 gv_run_ins_msg, 50 sy-datum ,65  sy-uzeit.
    MESSAGE s005(/sdocs/sspay_msg).
    EXIT.
  ENDIF.
  PERFORM get_data.

  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_enable_token WHERE config = 'HTTP_TOKEN_ENABLE'.
  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_data_to_file WHERE config = 'DATA_TRANSFER_VIA_FILE'.
  SELECT SINGLE config_value FROM /sdocs/sspy_sgc INTO gv_wty WHERE config = 'WITH_HOLD_TAX_TYPE_DIS'.
  CONDENSE gv_wty NO-GAPS.
***    code add on 08/09/2023
***For getting dynamic field form global configuration
*  SELECT SINGLE config_value INTO @DATA(lv_pan) FROM /sdocs/sspy_sgc WHERE config = 'VENDOR_PAN'.
*  IF lv_pan is not initial.
**    DATA(lv_safe_pan) = cl_abap_dyn_prg=>escape_quotes( lv_pan ).
*    wa_str-line = |{ lv_pan }|.
*    APPEND wa_str TO it_str.CLEAR wa_str.
*  ENDIF.
*  CLEAR lv_pan.
*******
  IF gv_enable_token IS NOT INITIAL.
    IF gt_lfa1[] IS NOT INITIAL.
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
    IF gt_lfa1[] IS INITIAL.
      MESSAGE s002(/sdocs/sspay_msg).
    ELSE.
      PERFORM push_data_to_portal.
    ENDIF.
  ENDIF.

  PERFORM unlock_run_instance.
  WRITE:/ ''.
  WRITE:/ ''.
  WRITE:/ 'Program completed successfully'.
*&---------------------------------------------------------------------*
*&      Form  REPLACE_SYM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_L_VNAME  text
*----------------------------------------------------------------------*
FORM replace_sym  USING    p_field_value.
  gv_sym_k = 0.CLEAR :gv_sym_s_str.
  gv_str_len = strlen( p_field_value ).
  conv = cl_abap_conv_out_ce=>create( encoding = 'UTF-8'
                                        endian   = 'L'
                                        ignore_cerr = 'X'
                                        replacement = '#' ).
  DO gv_str_len TIMES.
    CLEAR: gv_sym_str,gv_ch.
    gv_ch = p_field_value+gv_sym_k(1).
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
  p_field_value = gv_sym_s_str.

ENDFORM.                    " REPLACE_SYM

*&---------------------------------------------------------------------*
*&      Form  PORTAL_AUTHITICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM portal_authitication .

  CLEAR:wa_profile.
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
ENDFORM.                    " PORTAL_AUTHITICATION

*}   INSERT
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  DATA BEGIN OF gt_lifnr OCCURS 0.
  DATA  lifnr TYPE lfa1-lifnr.
  DATA END OF gt_lifnr.
  DATA:lt_but000 TYPE TABLE OF but000,
       wa_but000 TYPE but000.
  REFRESH: it_lobj,gt_act_supp[],it_cdhdr,it_oblfa1,"it_dca_archv_map,"GT_EXPDT,gt_vendordocs,GT_DCUMNT_MAP_U,GT_VNDRDOCS,it_acgrp
           gt_lnrzb[],gt_lifnr,gt_lfbw[],lt_config_vnd_block[],gt_lfm1[],lt_but000.

  CLEAR:it_lobj,gt_act_supp,it_cdhdr,it_oblfa1,v_nonpo,wa_job_slog,gt_lnrzb,wa_but000 ."WA_EXPDT,WA_VENDORDOCS,WA_VNDRDOCS,

  IF p_delta IS INITIAL."s_lifnr is not initial or s_cdate is not initial.
*    SELECT v~lifnr v~ktokk c~bukrs
*      FROM lfa1 AS v INNER JOIN lfb1 AS c
*      ON v~lifnr = c~lifnr INTO TABLE gt_act_supp[]
*      WHERE v~lifnr IN s_lifnr AND v~erdat IN s_cdate
*      AND   c~bukrs IN s_bukrs.

    lv_db_table = 'LFA1'.
    SELECT lifnr,
           ktokk
      INTO TABLE @lt_lfa1
      FROM (lv_db_table)
      WHERE lifnr IN @s_lifnr
        AND erdat IN @s_cdate.

    IF lt_lfa1 IS NOT INITIAL.

       lv_db_table = 'LFB1'.
      SELECT lifnr,
             bukrs
        INTO TABLE @lt_lfb1
        FROM (lv_db_table)
        FOR ALL ENTRIES IN @lt_lfa1
        WHERE lifnr = @lt_lfa1-lifnr
          AND bukrs IN @s_bukrs.

      LOOP AT lt_lfa1 ASSIGNING FIELD-SYMBOL(<fs_lfa1>).
        READ TABLE lt_lfb1 ASSIGNING FIELD-SYMBOL(<fs_lfb1>)
          WITH KEY lifnr = <fs_lfa1>-lifnr.
        IF sy-subrc = 0.
          APPEND VALUE #( lifnr = <fs_lfa1>-lifnr
                          ktokk = <fs_lfa1>-ktokk
                          bukrs = <fs_lfb1>-bukrs ) TO gt_act_supp.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ELSEIF p_delta IS NOT INITIAL.
    PERFORM get_job_schedule.
    lv_db_table = 'CDHDR'.
    SELECT objectclas,
           objectid
      FROM (lv_db_table)
      INTO TABLE @it_cdhdr
      WHERE objectclas = 'KRED'
      AND   udate = @sy-datum "lr_date
      AND  utime IN @lr_time
      AND  change_ind IN ('U','I').

    IF it_cdhdr[] IS INITIAL AND p_delta IS NOT INITIAL.
      MESSAGE s000(/sdocs/sspay_msg) WITH 'No Data Found!'.
      EXIT.
    ENDIF.
    LOOP AT it_cdhdr.
      it_oblfa1-lifnr = it_cdhdr-objectid.
      APPEND it_oblfa1.
      CLEAR:it_cdhdr,it_oblfa1.
    ENDLOOP.

    IF it_oblfa1[] IS NOT INITIAL.
      lv_db_table = 'LFA1'.
      SELECT lifnr ktokk FROM (lv_db_table) INTO TABLE gt_act_supp[] FOR ALL ENTRIES IN it_oblfa1[] "#EC CI_NO_TRANSFORM
      WHERE lifnr = it_oblfa1-lifnr.
    ENDIF.
  ENDIF.

  LOOP AT gt_act_supp INTO wa_act_supp.
    APPEND wa_act_supp TO gt_act_supp1[].
  ENDLOOP.

  REFRESH:gt_act_supp[].
  gt_act_supp[] =  gt_act_supp1[].

  IF gt_act_supp[] IS NOT INITIAL.

    lv_db_table = 'LFA1'.
    SELECT lifnr
           land1
           name1
           name2
           ort01
           pstl2
           pstlz
           adrnr
           ktokk
           stcd1
           stcd2
           stcd3
           j_1kftind
           lnrza
           loevm
           sperr
           sperm
           sperq
           sperz
*      STCD1
*           j_1ipanno
      FROM (lv_db_table)
      INTO TABLE gt_lfa1[]
      FOR ALL ENTRIES IN gt_act_supp
      WHERE lifnr = gt_act_supp-lifnr.

    IF gt_lfa1 IS NOT INITIAL.
      LOOP AT s_exvndr.
        DELETE gt_lfa1 WHERE lifnr = s_exvndr-low.
      ENDLOOP.
    ENDIF.

    lv_db_table = 'BUT050'.
    SELECT partner1
           partner2
      INTO TABLE gt_but050[]
      FROM (lv_db_table)
      FOR ALL ENTRIES IN gt_act_supp[]
      WHERE partner1 = gt_act_supp-lifnr.

    IF gt_but050[] IS  NOT INITIAL .
      lv_db_table = 'BUT000'.
      SELECT partner name_first name_last persnumber FROM (lv_db_table) INTO TABLE gt_but000 FOR ALL ENTRIES IN
                                  gt_but050 WHERE partner = gt_but050-partner2.
    ENDIF.


    IF gt_lfa1[] IS NOT INITIAL.
      IF gt_but000[] IS INITIAL.
        lv_db_table = 'BUT000'.
        SELECT * FROM (lv_db_table) INTO TABLE lt_but000 FOR ALL ENTRIES IN  gt_lfa1 WHERE partner = gt_lfa1-lifnr.
      ENDIF.

      lv_db_table = 'LFBK'.
      SELECT lifnr
             banks
             bankl
             bankn
        FROM (lv_db_table)
        INTO TABLE gt_lfbk
        FOR ALL ENTRIES IN gt_lfa1
       WHERE lifnr = gt_lfa1-lifnr.
    ENDIF.

    IF gt_lfbk[] IS NOT INITIAL.
      lv_db_table = 'BNKA'.
      SELECT banks
             bankl
             stras
             swift
             banka
        FROM (lv_db_table)
        INTO TABLE gt_bnka
        FOR ALL ENTRIES IN gt_lfbk
        WHERE banks = gt_lfbk-banks
        AND bankl = gt_lfbk-bankl.
    ENDIF.

    IF gt_lfa1[] IS NOT INITIAL.
      lv_db_table = 'LFB1'.
      SELECT lifnr
             bukrs
             sperr
             zahls
             zterm
             akont
*             mindk
        FROM (lv_db_table)
        INTO TABLE gt_lfb1[]
        FOR ALL ENTRIES IN gt_lfa1
      WHERE lifnr = gt_lfa1-lifnr
      AND   bukrs IN s_bukrs.

      IF gt_lfb1[] IS NOT INITIAL.
        lv_db_table = 'LFBW'.
        SELECT lifnr
               bukrs
               witht
               wt_withcd
          FROM (lv_db_table)
          INTO TABLE gt_lfbw[]
          FOR ALL ENTRIES IN gt_lfb1[]
          WHERE lifnr = gt_lfb1-lifnr
          AND   bukrs = gt_lfb1-bukrs.
************************************************************** open - 14.02.2022
*        select mindk,
*               mtext
*          from t059t
*          into table @lt_t059t[]
*          for all entries in @gt_lfb1[]
*          where spras = @sy-langu
*          and   mindk = @gt_lfb1-mindk.
************************************************************** close - 14.02.2022
      ENDIF.

      IF gt_lfbw[] IS NOT INITIAL.
        REFRESH:gt_t059u[],gt_t059zt[].
        lv_db_table = 'T059U'.
        SELECT  land1
                witht
                text40
          FROM (lv_db_table)
          INTO TABLE gt_t059u[]
          FOR ALL ENTRIES IN gt_lfbw[]
          WHERE spras = sy-langu
          AND   witht = gt_lfbw-witht.

        lv_db_table = 'T059ZT'.
        SELECT land1
               witht
               wt_withcd
               text40
          FROM (lv_db_table)
          INTO TABLE gt_t059zt[]
          FOR ALL ENTRIES IN gt_lfbw[]
          WHERE spras     = sy-langu
          AND   witht     = gt_lfbw-witht
          AND   wt_withcd = gt_lfbw-wt_withcd.
      ENDIF.

      lv_db_table = 'LFM1'.
      SELECT lifnr
             ekorg
             sperm
        FROM (lv_db_table)
        INTO TABLE gt_lfm1[]
        FOR ALL ENTRIES IN gt_lfa1[]
        WHERE lifnr = gt_lfa1-lifnr.

      lv_db_table = 'ADRC'.
      SELECT addrnumber
             tel_number
             tel_extens
             fax_number
             fax_extens
             country street
             house_num1
             str_suppl3
             location
             region
             name_co
             city1
             post_code1
        FROM (lv_db_table)
        INTO CORRESPONDING FIELDS OF TABLE gt_adrc[]
        FOR ALL ENTRIES IN gt_lfa1[]
        WHERE addrnumber   = gt_lfa1-adrnr.

      lv_db_table = 'KNVK'.
      SELECT parnr
             kunnr
             namev
             name1
             titel_ap
             lifnr
             prsnr
             pafkt
        FROM (lv_db_table) INTO CORRESPONDING FIELDS OF TABLE gt_knvk[]
        FOR ALL ENTRIES IN gt_lfa1[]
        WHERE lifnr = gt_lfa1-lifnr.

      lv_db_table = 'ADR3'.
      SELECT addrnumber
             persnumber
             country
             fax_number
             faxnr_long
             faxnr_call
        FROM (lv_db_table)
        INTO TABLE gt_adr3[]
        FOR ALL ENTRIES IN gt_lfa1[]
        WHERE  addrnumber = gt_lfa1-adrnr.         "#EC CI_NO_TRANSFORM

      lv_db_table = 'ADR2'.
      SELECT addrnumber
             persnumber
             country
             home_flag
             tel_number
             tel_extens
             telnr_long
             telnr_call
        FROM (lv_db_table)
        INTO TABLE gt_adr2[]
        FOR ALL ENTRIES IN gt_lfa1[]
      WHERE  addrnumber = gt_lfa1-adrnr.

      lv_db_table = 'LFZA'.
      SELECT lifnr
             bukrs
             empfk
        FROM (lv_db_table)
        INTO TABLE gt_lfza[]
        FOR ALL ENTRIES IN gt_lfa1[]
      WHERE empfk = gt_lfa1-lifnr.
    ENDIF.

    IF gt_adrc[] IS NOT INITIAL.
      lv_db_table = 'ADR6'.
      SELECT * FROM (lv_db_table) INTO TABLE gt_adr6 FOR ALL ENTRIES IN gt_adrc "#EC CI_NO_TRANSFORM
                         WHERE addrnumber = gt_adrc-addrnumber. "#EC CI_NO_TRANSFORM

      lv_db_table = 'TOASP'.
      SELECT * FROM (lv_db_table) INTO TABLE gt_toasp.
      lv_db_table = 'TOADV'.
      SELECT * FROM (lv_db_table) INTO TABLE gt_toadv.
    ENDIF.
    IF gt_knvk[] IS NOT INITIAL.
      lv_db_table = 'ADR6'.
      SELECT * FROM (lv_db_table) APPENDING TABLE gt_adr6 FOR ALL ENTRIES IN gt_knvk "#EC CI_NO_TRANSFORM
                           WHERE persnumber = gt_knvk-prsnr. "#EC CI_NO_TRANSFORM
    ENDIF.
    IF lt_but000[] IS NOT INITIAL.
      lv_db_table = 'ADR6'.
      SELECT * FROM (lv_db_table) APPENDING TABLE gt_adr6 FOR ALL ENTRIES IN lt_but000 WHERE addrnumber = lt_but000-addrcomm.
    ENDIF.


*********************************************
    CLEAR:lv_config_val,wa_lfa1,lv_config_val1.
    REFRESH:lt_config_vnd_block[].",lt_vnd_blck[].
    SELECT SINGLE config_value
       FROM /sdocs/sspy_sgc
       INTO  lv_config_val
       WHERE config = 'VENDOR_BLOCK_TYPE'.

    SELECT SINGLE config_value
            FROM /sdocs/sspy_sgc
            INTO  lv_config_val1
            WHERE config = 'VENDOR_COMPANY_BLOCK'.

    SPLIT lv_config_val  AT ';' INTO TABLE lt_config_vnd_block[].
    SPLIT lv_config_val1 AT ';' INTO TABLE lt_ccodes[].

*********************************************

    LOOP AT gt_lfa1 INTO wa_lfa1.
      gv_objid = wa_lfa1-lifnr.
      REFRESH:gt_kss,gt_kss1.

*      SELECT * FROM TOA01 APPENDING TABLE GT_TOA01 WHERE SAP_OBJECT = 'LFA1' AND OBJECT_ID = GV_OBJID.
      IF  p_delta IS INITIAL.
*        DELETE GT_TOA01 WHERE AR_OBJECT <> 'ZVENDW9'.
      ENDIF.
      lv_db_table = 'KSSKAUSP'.
      SELECT objek  clint atzhl  atinn atwrt  FROM (lv_db_table) INTO TABLE gt_kss  WHERE objek = gv_objid
                                                  AND   clint = '0000000022'
                                                  AND   klart = '010'
      AND   atinn = '0000000100'.
      IF sy-subrc <> 0.
        lv_db_table = 'KSSKAUSP'.
        SELECT objek  clint atzhl  atinn atwrt  FROM (lv_db_table) INTO TABLE gt_kss  WHERE objek = gv_objid
                                                 AND   clint = '0000000023'
                                                 AND   klart = '010'
        AND   atinn = '0000000100'.
      ENDIF.
      lv_db_table = 'KSSKAUSP'.
      SELECT  objek  clint atzhl  atinn atwrt FROM (lv_db_table) INTO TABLE gt_kss1  WHERE objek = gv_objid
                                                AND   clint = '0000000022'
                                                AND   klart = '010'
      AND   atinn = '0000000101'.
      IF sy-subrc <> 0.
        lv_db_table = 'KSSKAUSP'.
        SELECT  objek  clint atzhl  atinn atwrt FROM (lv_db_table) INTO TABLE gt_kss1  WHERE objek = gv_objid
                                                 AND   clint = '0000000023'
                                                 AND   klart = '010'
        AND   atinn = '0000000101'.
      ENDIF.

      LOOP AT gt_kss INTO  wa_kss.
        lv_db_table = 'CAWNT'.
        SELECT SINGLE atwtb FROM (lv_db_table) INTO gv_atwtb WHERE atinn = wa_kss-atinn AND atzhl = wa_kss-atzhl AND spras = 'E'.
        IF wa_kss-atwrt IS NOT INITIAL.
          wa_dbe-atwrt = wa_kss-atwrt.
        ENDIF.

        IF wa_dbe-atwrt IS NOT INITIAL AND gv_atwtb IS NOT INITIAL.
          wa_dbe-atwtb = gv_atwtb.
          wa_dbe-objek = wa_kss-objek.
          APPEND wa_dbe TO gt_dbe.CLEAR:wa_dbe,gv_atwtb.
        ENDIF.
      ENDLOOP.

      LOOP AT gt_kss1 INTO  wa_kss1.
        lv_db_table = 'CAWNT'.
        SELECT SINGLE atwtb FROM (lv_db_table) INTO gv_atwtb1 WHERE atinn = wa_kss1-atinn AND atzhl = wa_kss1-atzhl AND spras = 'E'.
        IF wa_kss1-atwrt IS NOT INITIAL.
          wa_prd-atwrt = wa_kss1-atwrt.
        ENDIF.

        IF wa_prd-atwrt IS NOT INITIAL AND gv_atwtb1 IS NOT INITIAL.
          wa_prd-atwtb = gv_atwtb1.
          wa_prd-objek = wa_kss1-objek.
          APPEND wa_prd TO gt_prd.CLEAR:wa_prd,gv_atwtb1.
        ENDIF.

      ENDLOOP.
      CLEAR:wa_lfa1,gv_objid,wa_dbe,wa_prd,gv_atwtb1,gv_atwtb,wa_kss1.
      REFRESH:gt_kss1,gt_kss.
    ENDLOOP.
  ENDIF.

  LOOP AT gt_lfa1 INTO wa_lfa1 .
    CLEAR:wa_lfbk,wa_adrc,wa_adr6,wa_lfb1.
    wa_final-sup_id = wa_lfa1-lifnr. "vendornumber /supplier-id
    CONCATENATE wa_lfa1-name1 '' INTO wa_final-sup_name SEPARATED BY space.
    wa_final-city       = wa_lfa1-ort01."city
    wa_final-zip        = wa_lfa1-pstl2."P.O. Box Postal Code
    wa_final-country    = wa_lfa1-land1."country key
    READ TABLE gt_lfbk INTO wa_lfbk WITH KEY lifnr = wa_lfa1-lifnr.
    READ TABLE gt_lfb1 INTO wa_lfb1 WITH KEY lifnr = wa_lfa1-lifnr.
    READ TABLE gt_adrc INTO wa_adrc WITH KEY addrnumber = wa_lfa1-adrnr.
    READ TABLE gt_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_adrc-addrnumber.
    IF wa_adr6 IS INITIAL.
      READ TABLE lt_but000 INTO wa_but000 WITH KEY partner = wa_lfa1-lifnr.
      READ TABLE gt_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_but000-addrcomm.
    ENDIF.
    wa_final-bank_cntry_key  = wa_lfbk-banks. " Bank country key
    wa_final-bankl    = wa_lfbk-banks. "Bank Key or Routing Number.
    wa_final-bank_acc_no      = wa_lfbk-bankn ." Bank account number
    wa_final-bankl = wa_lfbk-bankl.
    wa_final-zahls = wa_lfb1-zahls.
    wa_final-address1 = wa_adrc-street.  " address1
    wa_final-address2 = wa_adrc-house_num1.  " address1
    wa_final-address3 = wa_adrc-str_suppl3.  " address1
    wa_final-location = wa_adrc-location .   "location
    wa_final-tel_number = wa_adrc-tel_number.
    wa_final-fax_number = wa_adrc-fax_number.
    wa_final-email      = wa_adr6-smtp_addr.
    wa_final-acc_group  = wa_lfa1-ktokk.
    wa_final-sperr      = wa_lfa1-sperr.
    APPEND wa_final TO gt_final. CLEAR wa_final.
  ENDLOOP.
  IF p_delta IS NOT INITIAL AND gt_lfa1[] IS INITIAL.
    wa_job_slog-prog_name = '/SDOCS/SSPAY_VENDOR_DATA_DISP'.
    wa_job_slog-prog_type = 'HTTP_CALL'.
    wa_job_slog-jlog_date = gv_curr_date.
    wa_job_slog-jlog_time = gv_curr_time.
    lv_db_table = '/sdocs/sspy_jlog'.
    MODIFY (lv_db_table) FROM wa_job_slog.
    REFRESH:gt_lifnr[].
  ENDIF.
ENDFORM.                    " GET_DATA
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
  CONCATENATE  gv_server  '/' p_ext INTO gv_url_str.
ENDFORM.                    " GET_URL
*&---------------------------------------------------------------------*
*&      Form  DISPATCH_PORTAL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dispatch_portal_data .

  PERFORM update USING gv_url gv_token
                 CHANGING gv_subrc.

  IF gv_res_str CA 'INVALID_XML'.
    gv_http_sflag = 'X'.
    WRITE:/2 'Job run date & time:' COLOR 3,26 sy-datum COLOR 3,38 sy-uzeit COLOR 3.
    SKIP 1.
    MESSAGE s000(/sdocs/sspay_msg) WITH 'Invalid XML!'.
    WRITE:/2 'Vendor data sync failed!'.
    LOOP AT gt_lifnr INTO wa_lifnr.
      WRITE:/2 wa_lifnr-lifnr.
      CLEAR: wa_lifnr-lifnr.
    ENDLOOP.
  ELSEIF ( ( gv_scode = '200' OR gv_scode = '201' ) OR gv_res_str = 'OK' ).

    LOOP AT gt_lifnr INTO wa_lifnr.
      IF gv_flag IS INITIAL.
        gv_flag = 'X'.
        WRITE:/2 'Job run date & time:' COLOR 3,26 sy-datum COLOR 3,38 sy-uzeit COLOR 3.
        SKIP 1.
        WRITE:/2 'Vendor Data Dispatched for:', wa_lifnr-lifnr.
      ELSE.
        WRITE:/30 wa_lifnr-lifnr.
      ENDIF.
      CLEAR:wa_lifnr.
    ENDLOOP.
  ENDIF.
  REFRESH:gt_lifnr[].
ENDFORM.                    " DISPATCH_PORTAL_DATA
FORM update  USING    p_uri
                      p_token
             CHANGING p_subrc.

  DATA:g_lines TYPE sy-index.

  CLEAR:gv_xml_str,gv_res_str,gv_success,gv_scode,gv_stext,g_lines.
  LOOP AT gt_xml INTO gs_xml.
    CONCATENATE gv_xml_str gs_xml-line  INTO gv_xml_str.
  ENDLOOP.

  DESCRIBE TABLE gt_xml[] LINES g_lines.

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
      p_token = 'NOTOKEN'.
    ENDIF.

    IF g_lines > 2.
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
          c_token_id           = gv_token
        EXCEPTIONS
          ex_internal_error    = 1
          ex_connection_failed = 2
          OTHERS               = 3.
      IF sy-subrc <> 0.
      ELSE.
        IF gv_res_str CS 'INVALID_XML'.
          MESSAGE s003(/sdocs/sspay_msg) WITH 'Invalid XML!'.
        ELSE.
          p_subrc = 0.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_HEADERDATA_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_headerdata_xml .
  DATA:l_vend_msme_lifnr TYPE /sdocs/sspy_sgc-config_value.
  DATA:l_vend_msme_lifnr1 TYPE /sdocs/sspy_sgc-config_value.
  DATA var1(2) TYPE c.
  DATA:l_vend_msme_glacc TYPE /sdocs/sspy_sgc-config_value.
  DATA:lv_years TYPE /sdocs/sspy_sgc-config_value.
  CLEAR:lv_bdate,lv_years,wa_adr6,l_vend_msme_glacc,l_vend_msme_lifnr,l_vend_msme_lifnr1,var1.
lv_db_table = '/sdocs/sspy_sgc'.
  SELECT SINGLE config_value INTO l_vend_msme_lifnr
       FROM (lv_db_table) WHERE config = 'VENDOR_MSME_LIFNR'.
lv_db_table = '/sdocs/sspy_sgc'.
  SELECT SINGLE config_value INTO l_vend_msme_lifnr1
  FROM (lv_db_table) WHERE config = 'VENDOR_MSME_LIFNR_V'.

  READ TABLE  gt_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_lfa1-adrnr persnumber = '' .
  IF sy-subrc EQ 0.
*    WA_ADR6-SMTP_ADDR = WA_EXST_VEN-ROLE.
  ENDIF.

  PERFORM replace_sym USING wa_adr6-smtp_addr.
  READ TABLE gt_adrc INTO wa_adrc WITH KEY addrnumber = wa_lfa1-adrnr.

  CLEAR gv_vname.
  gs_xml-line = '<SUPPLR_DATA>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  CONCATENATE '<SYSTEM_ID>' sy-sysid '</SYSTEM_ID>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml.
  CLEAR gs_xml.

  CONCATENATE '<CLIENT_ID>' sy-mandt '</CLIENT_ID>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml.
  CLEAR: gs_xml.

  IF wa_lfa1-lifnr CA lv_characters.

  ELSE.
    SHIFT wa_lfa1-lifnr LEFT DELETING LEADING '0'.
  ENDIF.

  CONCATENATE '<SUPPLR_ID>' wa_lfa1-lifnr '</SUPPLR_ID>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  CONCATENATE wa_lfa1-name1 wa_lfa1-name2 '' INTO gv_vname SEPARATED BY space.

  CLEAR gv_desc.
  gv_desc = gv_vname.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<SUPPLR_NAME>' gv_desc '</SUPPLR_NAME>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfb1.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = wa_lfa1-lifnr
    IMPORTING
      output = wa_lfa1-lifnr.

  CLEAR:wa_lfb1,gv_block,v_nonpo,wa_lfbw.
  READ TABLE gt_lfb1 INTO wa_lfb1 WITH KEY lifnr = wa_lfa1-lifnr.
  READ TABLE gt_lfbw INTO wa_lfbw WITH KEY lifnr = wa_lfa1-lifnr.
  CONDENSE wa_lfa1-stcd3 NO-GAPS.

  CONCATENATE '<GST>' wa_lfa1-stcd3 '</GST>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml.
  CLEAR:gs_xml.
*  IF it_str IS NOT INITIAL.
*    lv_db_table = 'LFA1'.
*    SELECT SINGLE (it_str) FROM (lv_db_table) INTO @lv_pan_value WHERE lifnr = @wa_lfa1-lifnr.
*  ENDIF.
**  PACK lv_pan_value TO lv_pan_value.
*  SHIFT lv_pan_value LEFT DELETING LEADING '0'.
*  CONDENSE lv_pan_value NO-GAPS.

  APPEND |<STATUS>Active</STATUS>| TO GT_XML.

  gs_xml-line = |<PAN_NUMBER> </PAN_NUMBER>|.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,lv_pan_value.
*  CONCATENATE '<PAN_NUMBER>' wa_lfa1-stcd1 '</PAN_NUMBER>' INTO gs_xml-line."wa_lfa1-j_1ipanno
*  APPEND gs_xml TO gt_xml. CLEAR:gs_xml.

************************************************************** open - 14.02.2022
*CLEAR:VAR1.
*  IF WA_LFB1-LIFNR IS NOT INITIAL.
*    SHIFT WA_LFB1-LIFNR LEFT DELETING LEADING '0'.
*    VAR1 = WA_LFB1-LIFNR+0(1).
*  ENDIF.
*  IF L_VEND_MSME_LIFNR EQ VAR1.
*    CONCATENATE '<MSME>' 'true' '</MSME>'  INTO GS_XML-LINE.
*    APPEND GS_XML TO GT_XML.
*    CLEAR:GS_XML.
*  ELSEIF L_VEND_MSME_LIFNR1 EQ VAR1.
*    CONCATENATE '<MSME>' 'true' '</MSME>'  INTO GS_XML-LINE.
*    APPEND GS_XML TO GT_XML.
*    CLEAR:GS_XML.
*  ELSE.
*    CONCATENATE '<MSME>' 'false' '</MSME>'  INTO GS_XML-LINE.
*    APPEND GS_XML TO GT_XML.
*    CLEAR:GS_XML.
*  ENDIF.
  IF wa_lfa1-j_1kftind = 'Medium Enterprises' OR wa_lfa1-j_1kftind = 'Micro Enterprises' OR wa_lfa1-j_1kftind = 'Small Enterprises'.
    CONCATENATE '<MSME>' 'true' '</MSME>'  INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR:gs_xml.
    CLEAR:gv_desc.
  ELSE.
    CONCATENATE '<MSME>' 'flase' '</MSME>'  INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR:gs_xml.
    CLEAR:gv_desc.
  ENDIF.

  gv_desc = wa_lfa1-ktokk.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<ACC_GROUP>' gv_desc '</ACC_GROUP>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfbk.
  IF wa_lfa1-ktokk = 'PT03' OR wa_lfa1-ktokk = 'PT04' OR wa_lfa1-ktokk = 'PT02'.
    v_nonpo = 'false'.
  ELSEIF wa_lfa1-ktokk = 'PT01'.
    v_nonpo = 'true'.
  ENDIF.

  CONCATENATE '<NON_PO>' v_nonpo '</NON_PO>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfbk.

  IF wa_adrc-tel_number IS NOT INITIAL.

  ENDIF.

  CONCATENATE '<PHONE_NUMBER>' wa_adrc-tel_number '</PHONE_NUMBER>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfbk.

  CONCATENATE '<SSN_NO>' wa_lfa1-stcd1 '</SSN_NO>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfbk.

  CONCATENATE '<PHONE_EXT>' wa_adrc-tel_extens '</PHONE_EXT>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfbk.

  CONCATENATE '<PHONE_CNTRYCODE>' wa_adrc-country '</PHONE_CNTRYCODE>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfbk.

  IF wa_adrc-fax_number IS NOT INITIAL.

  ENDIF.

  CONCATENATE '<FAX_NUMBER>' wa_adrc-fax_number '</FAX_NUMBER>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfbk.

  CONCATENATE '<FAX_CNTRYCODE>' wa_adrc-fax_extens '</FAX_CNTRYCODE>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfbk.

  TRANSLATE wa_adr6-smtp_addr TO LOWER CASE.
  CONCATENATE '<PRIMARY_EMAIL>' wa_adr6-smtp_addr '</PRIMARY_EMAIL>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfbk.

  CONCATENATE '<EMP_ID_NO>' wa_lfa1-stcd2 '</EMP_ID_NO>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml.
  CLEAR:gs_xml.
  IF wa_lfa1-stcd1 IS NOT INITIAL.
    CONCATENATE '<TAXID>' wa_lfa1-stcd1 '</TAXID>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR:gs_xml.
  ELSE.
    CONCATENATE '<TAXID>' wa_lfa1-stcd2 '</TAXID>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
  ENDIF.
  IF wa_lfbw-witht = 'FE'.
    CONCATENATE '<VC1099>' 'true' '</VC1099>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
  ELSE.
    CONCATENATE '<VC1099>' 'false' '</VC1099>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
  ENDIF.


  CLEAR:gs_xml,wa_lfbk.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DBEDATA_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_dbedata_xml .
  DATA:lv_dbdate TYPE char10.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = wa_lfa1-lifnr
    IMPORTING
      output = wa_lfa1-lifnr.
  gs_xml-line = '<DIVERSE_BUSINESSES>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  CLEAR:gv_objid,lv_dbdate.
  gv_objid = wa_lfa1-lifnr.
  LOOP AT gt_dbe INTO wa_dbe WHERE objek = gv_objid.
*    READ TABLE GT_EXPDT INTO WA_EXPDT WITH KEY LIFNR = GV_OBJID  ATWRT = WA_DBE-ATWRT.
    IF wa_dbe-atwrt EQ 'REG'.
      CONTINUE.
    ENDIF.
    gs_xml-line = '<DIVERSE_BUSINESS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CONCATENATE '<DBE>' wa_dbe-atwrt '</DBE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfb1.
    CLEAR g_desc.
    g_desc = wa_dbe-atwtb.
    PERFORM replace_sym USING g_desc.
    CONCATENATE '<DBE_DES>'  g_desc '</DBE_DES>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_t059t,lv_dbdate.

    CONCATENATE '<EXPIRATION_DATE>' lv_dbdate '</EXPIRATION_DATE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CONCATENATE '<CERTIFICATION_DATE>' '</CERTIFICATION_DATE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_t059t.
    gs_xml-line = '</DIVERSE_BUSINESS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CLEAR:wa_dbe.
  ENDLOOP.
  gs_xml-line = '</DIVERSE_BUSINESSES>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_PCTDATA_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_pctdata_xml .
  gs_xml-line = '<PRODUCT_CATAGORIES>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  CLEAR: gv_objid.
  gv_objid = wa_lfa1-lifnr.
  LOOP AT gt_prd INTO wa_prd WHERE objek = wa_lfa1-lifnr  .

    CONCATENATE '<PRODUCT_CATAGORY>' wa_prd-atwrt '</PRODUCT_CATAGORY>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfb1.

    CLEAR:wa_prd.
  ENDLOOP.
  gs_xml-line = '</PRODUCT_CATAGORIES>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ADDRESSDATA_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_addressdata_xml .
  CLEAR:wa_adrc.
  LOOP AT gt_adrc INTO wa_adrc WHERE addrnumber = wa_lfa1-adrnr.
    gs_xml-line = '<ADDRESS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CLEAR gv_desc.
    gv_desc = wa_adrc-street.
    PERFORM replace_sym USING  gv_desc .
    CONCATENATE '<ADDRESS1>'  gv_desc '</ADDRESS1>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CLEAR gv_desc.
    REPLACE ALL OCCURRENCES OF ',' IN  wa_adrc-street WITH ''.
    gv_desc = wa_adrc-house_num1.
    PERFORM replace_sym USING gv_desc .
    CONCATENATE '<ADDRESS2>' gv_desc '</ADDRESS2>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CLEAR gv_desc.
    gv_desc = wa_adrc-location.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<LCTON>' gv_desc '</LCTON>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CLEAR gv_desc.
    gv_desc = wa_adrc-city1.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<CITY>' gv_desc '</CITY>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CONCATENATE '<STATE>' wa_adrc-region '</STATE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CLEAR gv_desc.
    gv_desc = wa_adrc-country.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<CNTRY>' gv_desc '</CNTRY>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
*    PERFORM REPLACE_SYM USING WA_ADRC-POST_CODE1.
    CONCATENATE '<ZIP>' wa_adrc-post_code1 '</ZIP>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    gs_xml-line = '</ADDRESS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CLEAR:wa_adrc.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_REMIT_ADD_DATA_XML
*&---------------------------------------------------------------------*
*       text

*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_remit_add_data_xml .
  "New Code for remmit address
  DATA:lv_lnrzb TYPE lfb1-lnrzb.
  CLEAR: lv_lnrzb.
  gs_xml-line = '<REMITANCE_ADDRESSES>'.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml,wa_lfza,wa_lfa1_v,wa_adrc_v.
  lv_db_table = 'LFB1'.
  SELECT SINGLE lnrzb FROM (lv_db_table) INTO lv_lnrzb WHERE lifnr = wa_lfa1-lifnr.
  lv_db_table = 'LFA1'.
  SELECT SINGLE lifnr land1 name1 name2 ort01 pstlz adrnr FROM (lv_db_table)
  INTO wa_lfa1_v WHERE lifnr = wa_lfa1-lifnr.

  lv_db_table = 'ADRC'.
  SELECT SINGLE addrnumber name_co street  house_num1 region FROM (lv_db_table) INTO  wa_adrc_v
  WHERE addrnumber = wa_lfa1_v-adrnr.

  gs_xml-line = '<REMITANCE_ADDRESS>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  CONCATENATE wa_lfa1_v-name1 wa_lfa1_v-name2 INTO gv_vname SEPARATED BY ''.
  PERFORM replace_sym USING wa_lfa1_v-name1.
*      shift wa_lfa1_v-lifnr left deleting leading '0'.
  PERFORM replace_sym USING gv_vname.
  CONCATENATE '<PAYEE_NAME>' gv_vname '</PAYEE_NAME>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  CLEAR gv_desc.
  gv_desc = wa_adrc_v-house_num1.
  PERFORM replace_sym USING gv_desc .
  CONCATENATE '<ADDRESS1>' gv_desc '</ADDRESS1>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  CLEAR gv_desc.
  REPLACE ALL OCCURRENCES OF ',' IN  wa_adrc_v-street WITH ''.
  gv_desc = wa_adrc_v-street.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<ADDRESS2>' gv_desc '</ADDRESS2>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  CLEAR gv_desc.
  gv_desc = wa_lfa1_v-ort01.
  PERFORM replace_sym USING gv_desc.
  CONCATENATE '<CITY>' gv_desc '</CITY>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  CONCATENATE '<STATE>' wa_adrc_v-region '</STATE>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
*  PERFORM REPLACE_SYM USING WA_LFA1_V-LAND1.
  CONCATENATE '<CNTRY>' wa_lfa1_v-land1 '</CNTRY>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  CONCATENATE '<ZIP>' wa_lfa1_v-pstlz '</ZIP>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  gs_xml-line = '</REMITANCE_ADDRESS>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  IF lv_lnrzb IS NOT INITIAL.
    CLEAR:wa_lfa1_v,wa_adrc_v.
    lv_db_table = 'LFA1'.
    SELECT SINGLE lifnr land1 name1 name2 ort01 pstlz adrnr FROM (lv_db_table)
    INTO wa_lfa1_v WHERE lifnr = lv_lnrzb.

    lv_db_table = 'ADRC'.
    SELECT SINGLE addrnumber name_co street  house_num1 region FROM (lv_db_table) INTO  wa_adrc_v
    WHERE addrnumber = wa_lfa1_v-adrnr.
    gs_xml-line = '<REMITANCE_ADDRESS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CONCATENATE wa_lfa1_v-name1 wa_lfa1_v-name2 INTO gv_vname SEPARATED BY ''.
    PERFORM replace_sym USING wa_lfa1_v-name1.
*      shift wa_lfa1_v-lifnr left deleting leading '0'.
    PERFORM replace_sym USING gv_vname.
    CONCATENATE '<PAYEE_NAME>' gv_vname '</PAYEE_NAME>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CLEAR gv_desc.
    gv_desc = wa_adrc_v-house_num1.
    PERFORM replace_sym USING gv_desc .
    CONCATENATE '<ADDRESS1>' gv_desc '</ADDRESS1>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CLEAR gv_desc.
    REPLACE ALL OCCURRENCES OF ',' IN  wa_adrc_v-street WITH ''.
    gv_desc = wa_adrc_v-street.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<ADDRESS2>' gv_desc '</ADDRESS2>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CLEAR gv_desc.
    gv_desc = wa_lfa1_v-ort01.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<CITY>' gv_desc '</CITY>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CONCATENATE '<STATE>' wa_adrc_v-region '</STATE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
*  PERFORM REPLACE_SYM USING WA_LFA1_V-LAND1.
    CONCATENATE '<CNTRY>' wa_lfa1_v-land1 '</CNTRY>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CONCATENATE '<ZIP>' wa_lfa1_v-pstlz '</ZIP>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    gs_xml-line = '</REMITANCE_ADDRESS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  ENDIF.
*    endloop.

  gs_xml-line = '</REMITANCE_ADDRESSES>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CONTACT_DATA_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_contact_data_xml .
  CLEAR:wa_adr6.
  READ TABLE  gt_adr6 INTO wa_adr6 WITH KEY addrnumber = wa_lfa1-adrnr persnumber = ''  flgdefault = 'X'.

  PERFORM replace_sym USING wa_adr6-smtp_addr.
  READ TABLE gt_adrc INTO wa_adrc WITH KEY addrnumber = wa_lfa1-adrnr.

  gs_xml-line = '<CNTCTS>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.


  CONCATENATE '<CNTCT_ID>' wa_lfa1-lifnr  '</CNTCT_ID>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  CONCATENATE wa_lfa1-name1 wa_lfa1-name2 '' INTO gv_vname SEPARATED BY space.

  CLEAR gv_desc.
  gv_desc = gv_vname.
  PERFORM replace_sym USING gv_desc.


  CONCATENATE '<FRST_NAME>' gv_desc '</FRST_NAME>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  CONCATENATE '<LST_NAME>' '' '</LST_NAME>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  TRANSLATE wa_adr6-smtp_addr TO LOWER CASE.
  CLEAR: gv_desc.
  gv_desc =  wa_adr6-smtp_addr .
  PERFORM replace_sym USING gv_desc .
  TRANSLATE gv_desc TO LOWER CASE.
  CONCATENATE '<EMAL>' gv_desc '</EMAL>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR: gs_xml.

  CONCATENATE '<FAX_NUMBER>' wa_adrc-fax_number '</FAX_NUMBER>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml.

  CONCATENATE '<FAX_CNTRYCODE>' wa_adrc-fax_extens '</FAX_CNTRYCODE>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml.

  CONCATENATE '<PHONE_NUMBER>' wa_adrc-tel_number '</PHONE_NUMBER>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR:gs_xml.

  CONCATENATE '<PHONE_CNTRYCODE>' wa_adrc-country  '</PHONE_CNTRYCODE>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  CONCATENATE '<PHONE_EXT>' wa_adrc-country '</PHONE_EXT>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR: gs_xml.

  CONCATENATE '<MOBILE_NUMBER>' '' '</MOBILE_NUMBER>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  CONCATENATE '<MOBILE_CNTRYCODE>' '' '</MOBILE_CNTRYCODE>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  CONCATENATE '<CNCT>'  '</CNCT>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  CONCATENATE '<FUNC_NAME>' '' '</FUNC_NAME>' INTO gs_xml-line.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  gs_xml-line = '</CNTCTS>'.
  APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  CLEAR:wa_adrc,wa_adr3,wa_adr2,wa_adr6,wa_but000.

  LOOP AT gt_knvk INTO wa_knvk WHERE lifnr = wa_lfa1-lifnr.
    READ TABLE  gt_adr6 INTO wa_adr6 WITH KEY   persnumber = wa_knvk-prsnr.
    gs_xml-line = '<CNTCTS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.


    CONCATENATE '<CNTCT_ID>' wa_lfa1-lifnr  '</CNTCT_ID>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.



    CLEAR gv_desc.
    gv_desc = wa_knvk-namev.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<FRST_NAME>' gv_desc '</FRST_NAME>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CLEAR gv_desc.
    gv_desc = wa_knvk-name1.
    PERFORM replace_sym USING gv_desc.
    CONCATENATE '<LST_NAME>' gv_desc '</LST_NAME>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    TRANSLATE wa_adr6-smtp_addr TO LOWER CASE.
    CLEAR: gv_desc.
    gv_desc =  wa_adr6-smtp_addr .
    PERFORM replace_sym USING gv_desc .
    TRANSLATE gv_desc TO LOWER CASE.
    CONCATENATE '<EMAL>' gv_desc '</EMAL>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR: gs_xml.

    CONCATENATE '<FAX_NUMBER>' wa_adrc-fax_number '</FAX_NUMBER>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR:gs_xml.

    CONCATENATE '<FAX_CNTRYCODE>' wa_adrc-fax_extens '</FAX_CNTRYCODE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR:gs_xml.

    CONCATENATE '<PHONE_NUMBER>' wa_adrc-tel_number '</PHONE_NUMBER>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR:gs_xml.

    CONCATENATE '<PHONE_CNTRYCODE>' wa_adrc-country  '</PHONE_CNTRYCODE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CONCATENATE '<PHONE_EXT>' wa_adrc-country '</PHONE_EXT>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR: gs_xml.

    CONCATENATE '<MOBILE_NUMBER>' '' '</MOBILE_NUMBER>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CONCATENATE '<MOBILE_CNTRYCODE>' '' '</MOBILE_CNTRYCODE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CONCATENATE '<CNCT>'  '</CNCT>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CONCATENATE '<FUNC_NAME>' '' '</FUNC_NAME>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    gs_xml-line = '</CNTCTS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BANK_DATA_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_bank_data_xml .
  LOOP AT gt_lfbk INTO wa_lfbk WHERE lifnr = wa_lfa1-lifnr.
    CLEAR  wa_bnka.
    READ TABLE gt_bnka INTO wa_bnka WITH KEY banks = wa_lfbk-banks bankl = wa_lfbk-bankl.
    gs_xml-line = '<BNK_DTLS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CONCATENATE '<BNK_KEY>' wa_lfbk-bankl '</BNK_KEY>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CLEAR:g_desc.
    g_desc = wa_lfbk-bankn.
    PERFORM replace_sym USING g_desc.
    CONCATENATE '<BNK_ACC_NO>' g_desc '</BNK_ACC_NO>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CONCATENATE '<BNK_CNTRY_KEY>' wa_lfbk-banks '</BNK_CNTRY_KEY>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CLEAR g_desc.
    g_desc = wa_bnka-banka.
    PERFORM replace_sym USING g_desc.
    CONCATENATE '<BNK_NAME>' g_desc '</BNK_NAME>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CLEAR g_desc.
    g_desc = wa_bnka-stras.
    PERFORM replace_sym USING g_desc.
    CONCATENATE '<BNK_ADDRESS>' g_desc '</BNK_ADDRESS>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CONCATENATE '<BNK_SWIFT_CODE>' wa_bnka-swift '</BNK_SWIFT_CODE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    CONCATENATE '<BNK_IFSC_CODE>'  '</BNK_IFSC_CODE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

    gs_xml-line = '</BNK_DTLS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    CLEAR wa_lfbk.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_VENDORDOCS_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_vendordocs_xml .

  DATA:att_lines   TYPE sy-tabix,
       it_attach   TYPE TABLE OF gs_/sdocs/sspy_atta,
       it_toa01    TYPE TABLE OF toa01,
       lv_att_ind  TYPE sy-tabix,
       lv_exp_date TYPE sy-datum,
       lv_lfield   TYPE char50.
  REFRESH it_toa01 .

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = wa_lfa1-lifnr
    IMPORTING
      output = wa_lfa1-lifnr.
  gv_objid = wa_lfa1-lifnr.

  lv_db_table = 'TOA01'.
  SELECT * FROM (lv_db_table) INTO TABLE it_toa01 WHERE object_id = wa_lfa1-lifnr.

  IF it_toa01 IS NOT INITIAL.
    lv_db_table = '/SDOCS/SSPY_ATTA'.
    SELECT  docid arc_docid  arc_id  file_name file_type cr_date cr_time  ar_doctype FROM (lv_db_table)
                   INTO TABLE it_attach FOR ALL ENTRIES IN it_toa01
                   WHERE arc_docid  = it_toa01-arc_doc_id.
  ENDIF.

*******temp code added on  23.11.2023
  DATA(l_alinfr) = wa_lfa1-lifnr.
  lv_db_table = '/SDOCS/S1_VNDR_H'.
  SELECT SINGLE docid FROM (lv_db_table) INTO @l_docid WHERE vendor = @wa_lfa1-lifnr.
  IF l_docid IS INITIAL.
    SHIFT l_alinfr LEFT DELETING LEADING '0'.
    lv_db_table = '/SDOCS/S1_VNDR_H'.
    SELECT SINGLE docid FROM (lv_db_table) INTO l_docid WHERE vendor = l_alinfr.
  ENDIF.
  IF l_docid IS NOT INITIAL.
    lv_db_table = '/SDOCS/SSPY_ATTA'.
    SELECT  docid arc_docid  arc_id  file_name file_type cr_date cr_time  ar_doctype FROM (lv_db_table)
                    INTO TABLE it_attach  WHERE docid  = l_docid.
  ENDIF.
*************temp code ended on 23.112023
  IF p_delta IS NOT INITIAL.

*    gt_vendordocs2[] = gt_vendordocs[].
    gs_xml-line = '<VENDOR_MASTER_DOCS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.


    SORT it_attach BY arc_docid ."cr_date DESCENDING cr_time DESCENDING.
    DELETE ADJACENT DUPLICATES FROM it_attach COMPARING arc_docid.
    SORT it_attach BY cr_date DESCENDING cr_time DESCENDING.

    READ TABLE it_attach INTO wa_attach INDEX 1.
    DESCRIBE TABLE it_attach LINES att_lines.

    CLEAR lv_exp_date.
    LOOP AT it_attach INTO wa_attach.
      gs_xml-line = '<VENDOR_MASTER_DOC>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      IF wa_attach-ar_doctype IS INITIAL.
        CONCATENATE '<DOC_TYPE>' 'S1_VENDOR' '</DOC_TYPE>' INTO gs_xml-line. "WA_VENDORDOCS1-DOC_TYPE "WA_ATTACH-FILE_DOCTYPE
        APPEND gs_xml TO gt_xml. CLEAR gs_xml.
      ELSE.
        CONCATENATE '<DOC_TYPE>' wa_attach-ar_doctype  '</DOC_TYPE>' INTO gs_xml-line."WA_ATTACH-FILE_DOCTYPE
        APPEND gs_xml TO gt_xml. CLEAR gs_xml.
      ENDIF.

*    if lv_exp_date ge sy-datum.
      CONCATENATE '<STATUS>' 'Completed' '</STATUS>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.


      gs_xml-line = '<LATEST_ATTACHMNT>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      CONCATENATE '<VERSION_NO>'  '</VERSION_NO>' INTO gs_xml-line."WA_VENDORDOCS1-VERSION
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      CONCATENATE '<AR_ID>' wa_attach-arc_id  '</AR_ID>' INTO gs_xml-line."WA_ATTACH-ARC_ID
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      CONCATENATE '<AR_DOCID>'  wa_attach-arc_docid  '</AR_DOCID>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.
      CLEAR gv_file_name.
      gv_file_name =  wa_attach-file_name.
      PERFORM replace_sym USING gv_file_name .
      CONCATENATE '<FL_NAME>' gv_file_name   '</FL_NAME>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      CONCATENATE '<FL_TYPE>' wa_attach-file_type '</FL_TYPE>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      IF wa_attach-ar_doctype IS INITIAL.
        CONCATENATE '<DOC_TYPE>' 'S1_VENDOR' '</DOC_TYPE>' INTO gs_xml-line. "WA_VENDORDOCS1-DOC_TYPE "WA_ATTACH-FILE_DOCTYPE
        APPEND gs_xml TO gt_xml. CLEAR gs_xml.
      ELSE.
        CONCATENATE '<DOC_TYPE>' wa_attach-ar_doctype  '</DOC_TYPE>' INTO gs_xml-line."WA_ATTACH-FILE_DOCTYPE
        APPEND gs_xml TO gt_xml. CLEAR gs_xml.
      ENDIF.


      CONCATENATE '<DOC_EXPIRY_DATE>' '</DOC_EXPIRY_DATE>' INTO gs_xml-line."WA_ATTACH-EXPIRY_TODAT
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.


      CONCATENATE '<ATTID>' gv_attid  '</ATTID>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      gs_xml-line = '</LATEST_ATTACHMNT>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      CLEAR:lv_lfield.

      gs_xml-line = '<ATTCHMNTS>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

*      gs_xml-line = '<ATTCHMNT>'.
*      APPEND gs_xml TO gt_xml. CLEAR gs_xml.
*
*       gs_xml-line = '<ATTCHMNT>'.
*      APPEND gs_xml TO gt_xml. CLEAR gs_xml.
*      CLEAR lv_att_ind.

      gs_xml-line = '</ATTCHMNTS>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      gs_xml-line = '<FIELD_VALUES>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      gs_xml-line = '<FIELD>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.
      CONCATENATE '<NAME>' lv_lfield  '</NAME>' INTO gs_xml-line.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.
      CONCATENATE '<VALUE>'   '</VALUE>' INTO gs_xml-line." WA_VENDORDOCS1-EXPIRY_DT
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.

      gs_xml-line = '</FIELD>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.


      gs_xml-line = '</FIELD_VALUES>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.




      gs_xml-line = '</VENDOR_MASTER_DOC>'.
      APPEND gs_xml TO gt_xml. CLEAR gs_xml.
    ENDLOOP.
    " ENDLOOP.
    gs_xml-line = '</VENDOR_MASTER_DOCS>'.
    APPEND gs_xml TO gt_xml. CLEAR gs_xml.

  ELSEIF  p_delta IS INITIAL."P_BMODE IS NOT INITIAL OR

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_COMPANYDATA_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_companydata_xml.

  CLEAR:wa_lfb1,gv_block.
  gs_xml-line = '<COMPANY_CODES>'.
  APPEND gs_xml TO gt_xml.
  CLEAR:gs_xml.

  LOOP AT gt_lfb1 INTO wa_lfb1 WHERE lifnr = wa_lfa1-lifnr.
    gs_xml-line = '<COMPANY_DATA>'.
    APPEND gs_xml TO gt_xml.
    CLEAR:gs_xml.

    CONCATENATE '<COMPANY_CODE>' wa_lfb1-bukrs '</COMPANY_CODE>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR  gs_xml.

    CONCATENATE '<PAYMENT_TERM>' wa_lfb1-zterm '</PAYMENT_TERM>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR:gs_xml.


    CLEAR:gv_block,lv_all_comp.
    PERFORM get_vendor_block_data USING wa_lfa1 wa_lfb1 CHANGING gv_block lv_all_comp.

    IF gv_block EQ 'false' AND lv_all_comp EQ 'X'.
      READ TABLE lt_ccodes INTO DATA(wa_ccodes) WITH KEY bukrs = wa_lfb1-bukrs.
      IF sy-subrc EQ 0.
        gv_block = 'true'.
      ELSE.
        gv_block = 'false'.
      ENDIF.
    ENDIF.

    CONCATENATE '<PAYMENT_BLOCK>' gv_block '</PAYMENT_BLOCK>' INTO gs_xml-line.
    APPEND gs_xml TO gt_xml.
    CLEAR:gs_xml.

    gs_xml-line = '<TAX_DATA>'.
    APPEND gs_xml TO gt_xml.
    CLEAR:gs_xml.

    LOOP AT gt_lfbw    INTO DATA(wa_lfbw) WHERE lifnr = wa_lfb1-lifnr AND bukrs = wa_lfb1-bukrs.
      IF gv_wty IS INITIAL.
        LOOP AT gt_t059u  INTO DATA(wa_t059u)  WHERE land1 = wa_lfa1-land1 AND witht = wa_lfbw-witht.
          LOOP AT gt_t059zt INTO DATA(wa_t059zt) WHERE land1 = wa_lfa1-land1 AND witht = wa_lfbw-witht AND wt_withcd = wa_lfbw-wt_withcd.

            gs_xml-line = '<TAX>'.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml.

            CONCATENATE '<WTH_HLDNG_TAX_TYPE>' wa_lfbw-witht '</WTH_HLDNG_TAX_TYPE>' INTO gs_xml-line.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml.

            CONCATENATE '<WTH_HLDNG_TAX>' wa_lfbw-wt_withcd '</WTH_HLDNG_TAX>' INTO gs_xml-line.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml.

            CLEAR:gv_desc.
            gv_desc = wa_t059zt-text40.
            PERFORM replace_sym USING gv_desc.
            CONCATENATE '<WTH_HLDNG_TAX_DESC>' gv_desc '</WTH_HLDNG_TAX_DESC>' INTO gs_xml-line.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml.

            CLEAR:gv_desc.
            gv_desc = wa_t059u-text40.
            PERFORM replace_sym USING gv_desc.
            CONCATENATE '<WTH_HLDNG_TAX_TYPE_DESC>' gv_desc '</WTH_HLDNG_TAX_TYPE_DESC>' INTO gs_xml-line.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml,wa_t059zt.

            gs_xml-line = '</TAX>'.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml,wa_lfbw,wa_t059u,wa_t059zt.
          ENDLOOP.
        ENDLOOP.
      ELSEIF gv_wty = wa_lfbw-witht+0(1).
        LOOP AT gt_t059u  INTO wa_t059u WHERE land1 = wa_lfa1-land1 AND witht = wa_lfbw-witht.
          LOOP AT gt_t059zt INTO wa_t059zt WHERE land1 = wa_lfa1-land1 AND witht = wa_lfbw-witht AND wt_withcd = wa_lfbw-wt_withcd.

            gs_xml-line = '<TAX>'.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml.

            CONCATENATE '<WTH_HLDNG_TAX_TYPE>' wa_lfbw-witht '</WTH_HLDNG_TAX_TYPE>' INTO gs_xml-line.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml.

            CONCATENATE '<WTH_HLDNG_TAX>' wa_lfbw-wt_withcd '</WTH_HLDNG_TAX>' INTO gs_xml-line.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml.

            CLEAR:gv_desc.
            gv_desc = wa_t059zt-text40.
            PERFORM replace_sym USING gv_desc.
            CONCATENATE '<WTH_HLDNG_TAX_DESC>' gv_desc '</WTH_HLDNG_TAX_DESC>' INTO gs_xml-line.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml.

            CLEAR:gv_desc.
            gv_desc = wa_t059u-text40.
            PERFORM replace_sym USING gv_desc.
            CONCATENATE '<WTH_HLDNG_TAX_TYPE_DESC>' gv_desc '</WTH_HLDNG_TAX_TYPE_DESC>' INTO gs_xml-line.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml,wa_t059zt.

            gs_xml-line = '</TAX>'.
            APPEND gs_xml TO gt_xml.
            CLEAR:gs_xml,wa_lfbw,wa_t059u,wa_t059zt.
          ENDLOOP.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

    gs_xml-line = '</TAX_DATA>'.
    APPEND gs_xml TO gt_xml.
    CLEAR:gs_xml.


    gs_xml-line = '</COMPANY_DATA>'.
    APPEND gs_xml TO gt_xml.
    CLEAR:gs_xml,wa_lfb1,gv_block,wa_lfbw,wa_t059u,wa_t059zt.
  ENDLOOP.

  gs_xml-line = '</COMPANY_CODES>'.
  APPEND gs_xml TO gt_xml.
  CLEAR:gs_xml.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_JOB_SCHEDULE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_job_schedule .
  DATA:lv_curr_time TYPE sy-uzeit.
  CLEAR:lv_curr_time,wa_job_slog.
  lv_db_table = '/SDOCS/SSPY_JLOG'.
  SELECT SINGLE * FROM (lv_db_table) INTO wa_job_slog WHERE prog_name = sy-cprog
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
    lr_time-low = '000000'." ( sy-uzeit - 1200 ).
    lr_time-high = sy-uzeit.
    lr_time-option = 'BT'.
    lr_time-sign   = 'I'.
    APPEND lr_time.
  ENDIF.

  gv_curr_date = lr_date-high.
  gv_curr_time = lr_time-high.
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
*&      Form  PUSH_DATA_TO_PORTAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM push_data_to_portal .
  CLEAR:gv_div,gv_cnt,gv_from,gv_to,gv_mod.
  IF gt_lfa1[] IS NOT INITIAL.
    DESCRIBE TABLE gt_lfa1[] LINES gv_cnt.
    IF gv_cnt GT p_bsize.
      gv_div = gv_cnt / p_bsize.
      gv_mod = ( gv_cnt MOD p_bsize ).
      IF gv_mod => 1.
        gv_div = gv_div + 1.
      ENDIF.
    ELSE.
      gv_div = 1.
    ENDIF.

    PERFORM get_url.
    DO gv_div TIMES.
      CLEAR:gs_xml,wa_bnka.
      REFRESH:gt_xml[].
      gv_from = gv_to + 1.
      gv_to   = gv_from + p_bsize - 1.
      IF gv_to GT gv_cnt.
        gv_to = gv_cnt.
      ENDIF.
      gs_xml-line = '<SUPPLR_DATA_TRANSMIT>'.
      APPEND gs_xml TO gt_xml.
      CLEAR: gs_xml.

      LOOP AT gt_lfa1 INTO wa_lfa1 FROM gv_from TO gv_to.

        PERFORM get_headerdata_xml.
        PERFORM get_dbedata_xml.
        PERFORM get_pctdata_xml.
        PERFORM get_addressdata_xml.
        PERFORM get_companydata_xml.
        PERFORM get_remit_add_data_xml.
        PERFORM get_contact_data_xml.
        PERFORM get_bank_data_xml.
        PERFORM get_vendordocs_xml.

        gs_xml-line = '</SUPPLR_DATA>'.
        APPEND gs_xml TO gt_xml.
        CLEAR gs_xml.

        wa_lifnr-lifnr = wa_lfa1-lifnr.
        APPEND wa_lifnr TO gt_lifnr[].
        CLEAR:wa_lifnr,wa_lfa1,wa_attach.
      ENDLOOP.

      gs_xml-line = '</SUPPLR_DATA_TRANSMIT>'.
      APPEND gs_xml TO gt_xml.
      CLEAR: gs_xml.
      PERFORM dispatch_portal_data.
    ENDDO.
    IF p_delta IS NOT INITIAL AND  gv_http_sflag IS INITIAL.
      wa_job_slog-prog_name = '/SDOCS/SSPAY_VENDOR_DATA_DISP'.
      wa_job_slog-prog_type = 'HTTP_CALL'.
      wa_job_slog-jlog_date = gv_curr_date.
      wa_job_slog-jlog_time = gv_curr_time.
      lv_db_table = '/sdocs/sspy_jlog'.
      MODIFY (lv_db_table) FROM wa_job_slog.
    ENDIF.
  ENDIF.
ENDFORM.                    " PUSH_DATA_TO_PORTAL
*&---------------------------------------------------------------------*
*&      Form  GET_VENDOR_BLOCK_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_LFA1  text
*      -->P_WA_LFB1  text
*----------------------------------------------------------------------*
FORM get_vendor_block_data  USING    p_wa_lfa1 LIKE wa_lfa1
                                     p_wa_lfb1 LIKE wa_lfb1
                            CHANGING gv_block p_all_comp.

*  LOOP AT lt_config_vnd_block INTO DATA(wa_vnd_block).
*    CASE wa_vnd_block.
*      WHEN 'GEN_BLOCK'.
  IF p_wa_lfa1-sperq IS NOT INITIAL.
    gv_block = 'true'.
  ELSE.
    gv_block = 'false'.
  ENDIF.
*      WHEN 'ALL_CMPNY_BLOCK'.
  p_all_comp = 'X'.
  IF p_wa_lfa1-sperr IS NOT INITIAL.
    gv_block = 'true'.
  ELSE.
    gv_block = 'false'.
  ENDIF.
*      WHEN 'CMPNY_BLOCK'.
  IF p_wa_lfb1-sperr IS NOT INITIAL.
    gv_block = 'true'.
  ELSE.
    gv_block = 'false'.
  ENDIF.
*      WHEN 'ALL_PORG_BLOCK'.
  IF p_wa_lfa1-sperm IS NOT INITIAL.
    gv_block = 'true'.
  ELSE.
    gv_block = 'false'.
  ENDIF.
*      WHEN 'PORG_BLOCK'.
  READ TABLE gt_lfm1 INTO DATA(ps_lfm1) WITH KEY lifnr = p_wa_lfa1-lifnr.
  IF ps_lfm1-sperm IS NOT INITIAL.
    gv_block = 'true'.
  ELSE.
    gv_block = 'false'.
  ENDIF.
  CLEAR:ps_lfm1.
*    ENDCASE.

  IF gv_block = 'true'.
    EXIT.
  ENDIF.
*    CLEAR:wa_vnd_block.
*  ENDLOOP.
ENDFORM.
*}   INSERT
