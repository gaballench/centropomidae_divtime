#!/usr/bin/bash

for i in `ls *.phylip`; do cat $i >> concatenated.phylip; echo "" >> concatenated.phylip;  done
