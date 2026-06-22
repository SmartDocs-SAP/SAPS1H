*&---------------------------------------------------------------------*
*&  Include           /SDOCS/SSPY_INCL_DISPDATA
*&---------------------------------------------------------------------*

DATA:gv_desc                TYPE char255,
     gv_attid               TYPE numc5,
     gv_sign                TYPE c VALUE 'X',
     gv_signature_uri(4096) TYPE c,
     gv_price(20)           TYPE c,
     gv_price1(20)          TYPE c,
     gv_body_length         TYPE i,
     gv_scode               TYPE i,
     gv_stext               TYPE string,
     gv_nl                  TYPE sy-tabix,
     gv_ll                  TYPE sy-tabix,
     gv_l1                  TYPE sy-tabix,
     gv_n1                  TYPE sy-tabix,
     gv_subrc               TYPE sy-subrc,
     gv_out_resugt          TYPE string,
     gv_uri_str             TYPE string,
     gv_xml_str             TYPE string,
     gv_stblg               TYPE bkpf-stblg,
     gv_url                 TYPE sapb-uri,
     gv_url_str             TYPE string,
     gv_token               TYPE string,
     gv_success,
     gv_res_str             TYPE string,
     gv_prefix              TYPE char3,
     gv_server              TYPE scms_cossv,
     gv_c255(255)           TYPE c,
     gv_sym_k               TYPE sy-tabix,
     gv_ch                  TYPE c,
     gv_ch1                 TYPE string,
     gv_str                 TYPE string,
     gv_sym_str             TYPE string,
     gv_sym_s_str           TYPE string,
     gv_int1                TYPE string,
     gv_buffer              TYPE xstring,
     gv_buffer1             TYPE string,
     gv_str_len             TYPE sy-tabix,
     gv_int                 TYPE i,
     gv_cnt                 TYPE int4,
     gv_div                 TYPE int4,
     gv_mod                 TYPE int4,
     gv_from                TYPE int4,
     gv_to                  TYPE int4,
     gv_uri                 LIKE sapb-uri,
     gv_signed_data         LIKE ssfparms-sigdatalen,
     gv_uri_for_signature   LIKE sapb-uri,
     gv_abs_uri             LIKE sapb-uri,
     gv_curr_date           TYPE sy-datum,
     gv_curr_time           TYPE sy-uzeit,
     gv_enable_token,
     gv_prog_locked,
     gv_run_ins_msg         TYPE char50 VALUE 'Program run in other instance',
     gv_data_to_file ."""For using push data to application server

DATA:BEGIN OF gs_xml,
       line(2048) TYPE c,
     END OF gs_xml.

TYPES:BEGIN OF gs_text,
        text_field(1000) TYPE c,
      END OF gs_text.

DATA:BEGIN OF gs_resp,
       DATA(255) TYPE x,
     END OF gs_resp.

TYPES: BEGIN OF gs_output,
         value TYPE char10,
*     rfq_no type ekko-ebeln,
       END OF gs_output.


DATA:wa_profile TYPE /sdocs/sspy_sprf,
     wa_output  TYPE gs_output.

DATA:gt_xml              LIKE STANDARD TABLE OF gs_xml   WITH HEADER LINE,
     gt_resp             LIKE STANDARD TABLE OF gs_resp  WITH HEADER LINE,
     gt_response_body    LIKE STANDARD TABLE OF gs_resp  WITH HEADER LINE,
     gt_respb_upd        LIKE STANDARD TABLE OF gs_resp  WITH HEADER LINE,
     gt_reqb_upd         LIKE STANDARD TABLE OF gs_xml   WITH HEADER LINE,
     gt_resph_upd        LIKE TABLE OF line              WITH HEADER LINE,
     gt_response_headers TYPE STANDARD TABLE OF line     WITH HEADER LINE,
     gt_reqh_upd         TYPE STANDARD TABLE OF line     WITH HEADER LINE,
     gt_data             TYPE TABLE OF line              WITH HEADER LINE,
     gt_text_out         TYPE TABLE OF gs_text           WITH HEADER LINE,
     gt_request_body     TYPE TABLE OF line              WITH HEADER LINE,
     gt_request_headers  TYPE TABLE OF line              WITH HEADER LINE,
     gt_output           TYPE TABLE OF gs_output.
DATA:conv                TYPE REF TO cl_abap_conv_out_ce.
DATA:gv_srtfd TYPE gmspprogram-sponsored_prog.
CONSTANTS:gv_http_200  type char5 VALUE '200',
          gv_http_201 type char5 VALUE '201'.
