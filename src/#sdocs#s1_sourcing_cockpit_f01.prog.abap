*----------------------------------------------------------------------*
***INCLUDE /SDOCS/S1_SOURCING_COCKPIT_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  IF p_rel IS NOT INITIAL.
    lv_db_table = 'eban'.
    SELECT banfn
          bnfpo
          matnr
          menge
          meins
          lfdat
          preis
          peinh
          matkl
          werks
          lgort
          ekgrp
          afnam
          bednr
          lifnr
          flief
          ekorg
*          kostl
           FROM (lv_db_table) INTO CORRESPONDING FIELDS OF TABLE  gt_eban WHERE banfn IN s_banfn
                                           AND erdat IN s_cdate
                                           AND ekorg IN s_egrp
                                           AND matnr IN s_mat
                                           AND matkl IN s_matg
                                           AND werks IN s_werks
                                           AND afnam IN s_afnam
                                           AND frgrl = ''.   "Release PRs only.
    IF sy-subrc = 0.
      lv_db_table = 't001w'.
      SELECT werks name1 adrnr INTO TABLE gt_t001w[] FROM (lv_db_table) FOR ALL ENTRIES IN gt_eban
        WHERE werks = gt_eban-werks.

      lv_db_table = 'eket'.
      SELECT ebeln,ebelp,banfn,bnfpo FROM (lv_db_table) INTO TABLE @lt_eket FOR ALL ENTRIES IN @gt_eban WHERE
             banfn = @gt_eban-banfn AND bnfpo = @gt_eban-bnfpo.
    ENDIF.
  ELSE.

    lv_db_table = 'eban'.
    SELECT banfn
         bnfpo
         matnr
         menge
         meins
         lfdat
         preis
         peinh
         matkl
         werks
         lgort
         ekgrp
         afnam
         bednr
         lifnr
         flief
         ekorg" kostl
          FROM (lv_db_table)  INTO CORRESPONDING FIELDS OF TABLE gt_eban  WHERE banfn IN s_banfn
                                           AND erdat IN s_cdate
                                           AND ekorg IN s_egrp
                                           AND matnr IN s_mat
                                           AND matkl IN s_matg
                                           AND werks IN s_werks
                                           AND afnam IN s_afnam.

  ENDIF.

  IF gt_eban IS NOT INITIAL.
    lv_db_table = 't001w'.
    SELECT werks name1 adrnr INTO TABLE gt_t001w[] FROM (lv_db_table) FOR ALL ENTRIES IN gt_eban
      WHERE werks = gt_eban-werks.

    lv_db_table = 'eket'.
    SELECT ebeln ebelp banfn bnfpo FROM (lv_db_table) INTO TABLE lt_eket FOR ALL ENTRIES IN gt_eban WHERE
           banfn = gt_eban-banfn AND bnfpo = Gt_eban-bnfpo.

    lv_db_table = 'makt'.
    SELECT matnr ,maktx FROM (lv_db_table) INTO TABLE @lt_makt FOR ALL ENTRIES IN @gt_eban WHERE matnr = @gt_eban-matnr AND spras = @sy-langu.

  ENDIF.


  lv_db_table = '/sdocs/s1_buy_hd'.
  SELECT * FROM (lv_db_table) INTO TABLE @lt_bhd  WHERE ebeln IN @s_ebeln AND cr_date IN @s_crdat
                         AND doctype = 'S1_RFQ' AND rfx_award = ' '.

  lv_db_table = '/sdocs/s1_buy_hd'.
  SELECT * FROM (lv_db_table) APPENDING TABLE lt_bhd  WHERE ebeln IN S_ebeln AND rfqa_date IN s_crdat
                         AND doctype = 'S1_RFQ' AND rfx_award = 'X'.

  lv_db_table = '/sdocs/s1_buy_hd'.
  SELECT * FROM (lv_db_table) APPENDING TABLE lt_bhd WHERE ebeln IN s_ebeln AND cr_date IN s_crdat
                         AND doctype = 'S1_PR'AND banfn = ' '.

  lv_db_table = '/sdocs/s1_buy_ln'.
  SELECT * FROM (lv_db_table) INTO TABLE @lt_ln FOR ALL ENTRIES IN @gt_eban
    WHERE ebeln = @gt_eban-banfn AND ebelp = @gt_eban-bnfpo.
  IF sy-subrc = 0.
    lv_db_table = '/sdocs/s1_buy_hd'.
    SELECT docid,gi_no,prr_ref_id FROM (lv_db_table) INTO TABLE @lt_gi FOR ALL ENTRIES IN @lt_ln
         WHERE docid  = @lt_ln-docid AND doctype  =  'S1_GI'.
    IF sy-subrc = 0.
      REFRESH:lt_ln.
      lv_db_table = '/sdocs/s1_buy_ln'.
      SELECT * FROM (lv_db_table) INTO TABLE lt_ln FOR ALL ENTRIES IN lt_gi
      WHERE docid = lt_gi-docid.
      lv_db_table = '/sdocs/s1_buy_ln'.
      SELECT * FROM (lv_db_table) INTO TABLE @lt_gdata FOR ALL ENTRIES IN @lt_gi
      WHERE docid = @lt_gi-prr_ref_id.
    ELSE.
      REFRESH:lt_ln.
    ENDIF.
  ENDIF.



DATA:LV_banfn TYPE banfn.
  DELETE gt_eban WHERE ekorg = ''.
  SORT lt_eket BY ebeln DESCENDING ebelp DESCENDING.
  LOOP AT gt_eban INTO DATA(wa_eban).
    READ TABLE lt_makt INTO DATA(wa_makt) WITH KEY matnr = wa_eban-matnr.

    lv_db_table = '/sdocs/s1_buy_hd'.
    SELECT SINGLE docid FROM (lv_db_table) INTO wa_final-pr_rfx WHERE banfn = wa_eban-banfn AND doctype = 'S1_RFQ'.

    IF sy-subrc = 0.


**      IF wa_final-pr_rfx IS INITIAL.
*       wa_final-po  = wa_eket-ebeln.
**      ENDIF.

      wa_final-status = 'Completed'.
    ELSE.
      wa_final-status = 'Bid Inprocess'.
    ENDIF.
    LOOP AT lt_eket INTO DATA(wa_eket) WHERE banfn = wa_eban-banfn AND bnfpo = wa_eban-bnfpo.
      lv_db_table = 'ekko'.
      SELECT SINGLE ebeln FROM (lv_db_table) INTO  wa_final-po WHERE ebeln = wa_eket-ebeln AND bstyp = 'F'.
      IF wa_final-po IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDLOOP.
*     wa_final-po  = wa_eket-ebeln.
    wa_final-maktx = wa_makt-maktx.
    READ TABLE lt_ln INTO DATA(l_gi) WITH KEY ebeln = wa_eban-banfn ebelp = wa_eban-bnfpo.
    IF sy-subrc = 0.
      READ TABLE lt_gi INTO DATA(wa_gi) WITH KEY docid = l_gi-docid.
      IF sy-subrc = 0.
        wa_final-gi_docid = wa_gi-docid.
        wa_final-sap_gi = wa_gi-gi_no.
      ENDIF.
    ELSE.
      lv_db_table = '/sdocs/s1_buy_ln'.
      SELECT SINGLE docid FROM (lv_db_table) INTO @l_gidocid WHERE ebeln = @wa_eban-banfn AND ebelp = @wa_eban-bnfpo.
      IF sy-subrc = 0.
        lv_db_table = '/sdocs/s1_byract'.
        SELECT SINGLE gi_num,gi_no FROM /sdocs/s1_byract INTO @DATA(wa_gidata) WHERE docid  = @l_gidocid.
        wa_final-gi_docid = wa_gidata-gi_num.
        wa_final-sap_gi = wa_gidata-gi_no.
      ENDIF.

    ENDIF.
    CLEAR:wa_gidata,l_gidocid.
    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input          = wa_eban-meins
        language       = sy-langu
      IMPORTING
*       LONG_TEXT      =
        output         = wa_eban-meins
*       SHORT_TEXT     =
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
    ENDIF.
    IF wa_final-gi_docid IS NOT INITIAL.
      wa_final-status = 'Completed'.
    ENDIF.
    IF wa_eban-lifnr IS INITIAL OR wa_eban-flief IS INITIAL.
      lv_db_table = 'ekko'.
      SELECT SINGLE lifnr FROM (lv_db_table) INTO wa_eban-lifnr WHERE ebeln = wa_eket-ebeln.
    ENDIF.

    lv_db_table = '/sdocs/s1_buy_hd'.
    SELECT SINGLE docid INTO wa_final-sbuydocid FROM (lv_db_table) WHERE banfn = wa_eban-banfn AND doctype = 'S1_PR'.
    SHIFT wa_final-sbuydocid LEFT DELETING LEADING '0'.
    SHIFT wa_eban-banfn LEFT DELETING LEADING '0'.
    SHIFT wa_eban-matnr LEFT DELETING LEADING '0'.
    wa_final-banfn   = wa_eban-banfn.
    wa_final-bnfpo   = wa_eban-bnfpo.
    wa_final-matnr   = wa_eban-matnr.
    wa_final-menge   = wa_eban-menge.
    wa_final-meins   = wa_eban-meins.
    wa_final-lfdat   = wa_eban-lfdat.
    wa_final-matkl   = wa_eban-matkl.
    wa_final-werks   = wa_eban-werks.
    wa_final-lgort   = wa_eban-lgort.
    wa_final-ekgrp   = wa_eban-ekgrp.
    wa_final-afnam   = wa_eban-afnam.
    wa_final-bednr   = wa_eban-bednr.
    wa_final-lifnr   = wa_eban-lifnr.
    wa_final-flief   = wa_eban-flief.
    wa_final-ekorg   = wa_eban-ekorg.
*    wa_final-maktx   = wa_eban-maktx.
    wa_final-preis   = wa_eban-preis.
    wa_final-pEINH   = wa_eban-pEINH.
    SHIFT wa_final-gi_docid LEFT DELETING LEADING '0'.
    SHIFT wa_final-pr_rfx LEFT DELETING LEADING '0'.
    LV_banfn = |{ wa_eban-banfn ALPHA = IN }|.
    data(lv_bnfpo) = |{ wa_eban-bnfpo ALPHA = IN  }|.
    read table lt_bhd into wa_bhd with key banfn = LV_banfn.
*    bnfpo   = wa_eban-bnfpo.
    if sy-subrc = 0.
       wa_final-rfq_no   = wa_bhd-EBELN.
       wa_final-PR_RFX   = wa_bhd-ebeln.
    endif.
    APPEND wa_final TO gt_final.
    CLEAR:wa_final,wa_eket,wa_eban,wa_makt,wa_gi,l_gi,wa_bhd.
  ENDLOOP.
  LOOP AT lt_bhd INTO wa_bhd.
    wa_final-docid   = wa_bhd-docid.
    wa_final-rfq_no   = wa_bhd-ebeln.
    wa_final-ekgrp  = wa_bhd-ekgrp.
    wa_final-lifnr   = wa_bhd-lifnr.
    wa_final-bukrs   = wa_bhd-bukrs.
    wa_final-ekorg   = wa_bhd-ekorg.
    wa_final-doctype = wa_bhd-doctype.
    wa_final-rfx_award = wa_bhd-rfx_award.
    wa_final-psuccess = wa_bhd-psuccess.
    wa_final-private  = wa_bhd-rfx_private.
    wa_final-buyer = wa_bhd-req_email.
*    wa_final-ebeln = wa_bhd-ebeln.
    wa_final-ddate  = wa_bhd-ebdat.
    wa_final-qadate = wa_bhd-qa_ddate.
    wa_final-po = wa_bhd-RFq_NO.
    wa_final-qmode = wa_bhd-rfx_qmode.
    wa_final-title = wa_bhd-rfq_title.
    wa_final-contract = wa_bhd-contract.
    IF wa_final-ebeln IS NOT INITIAL OR wa_final-po IS NOT INITIAL.
      wa_final-status = 'Completed' .
    ELSEIF wa_final-rfx_award IS NOT INITIAL AND wa_final-psuccess IS NOT INITIAL.
      wa_final-status = 'Awarded'.
    ELSEIF  wa_final-contract IS NOT INITIAL.
      wa_final-status = 'Completed'.
    ELSEIF wa_final-rfx_award IS INITIAL AND wa_final-psuccess IS INITIAL..
      wa_final-status = 'Bid Inprocess'.
    ELSEIF wa_final-rfx_award IS NOT INITIAL AND wa_final-psuccess IS INITIAL..
      wa_final-status = 'Awarded Bid Inprocess'.
    ENDIF.
    APPEND wa_final TO gt_final.
    CLEAR: wa_final,wa_bhd.
  ENDLOOP.
  IF gt_final IS NOT INITIAL.
    lv_db_table = 'lfa1'.
    SELECT lifnr name1 FROM (lv_db_table) INTO TABLE lt_lfa1 FOR ALL ENTRIES IN gt_final WHERE lifnr = gt_final-lifnr.
  ENDIF.

  LOOP AT gt_final ASSIGNING FIELD-SYMBOL(<wa_final>).
    READ TABLE lt_lfa1 INTO DATA(l_lfa1) WITH KEY lifnr  = <wa_final>-lifnr.
    <wa_final>-name1 = l_lfa1-name1.
    CLEAR l_lfa1-name1.
  ENDLOOP.

  gt_eban_save  = gt_final.
  IF gv_node_event IS NOT INITIAL.
    IF gv_node_key = 'SPGR' AND root_node = 'ROOT'.
      PERFORM get_tree_data USING gv_ekorg gv_node_key .
      SORT gt_final BY banfn DESCENDING bnfpo DESCENDING.
    ELSEIF root_node = 'SPGR'.
      gv_ekorg = gv_node_key+4(3).
      PERFORM get_tree_data USING gv_ekorg root_node.
      SORT gt_final BY banfn DESCENDING bnfpo DESCENDING.
    ELSEIF gv_node_key = 'SBPR' AND root_node = 'ROOT'.
      PERFORM get_tree_data USING gv_ekorg gv_node_key .
      SORT gt_final BY docid DESCENDING.
    ELSEIF root_node = 'SBPR'.
      gv_ekorg = gv_node_key+4(3).
      PERFORM get_tree_data USING gv_ekorg root_node .
      SORT gt_final BY docid DESCENDING.
    ELSEIF gv_node_key = 'SRFQ' AND root_node = 'ROOT'.
      PERFORM get_tree_data USING gv_ekorg gv_node_key .
      SORT gt_final BY docid DESCENDING.
      DELETE gt_final WHERE lifnr = ' '.
    ELSEIF  root_node = 'SRFQ'.
      gv_ekorg = gv_node_key+4(3).
      PERFORM get_tree_data USING gv_ekorg root_node .
      SORT gt_final BY docid DESCENDING.
      DELETE gt_final WHERE lifnr = ' '.
    ELSEIF gv_node_key = 'ARFQ' AND root_node = 'ROOT'.
      PERFORM get_tree_data USING gv_ekorg gv_node_key .
      SORT gt_final BY docid DESCENDING.

    ELSEIF  root_node = 'ARFQ'.
      gv_ekorg = gv_node_key+4(3).
      PERFORM get_tree_data USING gv_ekorg root_node .
      SORT gt_final BY docid DESCENDING.

    ENDIF.
  ELSE.
    SORT gt_final BY banfn DESCENDING bnfpo DESCENDING.
  ENDIF.

  REFRESH:lt_bhd.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DATA_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_display .
  IF gt_eban[] IS NOT INITIAL.
    CALL SCREEN 100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_display .
  GT_EBAN_save = gt_final.
  SORT gt_final BY banfn DESCENDING bnfpo DESCENDING.
  IF gv_node_key IS INITIAL AND root_node IS INITIAL.
    DELETE gt_final WHERE doctype <> ' '.
  ENDIF.
  IF gt_cust IS  INITIAL.

    CREATE OBJECT gt_cust
      EXPORTING
        container_name = 'CC_SCS'.

    CREATE OBJECT gt_split
      EXPORTING
        parent  = gt_cust
        rows    = 1
        columns = 2.

    CALL METHOD gt_split->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = gt_cont.

    CALL METHOD gt_split->set_column_width
      EXPORTING
        id    = 1
        width = 20.


    CALL METHOD gt_split->get_container
      EXPORTING
        row       = 1
        column    = 2
      RECEIVING
        container = gt_cont2.

    CREATE OBJECT gt_treeb
      EXPORTING
        node_selection_mode = cl_simple_tree_model=>node_sel_mode_single.

    CALL METHOD gt_treeb->create_tree_control
      EXPORTING
        parent = gt_cont.


    CREATE OBJECT gt_gridb
      EXPORTING
        i_parent = gt_cont2.

    g_layout-zebra      = 'C'.
    g_layout-sel_mode   = 'A'.
    g_layout-cwidth_opt = 'X'.

    DESCRIBE TABLE gt_FINAL[] LINES g_tit_cnt.
    gc_tit_cnt = g_tit_cnt.
    CONDENSE gc_tit_cnt.
    CONCATENATE 'Purchase Requisitions - ' gc_tit_cnt INTO g_title SEPARATED BY space.
    g_layout-grid_title = g_title.
    PERFORM sourcing_field_cat USING gt_fcat.
*    create object event_grid.
*    create object event_grid exporting sh_flag = l_sh.
    CREATE OBJECT lv_ref.
    SET HANDLER lv_ref->handle_toolbar FOR gt_gridb.
    SET HANDLER lv_ref->handle_user_command FOR gt_gridb.
*    set handler event_grid->handle_user_command for gt_gridb.
    SET HANDLER lv_ref->hotspot_click FOR gt_gridb.
    g_variant-report = sy-repid.
    g_variant-username = sy-uname.
    CALL METHOD gt_gridb->set_table_for_first_display "r_grid
      EXPORTING
        is_variant                    = g_variant
        i_save                        = 'A'
        is_layout                     = g_layout
      CHANGING
        it_outtab                     = gt_final[]
        it_fieldcatalog               = gt_fcat[]
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*                 with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.
*     describe table gt_header[] lines g_tit_cnt.
*    gc_tit_cnt = g_tit_cnt.
*    condense gc_tit_cnt.
*    concatenate 'Documents' gc_tit_cnt into g_title separated by space.
*    g_layout-grid_title = g_title.
*    data:lv_stable type LVC_S_STBL .
*         lv_stable-row = 'X'.
*         lv_stable-col = 'X'.
*
*                 call method gt_gridb->refresh_table_display
*                   exporting
*                     is_stable      =  lv_stable
**                     i_soft_refresh =
*                   exceptions
*                     finished       = 1
*                     others         = 2
*                         .
*                 if sy-subrc <> 0.
**                  Implement suitable error handling here
*                 endif.
    IF  gt_gridb IS BOUND.
      CALL METHOD gt_gridb->set_frontend_fieldcatalog
        EXPORTING
          it_fieldcatalog = gt_fcat[].
    ENDIF.
    CALL METHOD gt_gridb->refresh_table_display.

*TRY.
*  CALL METHOD gt_gridb->refresh_table_display.
*CATCH cx_root INTO DATA(lx_error).
*
*ENDTRY.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SOURCING_FIELD_CAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FCAT  text
*----------------------------------------------------------------------*
FORM sourcing_field_cat  USING    p_gt_fcat.
  DATA:wt_fcat TYPE lvc_s_fcat.
  REFRESH:gt_fcat[].

  IF  ( ( gv_node_key = 'SRFQ' OR root_node = 'SRFQ' ) OR  ( gv_node_key = 'ARFQ' OR root_node = 'ARFQ' )  ) .
    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'DOCID'.
    wt_fcat-reptext    = 'RFQ No'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-hotspot    = 'X'.
    wt_fcat-outputlen  = '10'.
    wt_fcat-just       = 'C'.
    APPEND wt_fcat TO gt_fcat.

    IF gv_node_key = 'SRFQ' OR root_node = 'SRFQ'.
      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'TITLE'.
      wt_fcat-reptext   = 'RFQ Title'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'STATUS'.
      wt_fcat-reptext    = 'Status'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '10'.
      APPEND wt_fcat TO gt_fcat.


      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'PO'.
      wt_fcat-reptext    = 'PO No'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'CONTRACT'.
      wt_fcat-reptext    = 'Contract'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'LIFNR'.
      wt_fcat-reptext   = 'Awarded Vendor'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'NAME1'.
      wt_fcat-reptext   = 'Vendor Name'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'DDATE'.
      wt_fcat-reptext   = 'Deadline date'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'QADATE'.
      wt_fcat-reptext   = 'QA date'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'PRIVATE'.
      wt_fcat-reptext   = 'Private'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '5'.
      wt_fcat-checkbox  = 'X'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'QMODE'.
      wt_fcat-reptext   = 'Quick'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '5'.
      wt_fcat-checkbox  = 'X'.
      APPEND wt_fcat TO gt_fcat.



      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'BUYER'.
      wt_fcat-reptext    = 'Buyer'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '20'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'EKGRP'.
      wt_fcat-reptext   = 'P.Grp'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '7'.
      APPEND wt_fcat TO gt_fcat.


      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'RFQ_NO'.
      wt_fcat-reptext    = 'SAP RFQ No.'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '10'.
      APPEND wt_fcat TO gt_fcat.

*      CLEAR : wt_fcat.
*      wt_fcat-tabname    = 'GT_FINAL'.
*      wt_fcat-fieldname  = 'EBELN'.
*      wt_fcat-reptext    = 'Purch Ord.'.
*      wt_fcat-lowercase  = 'X'.
*      wt_fcat-outputlen  = '10'.
*      APPEND wt_fcat TO gt_fcat.


    ENDIF.
    IF gv_node_key = 'ARFQ' OR root_node = 'ARFQ'.
      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'TITLE'.
      wt_fcat-reptext   = 'RFQ Title'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'STATUS'.
      wt_fcat-reptext    = 'Status'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '10'.
      APPEND wt_fcat TO gt_fcat.


      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'DDATE'.
      wt_fcat-reptext   = 'Deadline date'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'QADATE'.
      wt_fcat-reptext   = 'QA date'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'PRIVATE'.
      wt_fcat-reptext   = 'Private'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '5'.
      wt_fcat-checkbox  = 'X'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'QMODE'.
      wt_fcat-reptext   = 'Quick'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '5'.
      wt_fcat-checkbox  = 'X'.
      APPEND wt_fcat TO gt_fcat.



      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'BUYER'.
      wt_fcat-reptext    = 'Buyer'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '20'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname   = 'GT_FINAL'.
      wt_fcat-fieldname = 'EKGRP'.
      wt_fcat-reptext   = 'P.Grp'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen = '7'.
      APPEND wt_fcat TO gt_fcat.


      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'RFQ_NO'.
      wt_fcat-reptext    = 'SAP RFQ No.'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'PO'.
      wt_fcat-reptext    = 'PO No'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '10'.
      APPEND wt_fcat TO gt_fcat.

      CLEAR : wt_fcat.
      wt_fcat-tabname    = 'GT_FINAL'.
      wt_fcat-fieldname  = 'CONTRACT'.
      wt_fcat-reptext    = 'Contract'.
      wt_fcat-lowercase  = 'X'.
      wt_fcat-outputlen  = '10'.
      APPEND wt_fcat TO gt_fcat.
    ENDIF.
  ENDIF.
  IF ( (  gv_node_key IS INITIAL AND root_node IS INITIAL ) OR ( gv_node_key = 'SPGR' OR root_node = 'SPGR' ) ).

    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'BANFN'.
    wt_fcat-reptext   = 'Purchase Req'.
    wt_fcat-fix_column = 'X'.
    wt_fcat-hotspot   = 'X'.
    wt_fcat-outputlen = '10'.

    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'BNFPO'.
    wt_fcat-reptext   = 'Item'.
    wt_fcat-outputlen = '5'.
*  wt_fcat-hotspot   = 'X'.
    wt_fcat-fix_column = 'X'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'MATNR'.
    wt_fcat-reptext   = 'Material'.
    wt_fcat-outputlen = '12'.
    wt_fcat-hotspot   = 'X'.
    APPEND wt_fcat TO gt_fcat.


    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'MAKTX'.
    wt_fcat-reptext   = 'Description'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen = '12'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'MENGE'.
    wt_fcat-reptext    = 'Quantity'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'MEINS'.
    wt_fcat-reptext   = 'UOM'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen = '12'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'STATUS'.
    wt_fcat-reptext    = 'Status'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'PR_RFX'.
    wt_fcat-reptext    = 'RFQ No.'.
    wt_fcat-hotspot    = 'X'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'PO'.
    wt_fcat-reptext    = 'PO No'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    wt_fcat-hotspot    = 'X'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'GI_DOCID'.
    wt_fcat-reptext    = 'GIR No'.
    wt_fcat-hotspot    = 'X'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'SBUYDOCID'.
    wt_fcat-reptext    = 'SBUY ID'.
    wt_fcat-hotspot    = 'X'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'LFDAT'.
    wt_fcat-reptext    = 'Delivery Date'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'MATKL'.
    wt_fcat-reptext   = 'Mat.Grp'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen = '7'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'WERKS'.
    wt_fcat-reptext   = 'Plant'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen = '5'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'LGORT'.
    wt_fcat-reptext   = 'S.Loc'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen = '7'.
    APPEND wt_fcat TO gt_fcat.


    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'EKGRP'.
    wt_fcat-reptext   = 'P.Grp'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen = '7'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'EKORG'.
    wt_fcat-reptext    = 'P.Org'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'AFNAM'.
    wt_fcat-reptext    = 'Requisitioner'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'LIFNR'.
    wt_fcat-reptext    = 'vendor'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'FLIEF'.
    wt_fcat-reptext    = 'Desired vendor'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'SAP_GI'.
    wt_fcat-reptext    = 'GIR No'.
    wt_fcat-hotspot    = 'X'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.
  ENDIF.

  IF    gv_node_key = 'SBPR' OR root_node = 'SBPR' .
    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'DOCID'.
    wt_fcat-reptext    = 'Document ID'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-hotspot    = 'X'.
    wt_fcat-outputlen  = '10'.
    wt_fcat-just       = 'C'.
    APPEND wt_fcat TO gt_fcat.


    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'WF_TEXT'.
    wt_fcat-reptext   = 'Description'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen = '12'.
    APPEND wt_fcat TO gt_fcat.



    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'BATXT'.
    wt_fcat-reptext    = 'PR Document Type'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen  = '20'.
    APPEND wt_fcat TO gt_fcat.



    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'LIFNR'.
    wt_fcat-reptext   = 'Vendor'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname   = 'GT_FINAL'.
    wt_fcat-fieldname = 'NAME1'.
    wt_fcat-reptext   = 'Vendor Name'.
    wt_fcat-lowercase  = 'X'.
    wt_fcat-outputlen = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'BUKRS'.
    wt_fcat-reptext    = 'Comp Code'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'EKGRP'.
    wt_fcat-reptext    = 'Pur Group'.
    wt_fcat-outputlen  = '08'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'EKORG'.
    wt_fcat-reptext    = 'Pur Org'.
    wt_fcat-outputlen  = '08'.
    APPEND wt_fcat TO gt_fcat.

    CLEAR : wt_fcat.
    wt_fcat-tabname    = 'GT_FINAL'.
    wt_fcat-fieldname  = 'NETWR'.
    wt_fcat-reptext    = 'Amount'.
    wt_fcat-outputlen  = '10'.
    APPEND wt_fcat TO gt_fcat.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EVENT_TREE_REG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM event_tree_reg .
  DATA: lt_events TYPE cntl_simple_events,
        ls_event  TYPE cntl_simple_event.

  DATA: event_handler TYPE REF TO lcl_event_grid.

  CALL METHOD gt_treeb->get_registered_events
    IMPORTING
      events = lt_events.


  ls_event-eventid = cl_simple_tree_model=>eventid_node_double_click.
  APPEND ls_event TO lt_events.CLEAR ls_event.

  CALL METHOD gt_treeb->set_registered_events
    EXPORTING
      events = lt_events.

  CREATE OBJECT event_handler.
  SET HANDLER event_handler->node_dc FOR gt_treeb.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_TREE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process_tree_data .
  DATA:lv_cnt      TYPE i,
       lv_cnt1(10) TYPE c.
  CLEAR:lv_cnt1,lv_cnt.
  IF gt_treeb IS NOT INITIAL.
    gt_treeb->delete_all_nodes( ).
  ENDIF.

  CALL METHOD gt_treeb->add_node
    EXPORTING
      node_key = 'ROOT'
      isfolder = 'X'
      text     = 'Sourcing' "Purchase Requisition
      expander = 'X'.

  wa_rnode = 'ROOT'.
  APPEND wa_rnode TO gt_rnode.
  CLEAR wa_rnode.
*   GT_EBAN_save[] = GT_FINAL[] .
  gt_final[] = gt_eban_save[].
  gt_eban[] = gt_final[] .
  DELETE gt_eban[] WHERE ekorg = ' '.
  DATA(lt_eban) = gt_final[].
  DATA(lt_eban1) = lt_eban[].
  SORT lt_eban1 BY ekorg.
  DELETE ADJACENT DUPLICATES FROM lt_eban1 COMPARING ekorg.
  p_root = 'ROOT'.
  p_isfolder = 'X'.
  p_expander = 'X'.
  str1 = 'SPGR'.
  str2 = 'SBPR'.
  str5 = 'SRFQ'.
  str7 = 'ARFQ'.
  PERFORM add_node USING  gt_treeb str1 p_root p_isfolder 'Purchase Requisitions' p_expander.
*  PERFORM add_node USING  gt_treeb str2 p_root p_isfolder 'SmartBuy' p_expander.
  PERFORM add_node USING gt_treeb  str7  p_root p_isfolder 'InProcess RFQs'  p_expander.
  PERFORM add_node USING gt_treeb  str5  p_root p_isfolder 'Awarded RFQs'  p_expander.

  LOOP AT lt_eban1 INTO DATA(wa_eban1).
    CONCATENATE 'PORG' wa_eban1-ekorg INTO str3.
*    CONCATENATE 'SBUY' wa_eban1-ekorg INTO str4.
    CONCATENATE 'SRFQ' wa_eban1-ekorg INTO str6.
    CONCATENATE 'ARFQ' wa_eban1-ekorg INTO str9.

    PERFORM total_purch_org USING wa_eban1-ekorg CHANGING lv_cnt.
    lv_cnt1 = lv_cnt.

    IF lv_cnt IS NOT INITIAL.
      CONDENSE lv_cnt1 NO-GAPS.
      CONCATENATE wa_eban1-ekorg '('lv_cnt1')' INTO DATA(lv_ekorg_cnt) SEPARATED BY space.
      CONCATENATE 'Purch Org -' lv_ekorg_cnt INTO DATA(lv_ekorg) SEPARATED BY space.
      PERFORM add_node USING  gt_treeb str3 str1 p_isfolder lv_ekorg p_expander.
    ENDIF.


*    CLEAR lv_cnt.
*    PERFORM total_sbuy_purch_org USING wa_eban1-ekorg CHANGING lv_cnt.
*    lv_cnt1 = lv_cnt.
*    IF lv_cnt IS NOT INITIAL.
*      CONDENSE lv_cnt1 NO-GAPS.
*      CONCATENATE wa_eban1-ekorg '('lv_cnt1')' INTO lv_ekorg_cnt SEPARATED BY space.
*      CONCATENATE 'Purch Org -' lv_ekorg_cnt INTO lv_ekorg SEPARATED BY space.
*      PERFORM add_node USING  gt_treeb str4 str2 p_isfolder lv_ekorg  p_expander.
*    ENDIF.

    CLEAR lv_cnt.
    PERFORM total_sbuy_AWARD_RFQS USING wa_eban1-ekorg CHANGING lv_cnt.
    lv_cnt1 = lv_cnt.
    IF lv_cnt IS NOT INITIAL.
      CONDENSE lv_cnt1 NO-GAPS.
      CONCATENATE wa_eban1-ekorg '('lv_cnt1')' INTO lv_ekorg_cnt SEPARATED BY space.
      CONCATENATE 'Purch Org -' lv_ekorg_cnt INTO lv_ekorg SEPARATED BY space.
      PERFORM add_node USING  gt_treeb str6 str5 p_isfolder lv_ekorg  p_expander.
    ENDIF.

    CLEAR lv_cnt.
    PERFORM total_sbuy_inprocess_RFQS USING wa_eban1-ekorg CHANGING lv_cnt.
    lv_cnt1 = lv_cnt.
    IF lv_cnt IS NOT INITIAL.
      CONDENSE lv_cnt1 NO-GAPS.
      CONCATENATE wa_eban1-ekorg '('lv_cnt1')' INTO lv_ekorg_cnt SEPARATED BY space.
      CONCATENATE 'Purch Org -' lv_ekorg_cnt INTO lv_ekorg SEPARATED BY space.
      PERFORM add_node USING  gt_treeb str9 str7 p_isfolder lv_ekorg  p_expander.
    ENDIF.




  ENDLOOP.


  CALL METHOD gt_treeb->expand_nodes
    EXPORTING
      node_key_table          = gt_rnode
    EXCEPTIONS
      error_in_node_key_table = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADD_NODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_TREEB  text
*      -->P_STR7  text
*      -->P_STR  text
*      -->P_P_ISFOLDER  text
*      -->P_LV_BUKRS  text
*      -->P_P_EXPANDER  text
*----------------------------------------------------------------------*
FORM add_node  USING obj_tree TYPE REF TO cl_simple_tree_model
                        p_node_key
                        p_root
                        p_isfolder
                        p_node_text
                        p_expander.

  CALL METHOD obj_tree->add_node
    EXPORTING
      node_key          = p_node_key
      relative_node_key = p_root
      relationship      = cl_simple_tree_model=>relat_last_child
      isfolder          = p_isfolder
      text              = p_node_text
      expander          = p_expander.
  wa_rnode = p_node_key.
  APPEND wa_rnode TO gt_rnode.
  CLEAR wa_rnode.

ENDFORM.

FORM fill_bdc_screen  TABLES pt_bdc STRUCTURE bdcdata
                      USING    p_prog
                               p_dynr.
  CLEAR wa_bdc.
  wa_bdc-program = p_prog.
  wa_bdc-dynpro = p_dynr.
  wa_bdc-dynbegin = 'X'.
  APPEND wa_bdc TO pt_bdc.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_BDC_VALUE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LT_BDC
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM fill_bdc_value  TABLES  pt_bdc STRUCTURE bdcdata
                     USING    p_fnam
                              p_fval.
  CLEAR wa_bdc.
  wa_bdc-fnam = p_fnam.
  wa_bdc-fval = p_fval.
  APPEND wa_bdc TO pt_bdc.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EVENT_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_ROW_ID  text
*      -->P_E_COLUMN_ID  text
*----------------------------------------------------------------------*
FORM event_hotspot_click  USING    p_e_row_id
                                   p_e_column_id.
  READ TABLE gt_final INTO wa_final INDEX p_e_row_id.
  DATA:p_docid   TYPE /sdocs/s1_buy_hd-docid,
       l_gidocid TYPE /sdocs/s1_buy_hd-docid,
       lv_matnr  TYPE matnr,
       lv_werks  TYPE werks,
       lv_statm  TYPE statm.
  CLEAR l_gidocid.
  CASE p_e_column_id.
    WHEN 'BANFN'.
      IF wa_final-banfn IS NOT INITIAL.
        DATA: lt_eban       TYPE TABLE OF eban,
              lv_authorized TYPE abap_bool VALUE abap_false.

        SELECT PurchaseRequisition,Plant FROM I_PurchaseRequisitionItemAPI01 INTO TABLE @lt_eban WHERE PurchaseRequisition = @wa_final-banfn.

        LOOP AT lt_eban INTO DATA(ls_eban).
          AUTHORITY-CHECK OBJECT 'M_BANF_WRK'
            ID 'ACTVT' FIELD '03'
            ID 'WERKS' FIELD ls_eban-werks.
          IF sy-subrc = 0.
            lv_authorized = abap_true.
            EXIT. " Authorized for at least one plant
          ENDIF.
        ENDLOOP.

        IF lv_authorized = abap_true.
*          lv_db_table = 'eban'.
*          SELECT SINGLE werks
*                    FROM (lv_db_table)
*                    INTO lv_werks
*                    WHERE banfn = wa_final-banfn.
*
*          IF sy-subrc = 0.

*             Check authorization for Purchase Requisition with Plant
*            AUTHORITY-CHECK OBJECT 'M_BANF_WRK'
*              ID 'ACTVT' FIELD '03'        " 03 = Display
*              ID 'WERKS' FIELD lv_werks.   " Plant from PR
*
*            IF sy-subrc = 0.
          " Authorization successful
          SET PARAMETER ID 'BAN' FIELD ''.
          SET PARAMETER ID 'BAN' FIELD wa_final-banfn.
          CALL TRANSACTION 'ME53N' AND SKIP FIRST SCREEN.
        ELSE.
          RETURN.
        ENDIF.
      ELSE.
        MESSAGE 'You are not authorized to display this purchase requisition' TYPE 'E'.
      ENDIF.
*        ENDIF.
*      ENDIF.

    WHEN  'MATNR'.
*      IF wa_final-matnr IS NOT INITIAL.
*
*        lv_matnr = wa_final-matnr.
*
*        lv_db_table = 'mara'.
*        SELECT SINGLE statm
*          FROM (lv_db_table)
*          INTO lv_statm
*          WHERE matnr = lv_matnr.
*
*        IF sy-subrc = 0.
*
*          AUTHORITY-CHECK OBJECT 'M_MATE_STA'
*            ID 'ACTVT' FIELD '03'
*            ID 'STATM' FIELD lv_statm.
*
*          IF sy-subrc = 0.
*            SET PARAMETER ID 'BAN' FIELD ''.
*            SET PARAMETER ID 'MAT' FIELD wa_final-matnr.
*            CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
*          ELSE.
*            MESSAGE 'You are not authorized to display this material' TYPE 'E'.
*          ENDIF.
*        ENDIF.
*      ENDIF.
    WHEN 'PO'.
      IF wa_final-po IS NOT INITIAL.


        SELECT SINGLE PurchasingOrganization FROM I_PurchaseOrderAPI01 INTO @DATA(lv_ekorg) WHERE PurchaseOrder = @wa_final-po.
        AUTHORITY-CHECK OBJECT 'M_BEST_EKO'
          ID 'ACTVT' FIELD '03'
          ID 'EKORG' FIELD lv_ekorg.
*  ID 'EKGRP' FIELD lv_ekgrp.
        IF sy-subrc = 0.
          SET PARAMETER ID 'BES' FIELD wa_final-po.
          CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.

        ENDIF.

      ENDIF.
    WHEN 'PR_RFX'.
      IF wa_final-pr_rfx IS  NOT INITIAL.
        DATA:lv_appl TYPE string.
        lv_db_table = '/sdocs/sspy_sgc'.
        SELECT SINGLE config_value INTO lv_appl FROM (lv_db_table) WHERE config = 'BROWSER_EXTESTION_NAME'.
        IF lv_appl IS INITIAL.
          lv_appl  = 'msedge.exe'.
        ENDIF.
        DATA(l_rfx) = wa_final-pr_rfx.
        SHIFT l_rfx LEFT DELETING LEADING '0'.
        CONCATENATE 'https://s4-demo.smartdocs.one/#/sp/company/rfx/' l_rfx INTO lv_param.
        cl_gui_frontend_services=>execute(
      EXPORTING
        application = lv_appl "'chrome.exe' "msedge.exe
        parameter   = lv_param"'/new-window https://google.com'
      EXCEPTIONS
        OTHERS      = 1 ).
      ENDIF.
    WHEN 'SAP_GI'.
*      IF wa_final-sap_gi IS NOT INITIAL.
*        DATA : lv_fm TYPE char100.
*        lv_fm = 'migo_dialog'.
*        CALL FUNCTION lv_fm
*          EXPORTING
*            i_action            = 'A07'
*            i_notree            = 'X'
*            i_no_auth_check     = ' '
*            i_deadend           = 'X'
*            i_skip_first_screen = 'X'
*            i_okcode            = 'OK_GO'
*            i_mblnr             = wa_final-sap_gi
*            i_mjahr             = '2023'
*          EXCEPTIONS
*            illegal_combination = 1
*            OTHERS              = 2.
*        IF sy-subrc <> 0.
** Implement suitable error handling here
*        ENDIF.
*      ENDIF.

    WHEN 'DOCID'.
*      IF wa_final-docid IS NOT INITIAL AND wa_final-rfx_award IS  INITIAL.
*
*        CALL FUNCTION '/SDOCS/S1_RFQ_RESUBMIT'
*          EXPORTING
*            i_docid = wa_final-docid
*            i_disp  = ' '.

*      ELSEIF wa_final-docid IS NOT INITIAL AND wa_final-rfx_award IS NOT INITIAL.
*
*        CALL FUNCTION '/SDOCS/S1_RFQ_RESUBMIT'
*          EXPORTING
*            i_docid = wa_final-docid
*            i_disp  = 'X'.
*
*
*      ENDIF.
    WHEN 'GI_DOCID' OR 'SBUYDOCID'.
*      IF p_e_column_id = 'SBUYDOCID'.
*        wa_final-gi_docid  = wa_final-sbuydocid.
*      ENDIF.
*      IF wa_final-gi_docid IS NOT INITIAL.
*        l_gidocid  = wa_final-gi_docid .
*        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*          EXPORTING
*            input  = l_gidocid
*          IMPORTING
*            output = l_gidocid.
*        lv_db_table = '/sdocs/s1_buy_hd'.
*        SELECT SINGLE doctype FROM (lv_db_table) INTO @l_doctype WHERE docid = @l_gidocid.
*        lv_db_table = '/sdocs/s1_buy_hd'.
*        SELECT SINGLE docid FROM (lv_db_table) INTO @l_docid WHERE docid = @l_gidocid.
*        IF sy-subrc = 0 AND l_doctype <> 'S1_GRR'.
*          p_docid = l_gidocid.
*          FREE MEMORY ID 'BSTL_DOCID'.
*          EXPORT p_docid TO MEMORY ID 'BSTL_DOCID'.
*          AUTHORITY-CHECK OBJECT 'S_TCODE'
*            ID 'TCD' FIELD '/SDOCS/S1_PARBUY'.
*          IF sy-subrc = 0.
*            CALL TRANSACTION '/SDOCS/S1_PARBUY'.
*          ELSE.
*            MESSAGE |No authorization to execute transaction /SDOCS/S1_PARBUY| TYPE 'E'.
*          ENDIF.
*        ELSEIF sy-subrc = 0 AND l_doctype = 'S1_GRR'.
*          p_docid = l_gidocid.
*          FREE MEMORY ID 'VLSTL_DOCID'.
*          EXPORT p_docid TO MEMORY ID 'VLSTL_DOCID'.
*
*          " Check general transaction code authorization
*          AUTHORITY-CHECK OBJECT 'S_TCODE'
*            ID 'TCD' FIELD '/SDOCS/S1_LPAR'.
*
*          IF sy-subrc = 0.
*            " User has authorization to execute this transaction
*            CALL TRANSACTION '/SDOCS/S1_LPAR'.
*          ELSE.
*            " No authorization
*            MESSAGE |No authorization to execute transaction /SDOCS/S1_LPAR| TYPE 'E'.
*          ENDIF.
*        ENDIF.
*        CLEAR:l_doctype, l_docid,l_gidocid.
*      ENDIF.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_RFQ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_VENDOR  text
*      -->P_LV_DDATE  text
*      -->P_WA_EBAN  text
*----------------------------------------------------------------------*
*FORM CREATE_RFQ  USING    P_VENDOR
*                          P_DDATE
*                          P_WA_EBAN TYPE FS_EBAN.
*  PERFORM COCKPIT_RFQ_CREATION USING P_VENDOR P_DDATE P_WA_EBAN .
*ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_TREE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MORE_KEY  text
*      -->P_LV_BUKRS  text
*----------------------------------------------------------------------*
FORM get_tree_data  USING    p_ekorg p_doctype.
  REFRESH gt_final .
  IF p_doctype = 'SPGR' AND p_ekorg IS INITIAL.
    LOOP AT GT_EBAN_save INTO DATA(wa_eban_save) WHERE doctype = ' '.
      APPEND wa_eban_save TO gt_final.
      CLEAR wa_eban_save.
    ENDLOOP.
  ELSEIF  p_doctype = 'SPGR' AND p_ekorg IS NOT INITIAL.
    LOOP AT GT_EBAN_save INTO wa_eban_save WHERE doctype = ' ' AND ekorg = p_ekorg.
      APPEND wa_eban_save TO gt_final.
      CLEAR wa_eban_save.
    ENDLOOP.
  ELSEIF p_doctype = 'SBPR' AND p_ekorg IS INITIAL.
    LOOP AT GT_EBAN_save INTO wa_eban_save WHERE doctype = 'S1_PR'.
      APPEND wa_eban_save TO gt_final.
      CLEAR wa_eban_save.
    ENDLOOP.
  ELSEIF  p_doctype = 'SBPR' AND p_ekorg IS NOT INITIAL.
    LOOP AT GT_EBAN_save INTO wa_eban_save WHERE doctype = 'S1_PR' AND ekorg = p_ekorg.
      APPEND wa_eban_save TO gt_final.
      CLEAR wa_eban_save.
    ENDLOOP.
  ELSEIF  p_doctype = 'SRFQ' AND p_ekorg IS INITIAL.
    LOOP AT GT_EBAN_save INTO wa_eban_save WHERE doctype = 'S1_RFQ' AND rfx_award = 'X'..
      APPEND wa_eban_save TO gt_final.
      CLEAR wa_eban_save.
    ENDLOOP.
  ELSEIF  p_doctype = 'SRFQ' AND p_ekorg IS NOT INITIAL.
    LOOP AT GT_EBAN_save INTO wa_eban_save WHERE doctype = 'S1_RFQ' AND ekorg = p_ekorg AND rfx_award = 'X'..
      APPEND wa_eban_save TO gt_final.
      CLEAR wa_eban_save.
    ENDLOOP.

  ELSEIF  p_doctype = 'ARFQ' AND p_ekorg IS INITIAL.
    LOOP AT GT_EBAN_save INTO wa_eban_save WHERE doctype = 'S1_RFQ' AND rfx_award = ' '.
      APPEND wa_eban_save TO gt_final.
      CLEAR wa_eban_save.
    ENDLOOP.
  ELSEIF  p_doctype = 'ARFQ' AND p_ekorg IS NOT INITIAL.
    LOOP AT GT_EBAN_save INTO wa_eban_save WHERE doctype = 'S1_RFQ' AND ekorg = p_ekorg AND rfx_award = ' '...
      APPEND wa_eban_save TO gt_final.
      CLEAR wa_eban_save.
    ENDLOOP.
*  ELSEIF p_ekorg IS NOT INITIAL  AND p_werks IS NOT INITIAL.
*    LOOP AT GT_EBAN_save INTO wa_eban_save WHERE ekorg = p_ekorg AND werks = p_werks.
*      APPEND wa_eban_save TO gt_final.
*      CLEAR wa_eban_save.
*    ENDLOOP.
*  ELSEIF p_ekorg IS NOT INITIAL AND p_werks IS  INITIAL.
*    LOOP AT GT_EBAN_save INTO wa_eban_save WHERE ekorg = p_ekorg.
*
*      APPEND wa_eban_save TO gt_final.
*      CLEAR wa_eban_save.
*    ENDLOOP.
*  ELSEIF  p_ekorg IS  INITIAL AND p_werks IS  INITIAL AND p_doctype IS INITIAL.
*    gt_final[] = GT_EBAN_save[].
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_PO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_ROWS  text
*      -->P_GT_EBAN  text
*----------------------------------------------------------------------*
FORM create_po  TABLES   pgt_rows LIKE  gt_rows
                         pgt_eban STRUCTURE wa_EBAN.
  CONSTANTS : po_x VALUE 'X'.
  DATA:lv_taxcode(2) TYPE c.
  DATA: del_date TYPE sy-datum.
  DATA: ls_pohead  TYPE bapimepoheader.
  DATA: ls_poheadx TYPE bapimepoheaderx,
        lt_byract  TYPE TABLE OF /sdocs/s1_byract,
        wa_byract  TYPE /sdocs/s1_byract.
  DATA: exp_head TYPE bapimepoheader.
  DATA:lt_poaccount  TYPE TABLE OF bapimepoaccount WITH HEADER LINE,
       lt_poaccountx TYPE TABLE OF bapimepoaccountx WITH HEADER LINE.
  DATA: lt_return  TYPE TABLE OF bapiret2 WITH HEADER LINE.
  DATA: lt_poitem  TYPE TABLE OF bapimepoitem WITH HEADER LINE.
  DATA: lt_poitemx TYPE TABLE OF bapimepoitemx WITH HEADER LINE.
  DATA: w_return TYPE  bapiret2.
  DATA: it_message_tab TYPE esp1_message_tab_type,
        wa_message_tab TYPE esp1_message_wa_type.
  DATA:lv_bstme TYPE bstme,
       lv_meins TYPE meins,
       ls_row   TYPE LVC_s_ROW.

  DATA: lt_posched  TYPE TABLE OF bapimeposchedule WITH HEADER LINE.
  DATA: lt_poschedx TYPE TABLE OF bapimeposchedulx WITH HEADER LINE.

  DATA: ex_po_number TYPE bapimepoheader-po_number.
  DATA:lv_rlcode_s.
  DATA:i_ext TYPE /sdocs/sspy_http_ext ."value '/pordata/update'.
  DATA:gv_por_action TYPE /sdocs/sspy_http_ext." value  '/pordata/action'.
  DATA:lv_date TYPE string.
  DATA:lv_matkl  TYPE /sdocs/s1_buy_ln-matkl.
  DATA:lv_cnt TYPE numc5.
  DATA: wa_excpt TYPE /sdocs/s1_er_msg,
        it_excpt TYPE TABLE OF /sdocs/s1_er_msg.
  DATA:l_por TYPE /sdocs/s1_byract-por_no.
  DATA:l_por1  TYPE /sdocs/s1_byract-por_no,
       lv_cnt1 TYPE sy-tabix.

  DATA lv_vendor TYPE lifnr.
  REFRESH:lt_return[],lt_poitem[],lt_poitemx[],it_message_tab[],lt_posched[],lt_poschedx[],it_excpt.
  CLEAR:ls_pohead,ls_poheadx,exp_head,lt_return,lt_poitem,lt_poitemx,w_return,wa_message_tab,lt_posched,lt_poschedx,
        ex_po_number,lv_vendor,lv_date,lv_cnt,lv_matkl,wa_excpt,l_por,l_por1,lv_rlcode_s,lv_taxcode.
* Header Level Data
  READ TABLE pgt_rows INTO ls_row INDEX 1.
  READ TABLE pgt_eban INTO wa_eban INDEX ls_row-index.
*    if ls_head-ebeln is initial.
  lv_db_table = '/sdocs/sspy_sgc'.
  SELECT SINGLE config_value INTO lv_taxcode FROM (lv_db_table)  WHERE config = 'DEFAULT_TAXCODE_BAPIPO'.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = '1000'
    IMPORTING
      output = ls_pohead-vendor.


*      if ls_head-bsart is initial.
*        ls_head-bsart = 'NB'.
*      endif.
  CLEAR lv_date.
  DATA:lt_eban TYPE TABLE OF eban WITH HEADER LINE.
  lv_db_table = 'eban'.
  SELECT * FROM (lv_db_table) INTO TABLE lt_eban WHERE banfn = wa_eban-banfn.
  READ TABLE lt_eban INDEX 1.
*   concatenate sy-datum+6(2) sy-datum+4(2) sy-datum+0(4) into  lv_date    .
  ls_pohead-comp_code  = '1000'."ls_head-bukrs.
  ls_pohead-doc_type   = lt_eban-bsart."ls_head-bsart.
  ls_pohead-creat_date = sy-datum."lv_date.
*      ls_pohead-vendor     = ls_head-lifnr.
  ls_pohead-purch_org  = lt_eban-ekorg."ls_head-ekorg.
  ls_pohead-pur_group  = lt_eban-ekgrp.
  ls_pohead-vper_start = sy-datum.
  ls_pohead-langu      = sy-langu   .
  ls_pohead-doc_date   = sy-datum."lv_date.
  ls_pohead-currency   = lt_eban-waers.
*      ls_pohead-incoterms1 = ls_head-inco1.
*      ls_pohead-pmnttrms = ls_head-zterm.

  ls_poheadx-comp_code  = po_x.
  ls_poheadx-doc_type   = po_x.
  ls_poheadx-creat_date = po_x.
  ls_poheadx-vendor     = po_x.
  ls_poheadx-langu      = po_x.
  ls_poheadx-purch_org  = po_x.
  ls_poheadx-pur_group  = po_x.
  ls_poheadx-doc_date   = po_x.
  ls_poheadx-currency   = po_x.
*      ls_poheadx-incoterms1 = po_x.
*      ls_poheadx-pmnttrms   = po_x.
  ls_poheadx-vper_start  = po_x.

* Item Level Data
  CLEAR: lv_cnt,lv_cnt1.
*      loop at lt_item into ls_item.
  LOOP AT pgt_rows INTO ls_ROW.
    CLEAR: lt_eban,wa_eban.
    READ TABLE pgt_eban INTO wa_eban INDEX ls_row-index.
    READ TABLE lt_eban WITH KEY banfn = wa_eban-banfn bnfpo = wa_eban-bnfpo.

    lv_cnt1 = lv_cnt1 + 1.
    lv_cnt =  lv_cnt1 * 10 ."lv_cnt + 1.
    lt_poitem-po_item    =  lv_cnt .
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = lt_eban-matnr
      IMPORTING
        output       = lt_eban-matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
*        clear:lv_meins,lv_bstme.
*        select single meins bstme into (lv_meins,lv_bstme) from mara where matnr = ls_item-matnr.
*        if lv_bstme is INITIAL.
*          lv_bstme = lv_meins.
*        endif.
    lt_poitem-material   = lt_eban-matnr.
    lt_poitem-plant      = lt_eban-werks.
    lt_poitem-short_text  = lt_eban-txz01.
    lt_poitem-stge_loc   =  lt_eban-lgort.
    lt_poitem-quantity   =  lt_eban-menge.
*        lt_poitem-net_price  =  lt_eban-netpr.
*        if lt_poitem-material is INITIAL.
    lt_poitem-po_unit    =  lt_eban-meins."ls_item-uom."ls_item-uom.
*        lt_poitem-po_unit_iso = lv_bstme.
*        endif.
    lt_poitem-orderpr_un = lt_eban-meins.
    lt_poitem-matl_group = lt_eban-matkl.
    lt_poitem-price_unit = lt_eban-peinh.
*        lt_poitem-conf_ctrl  = '0003'.  "Rough GR/Inbound Delivery
*        if ls_item-matnr is initial.
*          lt_poitem-acctasscat = 'K'.
*        endif.
*
*
*        if ls_item-mwskz is initial.
*          lt_poitem-tax_code = lv_taxcode.
*        endif.

    APPEND lt_poitem.

    lt_poitemx-po_item    = lv_cnt.
    lt_poitemx-po_itemx   = po_x.
    lt_poitemx-net_price  = po_x .
*        if lt_poitem-material is initial.
*        lt_poitemx-po_unit    = po_x .
*        else.
    lt_poitemx-material   = po_x.
*        endif.
    lt_poitemx-plant      = po_x .
    lt_poitemx-stge_loc   = po_x .
    lt_poitemx-quantity   = po_x .
    lt_poitemx-tax_code   = po_x .
    lt_poitemx-item_cat   = po_x .
    lt_poitemx-matl_group = po_x .
    lt_poitemx-price_unit = po_x .
*        lt_poitemx-conf_ctrl  = po_x .
    lt_poitemx-orderpr_un = po_x .
    lt_poitemx-short_text  = po_x .
    lt_poitemx-tax_code   = po_x .
*        lt_poitemx-orderpr_un_iso = po_x .
*        lt_poitemx-po_unit_iso    = po_x .
*        if ls_item-matnr is initial.
*          lt_poitemx-acctasscat = po_x .
*        endif.

    APPEND lt_poitemx.


* Schedule Line Level Data
*       CONCATENATE ls_item-eindt+4(2) ls_item-eindt+6(2) ls_item-eindt+0(4)   INTO lt_posched-delivery_date.
    lt_posched-po_item        = lv_cnt.
    lt_posched-sched_line     = '1'."lv_cnt.
    lt_posched-del_datcat_ext = 'D'.
*        lt_posched-delivery_date  = ls_item-eindt.
    lt_posched-deliv_time     = '235959'.
    lt_posched-quantity       = lt_eban-menge.
    lt_posched-preq_no       = lt_eban-banfn.
    lt_posched-preq_item    = lt_eban-bnfpo.
*        lt_posched-stat_date      = lt_posched-delivery_date.
    APPEND lt_posched.

    lt_poschedx-po_item        = lv_cnt."'1'.
    lt_poschedx-sched_line     = '1'.
    lt_poschedx-po_itemx       = po_x.
    lt_poschedx-sched_linex    = po_x.
    lt_poschedx-del_datcat_ext = po_x.
    lt_poschedx-delivery_date  = po_x.
    lt_poschedx-quantity       = po_x.
    lt_poschedx-stat_date      = po_x.
    lt_poschedx-preq_no       = po_x.
    lt_poschedx-preq_item    = po_x.
    APPEND lt_poschedx.



*        if lt_poitem-material is initial.
*          lt_poaccount-po_item = lv_cnt.
*          call function 'CONVERSION_EXIT_ALPHA_INPUT'
*            exporting
*              input  = ls_item-saknr
*            importing
*              output = ls_item-saknr.
*          lt_poaccount-gl_account = ls_item-saknr."'0000420402'.
*
*          call function 'CONVERSION_EXIT_ALPHA_INPUT'
*            exporting
*              input  = ls_item-kostl
*            importing
*              output = ls_item-kostl.
*
*          lt_poaccount-serial_no  = 1.
*          lt_poaccount-costcenter = ls_item-kostl.
*          lt_poaccount-quantity   = ls_item-bamng.
*          lt_poaccount-net_value  = ls_item-netpr.
*          append lt_poaccount.clear lt_poaccount.
*
*
*          lt_poaccountx-po_item    = lv_cnt.
*          lt_poaccountx-serial_no  = 1.
*          lt_poaccountx-po_itemx   = po_x .
*          lt_poaccountx-gl_account = po_x .
*          lt_poaccountx-costcenter = po_x .
*          lt_poaccountx-quantity   = po_x.
*          lt_poaccountx-net_value  = po_x.
*          append lt_poaccountx.clear lt_poaccountx.
*
*        endif.
    CLEAR:lt_poitem,lt_poitem, lt_poschedx,lt_posched.
  ENDLOOP.

*      CALL FUNCTION 'DIALOG_SET_NO_DIALOG'.

  CALL FUNCTION 'BAPI_PO_CREATE1'
    EXPORTING
      poheader         = ls_pohead
      poheaderx        = ls_poheadx
*     testrun          = 'X'
      no_price_from_po = 'X'
    IMPORTING
      exppurchaseorder = ex_po_number
      expheader        = exp_head
    TABLES
      return           = lt_return
      poitem           = lt_poitem
      poitemx          = lt_poitemx
      poschedule       = lt_posched
      poschedulex      = lt_poschedx.
*          poaccount        = lt_poaccount
*          poaccountx       = lt_poaccountx.
*    endif.
*    if ls_head-ebeln is not initial or ex_po_number is not initial.
*      if ls_head-ebeln is not initial or ex_po_number is  initial.
*        ex_po_number = ls_head-ebeln.
*      endif.
*
  IF ex_po_number IS NOT INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    CONCATENATE  'PO created with'   ex_po_number INTO DATA(lv_msg) SEPARATED BY space.
    MESSAGE lv_msg TYPE 'I'.
    CLEAR lv_msg.
  ENDIF.
*      endif.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_PURCH_COUNT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_purch_count USING p_ekorg p_cnt.
  DATA(lt_eban) = gt_eban[].
  DELETE lt_eban WHERE ekorg <> p_ekorg.
  DESCRIBE TABLE lt_eban LINES p_cnt.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_PLANT_COUNT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_EBAN1_EKORG  text
*      -->P_WA_EBAN2_WERKS  text
*      <--P_LV_CNT  text
*----------------------------------------------------------------------*
FORM get_plant_count  USING    p_ekorg
                               p_werks
                      CHANGING p_cnt.

  DATA(lt_eban) = gt_eban[].
  DELETE lt_eban WHERE ekorg <> p_ekorg.
  DELETE lt_eban WHERE werks <> p_werks.
  DESCRIBE TABLE lt_eban LINES p_cnt.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COCKPIT_RFQ_CREATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_ROWS  text
*      -->P_GT_EBAN  text
*      -->P_P_VENDOR  text
*      -->P_P_DDATE  text
*----------------------------------------------------------------------*
FORM cockpit_rfq_creation  TABLES   pgt_rows LIKE  gt_rows
                                    pgt_eban STRUCTURE wa_EBAN
                           USING    p_vendor
                                    p_ddate
                                    p_deldate.
  DATA:lt_eket  TYPE TABLE OF eket WITH HEADER LINE,
       wa_eban1 TYPE fs_eban,
       wa_row   TYPE LVC_s_ROW.
  DATA:BEGIN OF lt_ekko OCCURS 0,
         ebeln TYPE ekko-ebeln,
         lifnr TYPE ekko-lifnr,
       END OF lt_ekko.
  REFRESH: lt_eket,lt_ekko.
  CLEAR lt_ekko.


  IF gt_eban1[] IS NOT INITIAL.
    lv_db_table = 'eket'.
    SELECT * FROM (lv_db_table) INTO TABLE lt_eket FOR ALL ENTRIES IN gt_eban1
      WHERE banfn = gt_eban1-banfn." AND BNFPO = WA_EBAN1-BNFPO.
    IF lt_eket[] IS NOT INITIAL.
      lv_db_table = 'ekko'.
      SELECT ebeln lifnr FROM (lv_db_table) INTO TABLE lt_ekko FOR ALL ENTRIES IN
                                lt_eket WHERE ebeln = lt_eket-ebeln AND bstyp = 'A'.
    ENDIF.
  ENDIF.
  READ TABLE lt_ekko WITH KEY lifnr = p_vendor.
  IF sy-subrc EQ 0.
    MESSAGE s006(/sdocs/sspay_msg) WITH 'RFQ already exists for selected PRs'.
  ELSE.




    PERFORM create_rfq_with_pr USING p_vendor p_ddate p_deldate.


  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_RFQ_WITH_PR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_rfq_with_pr  USING p_vendor p_ddate p_deldate.
  DATA:BEGIN OF lt_ekko OCCURS 0,
         ebeln TYPE ebeln,
         lifnr TYPE lifnr,
       END OF lt_ekko.
  DATA:lv_date(10)     TYPE c,
       lv_date1(10)    TYPE c,
       lv_crdate(10)   TYPE c,
       lv_fld(20)      TYPE c,
       lv_cnt          TYPE i,
       lv_tabix(5)     TYPE c,
       lv_tabix1(2)    TYPE n,
       lv_success,
       lv_msg          TYPE char50,
       l_index         TYPE i,
       lv_lno          TYPE numc5,
       lv_json_item    TYPE string,
       lv_json_items   TYPE string,
       lv_json_payload TYPE string,
       lv_vendors      TYPE string.
  DATA : lo_obj TYPE REF TO /sdocs/s1_cl_rfq_creation.
  REFRESH:lt_ekko[],gt_bdc,gt_ln.
  CLEAR:lv_crdate,lv_date,lv_date1,lv_cnt,lv_tabix1,lv_lno,wa_hd,lv_msg,l_index,lv_ebeln,lv_vendors.
  WRITE:p_ddate TO lv_date,
        p_deldate TO lv_date1,
        sy-datum TO lv_crdate.

  IF gt_eban1 IS NOT INITIAL.
    lv_db_table = 'eban'.
    SELECT banfn,bnfpo FROM (lv_db_table) INTO TABLE @LT_banfn FOR ALL ENTRIES IN @gt_eban1
     WHERE banfn = @gt_eban1-banfn AND ebeln = ' ' AND ebelp = ' '.
  ENDIF.
  SORT LT_banfn BY banfn bnfpo.
  SORT gt_eban1 BY banfn bnfpo.
  READ TABLE gt_eban1 INTO DATA(wa_eban1) INDEX 1.
  lv_db_table = 'ekpo'.
  SELECT SINGLE ebeln  FROM (lv_db_table) INTO lv_ebeln WHERE banfn = wa_eban1-banfn AND bnfpo  = wa_eban1-bnfpo.
  IF lv_ebeln IS NOT INITIAL.
    lv_db_table = 'ekko'.
    MESSAGE 'RFQ already exists' TYPE 'I'.
    RETURN.
  ELSE.
*    CALL FUNCTION 'NUMBER_GET_NEXT'
*      EXPORTING
*        nr_range_nr             = '01'
*        object                  = '/SDOCS/S1D'
*      IMPORTING
*        number                  = lv_submi
**       RETURNCODE              = ld_error
*      EXCEPTIONS
*        interval_not_found      = 1
*        number_range_not_intern = 2
*        object_not_found        = 3
*        quantity_is_0           = 4
*        quantity_is_not_1       = 5
*        interval_overflow       = 6
*        buffer_overflow         = 7
*        OTHERS                  = 8.
  ENDIF.

  DESCRIBE TABLE gt_eban1 LINES lv_cnt.
  CLEAR lv_ebeln.
  DATA : lv_menge   TYPE string,
         lv_qty_str TYPE n.
*               lv_qty_str1 type string.
  LOOP AT gt_eban1 INTO wa_eban1.
    " Convert quantity fields to string (if numeric)

    lv_menge =  wa_eban1-menge.
    CONDENSE lv_menge.
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*      EXPORTING
*        input  = wa_eban1-bnfpo
*      IMPORTING
*        output = lv_qty_str.
*          lv_qty_str1 = conv string( lv_qty_str ).
    DATA(lv_sch_dat)  = |{ wa_eban1-lfdat DATE = ISO }T00:00|.
    CONCATENATE
      '{'
      '"PurchaseRequisition": "' wa_eban1-banfn '",'
      '"PurchaseRequisitionItem": "' wa_eban1-bnfpo '",'
      '"ScheduleLineDeliveryDate": "' lv_sch_dat '",'
      '"ScheduleLineOrderQuantity": "' lv_menge '",'
      '"OrderQuantityUnit": "' wa_eban1-meins '",' "wa_eban1-meins"
      '"Plant": "' wa_eban1-werks '",'
      '"MaterialGroup": "' wa_eban1-matkl '",'
      '"Material": "' wa_eban1-matnr '"'
      '}'

    INTO lv_json_item.

    " Add comma between items except for last
    IF sy-tabix < lines( gt_eban1 ).
      CONCATENATE lv_json_item ',' INTO lv_json_item.
    ENDIF.


    CONCATENATE lv_json_items lv_json_item INTO lv_json_items.
  ENDLOOP.
*        DATA(lv_subm_date) = CONV string( sy-datum ).
*        DATA(lv_valid_date) = CONV string( sy-datum + 90 ).

  DATA(lv_subm_date)  = |{ gv_qdate DATE = ISO }T00:00|.
 DESCRIBE TABLE s_lifnr[] lines data(lv_vndr_cnt).
*  LOOP AT s_lifnr.
*    IF lv_vendors IS INITIAL.
*      CONCATENATE  '{'
*  '"Supplier": "' s_lifnr-low '"'
*  '}' INTO lv_vendors.
**    elseif lv_vndr_cnt = sy-tabix.
**       CONCATENATE lv_vendors '{'
**      '"Supplier": "' s_lifnr-low '"'
**      '}' INTO lv_vendors.
**    ELSE.
*      CONCATENATE lv_vendors ',' '{'
*      '"Supplier": "' s_lifnr-low '"'
*      '}' INTO lv_vendors.
*    ENDIF.
*  ENDLOOP.

  LOOP AT s_lifnr.
  CONCATENATE lv_vendors
              '{ "Supplier": "' s_lifnr-low '" }'
              INTO lv_vendors.

  " Add comma except after last element
  IF sy-tabix < lines( s_lifnr ).
    CONCATENATE lv_vendors ', ' INTO lv_vendors.
  ENDIF.
ENDLOOP.

  DATA: lv_future_date TYPE d.
  lv_future_date = qa_ddate.

*DATA(lv_valid_date) = |{ lv_future_date+0(4) }-{ lv_future_date+4(2) }-{ lv_future_date+6(2) }|.
  DATA(lv_valid_date) = |{  lv_future_date  DATE = ISO }T00:00|.
*        DATA(lv_curr) = CONV string( wa_eban-preis ).
  DATA(lv_curr) = 'USD'.
  " 4️⃣ Wrap items and supplier info into final JSON payload
  CONCATENATE
    '{"d": {'
    '"CompanyCode": "' wa_eban1-bukrs '",'
    '"PurchasingOrganization": "' wa_eban1-ekorg '",'
    '"PurchasingGroup": "' wa_eban1-ekgrp '",'
    '"DocumentCurrency": "' lv_curr '",'
    '"PurchasingDocumentType": "RQ",'
    '"RequestForQuotationName": "' gv_title '",'
    '"QuotationLatestSubmissionDate": "' lv_subm_date '",'
    '"BindingPeriodValidityEndDate": "' lv_valid_date '",'
    '"to_RequestForQuotationItem": { "results": ['
    lv_json_items
    '] },'
    '"to_RequestForQuotationBidder": { "results": [' lv_vendors
       '] }'
    '}}'


  INTO lv_json_payload.
*'"to_RequestForQuotationBidder": { "results": [ {'
*      '"Supplier": "' s_lifnr-low '"'
*      '} ] }'
*      '}}'



  CREATE OBJECT lo_obj.
  lo_obj->mv_url = 'https://VHCALS4HCS.DUMMY.NODOMAIN:443'.
  DATA: lv_exist TYPE ekpo-ebeln.
*  lv_db_table = 'ekpo'.
*  SELECT SINGLE  ebeln FROM (lv_db_table) INTO @lv_exist WHERE banfn = @wa_eban1-banfn AND bnfpo = @wa_eban1-bnfpo.
*  IF lv_exist IS INITIAL.
  lo_obj->create_rfq(
  EXPORTING
    lv_json_payload = lv_json_payload
    IMPORTING
    ev_quot_no = DATA(lv_res)
    es_no_token = DATA(gv_msg)  ).

*  LOOP AT s_lifnr.
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0300'.
*
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_CURSOR'  'EKKO-ANGDT',
*                                                 'BDC_OKCODE' '=KOPF',
*                                                 'RM06E-ASART' 'AN',
*                                                 'EKKO-SPRAS' sy-langu ,
*                                                 'RM06E-ANFDT' lv_crdate,
*                                                 'EKKO-ANGDT'  lv_date ,
*                                                 'EKKO-EKORG' wa_eban1-ekorg ,
*                                                 'EKKO-EKGRP' wa_eban1-ekgrp ,
*                                                 'RM06E-LPEIN' 'T' ,
*                                                 'RM06E-WERKS' ' '.
*
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0301'.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_CURSOR'  'EKKO-SUBMI',
*                                                 'BDC_OKCODE' '=BS',
*                                                 'EKKO-SUBMI' lv_submi,
*                                                 'EKKO-EKGRP' wa_eban1-ekgrp.
*
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0501'.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_CURSOR'  'EKET-BANFN',
*                                                 'BDC_OKCODE' '=ENTE',
*                                                 'EKET-BANFN' wa_eban1-banfn ,
*                                                 'EBAN-EKGRP' wa_eban1-ekgrp,
*                                                 'RM06E-BSKNT' 'X',
*                                                 'RM06E-BSLAG' 'X',
*                                                 'RM06E-OFFBA' 'X'.
*
**    PERFORM FILL_BDC_SCREEN TABLES GT_BDC USING 'SAPMM06E' '0125'.
**    PERFORM FILL_BDC_VALUE TABLES GT_BDC USING : 'BDC_CURSOR'  'EBAN-LGORT(01)',
**                                                 'BDC_OKCODE' '=MALL'.
*
**    PERFORM FILL_BDC_SCREEN TABLES GT_BDC USING 'SAPMM06E' '0125'.
**    PERFORM FILL_BDC_VALUE TABLES GT_BDC USING : 'BDC_CURSOR'  'EBAN-LGORT(01)',
**                                                 'BDC_OKCODE' '=REFH'.
*
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0125'.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_CURSOR'  'EBAN-BANFN(01)',
*                                                 'BDC_OKCODE' '=REFH'.
*    LOOP AT gt_eban1 INTO DATA(ls_eban).
*      READ TABLE LT_banfn INTO DATA(l_banfn) WITH KEY banfn = ls_eban-banfn bnfpo = ls_eban-bnfpo.
*      lv_tabix = sy-tabix.
*      lv_tabix1 = lv_tabix.
*      CONCATENATE  'RM06E-TCSELFLAG(' lv_tabix1  ')' INTO lv_fld.
*      PERFORM fill_bdc_value TABLES gt_bdc USING : lv_fld 'X'.
*      CLEAR:lv_tabix,ls_eban,l_banfn.
*    ENDLOOP.
*    DO lv_cnt TIMES.
*      PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0311'.
*      PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_CURSOR'  'RM06E-EEIND',
*                                                  'BDC_OKCODE' '/00'.
**                                                 'RM06E-EEIND' lv_date1.
*    ENDDO.
*
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0320'.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_CURSOR'  'RM06E-ANFPS(02)',
*                                                'BDC_OKCODE' '=LS'.
*
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0140'.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_CURSOR'  'EKKO-LIFNR',
*                                                'BDC_OKCODE' '/00',
*                                                'EKKO-LIFNR' s_lifnr-low.
*
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0140'.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_CURSOR'  'EKKO-LIFNR',
*                                                'BDC_OKCODE' '=AB'.
*
*
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0320'.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_CURSOR'  'RM06E-ANFPS(02)',
*                                                'BDC_OKCODE' '=BU'.
*
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPLSPO1' '0300'.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_OKCODE'  '=YES'.
*
*    PERFORM fill_bdc_screen TABLES gt_bdc USING 'SAPMM06E' '0140'.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_OKCODE'  '/EEN',
*                                                'BDC_CURSOR' 'EKKO-LIFNR'.
*
*    wa_options-dismode = 'E'.
*    wa_options-updmode = 'S'.
*    wa_options-racommit = abap_true.
*    wa_options-nobinpt = abap_true.
*
*    CALL TRANSACTION 'ME41' USING gt_bdc OPTIONS FROM wa_options MESSAGES INTO gt_messages.
*    CLEAR wa_msgs.
*    READ TABLE gt_messages INTO DATA(wa_msg) WITH KEY msgtyp = 'S' msgid = '06' msgnr = '017' ."needs to be check msg no and type
*    IF sy-subrc = 0 .
*      lt_ekko-ebeln = wa_msg-msgv2.
*      lt_ekko-lifnr = s_lifnr-low.
*      IF lv_ebeln IS INITIAL.
*        lv_ebeln  = wa_msg-msgv2.
*      ENDIF.
*      APPEND lt_ekko.


  DATA : lv_rfq_no TYPE ekpo-ebeln.
  DATA : lv_status_code TYPE int4.
  WAIT UP TO 2 SECONDS.
  lv_db_table = 'ekpo'.
  SELECT SINGLE ebeln FROM (lv_db_table) INTO @lv_rfq_no WHERE banfn = @wa_eban1-banfn AND bnfpo = @wa_eban1-bnfpo.
  CALL FUNCTION '/SDOCS/S1_RFQ_APPR_PUBLISH'
    EXPORTING
      p_rfq        = lv_rfq_no
    IMPORTING
      lv_response1 = lv_status_code.
  IF lv_rfq_no IS NOT INITIAL.
    lt_ekko-ebeln = lv_rfq_no.
    lt_ekko-lifnr = s_lifnr-low.
    IF lv_ebeln IS INITIAL.
      lv_ebeln = lv_rfq_no.
    ENDIF.
    APPEND lt_ekko.
    IF  lv_rfq_no IS NOT INITIAL.
      lv_msg = 'X'.
*            CONCATENATE 'RFQ created ' lv_rfq_no 'with reference PR' wa_eban1-banfn  INTO DATA(lv_msgs)
*                       SEPARATED BY space.
*            MESSAGE  lv_msgs TYPE 'I'.
      MESSAGE |RFQ created { lv_rfq_no } with reference PR { wa_eban1-banfn }| TYPE 'I'.
    ENDIF.
    lv_success = 'X'.
  ENDIF.
*    REFRESH:gt_messages,gt_bdc.
*  ENDLOOP.
*  ELSE.

*  ENDIF.
  IF lv_success IS NOT INITIAL.
    WAIT UP TO '0.2' SECONDS.
    READ TABLE  lt_ekko INDEX 1.
    lv_db_table = 'ekko'.
    SELECT SINGLE bukrs  FROM (lv_db_table) INTO wa_hd-bukrs WHERE ebeln = lt_ekko-ebeln.
    lv_db_table = 't024'.
    SELECT SINGLE smtp_addr FROM (lv_db_table) INTO @l_buyer WHERE ekgrp = @wa_eban1-ekgrp.
    wa_hd-docid = lv_submi.
    wa_hd-banfn = wa_eban1-banfn.
    wa_hd-ebdat = gv_qdate.
    wa_hd-doctype = 'S1_RFQ'.
    wa_hd-qa_dtime = gv_dtime.
    wa_hd-req_email = l_buyer.
    wa_hd-ebeln = lv_ebeln.
*       if wa_hd-BUKRS is INITIAL.
*       wa_hd-BUKRS = wa_eban1-bukrs.
*       endif.
    wa_hd-ekgrp = wa_eban1-ekgrp.
    wa_hd-ekorg = wa_eban1-ekorg.
    wa_hd-cr_date = sy-datum.
    wa_hd-cr_time = sy-uzeit.
    wa_hd-qa_ddate = qa_ddate.
    wa_hd-ebdat  = gv_qdate.
    wa_hd-waers  = 'USD'.
    wa_hd-rfx_private = gv_private.
    wa_hd-rfx_qmode  = gv_qmode.
    wa_hd-rfx_type = 'RFQ'.
    wa_hd-rfq_title = gv_title.
    IF lt_ekko[] IS NOT INITIAL.
      lv_db_table = 'ekpo'.
      SELECT * FROM (lv_db_table) INTO TABLE @lt_ekpo FOR ALL ENTRIES IN @lt_ekko WHERE ebeln = @lt_ekko-ebeln.

      LOOP AT lt_ekpo INTO DATA(wa_ekpo).
        lv_db_table = 'eket'.
        SELECT SINGLE eindt FROM (lv_db_table) INTO wa_ln-eindt WHERE ebeln = wa_ekpo-ebeln AND ebelp = wa_ekpo-ebelp.
        READ TABLE  lt_ekko WITH KEY ebeln = wa_ekpo-ebeln.

        lv_lno = lv_lno + 1.
        wa_ln-line_no = lv_lno.
        wa_ln-docid   = lv_submi.
        wa_ln-matnr   = wa_ekpo-matnr.
        wa_ln-txz01   = wa_ekpo-txz01.
        wa_ln-bamng   = wa_ekpo-ktmng.
        wa_ln-peinh   = wa_ekpo-peinh.
        wa_ln-lgort   = wa_ekpo-lgort.
        wa_ln-uom     = wa_ekpo-meins.
        wa_ln-matkl   = wa_ekpo-matkl.
        wa_ln-werks   = wa_ekpo-werks.
*        wa_ln-kostl   = wa_ekpo-kostl.
        wa_ln-netpr   = wa_ekpo-netpr.
        wa_ln-netwr   = wa_ekpo-netwr.
        wa_ln-mtart   = wa_ekpo-mtart.
        wa_ln-lifnr   = lt_ekko-lifnr.
        wa_ln-ebelp   = wa_ekpo-ebelp.
        wa_ln-ebelN   = wa_ekpo-ebelN.
        wa_ln-banfn   = wa_eban1-banfn.
        wa_ln-waers   = 'USD'.
        APPEND wa_ln TO gt_ln.
        CLEAR wa_ln.
      ENDLOOP.
    ENDIF.
    IF wa_hd IS NOT INITIAL.
      lv_db_table = '/sdocs/s1_buy_hd'.
      MODIFY (lv_db_table) FROM wa_hd.
    ENDIF.
    IF gt_ln IS NOT INITIAL.
      lv_db_table = '/sdocs/s1_buy_ln'.
      MODIFY (lv_db_table) FROM TABLE gt_ln.
    ENDIF.
    COMMIT WORK AND WAIT.
    WAIT UP TO '0.2' SECONDS.
    IF wa_hd IS NOT INITIAL.
      wa_hd-docid  = lv_ebeln.
      wa_hd-doctype  = 'S1_RFX'.
      wa_hd-coll_num = lv_submi.
      lv_db_table = '/sdocs/s1_buy_hd'.
      MODIFY (lv_db_table) FROM wa_hd.
    ENDIF.
    LOOP AT gt_ln INTO wa_ln.
      l_index  = l_index + 1.
      wa_ln-docid = wa_hd-docid.
      MODIFY gt_ln FROM wa_ln INDEX l_index TRANSPORTING docid.
    ENDLOOP.
    COMMIT WORK AND WAIT.
    WAIT UP TO '0.2' SECONDS.
    SUBMIT /sdocs/s1_rfq_data_dispatch USING SELECTION-SET 'TEST' AND RETURN.
  ENDIF.

*  IF lv_submi IS NOT INITIAL.
  SELECT SINGLE config_value INTO lv_param FROM /sdocs/sspy_sgc WHERE config = 'BUYER_HOMEPAGE_LOGINURL'.
  CONCATENATE 'Your RFQ is now dispatched to Vendor Portal - ' lv_submi INTO  gv_rfq_screen SEPARATED BY space.
  CONCATENATE 'Click on below to open it on Vendor Portal' ' ' INTO gv_rfq_screen1 .
  CONCATENATE lv_param lv_submi INTO lv_param.
  PERFORM call_msg_screen.

*  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_gi
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_ROWS
*&      --> GT_EBAN
*&---------------------------------------------------------------------*
FORM create_gi  TABLES   pgt_rows LIKE  gt_rows
                         pgt_eban STRUCTURE wa_final."wa_EBAN.
  DATA:lv_line TYPE sy-tabix.
  REFRESH:gt_goodsmvt_item[],gt_return[].
  CLEAR:g_goodsmvt_header,g_goodsmvt_code,gv_goodsmvt_headret,gv_materialdocument,gv_matdocumentyear,lv_line.
  g_goodsmvt_header-pstng_date = sy-datum.
  g_goodsmvt_header-doc_date   = sy-datum.
  g_goodsmvt_code-gm_code = '03'.

  CONCATENATE 'Ref_' sy-datum INTO g_goodsmvt_header-header_txt.
*  g_goodsmvt_header-header_txt = ' '.

  LOOP AT pgt_rows INTO DATA(wa_rows).
    CLEAR:wa_eban1.
    READ TABLE pgt_eban INTO wa_eban1 INDEX wa_rows-index.
    IF sy-subrc EQ 0.
      lv_line = lv_line + 1.
      CLEAR wa_eban1-matnr.
      lv_db_table = 'eban'.
      SELECT SINGLE matnr FROM (lv_db_table) INTO wa_eban1-matnr WHERE banfn = wa_eban1-banfn AND bnfpo = wa_eban1-bnfpo.
      gt_goodsmvt_item-material  = wa_eban1-matnr.
      gt_goodsmvt_item-plant      = wa_eban1-werks.
      gt_goodsmvt_item-stge_loc   = wa_eban1-lgort.
      gt_goodsmvt_item-move_type  = '201'.
*     IF wa_eban1-kostl IS INITIAL.
      wa_eban1-kostl = 'ADMIN'.
*     ENDIF.

      IF wa_eban1-kostl IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = wa_eban1-kostl
          IMPORTING
            output = wa_eban1-kostl.
      ENDIF.
      gt_goodsmvt_item-costcenter = wa_eban1-kostl.
      gt_goodsmvt_item-line_id    = lv_line.
      gt_goodsmvt_item-quantity   = wa_eban1-menge.
      gt_goodsmvt_item-entry_qnt  = wa_eban1-menge.
      gt_goodsmvt_item-mvt_ind    = ''.
      APPEND gt_goodsmvt_item TO gt_goodsmvt_item[].
      CLEAR:gt_goodsmvt_item,wa_eban1.

    ENDIF.

  ENDLOOP.

  IF gt_goodsmvt_item[] IS NOT INITIAL.
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = g_goodsmvt_header
        goodsmvt_code    = g_goodsmvt_code
      IMPORTING
        goodsmvt_headret = gv_goodsmvt_headret
        materialdocument = gv_materialdocument
        matdocumentyear  = gv_matdocumentyear
      TABLES
        goodsmvt_item    = gt_goodsmvt_item[]
        return           = gt_return[].

    IF gv_goodsmvt_headret-mat_doc IS NOT INITIAL AND gv_goodsmvt_headret-doc_year IS NOT INITIAL.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      CONCATENATE  'Goods issue created with' gv_goodsmvt_headret-mat_doc INTO DATA(lv_msg) SEPARATED BY space.
      MESSAGE lv_msg TYPE 'I'.
      COMMIT WORK AND WAIT.
    ELSE.
      DATA(wa_return) = VALUE #( gt_return[ type = 'E' ] OPTIONAL ).

      MESSAGE wa_return-message TYPE 'I'.

    ENDIF.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_vndr_COUNT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_EBAN1_LIFNR
*&      --> P_
*&      <-- LV_CNT
*&---------------------------------------------------------------------*
FORM GET_vndr_COUNT USING p_lifnr p_doctype CHANGING p_cnt.
  DATA(lt_eban) = GT_final[].
  DELETE lt_eban WHERE doctype <> p_doctype.
  DELETE lt_eban WHERE lifnr <> p_lifnr.
  DESCRIBE TABLE lt_eban LINES p_cnt.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_VNDR_TREE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROOT_NODE
*&      --> LV_LIFNR
*&---------------------------------------------------------------------*
FORM get_vndr_tree_data  USING    p_root_node
                                  p_lv_lifnr.
  DATA l_lifnr TYPE lfa1-lifnr.
  REFRESH gt_final .
  l_lifnr = p_lv_lifnr.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = l_lifnr
    IMPORTING
      output = l_lifnr.

  LOOP AT GT_EBAN_save INTO DATA(wa_eban_save) WHERE doctype = p_root_node  AND lifnr = l_lifnr.
    APPEND wa_eban_save TO gt_final.
    CLEAR wa_eban_save.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_po_from_rfq
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> L_EBAN_RFQ_NO
*&---------------------------------------------------------------------*
FORM create_po_from_rfq  USING    p_banfn p_lifnr p_ekgrp p_ekorg P_success p_ebeln.
*  DATA:lv_date      TYPE char10,
*       lv_fld(20)   TYPE c,
*       lv_tabix(5)  TYPE c,
*       lv_tabix1(2) TYPE n.
*  REFRESH:gt_messages,gt_bdc.
*  WRITE :sy-datum TO lv_date.
*  IF p_lifnr IS INITIAL.
*    p_lifnr  = '0000001801'.
*  ENDIF.
*  lv_db_table = 'eban'.
*  SELECT banfn,bnfpo FROM (lv_db_table) INTO TABLE @lt_eabn WHERE banfn = @p_banfn AND ebeln = ' ' AND ebelp = ' '.
*  SORT lt_eabn BY banfn ASCENDING bnfpo ASCENDING.
*  DESCRIBE TABLE lt_eabn LINES lv_count.
*  PERFORM fill_bdc_screen TABLES gt_bdc USING : 'SAPMM06E' '0100'.
*  p_lifnr  = |{ p_lifnr  ALPHA = OUT }|.
*  PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_OKCODE' '=BS',
*                           'EKKO-LIFNR' p_lifnr ,
*                               'RM06E-BSART' 'NB',
*                               'RM06E-BEDAT' lv_date,
*                           'EKKO-EKORG' p_ekorg,
*                           'EKKO-EKGRP' p_ekgrp,
*                           'RM06E-LPEIN'  'T'.
*
*
*  PERFORM fill_bdc_screen TABLES gt_bdc USING : 'SAPMM06E' '0501'.
*
*  PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_OKCODE' '=ENTE',
*                           'EKET-BANFN' p_banfn .
*
*
**  PERFORM fill_bdc_screen TABLES gt_bdc USING : 'SAPMM06E' '0510'.
**
**  PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_OKCODE' '=NB'.
*
*
**  PERFORM fill_bdc_screen  TABLES gt_bdc USING : 'SAPMM06E' '0125'.
*
**  PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_OKCODE' '=MALL'.  "add dynamic value
*
*  PERFORM fill_bdc_screen  TABLES gt_bdc USING : 'SAPMM06E' '0125'.
*
*  PERFORM fill_bdc_value TABLES gt_bdc  USING : 'BDC_OKCODE' '=REFH'.
*
*  LOOP AT gt_eban1 INTO DATA(ls_eban).
*    READ TABLE lt_eabn INTO DATA(l_eabn) WITH KEY banfn = ls_eban-banfn bnfpo = ls_eban-bnfpo.
*    lv_tabix = sy-tabix.
*    lv_tabix1 = lv_tabix.
*    CONCATENATE  'RM06E-TCSELFLAG(' lv_tabix1  ')' INTO lv_fld.
*    PERFORM fill_bdc_value TABLES gt_bdc USING : lv_fld 'X'.
*    CLEAR:lv_tabix,ls_eban,l_eabn.
*  ENDLOOP.
*
*  DO lv_count TIMES.
*    PERFORM fill_bdc_screen TABLES gt_bdc USING : 'SAPMM06E' '0111'.  " based on line item we will do again and again
*
*    PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_OKCODE' '/00',
*                                                 'EKPO-REPOS' 'X',
*                                                    'EKPO-WEBRE' 'X'.. ""
*  ENDDO.
*
*
**  PERFORM fill_bdc_screen  TABLES gt_bdc USING : 'SAPMM06E' '0120'.
**
**  PERFORM fill_bdc_value TABLES gt_bdc USING : 'BDC_OKCODE' '=BU'.
*
*
*
*  wa_options-dismode = 'E'.
*  wa_options-updmode = 'S'.
*  wa_options-racommit = abap_true.
*  wa_options-nobinpt = abap_true.
*
*    AUTHORITY-CHECK OBJECT 'M_BEST_EKO'
*      ID 'ACTVT' FIELD '01'        " 01 = Create
*      ID 'EKORG' FIELD wa_final-ekorg.
*
*  IF sy-subrc = 0.
*    CALL TRANSACTION 'ME21' USING gt_bdc OPTIONS FROM wa_options MESSAGES INTO gt_messages.
*  ELSE.
*    MESSAGE |No authorization to create PO in Purchasing Org for Transaction ME21| TYPE 'E'.
*  ENDIF.
*
*
*
*  READ TABLE gt_messages INTO DATA(wa_mess) WITH KEY msgtyp = 'S' msgnr = '017' .
*  IF sy-subrc = 0.
**    MESSAGE |PO is created with { wa_mess-msgv2 }  using PR { p_banfn }| TYPE 'S'.
**   UPDATE /SDOCS/S1_BUY_HD SET RFQ_NO = wa_mess-msgv2 WHERE DOCID = P_DOCID.
*    P_success  = 'X'.
*    p_ebeln = wa_mess-msgv2.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PLANT_COUNT_RFQ
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_EBAN1_EKORG
*&      --> WA_EBAN2_WERKS
*&      --> P_
*&      <-- LV_CNT
*&---------------------------------------------------------------------*
FORM get_plant_count_rfq   USING    p_ekorg
                               p_werks p_doctype
                      CHANGING p_cnt.

  DATA(lt_eban) = gt_final[].
  DELETE lt_eban WHERE ekorg <> p_ekorg.
  DELETE lt_eban WHERE werks <> p_werks.
  DELETE lt_eban WHERE doctype <> p_doctype.
  DESCRIBE TABLE lt_eban LINES p_cnt.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form total_purch_org
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_EBAN1_EKORG
*&      <-- LV_CNT
*&      <-- PERFORM
*&      <-- ADD_NODE
*&      --> GT_TREEB
*&      --> STR3
*&      --> STR1
*&      --> P_ISFOLDER
*&      --> LV_EKORG
*&      --> P_EXPANDER
*&---------------------------------------------------------------------*
FORM total_purch_org  USING    p_ekorg
                      CHANGING p_lv_cnt.
  DATA(lt_final) = gt_final.
  DELETE  lt_final WHERE doctype <> ''.
  DELETE  lt_final WHERE ekorg <> p_ekorg.
  DESCRIBE TABLE  lt_final LINES  p_lv_cnt.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form total_sbuy_purch_org
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_EBAN1_EKORG
*&      <-- LV_CNT
*&---------------------------------------------------------------------*
FORM total_sbuy_purch_org  USING    p_ekorg
                           CHANGING p_lv_cnt.
  DATA(lt_final) = gt_final.
  DELETE  lt_final WHERE doctype <> 'S1_PR'.
  DELETE  lt_final WHERE ekorg <> p_ekorg.
  DESCRIBE TABLE  lt_final LINES  p_lv_cnt.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form total_purch_org_plant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_EBAN1_EKORG
*&      --> WA_EBAN2_WERKS
*&      <-- LV_CNT
*&---------------------------------------------------------------------*
FORM total_purch_org_plant  USING    p_ekorg
                                     p_werks
                            CHANGING p_lv_cnt.
  DATA(lt_final) = gt_final.
  DELETE  lt_final WHERE doctype <> ' '.
  DELETE  lt_final WHERE ekorg <> p_ekorg.
  DELETE  lt_final WHERE werks <> p_werks.
  DESCRIBE TABLE  lt_final LINES  p_lv_cnt.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form total_purch_org_plant_spr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_EBAN1_EKORG
*&      --> WA_EBAN2_WERKS
*&      <-- LV_CNT
*&---------------------------------------------------------------------*
FORM total_purch_org_plant_spr  USING    p_ekorg
                                         p_werks
                                CHANGING p_lv_cnt.
  DATA(lt_final) = gt_final.
  DELETE  lt_final WHERE doctype <> 'S1_PR'.
  DELETE  lt_final WHERE ekorg <> p_ekorg.
  DELETE  lt_final WHERE werks <> p_werks.
  DESCRIBE TABLE  lt_final LINES  p_lv_cnt.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form total_sbuy_AWARD_RFQS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_EBAN1_EKORG
*&      <-- LV_CNT
*&---------------------------------------------------------------------*
FORM total_sbuy_AWARD_RFQS  USING    p_ekorg
                           CHANGING p_lv_cnt.
  DATA(lt_final) = gt_final.
  DELETE  lt_final WHERE doctype <> 'S1_RFQ'.
  DELETE  lt_final WHERE rfx_award = ' '.
  DELETE  lt_final WHERE ekorg <> p_ekorg.
  DESCRIBE TABLE  lt_final LINES  p_lv_cnt.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form total_sbuy_inprocess_RFQS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_EBAN1_EKORG
*&      <-- LV_CNT
*&---------------------------------------------------------------------*
FORM total_sbuy_inprocess_RFQS  USING    p_ekorg
                           CHANGING p_lv_cnt.
  DATA(lt_final) = gt_final.
  DELETE  lt_final WHERE doctype <> 'S1_RFQ'.
  DELETE  lt_final WHERE rfx_award <> ' '.
  DELETE  lt_final WHERE ekorg <> p_ekorg.
  DESCRIBE TABLE  lt_final LINES  p_lv_cnt.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_gir
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_ROWS
*&      --> GT_FINAL
*&---------------------------------------------------------------------*
FORM create_gir  TABLES   pgt_rows LIKE  gt_rows
                          pgt_eban STRUCTURE wa_final."wa_EBAN.
  DATA:wa_hd   TYPE /sdocs/s1_buy_hd,
       lv_lno  TYPE numc5,
       l_docid TYPE /sdocs/s1_buy_hd-docid,
       gt_bln  TYPE TABLE OF /sdocs/s1_buy_ln.
  REFRESH:gt_bln.
  CLEAR:l_docid,wa_hd,Lv_lno.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '02'
      object                  = '/SDOCS/S1D'
    IMPORTING
      number                  = l_docid
*     RETURNCODE              = ld_error
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7.

  LOOP AT pgt_rows INTO DATA(wa_rows).
    CLEAR:wa_eban1.
    READ TABLE pgt_eban INTO wa_eban1 INDEX wa_rows-index.
    IF sy-subrc EQ 0 AND wa_hd IS INITIAL.
      lv_db_table = 't024'.
      SELECT  SINGLE smtp_addr FROM (lv_db_table) INTO wa_hd-req_email WHERE ekgrp = wa_eban1-ekgrp.
      wa_hd-docid = l_docid.
      wa_hd-banfn = wa_eban1-banfn.
      wa_hd-ebdat = gv_qdate.
      wa_hd-bukrs = '3001'.
      wa_hd-doctype = 'S1_PRR'.
      wa_hd-qa_dtime = gv_dtime.
      wa_hd-ekgrp = wa_eban1-ekgrp.
      wa_hd-ekorg = wa_eban1-ekorg.
      wa_hd-cr_date = sy-datum.
      wa_hd-cr_time = sy-uzeit.
      wa_hd-qa_ddate = qa_ddate.
      wa_hd-ebdat  = gv_qdate.
      wa_hd-rfx_private = gv_private.
      wa_hd-rfx_qmode  = gv_qmode.
      wa_hd-rfx_type = 'RFQ'.
      wa_hd-rfq_title = gv_title.
      wa_hd-lifnr = wa_eban1-lifnr.
      wa_hd-bsart  = 'NB'.
      wa_hd-waers  = 'USD'.
    ENDIF.

    lv_lno = lv_lno + 1.
    wa_ln-line_no = lv_lno.
    wa_ln-docid   = l_docid.
    wa_ln-matnr   = wa_eban1-matnr.
*        wa_ln-txz01   = wa_ekpo-txz01.
    wa_ln-bamng   = wa_eban1-menge.
    wa_ln-peinh   = wa_eban1-peinh.
    wa_ln-lgort   = wa_eban1-lgort.
    wa_ln-uom     = wa_eban1-meins.
    wa_ln-matkl   = wa_eban1-matkl.
    wa_ln-werks   = wa_eban1-werks.
    wa_ln-kostl   = wa_eban1-kostl.
    wa_ln-netpr   = wa_eban1-preis.
    wa_ln-netwr   = wa_eban1-preis * wa_ln-bamng.
*        wa_ln-mtart   = wa_eban1-mtart.
    wa_ln-kostl = 'ADMIN'.
    wa_ln-waers  = 'USD'.
    wa_ln-lifnr   = wa_eban1-lifnr.
    wa_ln-banfn   = wa_eban1-banfn.
    wa_ln-ebeln   = wa_eban1-banfn.
    wa_ln-ebelp   = wa_eban1-bNFPO.
    APPEND wa_ln TO gt_bln.
    CLEAR wa_ln.

  ENDLOOP.

  IF wa_hd IS NOT INITIAL.
    lv_db_table = '/sdocs/s1_buy_hd'.
    MODIFY (lv_db_table) FROM wa_hd.
  ENDIF.
  IF gt_bln IS NOT INITIAL.
    lv_db_table = '/sdocs/s1_buy_ln'.
    MODIFY (lv_db_table) FROM TABLE gt_bln.
  ENDIF.

  COMMIT WORK AND WAIT.
  data(lv_fm) = '/SDOCS/S1_POR_CREATE'.
  CALL FUNCTION lv_fm
    EXPORTING
      i_docid      = wa_hd-docid
      i_proc       = 'G'
    TABLES
      gt_por_items = gt_bln.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0103  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0103 INPUT.
  CASE sy-ucomm.
    WHEN 'CONT' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'RFQL'.
      DATA:lv_appl TYPE string.

      CLEAR:lv_appl.
      SELECT SINGLE config_value INTO lv_appl FROM /sdocs/sspy_sgc WHERE config = 'BROWSER_EXTESTION_NAME'.
      IF lv_appl IS INITIAL.
        lv_appl  = 'msedge.exe'.
      ENDIF.
      cl_gui_frontend_services=>execute(
    EXPORTING
      application = lv_appl "'chrome.exe' "msedge.exe
      parameter   = lv_param"'/new-window https://google.com'
    EXCEPTIONS
      OTHERS      = 1 ).
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form call_msg_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_RFQ_SCREEN
*&      --> GV_RFQ_SCREEN1
*&      --> LV_PARAM
*&---------------------------------------------------------------------*
FORM call_msg_screen.

  CALL SCREEN '103' STARTING AT 50 5 ENDING AT 100 8.

ENDFORM.
