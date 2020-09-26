BASISNAME="def2-TZVPP"
INP_DIR="$PWD/tm10/*"
OUT_DIR="$PWD/nwtpss"

mkdir -p $OUT_DIR

cd $OUT_DIR
# cd $OUT_DIR
#for FILE in "$OUT_DIR"/* 
for FILE1 in $INP_DIR 
do
	FILE=${FILE1##*/}
	echo " start $FILE" > $OUT_DIR/$FILE.nw
	echo " geometry units angstroms noautosym" >> $OUT_DIR/$FILE.nw
	awk 'NR>2 {printf("%-5s %10.5f %10.5f %10.5f\n",$1, $2, $3, $4)}' $FILE1 >out1
 	sed -i -e 's/^/   /' out1
	cat out1 >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
        CHARGE=0
        echo " charge $CHARGE" >> $OUT_DIR/$FILE.nw
	echo " basis " >> $OUT_DIR/$FILE.nw
	echo "   * library $BASISNAME" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
	echo "dft" >> $OUT_DIR/$FILE.nw
	MULT=$(sed -n '2p' $FILE1)
	echo "   xc xtpss03 ctpss03" >> $OUT_DIR/$FILE.nw
#	echo "   direct" >> $OUT_DIR/$FILE.nw
#       echo "   xc HFexch" >> $OUT_DIR/$FILE.nw
	echo "   decomp" >> $OUT_DIR/$FILE.nw
	echo "   maxiter 5000" >> $OUT_DIR/$FILE.nw
	echo "   mult $MULT" >> $OUT_DIR/$FILE.nw
	echo "end" >> $OUT_DIR/$FILE.nw
#
	echo " task dft energy" >> $OUT_DIR/$FILE.nw
        mpirun -np 4 nwchem $OUT_DIR/${FILE}.nw > $OUT_DIR/${FILE}.out
	rm -f *.db *.movecs *.b *.b^-1 *.c *.gridpts.0 *.p *.zmat *.gridpts.* out1

wait
done
