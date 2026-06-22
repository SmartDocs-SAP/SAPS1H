*&---------------------------------------------------------------------*
*& Report  /SDOCS/S1_SOURCING_COCKPIT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT /sdocs/s1_sourcing_cockpit.
TABLES:eban,lfa1.
*INCLUDE <cntn01>.
TYPES:BEGIN OF fs_eban,
        banfn TYPE banfn, "PR
        bnfpo TYPE bnfpo, "PR Item
        matnr TYPE matnr, "Material
        menge TYPE menge_d, " Quantity
        meins TYPE meins,   "UOM
        lfdat TYPE eindt,   "Delivery date
        preis TYPE eban-preis,
        peinh TYPE eban-peinh,
        matkl TYPE matkl,   "Material group
        werks TYPE werks_d,  "Plant
        lgort TYPE lgort_d,  "Storage location
        ekgrp TYPE ekgrp,    "purchase group
        afnam TYPE eban-afnam, "Requisitioner
        bednr TYPE eban-bednr, "Tracking
        lifnr TYPE eban-lifnr, "Desired vendor
        flief TYPE eban-flief, "Fixed vendor
        ekorg TYPE eban-ekorg, "purchase group
        maktx TYPE makt-maktx,
        kostl TYPE csks-kostl,
      END OF fs_eban.

TYPES:BEGIN OF ty_final,
        banfn      TYPE banfn, "PR
        bnfpo      TYPE bnfpo, "PR Item
        matnr      TYPE matnr, "Material
        menge      TYPE menge_d, " Quantity
        meins      TYPE meins,   "UOM
        lfdat      TYPE eindt,   "Delivery date
        preis      TYPE eban-preis,
        peinh      TYPE eban-peinh,
        matkl      TYPE matkl,   "Material group
        werks      TYPE werks_d,  "Plant
        lgort      TYPE lgort_d,  "Storage location
        ekgrp      TYPE ekgrp,    "purchase group
        afnam      TYPE eban-afnam, "Requisitioner
        bednr      TYPE eban-bednr, "Tracking
        lifnr      TYPE eban-lifnr, "Desired vendor
        flief      TYPE eban-flief, "Fixed vendor
        ekorg      TYPE eban-ekorg, "purchase group
        maktx      TYPE makt-maktx,
        status     TYPE char50,
        doctype    TYPE /sdocs/s1_buy_hd-doctype,
        rfq_no     TYPE ebeln,
        docid      TYPE /sdocs/s1_buy_hd-docid,
        rfx_award  TYPE c,
        psuccess,
        private,
        buyer(100) TYPE c,
        ebeln      TYPE ebeln,
        ddate      TYPE sy-datum,
        qadate     TYPE sy-datum,
        name1      TYPE lfa1-name1,
        qmode,
        title(50)  TYPE c,
        contract   TYPE ebeln,
        po         TYPE ebeln,
        gi_docid   TYPE /sdocs/s1_buy_hd-docid,
        pr_rfx     TYPE /sdocs/s1_buy_hd-docid,
        sap_gi     TYPE mblnr,
        sbuydocid  TYPE /sdocs/s1_buy_hd-docid,
        bukrs      TYPE bukrs,
      END OF ty_final.
TYPES: BEGIN OF fs_t001w,
         werks TYPE t001w-werks,
         name1 TYPE t001w-name1,
         adrnr TYPE t001w-adrnr,
       END OF fs_t001w.

DATA:BEGIN OF lt_lfa1 OCCURS 0 ,
       lifnr TYPE lfa1-lifnr,
       name1 TYPE lfa1-name1,
     END OF lt_lfa1.

DATA:gt_eban          TYPE TABLE OF fs_eban,
     gt_final         TYPE TABLE OF ty_final,
     gt_t001w         TYPE TABLE OF fs_t001w,
     gt_eban_save     TYPE TABLE OF ty_final,
     gt_goodsmvt_item TYPE TABLE OF bapi2017_gm_item_create WITH HEADER LINE,
     gt_return        TYPE TABLE OF bapiret2,
     gs_return        TYPE bapiret2,
     wa_t001w         TYPE fs_t001w,
     wa_eban          TYPE fs_eban,
     wa_final         TYPE ty_final,
     wa_eban1         TYPE fs_eban.
DATA:ok_code      TYPE sy-ucomm,
     ok_code_save TYPE sy-ucomm.
DATA:gv_lifnr            TYPE lifnr,
     gv_ddate            TYPE sy-datum,
     gv_dtime            TYPE sy-uzeit,
     gv_qmode,
     qa_ddate            TYPE sy-datum,
     gv_qdate            TYPE sy-datum,
     gv_rfq_screen(100)  TYPE c,
     gv_rfq_screen1(100) TYPE c,
     lv_ebeln            TYPE ebeln,
     lv_angdt            TYPE angdt,
     lv_param            TYPE string.
RANGES:s1_lifnr FOR lfa1-lifnr.
DATA:
* Reference Variable for Docking Container
  r_dock_container TYPE REF TO cl_gui_docking_container,
  go_splitter      TYPE REF TO cl_gui_splitter_container,
  go_cell_left     TYPE REF TO cl_gui_container,
  go_cell_right    TYPE REF TO cl_gui_container,
* Reference Variable for alv grid
  r_grid           TYPE REF TO cl_gui_alv_grid,
  g_layout         TYPE lvc_s_layo.
DATA:g_title    TYPE char50,
     g_tit_cnt  TYPE sy-tabix,
     gc_tit_cnt TYPE char15,
     gt_fcat    TYPE lvc_t_fcat,
     g_variant  TYPE disvariant,
     g_repid    TYPE sy-repid.

DATA: gt_split TYPE REF TO cl_gui_splitter_container,
      gt_cust  TYPE REF TO cl_gui_custom_container,
      ref_alv1 TYPE REF TO cl_gui_alv_grid,
      gt_gridb TYPE REF TO cl_gui_alv_grid,
      gt_cont  TYPE REF TO cl_gui_container,
      gt_eban1 TYPE TABLE OF ty_final, "fs_eban,
      gt_cont2 TYPE REF TO cl_gui_container.
DATA:gt_full_bcust TYPE REF TO cl_gui_custom_container,
     se_full_bcust TYPE REF TO cl_gui_custom_container,
     gt_full_bgrid TYPE REF TO cl_gui_alv_grid,
     se_full_bgrid TYPE REF TO cl_gui_alv_grid.

DATA: gt_treeb  TYPE REF TO cl_simple_tree_model.
DATA: g_row  TYPE lvc_s_roid.
DATA: gt_rows TYPE lvc_t_row .
TYPES: BEGIN OF ty_eket,
         ebeln TYPE eket-ebeln,
         ebelp TYPE eket-ebelp,
         banfn TYPE eket-banfn,
         bnfpo TYPE eket-bnfpo,
       END OF ty_eket.
DATA : lt_eket TYPE TABLE OF ty_eket.
TYPES : BEGIN OF ty_makt,
          matnr TYPE makt-matnr,
          maktx TYPE makt-maktx,
        END OF ty_makt.
DATA : lt_makt TYPE TABLE OF ty_makt.
DATA : lt_bhd   TYPE STANDARD TABLE OF /sdocs/s1_buy_hd,
        wa_bhd type /sdocs/s1_buy_hd,
       lt_ln    TYPE STANDARD TABLE OF /sdocs/s1_buy_ln,
       lt_gdata TYPE STANDARD TABLE OF /sdocs/s1_buy_ln.
DATA : l_gidocid TYPE /sdocs/s1_buy_ln-docid.
TYPES : BEGIN OF ty_gi,
          docid      TYPE /sdocs/s1_buy_hd-docid,
          gi_no      TYPE /sdocs/s1_buy_hd-gi_no,
          prr_ref_id TYPE /sdocs/s1_buy_hd-prr_ref_id,
        END OF ty_gi.
DATA:lt_gi TYPE STANDARD TABLE OF ty_gi.


DATA : wa_node TYPE treemsnodt.
DATA : wa1_node TYPE treemsnodt.
DATA : p_root     TYPE tm_nodekey,
       p_isfolder TYPE flag,
       p_expander TYPE flag.
DATA: str    TYPE string,
      str1   TYPE string,
      str2   TYPE string,
      str3   TYPE string,
      str4   TYPE string,
      str5   TYPE string,
      str6   TYPE string,
      str7   TYPE string,
      str8   TYPE string,
      str9   TYPE string,
      str31  TYPE string,
      str41  TYPE string,
      str51  TYPE string,
      grr    TYPE string,
      gir    TYPE string,
      str71  TYPE string,
      str711 TYPE string,
      str722 TYPE string.
DATA:gt_rnode TYPE treemnotab,
     wa_rnode TYPE LINE OF treemnotab.
TYPES pict_line(256) TYPE c.
DATA :init,
      container TYPE REF TO cl_gui_custom_container,
      editor    TYPE REF TO cl_gui_textedit,
      picture   TYPE REF TO cl_gui_picture,
      pict_tab  TYPE TABLE OF pict_line,
      url(255)  TYPE c.
CONSTANTS: cntl_true  TYPE i VALUE 1,
           cntl_false TYPE i VALUE 0.
DATA: graphic_url(255),
      graphic_refresh(1),
      g_result LIKE cntl_true.

DATA: BEGIN OF graphic_table OCCURS 0,
        line(255) TYPE x,
      END OF graphic_table.

DATA: graphic_size   TYPE i.
DATA: l_graphic_xstr TYPE xstring,
      l_graphic_conv TYPE i,
      l_graphic_offs TYPE i.
DATA:gv_node.
DATA:gv_bukrs TYPE bukrs.
DATA:g_node_key TYPE tv_nodekey.
DATA:root_node   TYPE tm_nodekey,
     more_key    TYPE string,
     gv_node_key TYPE tm_nodekey.
DATA:gv_private,
     gv_public.
DATA:gv_node_event TYPE c.
DATA:gv_nkey TYPE tm_nodekey.
DATA:gv_werks TYPE werks_d.
DATA:gv_ekorg TYPE ekorg.
DATA:it_toolbar TYPE stb_button.
DATA : gt_no TYPE lvc_t_roid.
DATA wa_options  TYPE ctu_params.
DATA :gt_bdc      TYPE STANDARD TABLE OF bdcdata INITIAL SIZE 1,
      wa_bdc      TYPE bdcdata,
      gt_messages TYPE STANDARD TABLE OF bdcmsgcoll INITIAL SIZE 1,
      wa_msgs     TYPE bdcmsgcoll.
DATA:r_ebeln TYPE ekko-ebeln.
DATA:wa_hd     TYPE /sdocs/s1_buy_hd,
     wa_ln     TYPE /sdocs/s1_buy_ln,
     gt_ln     TYPE TABLE OF /sdocs/s1_buy_ln,
     l_doctype TYPE /sdocs/s1_buy_hd-doctype,
     l_docid   TYPE /sdocs/s1_buy_hd-docid.
TYPES : BEGIN OF ty_banfn,
          banfn TYPE eban-banfn,
          bnfpo TYPE eban-banfn,
        END OF ty_banfn.
DATA: lt_banfn TYPE TABLE OF ty_banfn.
DATA : lv_submi TYPE ekko-submi.
DATA : l_buyer TYPE t024-smtp_addr,
       lt_ekpo TYPE STANDARD TABLE OF ekpo.
TYPES : BEGIN OF ty_eabn,
          banfn TYPE eban-banfn,
          bnfpo TYPE eban-bnfpo,
        END OF ty_eabn.
DATA : lt_eabn TYPE TABLE OF ty_eabn.
DATA : lv_count TYPE i,
       lv_qua   TYPE char20,
       lv_lifnr TYPE lfa1-lifnr,
       gv_title TYPE char50.
DATA: gv_goodsmvt_headret LIKE  bapi2017_gm_head_ret,
      gv_materialdocument TYPE  bapi2017_gm_head_ret-mat_doc,
      gv_matdocumentyear  TYPE  bapi2017_gm_head_ret-doc_year,
      g_goodsmvt_header   TYPE bapi2017_gm_head_01,
      lv_db_table         TYPE string,
      g_goodsmvt_code     TYPE bapi2017_gm_code.

SELECT-OPTIONS:s_banfn FOR eban-banfn,
               s_cdate FOR eban-erdat DEFAULT sy-datum,
               s_ebeln FOR r_ebeln,
               s_crdat FOR sy-datum DEFAULT sy-datum,
               s_egrp  FOR eban-ekorg,
               s_mat   FOR eban-matnr,
               s_matg  FOR eban-matkl,
               s_werks FOR eban-werks,
               s_afnam FOR eban-afnam.


SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN POSITION 1.
    SELECTION-SCREEN COMMENT 1(15) TEXT-001.
    SELECT-OPTIONS :s_lifnr FOR lv_lifnr NO INTERVALS.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF SCREEN 102 .
PARAMETERS:p_rel TYPE c AS CHECKBOX DEFAULT 'X'.


*----------------------------------------------------------------------*
*       CLASS lcl_event_grid DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_grid DEFINITION.
  PUBLIC SECTION.
    METHODS: node_dc FOR EVENT node_double_click OF cl_simple_tree_model
      IMPORTING node_key sender.
    METHODS : handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
        e_object
        e_interactive.
    METHODS : handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
        e_ucomm,
      hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no.

ENDCLASS.                    "lcl_event_grid DEFINITION
**----------------------------------------------------------------------*
**       CLASS lcl_event_grid IMPLEMENTATION
**----------------------------------------------------------------------*
**
**----------------------------------------------------------------------*
CLASS lcl_event_grid IMPLEMENTATION.
  METHOD hotspot_click.
    PERFORM event_hotspot_click USING e_row_id
                                      e_column_id.
  ENDMETHOD.                    "hotspot_click
  METHOD: node_dc.


    DATA: len TYPE i.
    DATA:l_title TYPE char50.
    DATA:lv_lifnr TYPE lfa1-lifnr.
    DATA:lv_split  TYPE char20,
         lv_split1 TYPE char20.
    DATA:g_event(30).
    DATA:lv_doctype TYPE /sdocs/sspy_hd-doctype.
    DATA: l_layout TYPE lvc_s_layo.
    DATA: l_banfn TYPE eban-banfn.
    DATA:lv_len TYPE i.
    DATA:lv_node TYPE char20.
    CLEAR gv_node_event.
    g_event = 'NODE_DOUBLE_CLICK'.
    g_node_key = node_key.
    gv_node_event = 'X'.

    CLEAR:gv_nkey,root_node,lv_split1,lv_split,lv_doctype,gv_node,gv_node_key,gv_ekorg,gv_werks,lv_len,l_title.

    CALL METHOD gt_treeb->node_get_parent
      EXPORTING
        node_key        = node_key
      IMPORTING
        parent_node_key = root_node
      EXCEPTIONS
        node_not_found  = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    gv_node_key = node_key.
    IF node_key = 'SPGR' AND root_node = 'ROOT'.
      PERFORM get_tree_data USING gv_ekorg  node_key .
      SORT gt_final BY banfn DESCENDING bnfpo DESCENDING.
      l_title = 'Purchase Requisitions'.
    ELSEIF root_node = 'SPGR'.
      gv_ekorg = node_key+4(*).
      PERFORM get_tree_data USING gv_ekorg root_node.
      SORT gt_final BY banfn DESCENDING bnfpo DESCENDING.
      l_title = 'Purchase Requisitions'.
    ELSEIF node_key = 'SBPR' AND root_node = 'ROOT'.
      PERFORM get_tree_data USING gv_ekorg node_key .
      SORT gt_final BY docid DESCENDING.
      l_title = 'SmartBuy'.
    ELSEIF root_node = 'SBPR'.
      gv_ekorg = node_key+4(*).
      PERFORM get_tree_data USING gv_ekorg  root_node .
      SORT gt_final BY docid DESCENDING.
      l_title = 'SmartBuy'.
    ELSEIF node_key = 'SRFQ' AND root_node = 'ROOT'.
      PERFORM get_tree_data USING gv_ekorg  node_key .
      SORT gt_final BY docid DESCENDING.
      l_title = 'Awarded RFQs'.
      DELETE gt_final WHERE lifnr = ' '.
    ELSEIF  root_node = 'SRFQ'.
      gv_ekorg = node_key+4(*).
      PERFORM get_tree_data USING gv_ekorg root_node .
      SORT gt_final BY docid DESCENDING.
      DELETE gt_final WHERE lifnr = ' '.
      l_title = 'Awarded RFQs'.
    ELSEIF node_key = 'ARFQ' AND root_node = 'ROOT'.
      PERFORM get_tree_data USING gv_ekorg  node_key .
      SORT gt_final BY docid DESCENDING.
      l_title = 'InProcess RFQs'.
    ELSEIF  root_node = 'ARFQ'.
      gv_ekorg = node_key+4(*).
      PERFORM get_tree_data USING gv_ekorg root_node .
      SORT gt_final BY docid DESCENDING.
      l_title = 'InProcess RFQs'.
    ENDIF.



    DESCRIBE TABLE gt_FINAL[] LINES g_tit_cnt.
    gc_tit_cnt = g_tit_cnt.
    CONDENSE gc_tit_cnt.
    CONCATENATE l_title '-' gc_tit_cnt INTO g_title SEPARATED BY space.
    g_layout-grid_title = g_title.

    CALL METHOD gt_gridb->set_frontend_layout
      EXPORTING
        is_layout = g_layout.

    IF g_variant IS NOT INITIAL.
      CALL METHOD gt_gridb->set_variant
        EXPORTING
          is_variant = g_variant
          i_save     = 'A'.
    ENDIF.

    PERFORM sourcing_field_cat USING gt_fcat.

    IF  gt_gridb IS BOUND.
      CALL METHOD gt_gridb->set_frontend_fieldcatalog
        EXPORTING
          it_fieldcatalog = gt_fcat[].
    ENDIF.
    CALL METHOD gt_gridb->refresh_table_display.


  ENDMETHOD.                    "hotspot_click

  METHOD handle_toolbar.

    CLEAR it_toolbar.
    MOVE 'REFRESH' TO it_toolbar-function.
    MOVE icon_refresh TO it_toolbar-icon.
    MOVE 'Refresh' TO it_toolbar-quickinfo.
    MOVE 'Refresh' TO it_toolbar-text.
    APPEND it_toolbar TO e_object->mt_toolbar.
    CLEAR it_toolbar.

    IF ( ( gv_node_key IS INITIAL AND root_node IS INITIAL ) OR ( gv_node_key = 'SPGR' OR root_node = 'SPGR' ) ).
      CLEAR it_toolbar.
      MOVE 'CREATE_RFQ' TO it_toolbar-function.
      MOVE icon_create TO it_toolbar-icon.
      MOVE 'Create RFQ' TO it_toolbar-quickinfo.
      MOVE 'Create RFQ' TO it_toolbar-text.
      APPEND it_toolbar TO e_object->mt_toolbar.
      CLEAR it_toolbar.

      CLEAR it_toolbar.
      MOVE 'CREATE_PO' TO it_toolbar-function.
      MOVE icon_create TO it_toolbar-icon.
      MOVE 'Create PO' TO it_toolbar-quickinfo.
      MOVE 'Create PO' TO it_toolbar-text.
      APPEND it_toolbar TO e_object->mt_toolbar.

      CLEAR it_toolbar.
      MOVE 'CREATE_GI' TO it_toolbar-function.
      MOVE icon_create TO it_toolbar-icon.
      MOVE 'GI Request' TO it_toolbar-quickinfo.
      MOVE 'GI Request' TO it_toolbar-text.
      APPEND it_toolbar TO e_object->mt_toolbar.

      CLEAR it_toolbar.
      MOVE 'MMBE' TO it_toolbar-function.
      MOVE icon_create TO it_toolbar-icon.
      MOVE 'MMBE' TO it_toolbar-quickinfo.
      MOVE 'MMBE' TO it_toolbar-text.
      APPEND it_toolbar TO e_object->mt_toolbar.


*     CLEAR it_toolbar.
*    MOVE 'CREATE_RFQ' TO it_toolbar-function.
*     MOVE icon_create TO it_toolbar-icon.
*    MOVE 'Create RFQ' TO it_toolbar-quickinfo.
*    MOVE 'Create RFQ' TO it_toolbar-text.
*    APPEND it_toolbar TO e_object->mt_toolbar.
*    CLEAR it_toolbar.
    ELSEIF gv_node_key = 'SBPR' OR root_node = 'SBPR'.

      CLEAR it_toolbar.
      MOVE 'CREATE_PR' TO it_toolbar-function.
      MOVE icon_create TO it_toolbar-icon.
      MOVE 'Create PR' TO it_toolbar-quickinfo.
      MOVE 'Create PR' TO it_toolbar-text.
      APPEND it_toolbar TO e_object->mt_toolbar.
      CLEAR it_toolbar.
    ELSEIF gv_node_key = 'SRFQ' OR root_node = 'SRFQ'.

      CLEAR it_toolbar.
      MOVE 'CREATE_PO' TO it_toolbar-function.
      MOVE icon_create TO it_toolbar-icon.
      MOVE 'Create PO' TO it_toolbar-quickinfo.
      MOVE 'Create PO' TO it_toolbar-text.
      APPEND it_toolbar TO e_object->mt_toolbar.

      CLEAR it_toolbar.
      MOVE 'CREATE_CNTR' TO it_toolbar-function.
      MOVE icon_create TO it_toolbar-icon.
      MOVE 'Create Contract' TO it_toolbar-quickinfo.
      MOVE 'Create Contract' TO it_toolbar-text.
      APPEND it_toolbar TO e_object->mt_toolbar.

    ELSE.
*     CLEAR it_toolbar.
*    MOVE 'CREATE_GI' TO it_toolbar-function.
*    MOVE icon_create TO it_toolbar-icon.
*    MOVE 'GI Request' TO it_toolbar-quickinfo.
*    MOVE 'GI Request' TO it_toolbar-text.
*    APPEND it_toolbar TO e_object->mt_toolbar.

    ENDIF.

  ENDMETHOD.


  METHOD handle_user_command.

    REFRESH gt_rows.
    TRY.
        gt_gridb->get_selected_rows(
               IMPORTING
                  et_index_rows = gt_rows
                  et_row_no     = gt_no ).
      CATCH cx_sy_ref_is_initial.
    ENDTRY.
    DATA l_banfn TYPE eban-banfn.
    DATA:l_matnr TYPE mara-matnr.
    CLEAR:gv_lifnr,wa_eban,gv_qdate,gv_ddate,l_banfn,qa_ddate,gv_qmode,gv_private,
    gv_title,gv_dtime,gv_rfq_screen,l_matnr.
    REFRESH:gt_eban1,s_lifnr.
    LOOP AT gt_rows INTO DATA(l_rows1).
      READ TABLE gt_final INTO wa_final INDEX l_rows1-index.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = wa_final-banfn
        IMPORTING
          output = wa_final-banfn.

      MODIFY gt_final FROM wa_final INDEX l_rows1-index TRANSPORTING banfn.
    ENDLOOP.
    READ TABLE gt_no INTO g_row INDEX 1.
    READ TABLE gt_final INTO wa_final INDEX g_row-row_id.
    CASE e_ucomm.

      WHEN 'CREATE_GI'.
*        PERFORM create_gi TABLES gt_rows gt_final.
        LOOP AT gt_rows INTO DATA(l_rows).
          READ TABLE gt_final INTO DATA(l_eban) INDEX l_rows-index.
          IF sy-subrc = 0.
            APPEND l_eban TO gt_eban1.
          ENDIF.
          CLEAR:l_eban,l_rows.
        ENDLOOP.
*        read table gt_eban1 INTO wa_final with key status = 'Completed'.
*        if sy-subrc = 0.
*          MESSAGE 'Please select inprocess PR data' type 'S'.
*        else.
        READ TABLE gt_eban1 INTO wa_final WITH KEY matnr = ' '.
        IF sy-subrc = 0.
          MESSAGE 'Material is required' TYPE 'S' DISPLAY LIKE 'W'.
        ELSE.
          PERFORM create_gir TABLES gt_rows gt_final.
        ENDIF.
*        endif.
      WHEN 'MMBE'.
        LOOP AT gt_rows INTO l_rows.
          READ TABLE gt_final INTO l_eban INDEX l_rows-index.
          IF sy-subrc = 0.
            IF l_matnr IS INITIAL.
              l_matnr  = l_eban-matnr.
            ENDIF.
            IF l_matnr  <> l_eban-matnr.
              DATA(l_mat)  = 'X'.
              EXIT.
            ENDIF.
          ENDIF.
        ENDLOOP.
        IF l_mat IS INITIAL.
*          SET PARAMETER ID 'MAT' FIELD l_matnr.
*          CALL TRANSACTION 'MMBE' AND SKIP FIRST SCREEN.
          lv_db_table = 'mara'.
          SELECT SINGLE matnr
                    FROM (lv_db_table)
                    INTO @l_matnr
                    WHERE matnr = @l_matnr.

          IF sy-subrc = 0.
            AUTHORITY-CHECK OBJECT 'M_MATE_WRK'
              ID 'ACTVT' FIELD '03'
              ID 'WERKS' FIELD gv_werks.

            IF sy-subrc = 0.
              SET PARAMETER ID 'MAT' FIELD l_matnr.
              CALL TRANSACTION 'MMBE' AND SKIP FIRST SCREEN.
            ELSE.
              MESSAGE 'You are not authorized to view stock for this material' TYPE 'E'.
            ENDIF.
          ELSE.
            MESSAGE 'Please select same material code' TYPE 'S'.
          ENDIF.
        ENDIF.
*      WHEN 'CREATE_PO'.
*        PERFORM create_po TABLES gt_rows gt_eban.

        WHEN 'CREATE_RFQ'.
          DATA:lt_svals  TYPE TABLE OF sval,
               wa_svals  TYPE sval,
               lv_ddate  TYPE eban-lfdat,
               lv_vendor TYPE lfa1-lifnr,
               lv_rows   TYPE i,
               lv_deld   TYPE eban-lfdat.
          CLEAR lv_rows.
          DESCRIBE TABLE gt_rows LINES lv_rows.
          IF lv_rows = 0.
            MESSAGE 'Please select at least one row.' TYPE 'S'.
          ELSE.
            LOOP AT gt_rows INTO l_rows.
              READ TABLE gt_final INTO l_eban INDEX l_rows-index.
              IF l_banfn IS  INITIAL.
                l_banfn = l_eban-banfn.
              ENDIF.
              IF l_banfn <> l_eban-banfn.
                MESSAGE 'Selected PRs should not be different' TYPE 'S' DISPLAY LIKE 'E'.
                RETURN.
              ENDIF.

            ENDLOOP.
            LOOP AT gt_rows INTO DATA(wa_rows).
              CLEAR:wa_eban1.
              READ TABLE gt_final INTO DATA(wa_final) INDEX wa_rows-index.
              IF sy-subrc EQ 0.
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = wa_final-banfn
                  IMPORTING
                    output = wa_final-banfn.

                APPEND wa_final TO gt_eban1.
              ENDIF.

            ENDLOOP.
*       read table gt_eban1 INTO wa_final with key status = 'Completed'.
*       if sy-subrc <> 0.
            CLEAR l_banfn.
            READ TABLE gt_rows INTO l_rows INDEX 1.
            READ TABLE gt_final INTO l_eban INDEX l_rows-index.

            lv_db_table = 'eket'.
            SELECT SINGLE ebeln  FROM (lv_db_table) INTO @lv_ebeln WHERE banfn = @l_eban-banfn AND bnfpo  = @l_eban-bnfpo.
            lv_db_table = 'ekko'.
            SELECT SINGLE angdt FROM (lv_db_table) INTO @lv_angdt WHERE ebeln = @lv_ebeln.
            IF sy-subrc = 0.
              gv_qdate =  lv_angdt.
            ENDIF.

            CALL SCREEN '101' STARTING AT  25 6.

            IF sy-ucomm = 'CONT'.
              lv_ddate = gv_qdate.
              lv_deld   = gv_ddate.
              PERFORM cockpit_rfq_creation TABLES gt_rows gt_final USING lv_vendor lv_ddate lv_deld." tables P_WA_EBAN .
            ENDIF.

*      else.
*      MESSAGE 'Please select Inprocess PR items only.' type 'S'.
*      endif.
          ENDIF.
        WHEN 'CREATE_PO'.
          DATA:L_success,lv_success.
          DATA:l_ebeln TYPE ekko-ebeln.
          CLEAR:lv_success,L_success,l_ebeln.
          LOOP AT gt_rows INTO l_rows.
            READ TABLE gt_final INTO l_eban INDEX l_rows-index.
            IF sy-subrc = 0.
              APPEND l_eban TO gt_eban1.
              CLEAR l_eban.
            ENDIF.
          ENDLOOP.
          SELECT SINGLE config_value INTO @DATA(l_po_bapi) FROM /sdocs/sspy_sgc
                                                  WHERE config = 'PO_CREATION_RFQ_BAPI'.

          IF  l_po_bapi = ''.
            READ TABLE  gt_eban1 INTO l_eban INDEX 1.
            IF sy-subrc = 0 AND l_eban-docid IS NOT INITIAL..
              CALL FUNCTION '/SDOCS/S1_PO_FROM_RFQ_CR'
                EXPORTING
                  i_docid   = l_eban-docid
                  i_bmod    = 'X'
                IMPORTING
                  e_success = L_success
                  e_ebeln   = l_eban-ebeln.
            ELSE.
              PERFORM create_po_from_rfq USING l_eban-banfn l_eban-lifnr l_eban-ekgrp l_eban-ekorg L_success l_eban-ebeln.
              IF lv_success IS  INITIAL.
                lv_success = l_success.
              ENDIF.
            ENDIF.
          ELSE.
            READ TABLE  gt_eban1 INTO l_eban INDEX 1.
            CALL FUNCTION '/SDOCS/S1_PO_CR_FROM_RFQ_BAPI'
              EXPORTING
                iv_docid   = l_eban-docid
                iv_rfqno   = l_eban-rfq_no
              IMPORTING
                ev_success = L_success.
            IF L_success IS NOT INITIAL.
              lv_db_table = '/sdocs/s1_buy_hd'.
              SELECT SINGLE rfq_no FROM (lv_db_table) INTO l_eban-ebeln WHERE  docid  = l_eban-docid.
            ENDIF.
          ENDIF.
          IF lv_success IS  INITIAL.
            lv_success = l_success.
          ENDIF.
          IF lv_success IS NOT INITIAL.
            SUBMIT /sdocs/sspay_po_data_dispatch USING SELECTION-SET 'TEST' AND RETURN.
            CONCATENATE 'Your Purchase Order is now dispatched to Vendor Portal - ' l_eban-ebeln INTO  gv_rfq_screen SEPARATED BY space.
            CONCATENATE 'Click on below to open it on Vendor Portal' ' ' INTO gv_rfq_screen1 .
            CONCATENATE 'https://s4-demo.smartdocs.one/#/sp/company/open-po-details/S4H/' l_eban-ebeln
            '///' INTO lv_param.
            PERFORM call_msg_screen.
          ENDIF.
*         else.
*           MESSAGE 'PO already created!' type 'S'.
*        endif.
*        else.
*        MESSAGE 'PO already created!' type 'S'.
*        endif.

        WHEN 'CREATE_PR'.
          LOOP AT gt_rows INTO l_rows.
            READ TABLE gt_final INTO l_eban INDEX l_rows-index.
            IF sy-subrc = 0.
              APPEND l_eban TO gt_eban1.
            ENDIF.
            CLEAR:l_eban,l_rows.
          ENDLOOP.
          READ TABLE gt_eban1 INTO wa_final WITH KEY status = 'Completed'.
          IF sy-subrc = 0.
            MESSAGE 'Please select inprocess data' TYPE 'S'.
          ELSE.
            LOOP AT gt_rows INTO l_rows.
              CLEAR  L_success.
              READ TABLE gt_final INTO l_eban INDEX l_rows-index.
              IF sy-subrc = 0 AND l_eban-docid IS NOT INITIAL.
                CALL FUNCTION '/SDOCS/S1_PR_CR'
                  EXPORTING
                    i_docid   = l_eban-docid
                    i_bmod    = 'X'
                  IMPORTING
                    e_success = L_success.

              ENDIF.

            ENDLOOP.
          ENDIF.
        WHEN 'CREATE_CNTR'.
          CLEAR lv_success.
          LOOP AT gt_rows INTO l_rows.
            READ TABLE gt_final INTO l_eban INDEX l_rows-index.
            IF sy-subrc = 0.
              APPEND l_eban TO gt_eban1.
            ENDIF.
            CLEAR:l_eban,l_rows.
          ENDLOOP.
          LOOP AT gt_rows INTO l_rows.
            CLEAR  L_success.
            SELECT SINGLE config_value INTO @DATA(l_CTR_bapi) FROM /sdocs/sspy_sgc
                                                  WHERE config = 'CNTRCT_CREATION_RFQ_BAPI'.
            IF l_CTR_bapi IS INITIAL.
              READ TABLE gt_final INTO l_eban INDEX l_rows-index.
              IF sy-subrc = 0 AND l_eban-docid IS NOT INITIAL.
                CALL FUNCTION '/SDOCS/S1_CNT_FROM_RFQ_CR'
                  EXPORTING
                    i_docid   = l_eban-docid
                    i_bmod    = 'X'
                  IMPORTING
                    e_success = L_success
                    e_ebeln   = l_eban-ebeln.

              ENDIF.
            ELSE.
              READ TABLE gt_final INTO l_eban INDEX l_rows-index.
              CALL FUNCTION '/SDOCS/S1_CTR_CR_FROM_RFQ_BAPI'
                EXPORTING
                  iv_docid   = l_eban-docid
                  iv_rfqno   = l_eban-rfq_no
                IMPORTING
                  ev_success = L_success.
              IF L_success IS NOT INITIAL.
                lv_db_table = '/sdocs/s1_buy_hd'.
                SELECT SINGLE contract FROM (lv_db_table) INTO l_eban-ebeln WHERE  docid  = l_eban-docid.
              ENDIF.
            ENDIF.
            IF lv_success IS  INITIAL.
              lv_success = l_success.
            ENDIF.
            IF lv_success IS NOT INITIAL.
              SUBMIT /sdocs/sspay_contract_dispatch USING SELECTION-SET 'TEST' AND RETURN.
              CONCATENATE 'Your Contract is now dispatched to Vendor Portal - ' l_eban-ebeln INTO  gv_rfq_screen SEPARATED BY space.
              CONCATENATE 'Click on below to open it on Vendor Portal' ' ' INTO gv_rfq_screen1 .
              CONCATENATE 'https://s4-demo.smartdocs.one/#/sp/company/contracts/' l_eban-ebeln
              INTO lv_param.
              PERFORM call_msg_screen.
            ENDIF.

          ENDLOOP.



*               endif.
        WHEN 'REFRESH'.
          REFRESH gt_final.
      ENDCASE.
      REFRESH gt_final.
      PERFORM get_data.
      PERFORM sourcing_field_cat USING gt_fcat.
      IF gv_node_event IS INITIAL.
        DELETE gt_final WHERE doctype <> ' '.
      ENDIF.
      IF  gt_gridb IS BOUND.
        CALL METHOD gt_gridb->set_frontend_fieldcatalog
          EXPORTING
            it_fieldcatalog = gt_fcat[].
      ENDIF.
      CALL METHOD gt_gridb->refresh_table_display.
      CLEAR:l_po_bapi,l_CTR_bapi.
    ENDMETHOD.

ENDCLASS.

DATA :lv_ref TYPE REF TO lcl_event_grid.


INCLUDE /sdocs/s1_sourcing_cockpit_o01.
INCLUDE /sdocs/s1_sourcing_cockpit_i01.
INCLUDE /sdocs/s1_sourcing_cockpit_f01.

START-OF-SELECTION.
  PERFORM get_data.
  IF gt_final[] IS NOT INITIAL.
    PERFORM data_display.
  ELSE.
    MESSAGE s006(/sdocs/sspay_msg) WITH 'No Data'.
  ENDIF.
