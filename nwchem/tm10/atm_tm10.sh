npp=4
BASISNAME="def2-TZVPP"
OUT_DIR="$PWD/atpss"
mkdir -p $OUT_DIR
atoms="Co Cr H F O Cu Mn Sc Ti V"
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

        # Getting multiplicity from the file mltatoms
        MULT="$(grep -w "$FILE" mltatoms | awk '{print $2}')"
	echo "   xc xtpss03 ctpss03" >> $OUT_DIR/$FILE.nw
	echo "   decomp" >> $OUT_DIR/$FILE.nw
	echo "   maxiter 5000" >> $OUT_DIR/$FILE.nw
	echo "   mult $MULT" >> $OUT_DIR/$FILE.nw
	echo " end" >> $OUT_DIR/$FILE.nw
	echo " task dft energy" >> $OUT_DIR/$FILE.nw
	cp $OUT_DIR/$FILE.nw nwchem.nw
	mpirun -np $npp nwchem >$OUT_DIR/$FILE.out
        rm -f *.db *.movecs *.b *.b^-1 *.c *.gridpts.0 *.p *.zmat *.gridpts.* 
wait
done 