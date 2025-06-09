#!/bin/bash -l
#SBATCH --job-name=oxtidal
#SBATCH -n 48 
#SBATCH -p k2-medpri
#SBATCH --time=23:59:00
#SBATCH --output=case_%j.log
module load apps/openfoam/8/gcc-4.8.5+openmpi-4.0.0+cmake-3.5.2+qt-5.12.10
module load libs/armadillo/10.7.0/gcc-4.8.5+openblas-0.3.15+lapack-3.5.0+hdf5_serial-1.10.1+arpack-ng-3.3.0+superlu-5.3.0
module load libs/numpy_python34/1.11.3/gcc-4.8.5+atlas-3.10.3+python3-3.4.3
#export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export PATH=$PATH:/opt/gridware/depots/54e7fb3c/el7/pkg/apps/openfoamplus/18.12/gcc-4.8.5+openmpi-4.0.0+boost-1.60.0+cmake-3.5.2+mgridgen-1.0+qt-5.9.1/wmake
export WM_LABEL_SIZE=32
#export FOAM_SITE_APPBIN=/opt/gridware/depots/54e7fb3c/el7/pkg/apps/openfoamplus/18.12/gcc-4.8.5+openmpi-4.0.0+boost-1.60.0+cmake-3.5.2+mgridgen-1.0+qt-5.9.1/platforms/linux64GccDPInt32Opt/bin
#export FOAM_SITE_LIBBIN=/opt/gridware/depots/54e7fb3c/el7/pkg/apps/openfoamplus/18.12/gcc-4.8.5+openmpi-4.0.0+boost-1.60.0+cmake-3.5.2+mgridgen-1.0+qt-5.9.1/platforms/linux64GccDPInt32Opt/lib

export FOAM_USER_APPBIN=/users/$USER/OpenFOAM/$USER-8/platforms/linux64GccDPInt32Opt/bin/
export FOAM_USER_LIBBIN=/users/$USER/OpenFOAM/$USER-8/platforms/linux64GccDPInt32Opt/lib/

export PATH=$PATH:$FOAM_USER_APPBIN:/opt/gridware/depots/54e7fb3c/el7/pkg/apps/openfoam/8/gcc-4.8.5+openmpi-4.0.0+cmake-3.5.2+qt-5.12.10/wmake/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$FOAM_USER_LIBBIN

. $WM_PROJECT_DIR/bin/tools/RunFunctions    # Tutorial run functions


# Source tutorial run functions
. $WM_PROJECT_DIR/bin/tools/RunFunctions
. $WM_PROJECT_DIR/bin/tools/CleanFunctions

# Set application name
application=$(getApplication)
cp --backup=t -f log.potentialFreeSurfaceFoamsrc log.potentialFreeSurfaceFoamsrc
rm log.potentialFreeSurfaceFoamsrc
runParallel $application


