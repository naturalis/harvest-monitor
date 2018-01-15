#!/bin/bash

echo "Pulling data from oracle database"
export LD_LIBRARY_PATH=/instantclient_11_2/
/instantclient_11_2/sqlplus $USER/$PASS@\"//$SERVER\" @/script-txt.sql && cp /harvest.csv /harvest-`date '+%Y-%m-%d-%H:%M'.csv`

echo "Preparing data with R"
Rscript /analyse-harvest-errors.R
