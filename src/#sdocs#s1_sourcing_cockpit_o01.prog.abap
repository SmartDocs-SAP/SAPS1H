*&---------------------------------------------------------------------*
*&  Include           /SDOCS/S1_SOURCING_COCKPIT_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'PF_100'.
  SET TITLEBAR 'TITLE_100'.
  perform logo_display.
  perform alv_display.
  PERFORM event_tree_reg.
  PERFORM process_tree_data.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  LOGO_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM LOGO_DISPLAY .
data url    type char255.
  data query_table like w3query occurs 1 with header line.
  data html_table like w3html occurs 1.
  data return_code like  w3param-ret_code.
  data content_type like  w3param-cont_type.
  data content_length like  w3param-cont_len.
  data pic_data like w3mime occurs 0.
  data pic_size type i.
  if init is initial.
    init = 'X'.
    create object:
           container  exporting container_name = 'CC_FLOGO',
           picture    exporting parent = container.
  endif.
  refresh query_table.
  query_table-name = '_OBJECT_ID'.
  query_table-value = '/SDOCS/S1_LOGO'.
  append query_table.
  data(lv_fm) = 'WWW_GET_MIME_OBJECT'.
  call function lv_fm
    tables
      query_string        = query_table
      html                = html_table
      mime                = pic_data
    changing
      return_code         = return_code
      content_type        = content_type
      content_length      = content_length
    exceptions
      object_not_found    = 1
      parameter_not_found = 2
      others              = 3.
*     CALL METHOD picture->load_picture_from_url
*      EXPORTING
*       url = '/SDOCS/S1_LOGO'.
  if sy-subrc = 0.
    pic_size = content_length.
  endif.

  call function 'DP_CREATE_URL'
    exporting
      type    = 'IMAGE'
      subtype = 'X-UNKNOWN'
    tables
      data    = pic_data
    changing
      url     = url.
  call method picture->load_picture_from_url
    exporting
      url = url.

  call method picture->set_display_mode
    exporting
      display_mode = picture->display_mode_fit_center.
ENDFORM.

*{   INSERT         &$&$&$&$                                          1
*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0101 OUTPUT.
 SET PF-STATUS 'PF101'.
 SET TITLEBAR 'TIT'.
* data:lv_timestamp type timestamp,
*      lv_dat type sy-datum,
*      lv_tim type sy-uzeit.
* clear:lv_timestamp,lv_dat,lv_tim.
* convert date sy-datum time sy-uzeit INTO TIME STAMP lv_timestamp TIME ZONE sy-zonlo.
* lv_timestamp = sy-timestamp.
* convert TIME STAMP lv_timestamp time zone 'EST'
*                into date lv_dat time lv_tim." DAYLIGHT SAVING TIME 'EDT'.
 GV_DTIME = sy-uzeit.
ENDMODULE.
*}   INSERT
*&---------------------------------------------------------------------*
*& Module STATUS_0103 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0103 OUTPUT.
 SET PF-STATUS 'PF103'.
 SET TITLEBAR 'TIT103'.
ENDMODULE.
