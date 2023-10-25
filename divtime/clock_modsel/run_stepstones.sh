#!/usr/bin/bash

Rscript step_stones.R

for i in `seq 1 1 64`; do
    ln -s /home/balleng/Dropbox/Gustavo/papers/centropomidae_sphyraenidae/centropomidae_divtime/divtime/clock_modsel/_CLOCK/in.BV $i/in.BV
    cd $i
    echo "Running _CLOCK stone $i...\n"
    mcmctree >/dev/null
    cd ..
done

