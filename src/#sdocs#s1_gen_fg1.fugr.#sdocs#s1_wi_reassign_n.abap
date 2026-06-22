function /SDOCS/S1_WI_REASSIGN_N.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DOCID) TYPE  /SDOCS/SSPY_DOCID
*"     REFERENCE(I_TYPE) TYPE  CHAR1 OPTIONAL
*"     REFERENCE(I_EXT) TYPE  /SDOCS/SSPY_HTTP_EXT OPTIONAL
*"     REFERENCE(I_USERMAIL) TYPE  AD_SMTPADR OPTIONAL
*"     REFERENCE(I_RESERVED) TYPE  CHAR1 OPTIONAL
*"--------------------------------------------------------------------
*{   INSERT         S4HK903047                                        1
*{   DELETE         S4HK903116                                        1
*\  types:begin of lt_adr6,
*\         addrnumber type adr6-addrnumber,
*\         persnumber type adr6-persnumber,
*\        end of lt_adr6.
*\  data:lt_adr type table of lt_adr6,
*\       wa_adr type lt_adr6.
*\  data:lv_doctype type /sdocs/sspy_hd-doctype.
*\  data:l_log      like /sdocs/sspy_log.
*\  data:lv_adrnum  type adr6-addrnumber.
*\  data:lv_persnum type adr6-persnumber.
*\  data:lv_userid  type usr21-bname.
*\  data:l_actvty   type /sdocs/sspy_act_code.
*\  data:lv_success.
*\  data:l_ext      type  /sdocs/sspy_http_ext .
*\  clear:gv_reassign,gv_mail,lv_doctype,l_log,l_actvty,lv_success,lv_adrnum,lv_persnum,lv_userid,gv_mail_from.
*\  if i_docid is not initial.
*\    gv_reserved = i_reserved.
*\    g_docid      = i_docid.
*\    gv_to_mail   = i_usermail.
*\
*\
*\    call screen 250 starting at 25 1.
*\    if sy-ucomm = 'CONTINUE' and gv_mail is not initial.
*\      perform reassign_users using i_docid i_type i_ext i_usermail.
*\      if gv_reassign is not initial.
*\        translate gv_mail to lower case.
*\        select addrnumber persnumber into table lt_adr from adr6 where smtp_addr = gv_mail.
*\         loop at lt_adr into wa_adr.
*\          select single bname into lv_userid from usr21 where persnumber = wa_adr-persnumber and addrnumber = wa_adr-addrnumber.
*\         if lv_userid is not initial.
*\           exit.
*\         endif.
*\         endloop.
*\       select single  * from /sdocs/s1_rwfusr into @data(wa_rausr) where docid = @i_docid.
*\         if lv_userid  is INITIAL.
*\           SELECT SINGLE USR_ID from /sdocs/s1_usr into lv_userid where USR_MAIL = gv_mail.
*\        endif.
*\**********************************************added Change the 'Re-assign' functionality in SAP PAR report, work item needs to removed from existing users list and re-assigned to the selected user 14.02.2024
*\     if gv_reserved is not INITIAL.
*\        delete from /sdocs/s1_rwfusr where docid = i_docid.
*\     endif.
*\*******************************closed.
*\         wa_rausr-c_user = lv_userid .
*\         wa_rausr-c_email = gv_mail.
*\         wa_rausr-docid =  i_docid.
*\         wa_rausr-LDATE = sy-datum.
*\         wa_rausr-ltime = sy-uzeit.
*\         MODIFY /sdocs/s1_rwfusr from wa_rausr.clear wa_rausr.
*\        update /sdocs/s1_rwfusr  set RESERVED = ' ' where docid = i_docid and RESERVED = 'X'."and c_email = i_usermail.
*\      COMMIT WORK and WAIT.
*\      Message 'Successfully Reassigned' type 'S'.
*\      endif.
*\    endif.
*\  endif.
*\
*\
*}   DELETE

*}   INSERT
endfunction.
