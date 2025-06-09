#!/bin/bash
#Setup baseCase for different lambda values
baseCase='baseCasefine'
lambdalist=" 4.52 5.03 5.36 5.53 5.78 6.03 6.53 6.70 7.04 7.20 7.54 7.87"
#lambdalist="4.02"

for TSR in $lambdalist; do
    casename=$TSR'fine'
    echo 'Processing ' $casename
    cp -r $baseCase $casename
    sed -i  s/TSR/$TSR/g $casename/system/fvOptions
    sed -i  s/oxtidal/$TSR/g $casename/slurmruncase.sh
    
    cd $casename; sbatch slurmruncase.sh; cd ..;
done
