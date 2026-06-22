PROCESS BEFORE OUTPUT.
 MODULE STATUS_0101.
call subscreen sel_scrn including sy-repid '102'.
PROCESS AFTER INPUT.
MODULE exit AT EXIT-COMMAND.
call subscreen sel_scrn.
 MODULE USER_COMMAND_0101.
