#!/bin/bash
#PBS -N mgbl19
#PBS -o mgbl19.out
#PBS -j oe
#PBS -l nodes=1:ppn=16
#PBS -q test

npp=16 # number of 16essor to be used in compiling
cd $PBS_O_WORKDIR
BASISNAME="6-311++G(3df,3pd)"
nwc=/home/rabeet/nwchem-6.8/bin/LINUX64/nwchem

INP_DIR="$PWD/mgbl19/*"
OUT_DIR="$PWD/nwtpss"

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
	echo " geometry units angstroms noautoz noautosym" >> $OUT_DIR/$FILE.nw
        sed -n '3,$p' $FILE1 >out1
 	sed -i -e 's/^/   /' out1
	cat out1 >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw

        echo "stepper" >> $OUT_DIR/$FILE.nw
        echo " maxiter 20" >> $OUT_DIR/$FILE.nw
        echo "end" >> $OUT_DIR/$FILE.nw

        CHARGE=0
        echo " charge $CHARGE" >> $OUT_DIR/$FILE.nw
	echo " basis " >> $OUT_DIR/$FILE.nw
	echo "   * library $BASISNAME" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
	echo " dft" >> $OUT_DIR/$FILE.nw
	MULT=1
	echo  "xc xtpss03 ctpss03" >> $OUT_DIR/$FILE.nw
#	echo "   direct" >> $OUT_DIR/$FILE.nw
#       echo "xc HFexch" >> $OUT_DIR/$FILE.nw
	echo "   decomp" >> $OUT_DIR/$FILE.nw
	echo "   maxiter 5000" >> $OUT_DIR/$FILE.nw
	echo " mult $MULT" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
#
	echo " task dft optimize" >> $OUT_DIR/$FILE.nw
	mpirun -machinefile $PBS_NODEFILE -np $npp $nwc_tl $OUT_DIR/${FILE}.nw > $OUT_DIR/${FILE}.out
	rm -f *.db *.movecs *.b *.b^-1 *.c *.gridpts.0 *.p *.zmat *.gridpts.* out1 $OUT_DIR/*stpr*

wait
done
