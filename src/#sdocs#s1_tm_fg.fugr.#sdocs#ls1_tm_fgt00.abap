*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /SDOCS/SSPY_SGC.................................*
DATA:  BEGIN OF STATUS_/SDOCS/SSPY_SGC               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/SDOCS/SSPY_SGC               .
CONTROLS: TCTRL_/SDOCS/SSPY_SGC
            TYPE TABLEVIEW USING SCREEN '0010'.
*...processing: /SDOCS/SSPY_SPRF................................*
DATA:  BEGIN OF STATUS_/SDOCS/SSPY_SPRF              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/SDOCS/SSPY_SPRF              .
CONTROLS: TCTRL_/SDOCS/SSPY_SPRF
            TYPE TABLEVIEW USING SCREEN '0011'.
*.........table declarations:.................................*
TABLES: */SDOCS/SSPY_SGC               .
TABLES: */SDOCS/SSPY_SPRF              .
TABLES: /SDOCS/SSPY_SGC                .
TABLES: /SDOCS/SSPY_SPRF               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
