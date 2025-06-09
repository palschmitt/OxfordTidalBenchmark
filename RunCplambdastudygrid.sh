#!/bin/bash
#Setup baseCase for different lambda values
baseCase='gridCase'
lambdalist="  4.46 4.91 5.37 5.64 5.82 6.19 6.37 6.92 7.37 7.73 "
#lambdalist="3.91"

for TSR in $lambdalist; do
    casename=$TSR'c'
    echo 'Processing ' $casename
    cp -r $baseCase $casename
    sed -i  s/TSR/$TSR/g $casename/system/fvOptions
    sed -i  s/oxtidal/$TSR/g $casename/slurmruncase.sh
    
    cd $casename; sbatch slurmruncase.sh; cd ..;
done
