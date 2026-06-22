FUNCTION /SDOCS/S1_FTP_SAP_TO_EXTERNALN.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_PROG_NAME) TYPE  PROGNAME
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
*{   DELETE         S4HK903116                                        1
*\  DATA it_ftp TYPE STANDARD TABLE OF /sdocs/s1_ftplog INITIAL SIZE 1.
*\  types : begin of ty_file_ext,
*\    file_extn type /sdocs/s1_ftpfnm-file_extn,
*\    end of ty_file_ext.
*\  data: lv_file_ext type ty_file_ext.
*\ types : begin of ty_sprf,
*\    ftp_server type /sdocs/sspy_sprf-ftp_server,
*\   ftp_uid type /sdocs/sspy_sprf-ftp_server,
*\   ftp_pwd type /sdocs/sspy_sprf-ftp_server,
*\   end of ty_sprf.
*\   data : wa_ftp type ty_sprf.
*\lv_db_table = '/sdocs/s1_ftpfnm'.
*\  SELECT SINGLE file_extn
*\         FROM (lv_db_table)
*\         INTO @lv_file_ext
*\         WHERE prog_name = @i_prog_name.
*\
*\  IF i_ftp IS NOT INITIAL.
*\
*\    DATA(lv_source) = NEW char30( ). "password
*\    DATA(lv_file) = NEW char255( ).
*\    DATA(lv_sou_len) = NEW i( ).
*\    DATA(lv_key) = NEW i('26101957').
*\    DATA(lv_user) = NEW char30( ).
*\    DATA(lv_host) = NEW char30( ).
*\    DATA(lv_des) = NEW rfcdes-rfcdest('SAPFTPA')."background means use 'A'
*\    DATA(lv_handle) = NEW i( ).
*\    DATA(lv_command) = NEW char255( ).
*\    DATA:it_com TYPE STANDARD TABLE OF ty_file INITIAL SIZE 1.
*\*  data:lv_timestamp type tzonref-tstamps.
*\lv_db_table = '/sdocs/sspy_sprf'.
*\    SELECT SINGLE ftp_server,ftp_uid,ftp_pwd
*\             FROM (lv_db_table)
*\               INTO @wa_ftp
*\       WHERE profile_id = @i_profile.
*\
*\
*\    lv_source->* = wa_ftp-ftp_pwd.
*\
*\    lv_sou_len->* = strlen( lv_source->* ). "length of the password
*\    """converting password to encrypted format
*\    CALL FUNCTION 'HTTP_SCRAMBLE'
*\      EXPORTING
*\        source      = lv_source->*
*\        sourcelen   = lv_sou_len->*
*\        key         = lv_key->*
*\      IMPORTING
*\        destination = lv_source->*.
*\
*\
*\    lv_user->* = wa_ftp-ftp_uid.
*\    lv_host->* = wa_ftp-ftp_server.
*\    """CONNECTING TO FTP SERVER
*\    CALL FUNCTION 'FTP_CONNECT'
*\      EXPORTING
*\        user            = lv_user->*
*\        password        = lv_source->*
*\*       ACCOUNT         =
*\        host            = lv_host->*
*\        rfc_destination = lv_des->*
*\*       GATEWAY_USER    =
*\*       GATEWAY_PASSWORD       =
*\*       GATEWAY_HOST    =
*\      IMPORTING
*\        handle          = lv_handle->*
*\      EXCEPTIONS
*\        not_connected   = 1
*\        OTHERS          = 2.
*\    IF sy-subrc <> 0.
*\      DATA(lv_mess) = |Connection Error|.
*\
*\    ELSE.
*\
*\*** PUSH DATA TO FTP SERVER
*\*    DATA(lv_path) = NEW char200('/SAPTEST.TXT'). "40.117.253.110/home/ftpuser/SAPTEST.TXT
*\      lv_command->* = |cd { i_fname }|. "i_fname is folder name   "to change the directry
*\      PERFORM ztab_command USING lv_handle->* lv_command->*
*\                        CHANGING it_com.
*\
*\*    lv_command->* = |set passive on|. "i_fname is folder name   "to change the directry
*\*    PERFORM ztab_command USING lv_handle->* lv_command->*
*\*                      CHANGING it_com.
*\
*\      lv_command->* = |chmod 777 { i_fname }|. "i_fname is folder name   "to change the directry
*\      PERFORM ztab_command USING lv_handle->* lv_command->*
*\                        CHANGING it_com.
*\
*\****Setting file name and time
*\      GET TIME STAMP FIELD DATA(lv_timestamp).
*\*    lv_file->* = |{ lv_file_ext }.txt|.
*\      data(lv_file_ext1) = conv char50( lv_file_ext ).
*\      lv_file->* = |{ lv_file_ext1 }_{ lv_timestamp }.txt|.
*\
*\      CALL FUNCTION 'FTP_R3_TO_SERVER'
*\        EXPORTING
*\          handle         = lv_handle->*
*\          fname          = lv_file->*
*\*         BLOB_LENGTH    =
*\          character_mode = 'X'
*\        TABLES
*\*         blob           = it_file
*\          text           = i_data
*\        EXCEPTIONS
*\          tcpip_error    = 1
*\          command_error  = 2
*\          data_error     = 3
*\          OTHERS         = 4.
*\      IF sy-subrc <> 0.
*\        lv_mess = |Data Error|.
*\      ENDIF.
*\
*\      CALL FUNCTION 'FTP_DISCONNECT'   """disconnect to ftp server
*\        EXPORTING
*\          handle = lv_handle->*.
*\
*\    ENDIF.
*\
*\    IF lv_mess IS INITIAL .  "" S - Success , F - Failed
*\      e_success = 'S'.
*\    ELSE .
*\      e_success = 'F'.
*\    ENDIF.
*\
*\  ELSE.
*\
*\    DATA lv_path TYPE string." VALUE 'F:\usr\sap\S01\DVEBMGS00\work\test1.txt'.
*\    GET TIME STAMP FIELD DATA(lv_timestamp1).  """" getting global date and time
*\    SPLIT lv_file_ext AT '.' INTO DATA(lv_file1) DATA(lv_ext). """getting file from DB split filename and extention
*\    lv_path = |{ lv_file1 }_{ lv_timestamp1 }.{ lv_ext }|.  "need to add path
*\
*\    WAIT UP TO 1 SECONDS.   """ for getting time difference
*\    OPEN DATASET lv_path FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
*\    IF sy-subrc NE 0.
*\      e_success = 'F'.
*\      lv_mess = |File is not yet working|.
*\    ELSE.
*\      LOOP AT i_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*\        TRANSFER <fs_data> TO lv_path.  """"transfer data to application path line by line
*\      ENDLOOP.
*\      e_success = 'S'.
*\    ENDIF.
*\
*\    CLOSE DATASET lv_path.  ""close the application path
*\
*\    CLEAR :lv_timestamp1,lv_file1,lv_ext,lv_path.
*\
*\  ENDIF.
*\
*\  APPEND INITIAL LINE TO it_ftp ASSIGNING FIELD-SYMBOL(<fs_ftp>).
*\
*\  <fs_ftp>-filename =  lv_file->*.  """file name in application server
*\  <fs_ftp>-type_trnsfr_data = |{ i_prog_name }-Push|.   """type of data
*\  <fs_ftp>-sync_date = sy-datum.
*\  <fs_ftp>-sync_time = sy-uzeit.
*\  <fs_ftp>-sync_status = e_success.  """f- means failed ,s- means success
*\  <fs_ftp>-freason = lv_mess.
*\lv_db_table = '/sdocs/s1_ftplog'.
*\  MODIFY (lv_db_table) FROM TABLE it_ftp.
*\  COMMIT WORK.
*\
*\  CLEAR:lv_file_ext,lv_timestamp, wa_ftp.
*}   DELETE


*}   INSERT
ENDFUNCTION.
