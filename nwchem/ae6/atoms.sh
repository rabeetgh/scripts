#!/bin/bash
#PBS -N ae6_atoms
#PBS -o ae6_atoms.out
#PBS -j oe
#PBS -l nodes=1:ppn=16,walltime=2:00:00
#PBS -q test
cd $PBS_O_WORKDIR
npp=16
#module load mpi/gcc/openmpi/1.10.3a1
BASISNAME="6-311++G(3df,3pd)"
nwc=/home/rabeet/nwchem-6.8/bin/LINUX64/nwchem
OUT_DIR="$PWD/arevtpss"
mkdir -p $OUT_DIR
atoms="C  H  O  Si S"

for FILE in $atoms
do
	echo " start $FILE" > $OUT_DIR/$FILE.nw
	echo " geometry units angstroms" >> $OUT_DIR/$FILE.nw
	printf "%5s %10.5f %10.5f %10.5f\n" $FILE "0.0" "0.0" "0.0" >> $OUT_DIR/$FILE.nw 
	echo " end" >> $OUT_DIR/$FILE.nw
        CHARGE=0
        echo " charge $CHARGE" >> $OUT_DIR/$FILE.nw
	echo " basis " >> $OUT_DIR/$FILE.nw
	echo "   * library $BASISNAME" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
	echo " dft" >> $OUT_DIR/$FILE.nw
        MULT="$(grep -w "$FILE" mltatoms | awk '{print $2}')"
	echo "   xc xtpss03 ctpss03" >> $OUT_DIR/$FILE.nw
	echo "   decomp" >> $OUT_DIR/$FILE.nw
	echo "   maxiter 5000" >> $OUT_DIR/$FILE.nw
	echo "   mult $MULT" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
	echo " task dft energy" >> $OUT_DIR/$FILE.nw
	cp $OUT_DIR/$FILE.nw nwchem.nw
	mpirun -machinefile $PBS_NODEFILE -np $npp $nwc >$OUT_DIR/$FILE.out
        rm -f *.db *.movecs *.b *.b^-1 *.c *.gridpts.0 *.p *.zmat *.gridpts.* 
wait
done 
