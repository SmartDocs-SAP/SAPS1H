function /SDOCS/SSPAY_CREATE_ATT_FM_N.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DOCID) TYPE  /SDOCS/SSPY_DOCID
*"     REFERENCE(I_PROCESS) TYPE  CHAR1 OPTIONAL
*"  EXCEPTIONS
*"      EX_DOCID_NOT_FOUND
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
*{   INSERT         S4HK903116                                        2
data:gv_filesize    type i,
       gv_file_filter type string,
       gv_lfilename   type string,
       gv_compid      type char255,
       gv_file_table  type filetable,
       gv_filetab     type file_table,
       rc             type i,
       user_action    type i.

  data:gv_offset type i.
  data:gv_att    type /sdocs/sspy_atta.

  data:lv_config_value type /sdocs/sspy_sgc-config_value.

  data:lv_arc_docid  type toav0-arc_doc_id.
  data:gv_archive_id like toav0-archiv_id.
  data:gv_mimetype   type toadd-mimetype.

  data:lv_file_name type /sdocs/sspy_atta-file_name,
       lv_file_type type toadd-doc_type.

  data:lt_comps type table of scms_comp,
       l_comps  type scms_comp.
  data:lv_cnt   type sy-dbcnt,
        lv_db_table type char50.

  refresh:lt_comps[],lt_data_att[].
  clear:gv_filesize,gv_file_filter,gv_lfilename,gv_compid,gv_mimetype,lv_file_name,lv_file_type,lv_arc_docid,gv_mimetype,
        gv_file_table,gv_filetab,rc,user_action,gv_offset,gv_att,gv_archive_id,gv_mimetype,l_comps,lv_config_value,lv_cnt.
  if i_docid is not initial.
    lv_db_table = '/sdocs/sspy_atta'.
    select count(*) from (lv_db_table) into lv_cnt where docid = i_docid
                                                      and   primary_doc ne ''.
  endif.

  call method cl_gui_frontend_services=>file_open_dialog
    exporting
      default_extension       = '*'
      file_filter             = gv_file_filter
      multiselection          = space
    changing
      file_table              = gv_file_table
      rc                      = rc
      user_action             = user_action
    exceptions
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      others                  = 5.
  if sy-subrc <> 0
  or user_action   = cl_gui_frontend_services=>action_cancel.
    if user_action = '9'.
      message s000(/sdocs/sspay_msg) with 'Action Cancel' display like 'E'.
    endif.
  endif.

  loop at gv_file_table into gv_filetab.
    gv_lfilename = gv_filetab-filename.
    exit.
  endloop.

  translate gv_lfilename using '/\'.

  do.
    shift gv_lfilename up to '\'.
    if sy-subrc ne 0.
      exit.
    endif.
    shift gv_lfilename.
  enddo.

  if gv_lfilename is initial.
    exit.
  endif.

  clear:gv_offset,lv_file_name,lv_file_type,gv_att.
  find all occurrences of '.' in gv_lfilename match offset gv_offset.
  gv_att-file_name = gv_lfilename+0(gv_offset).
  add 1 to gv_offset.
  gv_att-file_type = gv_lfilename+gv_offset.

  lv_file_name = gv_att-file_name.
  lv_file_type = gv_att-file_type.
  clear:gv_att.
 data(lv_fm) = 'GUI_UPLOAD'.
  call function lv_fm
    exporting
      filename                = gv_lfilename
      filetype                = 'BIN'
    importing
      filelength              = gv_filesize
    tables
      data_tab                = lt_data_att[]
    exceptions
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      others                  = 17.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.
lv_db_table = '/sdocs/sspy_sgc'.
  select single config_value
      from (lv_db_table)
      into lv_config_value
      where config = 'SPM_ARC_ID'."Temp

  translate lv_file_type to upper case.
  lv_db_table = 'toadd'.
  select single mimetype
         from (lv_db_table)
         into gv_mimetype
         where doc_type = lv_file_type.

  l_comps-fsize    = gv_filesize.
  l_comps-compid   = 'data'.
  l_comps-mimetype = gv_mimetype.
  append l_comps to lt_comps.
  clear: l_comps.

  if lv_config_value is not initial.
    gv_archive_id = lv_config_value.
  endif.

  gv_archive_id = 'S1'.

  if gv_archive_id is not initial.
    lv_fm = 'SCMS_HTTP_CREATE_TABLE'.
    call function lv_fm
      exporting
        crep_id               = gv_archive_id
        signature             = 'X'
        doc_prot              = 'rud'
        accessmode            = 'c'
        security              = 'F'
      importing
        doc_id_out            = lv_arc_docid
      tables
        comps                 = lt_comps[]
        data                  = lt_data_att[]
      exceptions
        bad_request           = 1
        unauthorized          = 2
        forbidden             = 3
        conflict              = 4
        internal_server_error = 5
        error_http            = 6
        error_url             = 7
        error_signature       = 8
        error_parameter       = 9
        others                = 10.

    if sy-subrc <> 0.

    else.
     if  I_PROCESS is INITIAL.
      gv_att-docid       = i_docid.
     endif.
      gv_att-file_name   = lv_file_name.
      gv_att-file_type   = lv_file_type.
      gv_att-arc_docid   = lv_arc_docid.
      gv_att-arc_id      = gv_archive_id.
      gv_att-cr_date     = sy-datum.
      gv_att-cr_time     = sy-uzeit.
      gv_att-AR_DOCTYPE  = 'Supporting Document'.
      if lv_cnt is initial.
        gv_att-primary_doc = 'X'.
      endif.
      if  i_process is initial.
        lv_db_table = '/sdocs/sspy_atta'.
      modify (lv_db_table) from gv_att.
      commit work.
      else.
      append gv_att to gt_atta.
      endif.
    endif.
  endif.
  if gv_att is not initial.
    message s000(/sdocs/sspay_msg) with 'File Attached Successfully!'.
  else.
    message s000(/sdocs/sspay_msg) with 'File Attached Failed!'.
  endif.

*}   INSERT
*{   DELETE         S4HK903116                                        1
*\  data:gv_filesize    type i,
*\       gv_file_filter type string,
*\       gv_lfilename   type string,
*\       gv_compid      type char255,
*\       gv_file_table  type filetable,
*\       gv_filetab     type file_table,
*\       rc             type i,
*\       user_action    type i.
*\
*\  data:gv_offset type i.
*\  data:gv_att    type /sdocs/sspy_atta.
*\
*\  data:lv_config_value type /sdocs/sspy_sgc-config_value.
*\
*\  data:lv_arc_docid  type toav0-arc_doc_id.
*\  data:gv_archive_id like toav0-archiv_id.
*\  data:gv_mimetype   type toadd-mimetype.
*\
*\  data:lv_file_name type /sdocs/sspy_atta-file_name,
*\       lv_file_type type toadd-doc_type.
*\
*\  data:lt_comps type table of scms_comp,
*\       l_comps  type scms_comp.
*\  data:lv_cnt   type sy-dbcnt.
*\
*\  refresh:lt_comps[],lt_data_att[].
*\  clear:gv_filesize,gv_file_filter,gv_lfilename,gv_compid,gv_mimetype,lv_file_name,lv_file_type,lv_arc_docid,gv_mimetype,
*\        gv_file_table,gv_filetab,rc,user_action,gv_offset,gv_att,gv_archive_id,gv_mimetype,l_comps,lv_config_value,lv_cnt.
*\  if i_docid is not initial.
*\    select count(*) from /sdocs/sspy_atta into lv_cnt where docid = i_docid
*\                                                      and   primary_doc ne ''.
*\  endif.
*\
*\  call method cl_gui_frontend_services=>file_open_dialog
*\    exporting
*\      default_extension       = '*'
*\      file_filter             = gv_file_filter
*\      multiselection          = space
*\    changing
*\      file_table              = gv_file_table
*\      rc                      = rc
*\      user_action             = user_action
*\    exceptions
*\      file_open_dialog_failed = 1
*\      cntl_error              = 2
*\      error_no_gui            = 3
*\      others                  = 5.
*\  if sy-subrc <> 0
*\  or user_action   = cl_gui_frontend_services=>action_cancel.
*\    if user_action = '9'.
*\      message s000(/sdocs/sspay_msg) with 'Action Cancel' display like 'E'.
*\    endif.
*\  endif.
*\
*\  loop at gv_file_table into gv_filetab.
*\    gv_lfilename = gv_filetab-filename.
*\    exit.
*\  endloop.
*\
*\  translate gv_lfilename using '/\'.
*\
*\  do.
*\    shift gv_lfilename up to '\'.
*\    if sy-subrc ne 0.
*\      exit.
*\    endif.
*\    shift gv_lfilename.
*\  enddo.
*\
*\  if gv_lfilename is initial.
*\    exit.
*\  endif.
*\
*\  clear:gv_offset,lv_file_name,lv_file_type,gv_att.
*\  find all occurrences of '.' in gv_lfilename match offset gv_offset.
*\  gv_att-file_name = gv_lfilename+0(gv_offset).
*\  add 1 to gv_offset.
*\  gv_att-file_type = gv_lfilename+gv_offset.
*\
*\  lv_file_name = gv_att-file_name.
*\  lv_file_type = gv_att-file_type.
*\  clear:gv_att.
*\
*\  call function 'GUI_UPLOAD'
*\    exporting
*\      filename                = gv_lfilename
*\      filetype                = 'BIN'
*\    importing
*\      filelength              = gv_filesize
*\    tables
*\      data_tab                = lt_data_att[]
*\    exceptions
*\      file_open_error         = 1
*\      file_read_error         = 2
*\      no_batch                = 3
*\      gui_refuse_filetransfer = 4
*\      invalid_type            = 5
*\      no_authority            = 6
*\      unknown_error           = 7
*\      bad_data_format         = 8
*\      header_not_allowed      = 9
*\      separator_not_allowed   = 10
*\      header_too_long         = 11
*\      unknown_dp_error        = 12
*\      access_denied           = 13
*\      dp_out_of_memory        = 14
*\      disk_full               = 15
*\      dp_timeout              = 16
*\      others                  = 17.
*\  if sy-subrc <> 0.
*\* Implement suitable error handling here
*\  endif.
*\
*\  select single config_value
*\      from /sdocs/sspy_sgc
*\      into lv_config_value
*\      where config = 'SPM_ARC_ID'."Temp
*\
*\  translate lv_file_type to upper case.
*\  select single mimetype
*\         from toadd
*\         into gv_mimetype
*\         where doc_type = lv_file_type.
*\
*\  l_comps-fsize    = gv_filesize.
*\  l_comps-compid   = 'data'.
*\  l_comps-mimetype = gv_mimetype.
*\  append l_comps to lt_comps.
*\  clear: l_comps.
*\
*\  if lv_config_value is not initial.
*\    gv_archive_id = lv_config_value.
*\  endif.
*\
*\  gv_archive_id = 'S1'.
*\
*\  if gv_archive_id is not initial.
*\    call function 'SCMS_HTTP_CREATE_TABLE'
*\      exporting
*\        crep_id               = gv_archive_id
*\        signature             = 'X'
*\        doc_prot              = 'rud'
*\        accessmode            = 'c'
*\        security              = 'F'
*\      importing
*\        doc_id_out            = lv_arc_docid
*\      tables
*\        comps                 = lt_comps[]
*\        data                  = lt_data_att[]
*\      exceptions
*\        bad_request           = 1
*\        unauthorized          = 2
*\        forbidden             = 3
*\        conflict              = 4
*\        internal_server_error = 5
*\        error_http            = 6
*\        error_url             = 7
*\        error_signature       = 8
*\        error_parameter       = 9
*\        others                = 10.
*\
*\    if sy-subrc <> 0.
*\
*\    else.
*\     if  I_PROCESS is INITIAL.
*\      gv_att-docid       = i_docid.
*\     endif.
*\      gv_att-file_name   = lv_file_name.
*\      gv_att-file_type   = lv_file_type.
*\      gv_att-arc_docid   = lv_arc_docid.
*\      gv_att-arc_id      = gv_archive_id.
*\      gv_att-cr_date     = sy-datum.
*\      gv_att-cr_time     = sy-uzeit.
*\      gv_att-AR_DOCTYPE  = 'Supporting Document'.
*\      if lv_cnt is initial.
*\        gv_att-primary_doc = 'X'.
*\      endif.
*\      if  i_process is initial.
*\      modify /sdocs/sspy_atta from gv_att.
*\      commit work.
*\      else.
*\      append gv_att to gt_atta.
*\      endif.
*\    endif.
*\  endif.
*\  if gv_att is not initial.
*\    message s000(/sdocs/sspay_msg) with 'File Attached Successfully!'.
*\  else.
*\    message s000(/sdocs/sspay_msg) with 'File Attached Failed!'.
*\  endif.
*}   DELETE

*}   INSERT
endfunction.
