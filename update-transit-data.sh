#!/bin/sh
outputdir=/app/out/$(date '+%y%m%d-%H%M')
mkdir $outputdir
python /app/firetokengen.py $outputdir/firetoken.json
python /app/cocities-importer/coimporter.py $outputdir/alllines
python /app/firestorage-publisher/fireuploader.py /app/firebase-config.json --filetoken $outputdir/firetoken.json bilbobus/100 $outputdir/alllines.zip $outputdir/alllines-meta.json
