#!/bin/bash
#================= Start table setting for the data ============#
divider=============================================================================================
divider=$divider$divider
header="\n %-18s %5s %17s %10s %10s %10s %12s %10s %10s %10s\n"
headern="\n %-18s %7s %10s %12s %12s %10s %12s\n"
format=" %-18s %11.5f %11.5f %11.5f %11.5f %11.5f %11.5f %11.5f %11.5f %11.5f\n"
formatn=" %-18s %11.5f %11.5f %11.5f %11.5f %11.5f %11.5f\n"
width=90
printf "%$width.${width}s" "$divider"
#printf "$header" "Mole" "E" "1Electron" "Coulomb" "Ex" "Ec" "E_NN" "EA" "AE" "Ref."
printf "$headern" "Mole" "E" "EA" "AE" "Ref" "DE" "DAE"
printf "%$width.${width}s\n" "$divider"
#===============================================================#
inpdir=nwfunctional
inpdir2=afunctional
#rm $inpdir/ae6nwc*
sde=0.0; sdae=0.0
for struct in $inpdir/*.out;
do
mol=$(basename "$struct" .out)
name="$(grep -A 5 "Total DFT energy =" $inpdir/${mol}.out | awk '{print $NF}')"

#================== Getting Atoms in the molecules ==================================================#
sed -n -e '/No.       Tag          Charge          X/,/Atomic Mass/ p' $inpdir/${mol}.out > geometry
sed -i '1,2d'  geometry
sed -i -n -e :a -e '1,2!{P;N;D;};N;ba' geometry
matoms="$(awk '{print $2}' geometry)"
rm geometry

# ===============Getting atoms energy============================#
aa=()
for i in $matoms;
do
  aae=$(grep "Total DFT energy =" $inpdir2/${i}.out | awk '{print $NF}')
  aa+=("${aae}")
done
me="$(grep "Total DFT energy =" $inpdir/${mol}.out | awk '{print $NF}')"
ea=$(echo ${aa[@]} | sed 's/ /+/g' | bc)
ae=$(echo "($ea - $me)*627.509474" | bc -l)
rae="$(grep "$mol" ae.ref | awk '{print $2}')"
de=$(echo "$ae - $rae" | bc -l)
# Sum over all the differences between atomization energy vs its ref value #
sde=$(awk "BEGIN {print $sde+$de}")
dae=$(echo "$de" | sed 's/-//g')
# Sum over all the abs. differences between atomization energy vs its ref value #
sdae=$(awk "BEGIN {print $sdae+$dae}")
#printf "$format" $mol $name $ea $ae $rae
printf "$formatn" $mol $me $ea $ae $rae $de $dae 
#====================================================================================================#
done

echo 
ME=$(echo "scale=5; $sde/6.0" | bc -l)
MAE=$(echo "scale=5; $sdae/6.0" | bc -l)
printf "%-5s %10.5f %5s %10.5f\n" "ME" $ME "MAE" $MAE

