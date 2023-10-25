#!/bin/bash

Rscript step_stones.R

for i in `seq 1 1 64`; do
    ln -s /home/gaballench/centropomidae_divtime/divtime/clock_modsel/iln/in.BV $i/in.BV
    cd $i
    echo "Running iln stone $i..."
    mcmctree
    rm out
    cd ..
done

