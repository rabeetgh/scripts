#!/bin/bash
#================= Start table setting for the data ============#
divider=============================================================================================
divider=$divider$divider
header="\n %-18s %7s %10s %12s %12s %10s %12s\n"
format=" %-18s %11.5f %11.5f %11.5f %11.5f %11.5f %11.5f\n"
width=90
printf "%$width.${width}s" "$divider"
#printf "$header" "Mole" "E" "1Electron" "Coulomb" "Ex" "Ec" "E_NN" "EA" "AE" "Ref."
printf "$header" "Mole" "E" "EP" "PA" "Ref." "DPA" "DAE"
printf "%$width.${width}s\n" "$divider"
#===============================================================#
inpdir=nwtpss
#inpdir2=atoms
#rm $inpdir/ae6nwc*
sde=0.0; sdae=0.0
molp="C2H2.xyz HCl.xyz H2O.xyz H2S.xyz H2.xyz NH3.xyz PH3.xyz SiH4.xyz"

for struct in $molp;
do
mol=$(basename "$struct" .xyz)
#name="$(grep -A 5 "Total DFT energy =" $inpdir/${mol}.out | awk '{print $NF}')"
me="$(grep "Total DFT energy =" $inpdir/$mol.xyz.out | awk '{print $NF}')"
mep="$(grep "Total DFT energy =" $inpdir/$mol+.xyz.out | awk '{print $NF}')"
pa=$(echo "($me - $mep)*627.509474" | bc -l)
rpa="$(grep -w "$mol" refs.dat | awk '{print $3}')"
dpa=$(echo "$pa - $rpa" | bc -l)
# Sum over all the differences between atomization energy vs its ref value #
sde=$(awk "BEGIN {print $sde+$dpa}")
dae=$(echo "$dpa" | sed 's/-//g')
# Sum over all the abs. differences between atomization energy vs its ref value #
sdae=$(awk "BEGIN {print $sdae+$dae}")
#printf "$format" $mol $name $ea $ae $rae
printf "$format" $mol.xyz $me $mep $pa $rpa $dpa $dae
#====================================================================================================#
done

echo 
ME=$(echo "scale=5; $sde/8.0" | bc -l)
MAE=$(echo "scale=5; $sdae/8.0" | bc -l)
printf "%-5s %10.5f %5s %10.5f\n" "ME" $ME "MAE" $MAE

