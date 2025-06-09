#!/bin/bash
#Setup baseCase for different lambda values
baseCase='baseCasefine2'
#lambdalist="4.02 4.52 5.03 5.36 5.53 5.78 6.03 6.53 6.70 7.04 7.20 7.54 7.87"
lambdalist="4.02 5.03 5.53 6.03 6.70 7.20  7.87"
#lambdalist="4.02"

for TSR in $lambdalist; do
    casename=$TSR'fine2AL88'
    echo 'Processing ' $casename
    cp conrun.sh $casename/
    sed -i  s/TSR/$TSR/g $casename/system/fvOptions
    sed -i  s/oxtidal/$TSR/g $casename/conrun.sh
    
    cd $casename; sbatch conrun.sh; cd ..;
done
