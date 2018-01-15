-- Query to get harvest errors from the last day
-- Outputs a file 'harvest.csv'
		
SPOOL /harvest.csv

set colsep ,
SET TRIMS ON FEEDBACK OFF ECHO OFF
set pagesize 0 embedded on
set trimspool on
set trimout on
set linesize 400
SET NEWPAGE NONE
set underline off
	

select  he.ID, he.DATUM,
		REGEXP_REPLACE(REGEXP_REPLACE(he.MELDING, CHR(10), ' '),'at Atlantis.*','') as MELDING,
		he.HARVESTSESSIONID,
	    he.TIJD,
		DECODE (hb.VOLGNUMMER,  1, 'geneious dna extract plates', 
	                            2, 'geneious dna extracts', 
    	                        3, 'geneious specimens', 
        	                    4, 'Entomologie-CRS-Algemeen',
            	                5, 'Paleontologie-CRS-Algemeen',
                	            6, 'IM-CRS-Algemeen',
                    	        7, 'MineralogiePetrologie-CRS-Algemeen',
	                            8, 'Vertebraten-CRS-Algemeen',
	                            9, 'Evertebraten-CRS-Algemeen',
    	                        10, 'DNALab-CRS-Algemeen',
	                                'Onbekende harvestsource') AS harvestmap
from FRM_harvesterrors he,
FRM_harvestbronnen hb,
FRM_harvestsessions hs
where hs.HARVESTBRONID = hb.ID AND he.HARVESTSESSIONID = hs.ID
AND he.datum = to_char(current_date-1,'YYYYMMDD')
order by he.HARVESTSESSIONID;

SPOOL OFF 
exit


