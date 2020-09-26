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
printf "$headern" "Mole" "E" "AE" "Refs." "DE" "DAE" "SDAE"
printf "%$width.${width}s\n" "$divider"
#===============================================================#
inpdir=nwtpss
#rm $inpdir/ae6nwc*
mols="$(grep "$mol" refs.dat | awk '{print $1}')"
sde=0.0; sdae=0.0
#for struct in $inpdir/*-*.out;
for struct in $mols;
do
mol=$(basename "$struct" .out)
IFS='-' read mol1 mol2 <<< "$mol"

me="$(grep "Total DFT energy =" $inpdir/${mol}.out | awk '{print $NF}')"
m1e="$(grep "Total DFT energy =" $inpdir/${mol1}.out | awk '{print $NF}')"
m2e="$(grep "Total DFT energy =" $inpdir/${mol2}.out | awk '{print $NF}')"

ae=$(echo "(($m1e+$m2e)- $me)*627.509474" | bc -l)
rae="$(grep "$mol" refs.dat | awk '{print $5}')"
de=$(echo "$ae- $rae" | bc -l)
# Sum over all the differences between atomization energy vs its ref value #
sde=$(awk "BEGIN {print $sde+$de}")
dae=$(echo "$de" | sed 's/-//g')
# Sum over all the abs. differences between atomization energy vs its ref value #
sdae=$(awk "BEGIN {print $sdae+$dae}")
#printf "$format" $mol $name $ea $ae $rae
printf "$formatn" $mol $me $ae $rae $de $dae $sdae
#====================================================================================================#
done

echo 
ME=$(echo "scale=5; $sde/6.0" | bc -l)
MAE=$(echo "scale=5; $sdae/6.0" | bc -l)

printf "%-5s %10.5f %5s %10.5f\n" "ME=" $ME "MAE=" $MAE
