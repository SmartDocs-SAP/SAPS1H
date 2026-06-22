*&---------------------------------------------------------------------*
*&  Include           /SDOCS/SSPAY_INCL_RECDATA
*&---------------------------------------------------------------------*
*{   DELETE         S4HK903108                                        1
*\include <cntn01>.
*}   DELETE

type-pools: abap.


data: gv_body_length         type i,
      gv_nl                  like sy-index,
      gv_ll                  like sy-index,
      gv_uri                 like sapb-uri,
      gv_sign                type c value 'X',
      gv_signed_data         like ssfparms-sigdatalen,
      gv_uri_for_signature   like sapb-uri,
      gv_abs_uri             like sapb-uri,
      gv_signature_uri(4096) type c,
      gv_subrc               type sy-subrc,
      gv_line                type tline,
      gv_scode               type i,
      gv_stext               type string,
      gv_ar_id               like toav0-archiv_id,
      gv_doctype             type /sdocs/sspy_doctype,"/actip/doctype-doctype,
      gv_arc_docid           type sysuuid-c,
      gv_objkey              type swotobjid-objkey,
      gv_pack                type p,
      gv_eventid             type swedumevid-evtid,
      gv_seqid               type numc5,
      gv_tabix               type numc5,
      gv_path                type numc5,
      gv_step                type numc5,
      gv_seq                 type numc5,
      gv_comments_flag       type flag,
      gv_logdata_flag        type flag,
      gv_out_resugt          type string,
      gv_xml_str             type string,gv_cflag,
      gv_success             type char1,
      gv_uri_str             type string,
      gv_uri_ack_str         type string,
      gv_url                 type sapb-uri,
      gv_url_str             type string,
      gv_run_url             type string,
      gv_token               type string,
      gv_res_str             type string,
      gv_prefix              type char3,
      gv_l1                  type sy-tabix,
      gv_n1                  type sy-tabix,
      gv_server              type scms_cossv,
      gv_attdoc_str          type char255,
      gv_g_docid             type /sdocs/sspy_docid,
*      gv_docid               type /actip/document,
      gv_sum                 type f,
      gv_postfix(12)         type c,
      gv_ex                  type ref to cx_root,
      gv_var_text            type string,
      gv_c                   type string,
      gv_c1                  type string,
      gv_len                 type i,
      gv_k                   type i,
      gv_m                   type i,
      gv_r                   type i value 0,
      gs_var_text            type string.


types:begin of gs_desc,
         text type tdline,
      end of gs_desc.

types:begin of gs_text,
         text_field(1000) type c,
      end of gs_text.

data:begin of gs_ack occurs 0,
      ref_id(50) type c,
      sdocid type /SDOCS/SSPY_DOCID,"/actip/doc-docid,
      ven_ref_no type char20,
    end of gs_ack.

data:begin of gs_xml,
*      line(2048) type c,
     line type string,
     end of gs_xml.

data:begin of gs_resp,
     data(255) type x,
    end of gs_resp.

types:begin of gs_log,
        ref_id(50)         type c,
        step(10)           type c,
        seq(10)            type c,
        activity(50)       type c,
        activity_text(255) type c,
        comment(4000)       type c,
        type(255)          type c,
        user_id(255)       type c,
        actual_user(255)   type c,
        log_date(255)      type c,
        log_time(255)      type c,
        channel(255)       type c,
        agent(255)         type c,
        collab_with(255)   type c,
    end of gs_log.

types:begin of gs_pcomments,
        ref_id(50)        type c,
        step(10)          type c,
        seq(10)           type c,
        comment(4000)      type c,
        comment_text(4000) type c,
        log_date(255)      type c,
        log_time(255)      type c,
      end of gs_pcomments.


types:begin of gs_pcomments1,
        ref_id(50)        type c,
        step(10)          type c,
        seq(10)           type c,
        comment(255)      type c,
        comment_text(255) type c,
        activity(5)       type c,
      end of gs_pcomments1.

types:begin of gs_approval,
        level(50)    type c,
        approver(50) type c,
        ref_id(50)   type c,
      end of gs_approval.
types:begin of gs_adhoc_approvers,
       ref_id(50) type c,
       step       type numc5,
       approvers   type AD_SMTPADR,
      end of gs_adhoc_approvers.
types:begin of gs_recent_act,
         ref_id(50)   type c,
         activity(50) type c,
         step         type numc5,
         user         type char50,
         COLLABORATED_USER type char50,
      end of gs_recent_act.

types:begin of ty_reassing,
        item_type(255) type c,
        id(255) type c,
        status(255) type c,
      end of ty_reassing.

TYPES:BEGIN OF FS_OTH_STR,
        STR(10000) TYPE C,
      END OF FS_OTH_STR.

DATA:WA_OTH_STR TYPE /SDOCS/SSPY_ST_COMM,"FS_OTH_STR,
     GT_OTH_STR TYPE TABLE OF /SDOCS/SSPY_ST_COMM."FS_OTH_STR.

data:wa_head       type thead,
*{   DELETE         S4HK903108                                        2
*\     wa_act        type swc_object,
*}   DELETE
     wa_pcomments  type gs_pcomments,
     wa_pcomments1  type gs_pcomments1,
     wa_approvers  type gs_approval,
     wa_desc       type gs_desc,
     wa_result_xml type abap_trans_resbind,
     wa_adhoc_approvers type gs_adhoc_approvers,
     comments      type tlinetab,
     wa_comments   type tlinetab,
     wa_comm_l       type line of tlinetab,
     wa_reassingn        type  ty_reassing,
     wa_profile   type /SDOCS/SSPY_SPRF,
     wa_plog type gs_log,
     gv_tk_ext type /sdocs/sspy_http_ext,
     GV_RUN_INS_MSG  type char50 value 'Program run in other instance'..


data: gt_resp             like standard table of gs_resp with header line,
      gt_xml              like standard table of gs_xml  with header line,
      gt_reqb_upd         like standard table of gs_xml  with header line,
      gt_reqh_upd         type standard table of line    with header line,
      gt_response_body    like standard table of gs_resp with header line,
      gt_response_headers type standard table of line    with header line,
      gt_request_body     type table of line             with header line,
      gt_request_headers  type table of line             with header line,
      gt_respb_upd        like standard table of gs_resp with header line,
      gt_resph_upd        like table of line             with header line,
*      gt_docflow          type table of /actip/doc_flow  with header line,
      gt_text_out         type table of gs_text          with header line,
      gt_container        like swcont occurs 0           with header line,
      gt_actor_tab        like swhactor occurs 0         with header line,
      gt_pcomments        type STANDARD TABLE OF gs_pcomments,
      gt_pcomments1        type table of gs_pcomments1,
      gt_approvers        type standard table of gs_approval,
      GT_ADHOC_APPROVERS  type  table of gs_adhoc_approvers,
      gt_recent_act       type TABLE OF gs_recent_act,
      gt_desc             type table of gs_desc,
      gt_plog             type table of gs_log,
      gt_reassingn        type table of ty_reassing,
      gt_result_xml       type abap_trans_resbind_tab,
      gv_enable_token,


      gv_prog_locked.

*data: doc_obj             type ref to /actip/doc,
 data      gs_ex               type ref to cx_root.

DATA:GV_SRTFD TYPE GMSPPROGRAM-SPONSORED_PROG.

data : gv_data_to_file.
CONSTANTS:gv_http_200 type char5 value '200',
          gv_http_201 type char5 value '201'.
