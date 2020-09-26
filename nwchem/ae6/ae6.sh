#!/bin/bash
#PBS -N ae6
#PBS -o ae6.out
#PBS -j oe
#PBS -l nodes=1:ppn=16,walltime=2:00:00
#PBS -q test
cd $PBS_O_WORKDIR
npp=16
# source ~/opt/environments/env_intel.sh intel64
# BIN=/home/bikash/nwchem-6.6/bin/LINUX64/nwchem
BASISNAME="6-311++G(3df,3pd)"
#nwc=/home/bikashp/Code/nwchem-6.6_tpssloc/bin/LINUX64/nwchem
nwc=/home/rabeet/nwchem-6.8/bin/LINUX64/nwchem
#nwc=/home/bikashp/nwchem-6.6/bin/LINUX64/nwchem
#time_stamp=$(date +%Y%m%d_%H%M%SH)

#OUT_DIR="$PWD/G2-1/*"
#INP_DIR="$PWD/ae6/*"
INP_DIR="$PWD/ae6/*"
#OUT_DIR="$PWD/nwcae6"
OUT_DIR="$PWD/nwtpss"
#OUT_DIR=$OUT_DIR$time_stamp
#OUT_DIR=$OUT_DIR$HYBRID

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
#	echo " title "\""$FILE in $BASISNAME basis set"\""" >> $OUT_DIR/$FILE.nw
##	echo "" >> $OUT_DIR/$FILE.nw
#
#	echo " # Ref. G2-97 (in Ang)" >> $OUT_DIR/$FILE.nw
	echo " geometry units angstroms" >> $OUT_DIR/$FILE.nw
	grep -n -A1 -B2 MP2 $FILE1 | sed -n 's/^\([0-9]\{1,\}\).*/\1d/p' | sed -f - $FILE1 > out1
	sed -i -e 's/^/   /' out1 
	cat out1 >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
        CHARGE=$(sed -n '/MP2/{n;p;}' $FILE1 | cut -d " " -f 1)
        echo " charge $CHARGE" >> $OUT_DIR/$FILE.nw
	echo " basis " >> $OUT_DIR/$FILE.nw
	echo "   * library $BASISNAME" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
	echo " dft" >> $OUT_DIR/$FILE.nw
#	MULT=$(sed -n '/MP2/{n;p;}' $FILE1 | cut -d " " -f 2)
        MULT=$(sed -n '/MP2/{n;p;}' $FILE1 | cut -d " " -f 2 ); MULT=${MULT//$'\r'}
	if [ $((MULT%2)) -eq 0 ];
	then
#		echo "   odft" >> $OUT_DIR/$FILE.nw
		echo "   "
#		sed -i "s/SCFTYP.*/SCFTYP UKS TOL=0.100E-07/g" $OUT_DIR/$FILE.nw >> $OUT_DIR/$FILE.nw
	else
		echo ""
#		sed -i "s/SCFTYP.*/SCFTYP RKS TOL=0.100E-07/g" $OUT_DIR/$FILE.nw >> $OUT_DIR/$FILE.nw
	fi

	echo  "xc xtpss03 ctpss03" >> $OUT_DIR/$FILE.nw
#	echo "   direct" >> $OUT_DIR/$FILE.nw
#        echo "xc HFexch" >> $OUT_DIR/$FILE.nw
	echo "   decomp" >> $OUT_DIR/$FILE.nw
#	echo "   iterations 1000" >> $OUT_DIR/$FILE.nw
	echo "   maxiter 5000" >> $OUT_DIR/$FILE.nw
	echo " mult $MULT" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
#
#	echo " driver" >> $OUT_DIR/$FILE.nw
#	echo "   maxiter 1000" >> $OUT_DIR/$FILE.nw
#	echo " mult $MULT" >> $OUT_DIR/$FILE.nw
#	echo " end" >> $OUT_DIR/$FILE.nw
#
	echo " task dft energy" >> $OUT_DIR/$FILE.nw
#
#	echo " mult $MULT" >> $OUT_DIR/$FILE.nw
#	CHARGE=$(sed -n '/MP2/{n;p;}' $FILE1 | cut -d " " -f 1)
#	echo " charge $CHARGE" >> $OUT_DIR/$FILE.nw
#
cp $OUT_DIR/$FILE.nw nwchem.nw
FNAME=$FILE;
#$BIN>$FILE.nw
#tpss
#mpirun -machinefile $PBS_NODEFILE -np 16  /home/bikashp/nwchem-6.6/bin/LINUX64/nwchem ->output
#tpssloc
mpirun -machinefile $PBS_NODEFILE -np $npp $nwc ->output
cp output $OUT_DIR/$FNAME.out
#FNAME=$FILE;
#cp FNAME.nw $OUT_DIR/$FNAME.nw
#cp FNAME.out $OUT_DIR/$FNAME.out
#cp FNAME.mol $OUT_DIR/$FNAME.mol
#cp FNAME.rst $OUT_DIR/$FNAME.rst
#
# *** Cleanup deMon.* before next run ***
#
# rm deMon.inp deMon.mem deMon.mol deMon.new deMon.out deMon.rst
rm -f *.db *.movecs *.b *.b^-1 *.c *.gridpts.0 *.p *.zmat *.gridpts.* 
# Wait 
wait
done #> $OUTPUT
