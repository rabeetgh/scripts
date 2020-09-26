#!/bin/bash
#PBS -N hb6_r
#PBS -o hb6.out
#PBS -j oe
#PBS -l nodes=1:ppn=1,walltime=2:00:00
#PBS -q serial
npp=1
cd $PBS_O_WORKDIR
module load mpi/gcc/openmpi/1.10.3a1
BASISNAME="6-311++G(3df,3pd)"
#BASISNAME="ANO-RCC"
#nwc=/home/bikashp/Code/nwchem-6.6_tpssloc/bin/LINUX64/nwchem
nwc=/home/bikashp/Code/nwchem-6.6_revtpss/bin/LINUX64/nwchem
#time_stamp=$(date +%Y%m%d_%H%M%SH)

INP_DIR="$PWD/hb6/*"
OUT_DIR="$PWD/nwrevtpss"

mkdir -p $OUT_DIR

echo "Processing ..."

cd $OUT_DIR
# cd $OUT_DIR
#for FILE in "$OUT_DIR"/* 
for FILE1 in $INP_DIR 
do
	FILE=${FILE1##*/}
#	echo "Processing $FILE ..."
#
	echo " start $FILE" > $OUT_DIR/$FILE.nw
	echo " geometry units angstroms" >> $OUT_DIR/$FILE.nw
	awk 'NR>1 {printf("%-5s %10.5f %10.5f %10.5f\n",$1, $2, $3, $4)}' $FILE1 >out1
 	sed -i -e 's/^/   /' out1
	cat out1 >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
        #CHARGE=$(sed -n '/MP2/{n;p;}' $FILE1 | cut -d " " -f 1)
        CHARGE=0
        echo " charge $CHARGE" >> $OUT_DIR/$FILE.nw
	echo " basis " >> $OUT_DIR/$FILE.nw
	echo "   * library $BASISNAME" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
	echo " dft" >> $OUT_DIR/$FILE.nw
#	MULT=$(sed -n '/MP2/{n;p;}' $FILE1 | cut -d " " -f 2)
	MULT=1
	echo  "xc xtpss03 ctpss03" >> $OUT_DIR/$FILE.nw
#	echo "   direct" >> $OUT_DIR/$FILE.nw
#       echo "xc HFexch" >> $OUT_DIR/$FILE.nw
	echo "   decomp" >> $OUT_DIR/$FILE.nw
	echo "   maxiter 5000" >> $OUT_DIR/$FILE.nw
	echo " mult $MULT" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
#
	echo " task dft energy" >> $OUT_DIR/$FILE.nw
	mpirun -machinefile $PBS_NODEFILE -np $npp $nwc $OUT_DIR/${FILE}.nw > $OUT_DIR/${FILE}.out
	rm -f *.db *.movecs *.b *.b^-1 *.c *.gridpts.0 *.p *.zmat *.gridpts.* out1

wait
done