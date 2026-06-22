*&---------------------------------------------------------------------*
*&  Include           /SDOCS/S1_SOURCING_COCKPIT_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'BSTL'.
      AUTHORITY-CHECK OBJECT 'S_TCODE'
        ID 'TCD' FIELD '/SDOCS/S1_BSTL'.

      IF sy-subrc = 0.
        CALL TRANSACTION '/SDOCS/S1_BSTL'.
      ELSE.
        MESSAGE 'No authorization to execute this transaction' TYPE 'E'.
      ENDIF.
    WHEN 'BPAR'.
      AUTHORITY-CHECK OBJECT 'S_TCODE'
        ID 'TCD' FIELD '/SDOCS/S1_BPAR'.

      IF sy-subrc = 0.
        CALL TRANSACTION '/SDOCS/S1_BPAR'.
      ELSE.
        MESSAGE 'No authorization to execute this transaction' TYPE 'E'.
      ENDIF.
  ENDCASE.
ENDMODULE.

*{   INSERT         S4HK902244                                        1
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  CASE sy-ucomm.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'CONT' .
      IF s_lifnr[] IS NOT INITIAL AND gv_qdate IS NOT INITIAL  AND qa_ddate IS NOT INITIAL AND gv_title IS NOT INITIAL
        AND gv_dtime IS NOT INITIAL. "and gv_ddate is not INITIAL.
        IF gv_qdate <= qa_ddate.
          LEAVE TO SCREEN 0.
        ELSE .
          MESSAGE 'Please enter QA deadline date before than deadline for subm. of bids' TYPE 'S' DISPLAY LIKE 'E'.

*          MESSAGE 'Please enter deliv. date later than deadline for subm. of bids' type 'S' DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        IF gv_qdate IS INITIAL.
          LOOP AT SCREEN.
            CASE screen-name.
              WHEN 'GV_QDATE'.
                screen-required = '1'. " or probably '1'
            ENDCASE.
            MODIFY SCREEN.
          ENDLOOP.
        ENDIF.
        IF qa_ddate IS INITIAL.
          LOOP AT SCREEN.
            CASE screen-name.
              WHEN 'QA_DDATE'.
                screen-required = '1'. " or probably '1'
            ENDCASE.
            MODIFY SCREEN.
          ENDLOOP.
        ENDIF.
        IF gv_title IS INITIAL.
          LOOP AT SCREEN.
            CASE screen-name.
              WHEN 'GV_TITLE'.
                screen-required = '1'. " or probably '1'
            ENDCASE.
            MODIFY SCREEN.
          ENDLOOP.
        ENDIF.
        IF gv_dtime IS INITIAL.
          LOOP AT SCREEN.
            CASE screen-name.
              WHEN 'GV_DTIME'.
                screen-required = '1'. " or probably '1'
            ENDCASE.
            MODIFY SCREEN.
          ENDLOOP.
        ENDIF.
        IF s_lifnr IS INITIAL.
          MESSAGE 'Fill the required fields' TYPE 'S'.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDMODULE.
*}   INSERT
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE sy-ucomm.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
