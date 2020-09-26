#!/bin/bash
#PBS -N atoms
#PBS -o atoms.out
#PBS -j oe
#PBS -l nodes=1:ppn=1,walltime=2:00:00
#PBS -q serial
cd $PBS_O_WORKDIR
nwc_tl=/home/bikashp/Code/nwchem-6.6_tpssloc/bin/LINUX64/nwchem
module load mpi/gcc/openmpi/1.10.3a1
#

INP_DIR="$PWD/atoms/"
for FILE1 in $INP_DIR/*.nw
do
FILE=${FILE1##*/}
atom="$(echo "$(basename "$FILE")" | cut -f 1 -d '.')"
mpirun -machinefile $PBS_NODEFILE -np 1  $nwc_tl $INP_DIR/${atom}.nw > $INP_DIR/${atom}.out
rm -f *.db *.movecs *.b *.b^-1 *.c *.gridpts.0 *.p *.zmat *.gridpts.*
wait
done #> $OUTPUT
