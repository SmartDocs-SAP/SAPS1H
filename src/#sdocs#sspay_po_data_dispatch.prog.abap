

*-------------------------------------------------------------*
************************Copied from LnT NPL***********************
*&---------------------------------------------------------------------*
*& Report  /SDOCS/SSPAY_PO_DATA_DISPATCH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report /sdocs/sspay_po_data_dispatch.


include /sdocs/sspy_incl_dispdata.
tables:ekko.
data:begin of gt_sta occurs 0.
    include structure  jstat.
data: txt30 type tj02t-txt30,
      end of gt_sta.

data:begin of po_dis occurs 0,
       ebeln type ekko-ebeln,
     end of po_dis.

types:begin of po_eket,
        ebeln type eket-ebeln,
        ebelp type eket-ebelp,
        eindt type eket-eindt,
      end of po_eket.

types:begin of tt_nast,
        kappl type nast-kappl,
        objky type nast-objky,
        nacha type nast-nacha,
      end of tt_nast.

data:begin of t_toa01 occurs 0,
       object_id type toa01-object_id,
     end of t_toa01.

data:begin of it_toa01 occurs 0,
       object_id  type toa01-object_id,
       archiv_id  type toa01-archiv_id,
       arc_doc_id type toa01-arc_doc_id,
       ar_object  type toa01-ar_object,
       ar_date    type toa01-ar_date,
       reserve    type toa01-reserve,
     end of it_toa01.

data:begin of it_t001k occurs 0,
       bukrs type t001k-bukrs,
       bwkey type t001k-bwkey,
     end of it_t001k.

data:begin of it_t001w occurs 0,
       werks      type t001w-werks,
       j_1bbranch type t001w-j_1bbranch,
     end of it_t001w.

data:begin of it_1bbranch occurs 0,
       bukrs  type j_1bbranch-bukrs,
       branch type j_1bbranch-branch,
       stcd1  type j_1bbranch-stcd1,
       stcd2  type j_1bbranch-stcd2,
*       GSTIN  TYPE J_1BBRANCH-GSTIN,
     end of it_1bbranch.
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

data:begin of lt_lifnr occurs 0,
       lifnr type lfa1-lifnr,
     end of lt_lifnr.

types:begin of tt_t024,
        ekgrp     type t024-ekgrp,
        smtp_addr type t024-smtp_addr,
      end of tt_t024.

types:begin of tt_t007s,
        mwskz type t007s-mwskz,
        text1 type t007s-text1,
      end of tt_t007s.

types: begin of tt_ekpo,
         ebeln   type ekpo-ebeln,
         ebelp   type ekpo-ebelp,
         loekz   type ekpo-loekz,
         txz01   type ekpo-txz01,
         matnr   type ekpo-matnr,
         bukrs   type ekpo-bukrs,
         werks   type ekpo-werks,
         lgort   type ekpo-lgort,
         menge   type ekpo-menge,
         meins   type ekpo-meins,
         bprme   type ekpo-bprme,
         bpumz   type ekpo-bpumz,
         bpumn   type ekpo-bpumn,
         netpr   type ekpo-netpr,
         peinh   type ekpo-peinh,
         netwr   type ekpo-netwr,
         mwskz   type ekpo-mwskz,
         elikz   type ekpo-elikz,
         erekz   type ekpo-erekz,
         pstyp   type ekpo-pstyp,
         wepos   type ekpo-wepos,
         adrnr   type ekpo-adrnr,
         packno  type ekpo-packno,
         j_1bnbm type ekpo-j_1bnbm,
         mfrpn   type ekpo-mfrpn,
         webre   type ekpo-webre,
         afnam   type ekpo-afnam,
       end of tt_ekpo.

types: begin of tt_ekko,
         ebeln type ekko-ebeln,
         bukrs type ekko-bukrs,
         bsart type ekko-bsart,
         aedat type ekko-aedat,
         ernam type ekko-ernam,
         lifnr type ekko-lifnr,
         zterm type ekko-zterm,
         ekorg type ekko-ekorg,
         ekgrp type ekko-ekgrp,
         waers type ekko-waers,
         kdate type ekko-kdate,
         inco1 type ekko-inco1,
         inco2 type ekko-inco2,
         frggr type ekko-frggr,
         frgrl type ekko-frgrl,
         rettp type ekko-rettp,
       end of tt_ekko.


types:begin of tt_attach,
        ebeln     type ebeln,
        arc_id    type /sdocs/sspy_atta-arc_id,
        arc_docid type /sdocs/sspy_atta-arc_docid,
        file_type type /sdocs/sspy_atta-file_type,
        file_name type /sdocs/sspy_atta-file_name,
*        CREATOR   TYPE /SDOCS/SSPY_ATTA-CREATOR,
        cr_date   type /sdocs/sspy_atta-cr_date,
        cr_time   type /sdocs/sspy_atta-cr_time,
      end of tt_attach.

types: begin of tt_lfa1,
         lifnr type lfa1-lifnr,
         land1 type lfa1-land1,
         name1 type lfa1-name1,
         ort01 type lfa1-ort01,
         pstlz type lfa1-pstlz,
         regio type lfa1-regio,
         stras type lfa1-stras,
         adrnr type lfa1-adrnr,
       end of tt_lfa1.

types: begin of ty_ekbe,
         ebeln type ekbe-ebeln,
         ebelp type ekbe-ebelp,
         zekkn type ekbe-zekkn,
         vgabe type ekbe-vgabe,
         gjahr type ekbe-gjahr,
         belnr type ekbe-belnr,
         buzei type ekbe-buzei,
         bewtp type ekbe-bewtp,
         bwart type ekbe-bwart,
         menge type ekbe-menge,
         bpmng type ekbe-bpmng,
         shkzg type ekbe-shkzg,
       end of ty_ekbe.

types: begin of  ty_esuh,
         packno   type esuh-packno,
         sumlimit type esuh-sumlimit,
       end of ty_esuh.

data:gt_ekbe1 type table of ty_ekbe,
     wa_ekbe1 type ty_ekbe.

data:qt_lfa1 type table of tt_lfa1.

data: gv_selected_value(10) type c,
      gv_changed_str_to     type string,
      gv_amount             type char20,
      gv_supplierid         type lifnr,
      gv_supplierid1        type lifnr,
      gv_val2               type char32,
      gv_out                type string,
      gv_ecc_lsystem        type /sdocs/sspy_sgc-config_value, "CRMT_LOGSYS,
      gv_buyer              type adr6-smtp_addr,
      gv_po_crdate          type sy-datum.

data: gt_values  type table of dynpread,
      gt_tj02t   type table of tj02t,
      gt_options type table of rfc_db_opt,
      gt_fields  type table of rfc_db_fld,
      gt_return  type standard table of ddshretval,
      gt_data1   type table of tab512,
      gt_list    type vrm_values,
      gt_polist  type standard table of tt_ekko, "EKKO,
      gt_nast    type table of tt_nast,
      gt_nast2   type table of tt_nast,
      gt_items   type standard table of tt_ekpo, "EKPO,
      gt_eket    type table of po_eket,
      gt_t024    type table of tt_t024, "T024,
      gt_esuh    type table of ty_esuh,
      wa_esuh    type ty_esuh,
      wa_t024    type tt_t024. "T024.


data:wa_list          type vrm_value,
     wa_values        type dynpread,
     wa_tj02t         type tj02t,
     wa_options       type rfc_db_opt,
     wa_fields        type rfc_db_fld,
     wa_data          type tab512,
     wa_polist        type tt_ekko, "EKKO,
     wa_items         type tt_ekpo, "EKPO,
     wa_eket          type po_eket,
     wa_return        like line of gt_return,
     gv_http_sflag    type flag,
     gv_flag          type char1,
     wa_sta           like line of gt_sta,
     gs_nast          type tt_nast,
     gv_cur_date      type sy-datum,
     gv_cur_time      type sy-uzeit,
     gv_noemail_notif ,
     lv_oa_clear      type /sdocs/sspy_sgc-config_value, "CHAR1,
     lv_add(3)        type c,
     gt_t007s         type table of tt_t007s.

types:begin of fs_stat,
        stat  type jstat-stat,
        inact type jstat-inact,
      end of fs_stat.

data:wa_stat type fs_stat,
     it_stat type table of fs_stat.

data:r_ebeln type ekko-ebeln,
     r_aedat type ekko-aedat.

data:t_attach type table of tt_attach,
     l_attach type tt_attach.

types:begin of fs_usrlist,
        bname      type usr21-bname,
        smtp_addr  type adr6-smtp_addr,
        persnumber type usr21-persnumber,
      end of fs_usrlist.
data:wa_usrlist type fs_usrlist,
     t_usrlist  type table of fs_usrlist.
data:lv_config_value type /sdocs/sspy_sgc-config_value.
data:gv_blanket_value type /sdocs/sspy_sgc-config_value,
      lv_db_table type char50.


ranges:lr_date for sy-datum,
       lr_time for sy-uzeit.
data:wa_job_slog type /sdocs/sspy_jlog.
data:wa_po_sf type /sdocs/s1_st_archpo.
data:it_po_sf type table of /sdocs/s1_st_archpo.
data:gv_sf_fmname type rs38l_fnam."/sdocs/sspy_sgc-config_value.
data:gv_sf_taxfm    type rs38l_fnam,
     gv_tax_input   type /sdocs/s1_tax_input,
     gv_bg_objid    type thead-tdid,
     gv_ld_objid    type thead-tdid,
     gt_tax_output  type table of /sdocs/s1_tax_output with header line,
     lv_tax_per(18) type c.
types:begin of fs_ekbe,
        ebeln type ekbe-ebeln,
        ebelp type ekbe-ebelp,
        vgabe type ekbe-vgabe,
        bewtp type ekbe-bewtp,
        menge type ekbe-menge,
        dmbtr type ekbe-dmbtr,
      end of fs_ekbe.
data:wa_ekbe type fs_ekbe,
     gt_ekbe type table of fs_ekbe.
data:lt_t163y type table of t163y,
     wa_t163y type t163y.

data:lv_tax_code  type mwskz,
     lv_tax_amt   type mwsbp,
     lv_tax_prcnt type kbetr_kond.

data:lv_tdid   type thead-tdid,
     lv_ebeln  type thead-tdname,
     lv_flag   type flag,
     gv_sdtext type string.
data:t_lines type table of tline,
     l_lines type tline.
data:lv_characters  type string value 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.
*     lv_db_table type char50.
selection-screen begin of block b1 with frame title text-001.
parameters:p_profle type /sdocs/sspy_sprf-profile_id obligatory,
           p_tk_ext type /sdocs/sspy_http_ext default '',
           p_ext    type /sdocs/sspy_http_ext default '',
           p_bsize  type int4 default 5,
           p_retry  type int4 default 1.
selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-002.
select-options:s_ebeln for r_ebeln,
               s_aedat for r_aedat,
               s_epo   for ekko-ebeln no intervals.
selection-screen end of block b2.
parameters:p_delta as checkbox.

initialization.
  clear:gv_server,gv_ecc_lsystem,gv_sf_fmname,gv_sf_taxfm,wa_esuh.
  refresh: gt_polist,gt_items,gt_eket,gt_t007s[],gt_esuh..
  clear wa_eket.

at selection-screen output.
  p_profle = sy-sysid.
  loop at screen.
    if screen-name = 'P_PROFLE'.
      screen-input = 0.
      modify screen.
    endif.
  endloop.

start-of-selection.
  select single config_value from /sdocs/sspy_sgc into gv_sf_fmname
                                                  where config = 'FMNAME_FORSF_FROMPO'.
  select single config_value from /sdocs/sspy_sgc into gv_sf_taxfm
                                                  where config = 'PO_TAX_FM'.
  select single config_value from /sdocs/sspy_sgc into gv_bg_objid
                                                  where config = 'BG_EXISTS_OBJECTID'.
  select single config_value from /sdocs/sspy_sgc into gv_ld_objid
                                                  where config = 'LD_EXISTS_OBJECTID'.

  perform get_data.

  if p_bsize is initial.
    p_bsize = 10.
  endif.

  if p_bsize gt 50.
    message s000(/sdocs/sspay_msg) with 'Please maintain batch size less than or equal to 50'.
    exit.
  endif.

  clear:gv_enable_token.
  select single config_value into gv_enable_token from /sdocs/sspy_sgc where config = 'HTTP_TOKEN_ENABLE'.
  select single config_value from /sdocs/sspy_sgc into gv_data_to_file where config = 'DATA_TRANSFER_VIA_FILE'.
  if gv_enable_token is not initial.
    if gt_polist[] is not initial.
      perform portal_authitication.
      if gv_token is not initial and ( gv_scode = '200' or gv_scode = '201' ).
        perform push_data_to_portal.
      else.
        message s001(/sdocs/sspay_msg).
      endif.
    else.
      message s002(/sdocs/sspay_msg).
    endif.
  else.
    if gt_polist[] is initial.
      message s002(/sdocs/sspay_msg).
    else.
      perform push_data_to_portal.
    endif.
  endif.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_data .
  data:gv_cnt    type i,
       lv_add(3) type c.
  types:begin of fs_cdhdr,
          objectclas type cdhdr-objectclas,
          objectid   type cdhdr-objectid,
        end of fs_cdhdr.
  data:it_cdhdr type table of fs_cdhdr with header line.
  data:begin of lt_po occurs 0 ,
         ebeln type ekko-ebeln,
       end of lt_po.
  data:l_po like line of  lt_po.

  refresh:gt_nast2,gt_nast,t_attach,lt_lifnr[],gt_polist[],qt_lfa1[],gt_ekbe,t_toa01[].
  clear:lv_config_value.

  select single config_value from /sdocs/sspy_sgc into lv_config_value where config = 'DEFAULT_ARCHIV_ID'.
  select single config_value from /sdocs/sspy_sgc into gv_blanket_value where config = 'BLANKET_PO_TYPE'.


  if s_aedat is not initial or s_ebeln is not initial.
    p_delta = ''.
  endif.
  case p_delta.
    when 'X'.
      refresh:it_cdhdr,lt_po,gt_polist.
      clear:it_cdhdr.
           perform get_job_interval.
      gv_curr_date = sy-datum.
      gv_curr_time = sy-uzeit.
      lv_db_table = 'cdhdr'.
      select objectclas
             objectid from (lv_db_table) into table it_cdhdr where objectclas = 'EINKBELEG' and udate in lr_date and
             utime  in lr_time   and change_ind in ('U' , 'I').
*       SELECT * FROM CDHDR INTO TABLE LT_CDHDR WHERE OBJECTCLAS = 'EINKBELEG' AND UDATE = SY-DATUM AND TCODE = 'ME22N'.
        lv_db_table = 'ekbe'.
select ebeln into table lt_po from (lv_db_table) where vgabe = '1' and cpudt in lr_date and  cputm  in lr_time. "#EC CI_NOFIRST
      loop at it_cdhdr.
        move it_cdhdr-objectid to l_po-ebeln.
        append l_po to lt_po.
        clear: l_po,it_cdhdr.
      endloop.

      if lt_po[] is not initial.
         lv_db_table = 'ekko'.
        select ebeln,
               bukrs,
               	 bsart,
               aedat,
               ernam,
              lifnr,
               zterm,
               	ekorg,
               ekgrp,
                waers,
               	kdate,
               	inco1,
                inco2,
             frggr,
               	frgrl,
               rettp
          from 	(lv_db_table) into table @gt_polist[]
          for all entries in @lt_po[]
          where ebeln = @lt_po-ebeln
          and   bstyp = 'F' and frgrl eq ''  and memory eq ''   and  memorytype  eq ''. "#EC CI_NO_TRANSFORM
      endif.

      if gt_polist[] is not initial.
         lv_db_table = 'ekpo'.
        select ebeln,
               ebelp,
              loekz,
               	 txz01,
                matnr,
                bukrs,
               werks,
               lgort,
               menge,
               meins,
               bprme,
               bpumz,
                 bpumn,
               netpr,
               	 peinh,
               netwr,
               	mwskz,
                 elikz,
               	erekz,
               pstyp,
              wepos,
             adrnr,
               packno,
               j_1bnbm,
               mfrpn,
               webre,
               afnam
           from (lv_db_table)
          into table @gt_items[]
          for all entries in @gt_polist
          where ebeln = @gt_polist-ebeln.           "#EC CI_NO_TRANSFORM
 lv_db_table = 'ekbe'.
        select ebeln,
              ebelp,
             zekkn,
              vgabe,
            gjahr,
             belnr,
             buzei,
            bewtp,
              bwart,
              menge,
             bpmng,
              shkzg from (lv_db_table)
        into table @gt_ekbe1 for all entries in @gt_polist[] where ebeln = @gt_polist-ebeln and  bewtp = 'Q'. "#EC CI_NO_TRANSFORM
      endif.

    when ''.
       lv_db_table = 'ekko'.
      select ebeln,
               bukrs,
               	 bsart,
               aedat,
               ernam,
              lifnr,
               zterm,
               	ekorg,
               ekgrp,
                waers,
               	kdate,
               	inco1,
                inco2,
             frggr,
               	frgrl,
               rettp
        from (lv_db_table)
        into table @gt_polist[]
        where ebeln in @s_ebeln
        and   aedat in @s_aedat and frgrl eq '' and memory eq ''   and  memorytype  eq ''.

      if sy-subrc ne 0.
         lv_db_table = 'ekko'.
        select ebeln,
               bukrs,
               	 bsart,
               aedat,
               ernam,
              lifnr,
               zterm,
               	ekorg,
               ekgrp,
                waers,
               	kdate,
               	inco1,
                inco2,
             frggr,
               	frgrl,
               rettp
          from (lv_db_table)
          into table @gt_polist[]
          where ebeln in @s_ebeln
          and   aedat in @s_aedat and frgrl eq '' and memory eq ''   and  memorytype  eq ''      . "#EC CI_NO_TRANSFORM
      endif.

      if gt_polist[] is not initial.
         lv_db_table = 'ekpo'.
        select ebeln,
               ebelp,
              loekz,
               	 txz01,
                matnr,
                bukrs,
               werks,
               lgort,
               menge,
               meins,
               bprme,
               bpumz,
                 bpumn,
               netpr,
               	 peinh,
               netwr,
               	mwskz,
                 elikz,
               	erekz,
               pstyp,
              wepos,
             adrnr,
               packno,
               j_1bnbm,
               mfrpn,
               webre,
               afnam
           from (lv_db_table)
          into table @gt_items[]
          for all entries in @gt_polist
          where ebeln = @gt_polist-ebeln.           "#EC CI_NO_TRANSFORM
 lv_db_table = 'ekbe'.
        select ebeln,
              ebelp,
             zekkn,
              vgabe,
            gjahr,
             belnr,
             buzei,
            bewtp,
              bwart,
              menge,
             bpmng,
              shkzg from (lv_db_table)
        into table @gt_ekbe1 for all entries in @gt_polist[] where ebeln = @gt_polist-ebeln and  bewtp = 'Q'. "#EC CI_NO_TRANSFORM

        perform po_opn_status_process.
      endif.
  endcase.
  if gt_items[] is not initial.
    lv_db_table = 'esuh'.
    select packno sumlimit from (lv_db_table) into table gt_esuh for all entries in gt_items where packno = gt_items-packno.
  endif.
  loop at s_epo.
    delete gt_polist where ebeln = s_epo-low.
  endloop.

  if gt_polist[] is not initial.

    loop at gt_polist into wa_polist.
      gs_nast-objky     = wa_polist-ebeln.
      t_toa01-object_id = wa_polist-ebeln.
      append gs_nast to gt_nast2.
      append t_toa01 to t_toa01[].
      clear:gs_nast,t_toa01.
    endloop.

    if t_toa01[] is not initial.
      lv_db_table = 'toa01'.
      select object_id,
             archiv_id,
             arc_doc_id,
             ar_object,
             ar_date,
             reserve
        from (lv_db_table)
        into table @it_toa01[]
        for all entries in @t_toa01[]
        where object_id = @t_toa01-object_id.
    endif.

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

    if gt_polist[] is not initial.
      lv_db_table = 't001k'.
      select bukrs,
             bwkey
        from (lv_db_table)
        into table @it_t001k[]
        for all entries in @gt_polist[]
        where bukrs = @gt_polist-bukrs.
    endif.

    if it_t001k[] is not initial.
      lv_db_table = 't001w'.
      select werks,
             j_1bbranch
        from (lv_db_table)
        into table @it_t001w[]
        for all entries in @it_t001k[]
        where werks = @it_t001k-bwkey.
lv_db_table = 'J_1BBRANCH'.
      select bukrs,
             branch,
             stcd1,
             stcd2
*             GSTIN
        from (lv_db_table)
        into table @it_1bbranch[]
        for all entries in @it_t001k[]
        where bukrs = @it_t001k-bukrs.
    endif.
   lv_db_table = 't024'.
   SELECT EKGRP                                          "Select purchasing group
             SMTP_ADDR                                       "Select email address
        FROM (lv_db_table)                                          "From purchasing groups table
        INTO TABLE GT_T024                                  "Into internal table GT_T024
        FOR ALL ENTRIES IN GT_POLIST[]                      "For all POs in GT_POLIST
        WHERE EKGRP = GT_POLIST-EKGRP.                      "Match purchasing group with PO
 lv_db_table = 'lfa1'.
    SELECT LIFNR                                          "Select vendor number
           LAND1                                            "Country key
           NAME1                                            "Name 1
           ORT01                                            "City
           PSTLZ                                            "Postal code
           REGIO                                            "Region
           STRAS                                            "Street
           ADRNR                                            "Address number
        FROM (lv_db_table)                                          "From vendor master table
        INTO TABLE QT_LFA1[]                               "Into internal table QT_LFA1
        FOR ALL ENTRIES IN GT_POLIST[]                      "For all POs in GT_POLIST
        WHERE LIFNR = GT_POLIST-LIFNR.                      "Match vendor number with PO
  endif.


  if gt_items[] is not initial.
     lv_db_table = 'eket'.
      select ebeln
           ebelp
           eindt
      from (lv_db_table)
      into table gt_eket
      for all entries in gt_items[]
      where ebeln = gt_items-ebeln
      and   ebelp = gt_items-ebelp.
 lv_db_table = 'ekbe'.
    select ebeln
           ebelp
           vgabe
           bewtp
           menge
           dmbtr
      from (lv_db_table)
      into table gt_ekbe[]
      for all entries in gt_items[]
      where ebeln = gt_items-ebeln
      and  ebelp = gt_items-ebelp.
    lv_db_table = 't163y'.
    select * from (lv_db_table) into table lt_t163y where spras = sy-langu.
    lv_db_table = 't007s'.
    select mwskz,
           text1
      from (lv_db_table)
      into table @gt_t007s[]
      for all entries in @gt_items[]
      where spras = @sy-langu
      and   mwskz = @gt_items-mwskz.
  endif.

  refresh t_usrlist.
  if gt_polist[] is not initial.
*    select a~bname
*           b~smtp_addr b~persnumber  into table t_usrlist from ( adr6 as b join usr21 as a on a~persnumber = b~persnumber )
*                     for all entries in gt_polist
*                                       where a~bname = gt_polist-ernam.
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
                    smtp_addr = <fs_adr6>-smtp_addr
                     persnumber = <fs_usr21>-persnumber ) TO t_usrlist.
  ENDIF.
ENDLOOP.
*    SELECT SINGLE ADR6~SMTP_ADDR INTO T_LOG-ACTUAL_USER FROM ( ADR6 JOIN USR21 ON USR21~PERSNUMBER = ADR6~PERSNUMBER )
*                                   WHERE USR21~BNAME = LV_USER.
  endif.
********************************************* 03.01.2023 person number issue
  delete t_usrlist where persnumber = ''.
******************************************closed.

endform.
*&---------------------------------------------------------------------*
*&      Form  GENERATE_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form generate_xml .
   types : begin of ty_dadr6,
          persnumber type AD_PERSNUM,
          addrnumber type AD_ADDRNUM ,
       end of ty_dadr6.
   data : wa_dadr6 type ty_dadr6.
  data: begin of address_groups occurs 0.
      include structure adagroups.
  data: end of address_groups.
    data : lv_dept type char40.

  data:lv_char(18) type c.
  data:lv_supplierid(30)    type c,
       lv_requestor(50)     type c,
       lv_location(30)      type c,
       lv_email             type ad_smtpadr,
       lv_shipment_type(50) type c,
       lv_delcount          type sy-tabix,
       lv_delcount1         type sy-tabix,
       lv_dlvry_cnt         type sy-tabix,
       lv_erdat             type sy-datum,
       lv_ezeit             type sy-uzeit,
       ls_lfa1              type tt_lfa1, "LFA1,
       ls_adrc              type adrc,
       ls_addr1_val         type addr1_val,
       lv_inv_qty           type ekpo-menge,
       lv_inv_amt           type ekpo-netpr,
       lv_no_posf           type c,
       lv_status(25)        type c,
       l_status.

  clear:lv_supplierid,lv_requestor,lv_location,lv_delcount,lv_inv_qty,
        lv_delcount1,ls_lfa1,ls_adrc,lv_dlvry_cnt,lv_no_posf,lv_status,l_status.
  refresh: address_groups[],it_po_sf[].

  gs_xml-line = '<PO_DATA>'.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '<HEADER>'.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<SYSTEM_ID>' sy-sysid '</SYSTEM_ID>' into gs_xml-line.
  append gs_xml to gt_xml.
  clear gs_xml.

  concatenate '<CLIENT_ID>' sy-mandt '</CLIENT_ID>' into gs_xml-line.
  append gs_xml to gt_xml.
  clear: gs_xml.

  data(lv_po) = wa_polist-ebeln.
  shift lv_po left deleting leading '0'.
  concatenate '<PO>' lv_po '</PO>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.
  po_dis-ebeln = wa_polist-ebeln.
  append po_dis.clear po_dis.

  clear gv_desc.
  concatenate 'PO_' lv_po into gv_desc.

  concatenate '<PO_DESC>' gv_desc '</PO_DESC>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<CCODE>' wa_polist-bukrs '</CCODE>' into  gs_xml-line."ps_company_code
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<PORG>' wa_polist-ekorg '</PORG>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<PGRP>' wa_polist-ekgrp '</PGRP>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<POTYPE>' wa_polist-bsart '</POTYPE>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<DLVRY_DATE>' wa_eket-eindt '</DLVRY_DATE>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<PODATE>' wa_polist-aedat '</PODATE>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  clear:gv_amount,lv_shipment_type.
  loop at gt_items into wa_items where ebeln = wa_polist-ebeln.
    gv_amount = gv_amount + wa_items-netwr.
  endloop.

  condense gv_amount.
  concatenate '<PO_AMT>' gv_amount '</PO_AMT>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  clear:lv_shipment_type,gv_desc.
  concatenate wa_polist-inco1 wa_polist-inco2 into lv_shipment_type separated by space.
  gv_desc = lv_shipment_type.
  perform replace_sym using gv_desc.
  concatenate '<SHIPMENT_TYPE>' gv_desc '</SHIPMENT_TYPE>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<PO_CUR>' wa_polist-waers '</PO_CUR>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<PAY_TERMS>' wa_polist-zterm '</PAY_TERMS>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<RCONTRACT_NO>'  '</RCONTRACT_NO>' into  gs_xml-line. "WA_ITEM-CTR_HDR_NUMBER
  append gs_xml to gt_xml.clear gs_xml.


*  clear gv_buyer.
*  clear:wa_t024, gv_desc.
*  if wa_polist-ekgrp is not initial.
*    read table gt_t024 into wa_t024 with key ekgrp = wa_polist-ekgrp.
*  endif.

*  gv_desc =  wa_t024-smtp_addr.
  clear wa_usrlist.
  read table t_usrlist into wa_usrlist with key bname = wa_polist-ernam.
  gv_desc = wa_usrlist-smtp_addr.
  if not gv_desc is initial.
    perform replace_sym using gv_desc.
  endif.
  concatenate '<BUYER>' gv_desc  '</BUYER>' into  gs_xml-line."lv_email 'buyer@smartdocs.ai' GV_BUYER
  append gs_xml to gt_xml.clear gs_xml.
* ********************"Code added on 16/07/2021 by Quraishi
****************************************** department code 12.04.2024
loop at gt_items into data(ps_items1) where ebeln = wa_polist-ebeln and afnam <> ' '.
  exit.
ENDLOOP.
  clear:gv_desc.
  if ps_items1-afnam is not INITIAL.
    lv_db_table = 'usr21'.
  SELECT SINGLE persnumber,ADDRNUMBER FROM (lv_db_table) INTO @WA_DADR6 WHERE BNAME = @ps_items1-afnam.
  IF WA_DADR6 IS NOT INITIAL.
    lv_db_table = 'adcp'.
  select single department from (lv_db_table) into @lv_dept where ADDRNUMBER = @WA_DADR6-ADDRNUMBER AND
                                                               persnumber = @WA_DADR6-persnumber."wa_usrlist-persnumber.

      gv_desc  = lv_dept.
      perform replace_sym using gv_desc.

  endif.
  ENDIF.
  concatenate '<DEPARTMENT>' gv_desc '</DEPARTMENT>' into  gs_xml-line.
  append gs_xml to gt_xml.
  clear:gs_xml.

  clear:lv_dept,ps_items1,WA_DADR6,gv_desc.
*******************************closed.
  clear:lv_tdid,lv_flag,lv_ebeln.
*  lv_tdid = 'F04'."Liquidated Damages
  lv_ebeln = wa_polist-ebeln.
  perform read_standard_text using lv_ebeln  gv_ld_objid changing lv_flag gv_sdtext.
  if lv_flag is not initial.
    concatenate '<LD_EXISTS>' 'true' '</LD_EXISTS>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear:gs_xml.
  else.
    concatenate '<LD_EXISTS>' 'false' '</LD_EXISTS>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear:gs_xml.
  endif.

  gv_desc = gv_sdtext.
  if not gv_desc is initial.
    perform replace_sym using gv_desc.
  endif.
  concatenate '<LD_TEXT>' gv_desc '</LD_TEXT>' into  gs_xml-line.
  append gs_xml to gt_xml.
  clear:gs_xml.

  clear:lv_tdid,lv_flag,lv_ebeln.
*  lv_tdid = 'F06'."Performance Bank Guarantee
  lv_ebeln = wa_polist-ebeln.
  perform read_standard_text using lv_ebeln gv_bg_objid changing lv_flag gv_sdtext.
  if lv_flag is not initial.
    concatenate '<BG_EXISTS>' 'true' '</BG_EXISTS>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.
  else.
    concatenate '<BG_EXISTS>' 'false' '</BG_EXISTS>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.
  endif.

  gv_desc = gv_sdtext.
  if not gv_desc is initial.
    perform replace_sym using gv_desc.
  endif.
  concatenate '<BG_TEXT>' gv_desc '</BG_TEXT>' into  gs_xml-line.
  append gs_xml to gt_xml.
  clear:gs_xml.

  if wa_polist-rettp is not initial.
    concatenate '<RETENTION_CLAUSE>' 'true'  '</RETENTION_CLAUSE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.
  else.
    concatenate '<RETENTION_CLAUSE>' 'false'  '</RETENTION_CLAUSE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.
  endif.

  gv_desc = wa_polist-rettp.
  if not gv_desc is initial.
    perform replace_sym using gv_desc.
  endif.
  concatenate '<RETENTION_TEXT>' gv_desc '</RETENTION_TEXT>' into  gs_xml-line.
  append gs_xml to gt_xml.
  clear:gs_xml.

*  read table gt_items into data(ps_items) with key ebeln = wa_polist-ebeln."index 1
**15.02.2022
  read table gt_items into data(ps_items) with key ebeln = wa_polist-ebeln loekz = ''."index 1
*****

  read table it_t001k into data(wa_t001k) with key bukrs = ps_items-bukrs bwkey = ps_items-werks.
  read table it_t001w into data(wa_t001w) with key werks = wa_t001k-bwkey.
  read table it_1bbranch into data(wa_lbbranch) with key bukrs = wa_t001k-bukrs branch = wa_t001w-j_1bbranch.
*  IF SY-SUBRC EQ 0.
*    DATA(LV_COMP_GST) = WA_LBBRANCH-GSTIN.
*  ENDIF.
*********************************************************************   ---- open for primary plant
  concatenate '<PRIMARY_PLANT>'  ps_items-werks  '</PRIMARY_PLANT>' into  gs_xml-line.
  append gs_xml to gt_xml.
  clear:gs_xml.
*********************************************************************  ----- close for primary plant
  concatenate '<COMP_GST>'    '</COMP_GST>' into  gs_xml-line. "LV_COMP_GST
  append gs_xml to gt_xml.
  clear:gs_xml,ps_items,wa_t001k,wa_t001w,wa_lbbranch. "LV_COMP_GST

********************
  clear:lv_status.
*  if ( (  wa_polist-frggr is not initial and wa_polist-frgrl is initial ) or ( wa_polist-frggr is initial ) ).
  perform po_status using wa_polist-ebeln lv_status.
*  elseif ( wa_polist-frggr is not initial and wa_polist-frgrl is not initial ).
*    lv_status = 'Not Released'.
*  endif.
  " describe table gt_items lines lv_delcount.
*  loop at gt_items into wa_items where ebeln = wa_polist-ebeln.
*    clear lv_inv_qty.
*    lv_delcount = lv_delcount + 1.
*    if wa_items-loekz is not initial.  "Deleted PO Items
*      lv_delcount1 = lv_delcount1 + 1.
*    else.
*      if wa_items-pstyp = '9'.
*        loop at gt_ekbe into wa_ekbe where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and bewtp = 'Q'.
*          lv_inv_amt = lv_inv_amt + wa_ekbe-dmbtr.
*        endloop.
*        if lv_inv_amt = wa_items-netwr.
*          lv_dlvry_cnt = lv_dlvry_cnt + 1.
*        endif.
*      elseif wa_items-elikz = 'X'.    "Delivery Completed
*        loop at gt_ekbe into wa_ekbe where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and bewtp = 'Q'.
*          lv_inv_qty = lv_inv_qty + wa_ekbe-menge.
*        endloop.
*        if lv_inv_qty = wa_items-menge.
*          lv_dlvry_cnt =  lv_dlvry_cnt + 1.
*        endif.
*      endif.
*    endif.
*    clear wa_items.
*  endloop.
*  clear lv_no_posf .
*  if lv_delcount <> lv_delcount1.
*    lv_delcount = lv_delcount - lv_delcount1.
*    if lv_delcount = lv_dlvry_cnt.      "Closed PO
*      concatenate '<STATUS>' 'Close' '</STATUS>' into  gs_xml-line.
*      append gs_xml to gt_xml.clear gs_xml.
*    else.
*      concatenate '<STATUS>' 'Open' '</STATUS>' into  gs_xml-line.
*      append gs_xml to gt_xml.clear gs_xml.
*    endif.
*  else.
*    lv_no_posf = 'X'.
*    concatenate '<STATUS>' 'Deleted' '</STATUS>' into  gs_xml-line.
*    append gs_xml to gt_xml.clear gs_xml.
*  endif.
  gv_desc = wa_usrlist-smtp_addr.
  if not gv_desc is initial.
    perform replace_sym using gv_desc.
  endif.

  concatenate '<STATUS>' lv_status '</STATUS>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<REQUESTOR>' gv_desc '</REQUESTOR>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

*  SELECT SINGLE * FROM LFA1 INTO LS_LFA1  WHERE LIFNR = WA_POLIST-LIFNR.
  clear:ls_lfa1.
  read table qt_lfa1 into ls_lfa1 with key lifnr = wa_polist-lifnr.
  lv_db_table = 'adrc'.
  select single * from (lv_db_table) into ls_adrc where addrnumber = ls_lfa1-adrnr. "#EC CI_NO_TRANSFORM

  write:wa_polist-lifnr to lv_supplierid.
  lt_lifnr-lifnr = wa_polist-lifnr.
  append lt_lifnr.clear lt_lifnr.

  if lv_supplierid ca lv_characters.

  else.
    shift lv_supplierid left deleting leading '0'.
  endif.

  concatenate '<SUPPLR_ID>' lv_supplierid '</SUPPLR_ID>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<LOCATION>' lv_location '</LOCATION>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.
  if lv_oa_clear is not initial.
  endif.

  clear:lv_erdat,lv_ezeit.
   lv_db_table = 'ekes'.
  SELECT SINGLE ERDAT
                     EZEIT
                     FROM (lv_db_table)
                     INTO (LV_ERDAT,LV_EZEIT)
                     WHERE EBELN = WA_POLIST-EBELN.  "#EC CI_SEL_NESTED

  concatenate '<ORDER_ACK_DATE>' lv_erdat '</ORDER_ACK_DATE>' into gs_xml-line. "WA_HEADER-Z_PO_ACK_DATE
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<ORDER_ACK_TIME>' lv_ezeit  '</ORDER_ACK_TIME>' into gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  clear gv_desc.
  if lv_erdat is initial.
    gv_desc = 'false'.
  else.
    gv_desc = 'true'.
  endif.

  condense gv_desc no-gaps.
  concatenate '<ORDER_ACK_STATUS>' gv_desc  '</ORDER_ACK_STATUS>' into gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '<RMT_ADDRESSES>'.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '<RMT_ADDRESS>'.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<REF_ID>' '</REF_ID>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  clear gv_desc.
  gv_desc =  ls_lfa1-name1.
  perform replace_sym using gv_desc.
  concatenate '<NAME>' gv_desc '</NAME>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.
  clear gv_desc.
  gv_desc = ls_adrc-name_co.                       "#EC CI_NO_TRANSFORM
  perform replace_sym using gv_desc.
  concatenate '<ADDRESS1>' gv_desc '</ADDRESS1>' into  gs_xml-line. "'MP 154.2'
  append gs_xml to gt_xml.clear gs_xml.

  clear gv_desc.
  gv_desc = ls_lfa1-stras.
  perform replace_sym using gv_desc.
  concatenate '<ADDRESS2>' gv_desc '</ADDRESS2>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<ADDRESS3>'  '</ADDRESS3>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  clear gv_desc.
  gv_desc = ls_lfa1-ort01.
  perform replace_sym using gv_desc.
  concatenate '<CITY>' gv_desc '</CITY>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<STATE>' ls_lfa1-regio '</STATE>' into  gs_xml-line. "WA_PARTNER1-REGION
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<CNTRY>' ls_lfa1-land1 '</CNTRY>' into  gs_xml-line. "WA_PARTNER1-COUNTRY
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<ZIP>' ls_lfa1-pstlz  '</ZIP>' into  gs_xml-line. "WA_PARTNER1-POSTL_COD1
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '</RMT_ADDRESS>'.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '</RMT_ADDRESSES>'.
  append gs_xml to gt_xml.clear gs_xml.
  clear wa_items.
  read table gt_items into wa_items with key ebeln = wa_polist-ebeln loekz = ''."index 1.
  perform get_delivery_address using ls_addr1_val.
  gs_xml-line = '<SHP_ADDRESSES>'.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '<SHP_ADDRESS>'.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<REF_ID>' '</REF_ID>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  clear gv_desc.
  gv_desc =  ls_addr1_val-name1.
  perform replace_sym using gv_desc.
  concatenate '<NAME>' gv_desc '</NAME>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  clear gv_desc.
  if ls_addr1_val-name_co is not initial.
    gv_desc = ls_addr1_val-name_co.
  else.
    gv_desc = ls_addr1_val-name2.
  endif.
  perform replace_sym using gv_desc.
  concatenate '<ADDRESS1>' gv_desc '</ADDRESS1>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  clear gv_desc.
  concatenate  ls_addr1_val-house_num1 ls_addr1_val-street into gv_desc separated by space.
  perform replace_sym using gv_desc.
  concatenate '<ADDRESS2>'  '</ADDRESS2>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<ADDRESS3>'   '</ADDRESS3>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  clear gv_desc.
  gv_desc = ls_addr1_val-city1.
  perform replace_sym using gv_desc.
  concatenate '<CITY>' gv_desc '</CITY>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<STATE>' ls_addr1_val-region '</STATE>' into  gs_xml-line. "WA_DET-REGION
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<CNTRY>' ls_addr1_val-country '</CNTRY>' into  gs_xml-line."WA_DET-COUNTRY
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<ZIP>' ls_addr1_val-post_code1 '</ZIP>' into  gs_xml-line."WA_DET-POSTL_COD1
  append gs_xml to gt_xml.clear gs_xml.

  clear gv_desc.
  gv_desc = ls_addr1_val-location.
  perform replace_sym using gv_desc.
  concatenate '<LOCATION>'  gv_desc '</LOCATION>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '</SHP_ADDRESS>'.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '</SHP_ADDRESSES>'.
  append gs_xml to gt_xml.clear gs_xml.

  read table gt_items into wa_items with key ebeln = wa_polist-ebeln.
  if wa_items-pstyp = '9'.
    concatenate '<PO_CATEGORY>' 'SES' '</PO_CATEGORY>' into  gs_xml-line."WA_DET-COUNTRY
    append gs_xml to gt_xml.clear gs_xml.
  else.
    if wa_items-wepos = 'X'.
      concatenate '<PO_CATEGORY>' 'GR' '</PO_CATEGORY>' into  gs_xml-line."WA_DET-COUNTRY
      append gs_xml to gt_xml.clear gs_xml.
    else.
      concatenate '<PO_CATEGORY>' 'NGR' '</PO_CATEGORY>' into  gs_xml-line."WA_DET-COUNTRY
      append gs_xml to gt_xml.clear gs_xml.
    endif.
  endif.
  if gv_blanket_value = wa_polist-bsart.
    concatenate '<BLANKET_PO>' 'true'  '</BLANKET_PO>' into  gs_xml-line."WA_DET-COUNTRY
    append gs_xml to gt_xml.clear gs_xml.
  else.
    concatenate '<BLANKET_PO>' 'false'  '</BLANKET_PO>' into  gs_xml-line."WA_DET-COUNTRY
    append gs_xml to gt_xml.clear gs_xml.
  endif.


  concatenate '<VALID_PERIOD>' wa_polist-kdate   '</VALID_PERIOD>' into  gs_xml-line.
  append gs_xml to gt_xml.clear:wa_items, gs_xml.


  loop at gt_items into wa_items where  ebeln = wa_polist-ebeln and werks ne ''  .
    exit.
  endloop.
  concatenate '<PLNT>' wa_items-werks '</PLNT>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '</HEADER>'.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<RESET_OA>' 'false' '</RESET_OA>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<RESET_ASN>' 'false' '</RESET_ASN>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  concatenate '<NOTIFY>' 'false' '</NOTIFY>' into  gs_xml-line.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '<LINEITEMS>'.
  append gs_xml to gt_xml.clear gs_xml.

  sort gt_items[] by ebelp.
  clear:wa_items.
  loop at gt_items into wa_items where ebeln = wa_polist-ebeln.

    gs_xml-line = '<LINEITEM>'.
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<PO_LNE>' wa_items-ebelp '</PO_LNE>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    shift wa_items-matnr left deleting leading '0'.
    clear gv_desc.
    gv_desc = wa_items-matnr.
    perform replace_sym using gv_desc.
    concatenate '<MAT_CODE>' gv_desc '</MAT_CODE>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear gv_desc.
    gv_desc = wa_items-txz01.
    perform replace_sym using gv_desc.
    concatenate '<MAT_DES>' gv_desc '</MAT_DES>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<HSN_CODE>' wa_items-j_1bnbm '</HSN_CODE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    clear lv_char.
****Order Unit & PO order unit is different - open
    if wa_items-bprme is not initial.
      if wa_items-bprme ne wa_items-meins.
        if ( wa_items-bpumz is not initial and wa_items-bpumn is not initial ).
          lv_char = ( wa_items-bpumz / wa_items-bpumn ) .
        endif.
      else.
        lv_char = wa_items-menge.
      endif.
    else.
      lv_char = wa_items-menge.
    endif.
********************************Close
    condense lv_char.
    concatenate '<PO_QTY>' lv_char '</PO_QTY>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear lv_char.
    lv_char = wa_items-netpr.
    condense lv_char.

    concatenate '<PO_UNT_PRCE>' lv_char '</PO_UNT_PRCE>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.
    clear lv_char.
    lv_char = wa_items-netwr.
    condense lv_char.
    concatenate '<NET_VALUE>' lv_char '</NET_VALUE>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.


****Order Unit & PO order unit is different - open
    if wa_items-bprme is not initial.
      if wa_items-bprme ne wa_items-meins.
        call function 'CONVERSION_EXIT_CUNIT_OUTPUT'
          exporting
            input          = wa_items-bprme
            language       = sy-langu
          importing
*           LONG_TEXT      =
            output         = wa_items-bprme
*           SHORT_TEXT     =
          exceptions
            unit_not_found = 1
            others         = 2.
        if sy-subrc <> 0.
        else.
          wa_items-meins = wa_items-bprme.
        endif.
      else.
        call function 'CONVERSION_EXIT_CUNIT_OUTPUT'
          exporting
            input          = wa_items-meins
            language       = sy-langu
          importing
*           LONG_TEXT      =
            output         = wa_items-meins
*           SHORT_TEXT     =
          exceptions
            unit_not_found = 1
            others         = 2.
        if sy-subrc <> 0.
        endif.
      endif.
    else.
      call function 'CONVERSION_EXIT_CUNIT_OUTPUT'
        exporting
          input          = wa_items-meins
          language       = sy-langu
        importing
*         LONG_TEXT      =
          output         = wa_items-meins
*         SHORT_TEXT     =
        exceptions
          unit_not_found = 1
          others         = 2.
      if sy-subrc <> 0.
      endif.
    endif.

    clear: gt_tax_output,gv_tax_input.refresh gt_tax_output.
    if gv_sf_taxfm is not initial and wa_items-mwskz is not initial.

      gv_tax_input-ebeln = wa_items-ebeln.
      gv_tax_input-ebelp = wa_items-ebelp.
      gv_tax_input-item_amount = wa_items-netwr.
      gv_tax_input-mwskz = wa_items-mwskz.
      call function gv_sf_taxfm
        exporting
          i_tax_input   = gv_tax_input
        tables
          t_tax_details = gt_tax_output
        exceptions
          no_data_found = 1
          others        = 2.
      if sy-subrc <> 0.
* Implement suitable error handling here
      endif.
    endif.
    clear:gt_tax_output.
    read table gt_tax_output index 1.

    concatenate '<TAX_CODE>' gt_tax_output-mwskz '</TAX_CODE>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear:gv_desc.
    read table gt_t007s into data(gs_t007s) with key mwskz = gt_tax_output-mwskz.
    if sy-subrc eq 0.
      gv_desc = gs_t007s-text1.
      perform replace_sym using gv_desc.
    endif.
    concatenate '<TAXID_DES>' gv_desc '</TAXID_DES>' into  gs_xml-line.
    append gs_xml to gt_xml.clear: gs_xml,gs_t007s,gv_desc.

    clear lv_tax_per.
    lv_tax_per = gt_tax_output-total_per.
    condense lv_tax_per no-gaps.

    condense lv_tax_per no-gaps.
    concatenate '<TAX_PRCNTG>' lv_tax_per '</TAX_PRCNTG>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear lv_tax_per.
    lv_tax_per = gt_tax_output-total_tax.
    condense lv_tax_per no-gaps.
    concatenate '<TAX_AMT>' lv_tax_per '</TAX_AMT>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear lv_tax_per.
    lv_tax_per = gt_tax_output-frght_amt.
    condense lv_tax_per no-gaps.
    concatenate '<FRGHT_AMT>' lv_tax_per '</FRGHT_AMT>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear wa_t163y.
    read table lt_t163y into wa_t163y with key pstyp = wa_items-pstyp.
    concatenate '<ITM_CAT>' wa_t163y-epstp '</ITM_CAT>' into  gs_xml-line.
    append gs_xml to gt_xml.clear: gs_xml,wa_ekbe,wa_t163y.

    clear gv_desc.
    gv_desc = wa_t163y-ptext.
    perform replace_sym using gv_desc.
    concatenate '<ITM_CAT_DES>' gv_desc '</ITM_CAT_DES>' into  gs_xml-line.
    append gs_xml to gt_xml.clear: gs_xml,wa_ekbe.

    read table gt_ekbe into wa_ekbe with key ebeln = wa_items-ebeln ebelp = wa_items-ebelp vgabe = '4'.
    if sy-subrc eq 0.
      concatenate '<ADV_PAY_EXIST>' 'true' '</ADV_PAY_EXIST>' into  gs_xml-line.
      append gs_xml to gt_xml.clear gs_xml.
    else.
      concatenate '<ADV_PAY_EXIST>' 'false' '</ADV_PAY_EXIST>' into  gs_xml-line.
      append gs_xml to gt_xml.clear gs_xml.
    endif.

    concatenate '<PO_UOM>' wa_items-meins '</PO_UOM>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<PER_UOM>' wa_items-meins '</PER_UOM>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear lv_char.
    lv_char = wa_items-peinh.
    condense lv_char no-gaps.

    concatenate '<PER>' lv_char '</PER>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<PLANT>' wa_items-werks '</PLANT>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<SLOCATION>' wa_items-lgort '</SLOCATION>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear gv_desc.
    concatenate '<SPARTNO>' gv_desc '</SPARTNO>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear wa_eket.
    read table gt_eket into wa_eket with key ebeln = wa_items-ebeln ebelp = wa_items-ebelp.

    concatenate '<DLVRY_DATE>' wa_eket-eindt '</DLVRY_DATE>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear lv_char.
    condense lv_char.
    concatenate '<DIS_AMT>' lv_char '</DIS_AMT>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    if wa_items-webre is not initial.
      concatenate '<GRN_REQUIRED>' 'true' '</GRN_REQUIRED>' into  gs_xml-line.
      append gs_xml to gt_xml.clear gs_xml.
    elseif  wa_items-webre is initial.
      concatenate '<GRN_REQUIRED>' 'false' '</GRN_REQUIRED>' into  gs_xml-line.
      append gs_xml to gt_xml.clear gs_xml.
    endif.

    clear:gv_desc.
    gv_desc = wa_items-mfrpn.
    perform replace_sym using gv_desc.

    concatenate '<MNFC_PART>' gv_desc '</MNFC_PART>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.


    if wa_items-elikz is not initial.
      concatenate '<DELIVERY_COMP_IND>' 'true' '</DELIVERY_COMP_IND>' into  gs_xml-line.
      append gs_xml to gt_xml.clear gs_xml.
    else.
      concatenate '<DELIVERY_COMP_IND>' 'false' '</DELIVERY_COMP_IND>' into  gs_xml-line.
      append gs_xml to gt_xml.clear gs_xml.
    endif.

    if wa_items-loekz is not initial."wa_items-elikz is not initial.
      concatenate '<DELETED>' 'true' '</DELETED>' into  gs_xml-line.
      append gs_xml to gt_xml.clear gs_xml.
    else.
      concatenate '<DELETED>' 'false' '</DELETED>' into  gs_xml-line.
      append gs_xml to gt_xml.clear gs_xml.
    endif.

    perform get_delivery_address using ls_addr1_val.

    gs_xml-line = '<SHIP_TO_ADDRESS>'.
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<REF_ID>' '</REF_ID>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear gv_desc.
    gv_desc =  ls_addr1_val-name1.
    perform replace_sym using gv_desc.
    concatenate '<NAME>' gv_desc '</NAME>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear gv_desc.
    if ls_addr1_val-name_co is not initial.
      gv_desc = ls_addr1_val-name_co.
    else.
      gv_desc = ls_addr1_val-name2.
    endif.
    perform replace_sym using gv_desc.
    concatenate '<ADDRESS1>' gv_desc '</ADDRESS1>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear gv_desc.
    concatenate  ls_addr1_val-house_num1 ls_addr1_val-street into gv_desc separated by space.
    perform replace_sym using gv_desc.
    concatenate '<ADDRESS2>'  '</ADDRESS2>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<ADDRESS3>'   '</ADDRESS3>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    clear gv_desc.
    gv_desc = ls_addr1_val-city1.
    perform replace_sym using gv_desc.
    concatenate '<CITY>' gv_desc '</CITY>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<STATE>' ls_addr1_val-region '</STATE>' into  gs_xml-line. "WA_DET-REGION
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<CNTRY>' ls_addr1_val-country '</CNTRY>' into  gs_xml-line."WA_DET-COUNTRY
    append gs_xml to gt_xml.clear gs_xml.

    concatenate '<ZIP>' ls_addr1_val-post_code1 '</ZIP>' into  gs_xml-line."WA_DET-POSTL_COD1
    append gs_xml to gt_xml.clear gs_xml.

    clear gv_desc.
    gv_desc = ls_addr1_val-location.
    perform replace_sym using gv_desc.
    concatenate '<LOCATION>'  gv_desc '</LOCATION>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.

    gs_xml-line = '</SHIP_TO_ADDRESS>'.
    append gs_xml to gt_xml.clear gs_xml.

    read table gt_esuh into wa_esuh with  key packno = wa_items-packno.
    clear gv_desc.
    gv_desc = wa_esuh-sumlimit.
    condense gv_desc no-gaps.
    concatenate '<UPPER_LIMIT_AMT>' gv_desc  '</UPPER_LIMIT_AMT>' into  gs_xml-line.
    append gs_xml to gt_xml.clear gs_xml.
    clear: wa_esuh.



    gs_xml-line = '</LINEITEM>'.
    append gs_xml to gt_xml.clear gs_xml.
    clear:wa_items.
  endloop.

  gs_xml-line = '</LINEITEMS>'.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '<ATTCHMNTS>'.
  append gs_xml to gt_xml.
  clear gs_xml.

  loop at it_toa01 into data(wa_toa01) where object_id = wa_polist-ebeln.

    gs_xml-line = '<ATTCHMNT>'.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<AR_ID>' wa_toa01-archiv_id '</AR_ID>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<AR_DOCID>' wa_toa01-arc_doc_id '</AR_DOCID>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<VERSION_NO>' ''  '</VERSION_NO>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<VERSION_TYPE>' '' '</VERSION_TYPE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    clear:gv_desc.
    gv_desc =  |PO_{ wa_polist-ebeln }|.
    perform replace_sym using gv_desc.

    concatenate '<FL_NAME>' gv_desc  '</FL_NAME>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    wa_toa01-reserve = to_lower( wa_toa01-reserve ).
    concatenate '<FL_TYPE>' wa_toa01-reserve  '</FL_TYPE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<CR_DATE>' wa_toa01-ar_date '</CR_DATE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<CR_TIME>' '' '</CR_TIME>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<CREATOR>' '' '</CREATOR>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<DOC_TYPE>' wa_toa01-ar_object '</DOC_TYPE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<UPLOAD>' '' '</UPLOAD>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<DOC_EXPIRY_DATE>' '' '</DOC_EXPIRY_DATE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<DOC_EXPIRY_TIME>' ''  '</DOC_EXPIRY_TIME>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    gs_xml-line = '</ATTCHMNT>'.
    append gs_xml to gt_xml.
    clear:wa_toa01,gs_xml.
  endloop.

  gs_xml-line = '</ATTCHMNTS>'.
  append gs_xml to gt_xml.
  clear gs_xml.

  gs_xml-line = '<ORIGINAL_DOCUMENTS>'.
  append gs_xml to gt_xml.clear gs_xml.

  if gv_sf_fmname is not initial.
    perform get_attachments."po smartform's
  endif.

  loop at it_po_sf into wa_po_sf.
    gs_xml-line = '<ORIGINAL_DOCUMENT>'.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<AR_ID>'  wa_po_sf-arc_id '</AR_ID>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<AR_DOCID>' wa_po_sf-arc_docid '</AR_DOCID>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<VERSION_NO>' '' '</VERSION_NO>' into  gs_xml-line."lv_char
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<VERSION_TYPE>' '' '</VERSION_TYPE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<FL_NAME>' wa_po_sf-file_name '</FL_NAME>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<FL_TYPE>' wa_po_sf-file_type '</FL_TYPE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<CREATED_DATE>' sy-datum '</CREATED_DATE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<CREATED_TIME>' sy-uzeit '</CREATED_TIME>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<CREATOR>'  '</CREATOR>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<DOC_TYPE>' 'PO_SFDOC' '</DOC_TYPE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<UPLOAD>'  '</UPLOAD>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<DOC_EXPIRY_DATE>' '</DOC_EXPIRY_DATE>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    concatenate '<DOC_EXPIRY_TIME>'  '</DOC_EXPIRY_TIME>' into  gs_xml-line.
    append gs_xml to gt_xml.
    clear gs_xml.

    gs_xml-line = '</ORIGINAL_DOCUMENT>'.
    append gs_xml to gt_xml.
    clear:wa_po_sf,gs_xml.
  endloop.

  gs_xml-line = '</ORIGINAL_DOCUMENTS>'.
  append gs_xml to gt_xml.clear gs_xml.

  gs_xml-line = '</PO_DATA>'.
  append gs_xml to gt_xml.clear gs_xml.

endform.
*&---------------------------------------------------------------------*
*&      Form  GET_URL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_url .
  clear gv_url_str.
  concatenate gv_server '/' p_ext into gv_url_str.
endform.
*&---------------------------------------------------------------------*
*&      Form  UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_URL  text
*      -->P_GV_TOKEN  text
*      <--P_gV_SUBRC  text
*----------------------------------------------------------------------*
form update  using    p_url
                      p_token
             changing p_subrc.

  data:gv_xml_str type string,
       gv_res_str type string,
       gv_xmlcnt  type i.

  clear :gv_xml_str,gv_xmlcnt.
  describe table gt_xml[] lines gv_xmlcnt.
  loop at gt_xml into gs_xml.
    concatenate gv_xml_str gs_xml into gv_xml_str.
  endloop.

****FOR PUSHING DATA TO APPLICATION SERVER
  if not gv_data_to_file is initial.
    data lv_flag1 type flag.
    call function '/SDOCS/S1_FTP_SAP_TO_EXTERNALN'
      exporting
*       i_fname     =     " Char255
*       i_profile   =
        i_prog_name = sy-cprog    " CALL program
*       i_sec       =     " General Flag
        i_ftp       = space   " 'X' means data push to FTP servevr
      importing
        e_success   = lv_flag1   " General Flag
      tables
        i_data      = gt_xml.
********  END OF
  else.
    if p_token is initial.
      p_token = 'notoken'.
    endif.

    if gv_xmlcnt > '2'.
      call function '/SDOCS/SSPAY_HTTP_POST_N'
        exporting
          i_profile            = p_profle
          i_ext                = p_ext
          i_input_xml          = gv_xml_str
          i_token_flg          = ''
          i_input_method       = 'POST'
        importing
          e_success            = gv_success
          e_result             = gv_res_str
          e_scode              = gv_scode
          e_stext              = gv_stext
        changing
          c_token_id           = p_token
        exceptions
          ex_internal_error    = 1
          ex_connection_failed = 2
          others               = 3.
      if gv_res_str ca 'INVALID_XML'.
        gv_http_sflag = 'X'.
        write:/2 'Job run date & time:' color 3,26 sy-datum color 3,38 sy-uzeit color 3.
        skip 1.
        message s000(/sdocs/sspay_msg) with 'Invalid XML!'.
        write:/2 'PO data sync failed'.
        loop at po_dis.
          write:/2 po_dis-ebeln.
          clear:po_dis.
        endloop.

      elseif gv_scode = '200' or gv_scode = '201'.
        loop at po_dis.
          if gv_flag is initial.
            gv_flag = 'X'.
            write:/2 'Job run date & time:' color 3,26 sy-datum color 3,38 sy-uzeit color 3.
            skip 1.
            write:/2 'PO dispatched successfully for :',po_dis-ebeln.
          else.
            write:/35 po_dis-ebeln.
          endif.
        endloop.
      endif.
    endif.
  endif.

  refresh:po_dis[].
endform.
*&---------------------------------------------------------------------*
*&      Form  PORTAL_AUTHITICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form portal_authitication.

*CONCATENATE GV_SERVER  '/' P_TK_EXT INTO GV_URL_STR.
  clear:wa_profile.
  select single * from /sdocs/sspy_sprf into wa_profile where profile_id = p_profle.

  if wa_profile is not initial.
    do p_retry times.
      call function '/SDOCS/SSPAY_HTTP_GET_N'
        exporting
          i_profile            = p_profle
          i_ext                = p_tk_ext
          i_input_xml          = ''
          i_token_flg          = 'X'
          i_input_method       = 'GET'
        importing
          e_success            = gv_success
          e_result             = gv_res_str
          e_scode              = gv_scode
          e_stext              = gv_stext
        changing
          c_token_id           = gv_token
        exceptions
          ex_internal_error    = 1
          ex_connection_failed = 2
          others               = 3.
      if gv_token is not initial.
        exit.
      endif.
    enddo.
  endif.

  if gv_token is initial.
    message s000(/sdocs/sspay_msg) with gv_res_str.
    write:/ gv_res_str.
    exit.
  endif.
endform.                    " PORTAL_AUTHITICATION
*&---------------------------------------------------------------------*
*&      Form  REPLACE_SYM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_DESC  text
*----------------------------------------------------------------------*
form replace_sym  using    p_gv_desc.
  gv_sym_k = 0.clear :gv_sym_s_str,gv_str_len.
  gv_str_len = strlen( p_gv_desc ).
  conv = cl_abap_conv_out_ce=>create( encoding = 'UTF-8'
                                        endian   = 'L'
                                        ignore_cerr = 'X'
                                        replacement = '#' ).
  do gv_str_len times.
    clear: gv_sym_str,gv_ch.
    gv_ch = p_gv_desc+gv_sym_k(1).
    case gv_ch.
      when ''.
        concatenate gv_sym_str '%20' into gv_sym_str.
      when '<'.
        concatenate gv_sym_str '&lt;' into gv_sym_str.
      when '>'.
        concatenate gv_sym_str '&gt;' into gv_sym_str.
      when ''''.
        concatenate gv_sym_str '&apos;' into gv_sym_str.
      when '"'.
        concatenate gv_sym_str '&quot;' into gv_sym_str.
      when '&'.
        concatenate gv_sym_str '&amp;' into gv_sym_str.
      when others.
        clear:gv_buffer,gv_buffer1,gv_int1,gv_int,gv_ch1.
        gv_ch1 = gv_ch.
        call method conv->write( data = gv_ch ).
        gv_buffer = conv->get_buffer( ).
        gv_buffer1 = gv_buffer.
        concatenate '0x' gv_buffer1 into gv_buffer1.
        condense gv_buffer1.
        if gv_buffer1 > '0x7E'.
          try.
              call method cl_abap_conv_out_ce=>uccpi
                exporting
                  char = gv_ch1
                receiving
                  uccp = gv_int.
            catch cx_sy_codepage_converter_init .
            catch cx_sy_conversion_codepage .
            catch cx_parameter_invalid_range .
          endtry.
          gv_int1 = gv_int.
          concatenate '&#' gv_int1 ';' into gv_sym_str.
          condense gv_sym_str no-gaps.
        else.
          gv_sym_str = gv_ch1.
        endif.
        call method conv->reset( ).
    endcase.
    concatenate gv_sym_s_str gv_sym_str into gv_sym_s_str.
    gv_sym_k = gv_sym_k + 1.
  enddo.
  p_gv_desc = gv_sym_s_str.

endform.                    "REPLACE_SYM
*&---------------------------------------------------------------------*
*&      Form  GET_ATTACH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_ATTACH  text
*----------------------------------------------------------------------*
form get_attachments.

  clear:wa_po_sf.
*  if wa_polist-ebeln is not initial and gv_sf_fmname is not initial .
*    call function gv_sf_fmname
*      exporting
*        i_ebeln      = wa_polist-ebeln
*      tables
*        et_posf      = it_po_sf[]
*      exceptions
*        sf_not_found = 1.
*  endif.
endform.                    " GET_ATTACH
*&---------------------------------------------------------------------*
*&      Form  GET_DELIVERY_ADDRESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_ADDR1_VAL  text
*----------------------------------------------------------------------*
form get_delivery_address using ls_addr1_val.
  data: g_address_number  like adrc-addrnumber,
        g_address_handle  like szad_field-handle,
        g_nation          like adrc-nation,
        g_date_from       like adrc-date_from,
        address_selection like addr1_sel,
*       ls_addr1_val    type addr1_val,
        ls_ad1_flags      type ad1_flags,
        ls_addr1_text     type addr1_text.

  clear:g_address_number,g_address_handle,ls_addr1_val.

  if wa_items-adrnr is initial and wa_items-werks is not initial.
    lv_db_table = 't001w'.
    select single adrnr from (lv_db_table) into wa_items-adrnr where werks = wa_items-werks.
  endif.

  if wa_items-adrnr is not initial.
    g_address_number = wa_items-adrnr.
    lv_db_table = 'adrc'.
    select single date_from from (lv_db_table) into address_selection-date where addrnumber = wa_items-adrnr.
  else.
    concatenate 'T001W' wa_items-werks into g_address_handle.
  endif.

  move g_address_number   to  address_selection-addrnumber .
  move g_address_handle   to  address_selection-addrhandle .

  if address_selection-date is initial.
    address_selection-date  = '00010101'.
  endif.

  clear gv_desc.

  if address_selection is not initial.
*    call function 'ADDR_GET'
*      exporting
*        address_selection = address_selection
*      importing
*        address_value     = ls_addr1_val
*      exceptions
*        parameter_error   = 01
*        address_not_exist = 02
*        version_not_exist = 03
*        internal_error    = 04
*        others            = 99.
    lv_db_table = 'adrc'.
    select single * from (lv_db_table) into CORRESPONDING FIELDS OF ls_addr1_val where addrnumber = address_selection-addrnumber.
  endif.
endform.                    " GET_DELIVERY_ADDRESS
*&---------------------------------------------------------------------*
*&      Form  PUSH_DATA_TO_PORTAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form push_data_to_portal.
  perform prepare_po_xml.
endform.                    " PUSH_DATA_TO_PORTAL
*&---------------------------------------------------------------------*
*&      Form  PREPARE_PO_XML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form prepare_po_xml.
 data : lv_db_table type char50.
  if gt_polist[] is not initial.
    clear:gv_cnt.
    describe table gt_polist[] lines gv_cnt.

    if gv_cnt gt p_bsize.
      gv_div = ( gv_cnt / p_bsize ).
      gv_mod = ( gv_cnt mod p_bsize ).
      if gv_mod => 1.
        gv_div = gv_div + 1.
      endif.
    else.
      gv_div = 1.
    endif.

    do gv_div times.
      gv_from = gv_to + 1.
      gv_to   = gv_from + p_bsize - 1.

      refresh: gt_xml[].
      clear gv_http_sflag.
      gs_xml-line = '<PO_DATA_TRANSMIT>'.
      append gs_xml to gt_xml.clear:gs_xml.

      loop at gt_polist into wa_polist from gv_from to gv_to.
        clear:gv_po_crdate,gv_noemail_notif.
        perform generate_xml.
        clear: wa_polist.
      endloop.
      gs_xml-line = '</PO_DATA_TRANSMIT>'.
      append gs_xml to gt_xml.clear gs_xml.

      perform get_url.
      perform update using gv_uri gv_token changing gv_subrc.
    enddo.
    if p_delta is not initial and   gv_http_sflag is initial.
      wa_job_slog-prog_name = '/SDOCS/SSPAY_PO_DATA_DISPATCH'.
      wa_job_slog-prog_type = 'HTTP_CALL'.
      wa_job_slog-jlog_date    = gv_curr_date.
      wa_job_slog-jlog_time    = gv_curr_time.
      lv_db_table = '/SDOCS/SSPY_JLOG'.
      modify (lv_db_table) from wa_job_slog.
    endif.
  endif.

  if lt_lifnr[] is not initial.
    sort lt_lifnr[] by lifnr.
    delete adjacent duplicates from lt_lifnr[] comparing lifnr.
  endif.
endform.                    " PREPARE_PO_XML
*&---------------------------------------------------------------------*
*& Form GET_JOB_INTERVAL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form get_job_interval .

  clear wa_job_slog.
  lv_db_table = '/sdocs/sspy_jlog'.
  select single * from (lv_db_table) into wa_job_slog where prog_name = '/SDOCS/SSPAY_PO_DATA_DISPATCH'
                                                          and prog_type = 'HTTP_CALL'.
  if sy-subrc eq 0 and wa_job_slog-jlog_date is not initial and wa_job_slog-jlog_time  is not initial.

    if  wa_job_slog-jlog_date <> sy-datum.
      lr_date-low = wa_job_slog-jlog_date.
      lr_date-high = wa_job_slog-jlog_date.
      lr_date-option = 'BT'.
      lr_date-sign   = 'I'.
      append lr_date.
      lr_time-low = wa_job_slog-jlog_time.
      lr_time-high = '235959'.
      lr_time-option = 'BT'.
      lr_time-sign   = 'I'.
      append lr_time.
    endif.

    lr_date-low = wa_job_slog-jlog_date.
    lr_date-high = sy-datum.
    lr_date-option = 'BT'.
    lr_date-sign   = 'I'.
    append lr_date.
    if wa_job_slog-jlog_date <> sy-datum.
      wa_job_slog-jlog_time = '000000'.
    endif.
    lr_time-low = wa_job_slog-jlog_time.
    lr_time-high = sy-uzeit.
    lr_time-option = 'BT'.
    lr_time-sign   = 'I'.
    append lr_time.
  else.
    lr_date-low = sy-datum.
    lr_date-high = sy-datum.
    lr_date-option = 'BT'.
    lr_date-sign   = 'I'.
    append lr_date.
    lr_time-low = '000000'."( sy-uzeit - 1200 ).
    lr_time-high = sy-uzeit.
    lr_time-option = 'BT'.
    lr_time-sign   = 'I'.
    append lr_time.
  endif.
  gv_curr_date = lr_date-high.
  gv_curr_time = lr_time-high.
endform.
*&---------------------------------------------------------------------*
*& Form read_standard_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> WA_POLIST_EBELN
*&      --> LV_TDID
*&---------------------------------------------------------------------*
form read_standard_text  using  p_ebeln like thead-tdname
                                p_tdid  like thead-tdid
                         changing p_flag gv_sdtext.
  refresh:t_lines[].
  clear:p_flag,gv_sdtext.
  if p_tdid is not initial and p_ebeln is not initial.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = p_tdid
        language                = sy-langu
        name                    = p_ebeln
        object                  = 'EKKO'
      tables
        lines                   = t_lines[]
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
  endif.

  if t_lines[] is not initial.
    p_flag = 'X'.
    loop at t_lines into l_lines.
      concatenate gv_sdtext l_lines-tdline into gv_sdtext separated by space.
      clear l_lines.
    endloop.
  else.
    p_flag = ''.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  PO_OPN_STATUS_PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form po_opn_status_process .
  data:begin of lt_sqty occurs 0,
         packno type esll-packno,
         introw type  esll-introw,
         menge  type esll-menge,
       end of lt_sqty.
  data:lv_menge1   type ekpo-menge,
       lv_menge    type ekpo-menge,
       lv_inv_qty  type ekpo-menge,
       lv_packno   type esll-packno,
       lv_del      type i,
       lv_del1     type i,
       l_lines     type i,
       lv_tabix1   type sy-tabix,
       lv_tabix    type sy-tabix,
       lv_qty_esll type esll-menge,
       lv_inv_opn,
       lv_inv_comp,
       lv_inv_del.
 types : begin of ty_essr,
        packno type PACKNO,
       end of ty_essr.
  data: lt_essr type table of ty_essr.
  types : begin of ty_esll,
        sub_packno type SUB_PACKNO,
       end of ty_esll.
    data : lt_esll type table of ty_esll.
  types : begin of ty_temp_esll,
        packno type packno,
        menge type mengev ,
    end of ty_temp_esll.
    data : it_temp_esll type table of ty_temp_esll.
  clear:lv_menge1,lv_menge,lv_inv_qty,lv_inv_opn,lv_inv_comp,lv_inv_del,lv_del1,lv_del,l_lines,lv_qty_esll.
  loop at gt_polist into wa_polist.
    clear:lv_del, lv_del1.
    loop at gt_items into wa_items where ebeln = wa_polist-ebeln ."AND loekz = ' ' .
      lv_del = lv_del + 1.
      if wa_items-loekz is initial.
        if wa_items-pstyp = '9'.
          clear:lv_packno,lt_sqty,wa_items-menge,l_lines,lv_qty_esll.
          refresh lt_sqty[].
          lv_db_table = 'esll'.
          select single sub_packno from (lv_db_table) into lv_packno where packno = wa_items-packno.
           lv_db_table = 'essr'.
          select packno from (lv_db_table) into table @lt_essr where ebeln = @wa_polist-ebeln and ebelp = @wa_items-ebelp. "#EC CI_GENBUFF
          describe table lt_essr[] lines l_lines.
          if lt_essr[] is not initial.
              lv_db_table = 'esll'.
            select sub_packno from (lv_db_table) into table @lt_esll for all entries in @lt_essr[] where packno = @lt_essr-packno.
          endif.
          if lt_esll[] is not initial.
              lv_db_table = 'esll'.
            select packno, menge from (lv_db_table) into table @it_temp_esll for all entries in @lt_esll[] where packno = @lt_esll-sub_packno.
          endif.
          loop at it_temp_esll into data(wa_temp_esll).
            lv_qty_esll = lv_qty_esll + wa_temp_esll-menge.
          endloop.

          if lv_packno is not initial.
            lv_db_table = 'esll'.
            select packno introw menge into table lt_sqty from (lv_db_table) where packno = lv_packno.
          endif.

          loop at lt_sqty .
            wa_items-menge = wa_items-menge +  lt_sqty-menge.
          endloop.
          clear:lv_tabix1,lv_tabix.
          loop at gt_ekbe1 into wa_ekbe1 where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and shkzg = 'S'."Invoice Processed
            lv_tabix1 = lv_tabix1 + 1.
*            lv_menge = wa_ekbe1-menge + lv_menge.
          endloop.

          loop at gt_ekbe1 into wa_ekbe1 where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and shkzg = 'H'."Invoice Reversed
            lv_tabix = lv_tabix + 1.
*            lv_menge1 = wa_ekbe1-menge + lv_menge1.
          endloop.
          if lv_tabix > 0.
            lv_tabix1 = lv_tabix1 - lv_tabix.
          endif.
          if ( wa_items-menge = lv_qty_esll and lv_tabix1 eq l_lines ).
            lv_inv_comp = 'X'.
          else.
            lv_inv_opn = 'X'.
          endif.
          continue.
        endif.

        if wa_items-erekz is initial.
          loop at gt_ekbe1 into wa_ekbe1 where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and shkzg = 'S'."Invoice Processed
            lv_menge = wa_ekbe1-menge + lv_menge.
          endloop.
          loop at gt_ekbe1 into wa_ekbe1 where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and shkzg = 'H'."Invoice Reversed
            lv_menge1 = wa_ekbe1-menge + lv_menge1.
          endloop.
          if lv_menge1  > 0.
            lv_inv_qty = lv_menge - lv_menge1.
          else.
            lv_inv_qty = lv_menge.
          endif.
          if lv_inv_qty = wa_items-menge.
            lv_inv_comp = 'X'.
          else.
            lv_inv_opn = 'X'.
            clear :lv_inv_comp.
            exit.
          endif.
        else.
          lv_inv_comp = 'X'.
        endif.
      else.
        lv_del1 = lv_del1 + 1.
      endif.
      clear:lv_menge,lv_menge1.
    endloop.

    if lv_inv_opn = 'X'.
    elseif (  lv_del1 = lv_del or lv_inv_comp = 'X' ).
      delete gt_polist where ebeln = wa_polist-ebeln.
    endif.
    clear:lv_inv_opn,lv_inv_comp,lv_menge,lv_menge1,lv_del, lv_del1.
  endloop.
  refresh:lt_sqty[],lt_essr,lt_esll,it_temp_esll[].
endform.                    " PO_OPN_STATUS_PROCESS
*&---------------------------------------------------------------------*
*&      Form  PO_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_POLIST_EBELN  text
*      -->P_L_STATUS  text
*----------------------------------------------------------------------*
form po_status  using    p_ebeln
                         p_status.
  data:begin of lt_sqty occurs 0,
         packno type esll-packno,
         introw type  esll-introw,
         menge  type esll-menge,
       end of lt_sqty.

  data:lv_menge1   type ekpo-menge,
       lv_menge    type ekpo-menge,
       lv_inv_qty  type ekpo-menge,
       lv_packno   type esll-packno,
       lv_qty_esll type esll-menge,
       lv_tabix1   type i,
       lv_tabix    type i,
       lv_del      type i,
       lv_del1     type i,
       lv_inv_opn,
       lv_inv_comp,
       lv_inv_del.
   types : begin of ty_essr,
        packno type PACKNO,
       end of ty_essr.
  data: lt_essr type table of ty_essr.
  types : begin of ty_temp_esll,
     packno type packno,
    menge type mengev,
    end of ty_temp_esll.
    data : it_temp_esll type table of ty_temp_esll.
types : begin of ty_esll,
      sub_packno type sub_packno,
     end of ty_esll.
   data : lt_esll type table of  ty_esll.
  clear:lv_menge1,lv_menge,lv_inv_qty,lv_inv_opn,lv_inv_comp,lv_inv_del,lv_del1,lv_del,lv_packno.
  loop at gt_items into wa_items where ebeln = p_ebeln ."AND loekz = ' ' .
    lv_del = lv_del + 1.
    if wa_items-loekz is initial.
      if wa_items-pstyp = '9'.
        clear:lv_packno,lt_sqty,wa_items-menge,l_lines,lv_qty_esll.
        refresh lt_sqty[].
        lv_db_table = 'esll'.
        select single sub_packno from (lv_db_table) into lv_packno where packno = wa_items-packno.
          lv_db_table = 'essr'.
        select packno from (lv_db_table) into table @lt_essr where ebeln = @wa_polist-ebeln and ebelp = @wa_items-ebelp. "#EC CI_GENBUFF
        describe table lt_essr[] lines l_lines.
        if lt_essr[] is not initial.
          lv_db_table = 'esll'.
          select sub_packno from (lv_db_table) into table @lt_esll for all entries in @lt_essr[] where packno = @lt_essr-packno.
        endif.
        if lt_esll[] is not initial.
          lv_db_table = 'esll'.
          select packno, menge from (lv_db_table) into table @it_temp_esll for all entries in @lt_esll[] where packno = @lt_esll-sub_packno.
        endif.
        loop at it_temp_esll into data(wa_temp_esll).
          lv_qty_esll = lv_qty_esll + wa_temp_esll-menge.
        endloop.

        if lv_packno is not initial.
          lv_db_table = 'esll'.
          select packno introw menge into table lt_sqty from (lv_db_table) where packno = lv_packno.
        endif.

        loop at lt_sqty .
          wa_items-menge = wa_items-menge +  lt_sqty-menge.
        endloop.
        clear:lv_tabix1,lv_tabix.
        loop at gt_ekbe1 into wa_ekbe1 where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and shkzg = 'S'."Invoice Processed
          lv_tabix1 = lv_tabix1 + 1.
*            lv_menge = wa_ekbe1-menge + lv_menge.
        endloop.

        loop at gt_ekbe1 into wa_ekbe1 where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and shkzg = 'H'."Invoice Reversed
          lv_tabix = lv_tabix + 1.
*            lv_menge1 = wa_ekbe1-menge + lv_menge1.
        endloop.
        if lv_tabix > 0.
          lv_tabix1 = lv_tabix1 - lv_tabix.
        endif.
        if ( wa_items-menge = lv_qty_esll and lv_tabix1 eq l_lines ).
          lv_inv_comp = 'X'.
        else.
          lv_inv_opn = 'X'.
        endif.
        continue.
      endif.

      if wa_items-erekz is initial.
        loop at gt_ekbe1 into wa_ekbe1 where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and shkzg = 'S'."Invoice Processed
          lv_menge = wa_ekbe1-menge + lv_menge.
        endloop.
        loop at gt_ekbe1 into wa_ekbe1 where ebeln = wa_items-ebeln and ebelp = wa_items-ebelp and shkzg = 'H'."Invoice Reversed
          lv_menge1 = wa_ekbe1-menge + lv_menge1.
        endloop.
        if lv_menge1  > 0.
          lv_inv_qty = lv_menge - lv_menge1.
        else.
          lv_inv_qty = lv_menge.
        endif.
        if lv_inv_qty = wa_items-menge.
          lv_inv_comp = 'X'.
        else.
          lv_inv_opn = 'X'.
          clear :lv_inv_comp.
          exit.
        endif.
      else.
        lv_inv_comp = 'X'.
      endif.
    else.
      lv_del1 = lv_del1 + 1.
    endif.
    clear:lv_menge,lv_menge1.
  endloop.

  if lv_del1 = lv_del.
    p_status  = 'Deleted'.
  elseif lv_inv_opn = 'X'.
    p_status = 'Open'.
  else.
    p_status = 'Close'.
  endif.
  refresh:lt_sqty[],lt_essr,lt_esll,it_temp_esll[].
endform.                    " PO_STATUS
