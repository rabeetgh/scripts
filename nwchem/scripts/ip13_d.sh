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
printf "$headern" "Mole" "E" "EP" "IP" "Ref" "DE" "DAE"
printf "%$width.${width}s\n" "$divider"
#===============================================================#
inpdir=nwfunctional
#rm $inpdir/ae6nwc*
sde=0.0; sdae=0.0
for struct in $inpdir/*+.out;
do
mol=$(basename "$struct" +.out)

me="$(grep "Total DFT energy =" $inpdir/${mol}.out | awk '{print $NF}')"
mep="$(grep "Total DFT energy =" $inpdir/${mol}+.out | awk '{print $NF}')"
ip=$(echo "($mep - $me)*627.509474" | bc -l)
rip="$(grep -w "$mol" refs.dat | awk '{print $5}')"
dip=$(echo "$ip - $rip" | bc -l)
# Sum over all the differences between atomization energy vs its ref value #
sde=$(awk "BEGIN {print $sde+$dip}")
dae=$(echo "$dip" | sed 's/-//g')
# Sum over all the abs. differences between atomization energy vs its ref value #
sdae=$(awk "BEGIN {print $sdae+$dae}")
#printf "$format" $mol $name $ea $ae $rae
printf "$formatn" $mol $me $mep $ip $rip $dip $dae 
#====================================================================================================#
done

echo 
ME=$(echo "scale=5; $sde/13.0" | bc -l)
MAE=$(echo "scale=5; $sdae/13.0" | bc -l)
printf "%-5s %10.5f %5s %10.5f\n" "ME" $ME "MAE" $MAE


