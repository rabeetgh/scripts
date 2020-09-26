#!/bin/bash
#================= Start table setting for the data ============#
divider=============================================================================================
divider=$divider$divider
headern="\n %-10s %10s %10s %10s\n"
formatn=" %-18s %11.5f\n"
width=50
printf "%$width.${width}s" "$divider"
#printf "$header" "Mole" "E" "1Electron" "Coulomb" "Ex" "Ec" "E_NN" "EA" "AE" "Ref."
printf "$headern" "Mole1" "Mol2" "TS" "V"
printf "%$width.${width}s\n" "$divider"
#===============================================================#
inpdir=nwrevtpss
ref=(6.7 19.6 10.7 13.1 3.5 17.3)


tse="$(grep "Total DFT energy =" $inpdir/TS1.out | awk '{print $NF}')"
# VF
mol1e="$(grep "Total DFT energy =" $inpdir/OH.out | awk '{print $NF}')"
mol2e="$(grep "Total DFT energy =" $inpdir/CH4.out | awk '{print $NF}')"
Vf=$(echo "($tse - ($mol1e+$mol2e))*627.509474" | bc -l)
printf "%10.5f %12.5f %12.5f %12.5f\n" $mol1e $mol2e $tse $Vf
s1=$(echo "$Vf- ${ref[0]}" | bc -l)
s1a=$(echo "$s1" | sed 's/-//g')
#VR
mol1e="$(grep "Total DFT energy =" $inpdir/CH3.out | awk '{print $NF}')"
mol2e="$(grep "Total DFT energy =" $inpdir/H2O.out | awk '{print $NF}')"
Vr=$(echo "($tse - ($mol1e+$mol2e))*627.509474" | bc -l)
printf "%10.5f %12.5f %12.5f %12.5f\n" $mol1e $mol2e $tse $Vr 
s2=$(echo "$Vr- ${ref[1]}" | bc -l)
s2a=$(echo "$s2" | sed 's/-//g')

echo " "
tse="$(grep "Total DFT energy =" $inpdir/TS2.out | awk '{print $NF}')"
# VF
mol1e="$(grep "Total DFT energy =" $inpdir/H.out | awk '{print $NF}')"
mol2e="$(grep "Total DFT energy =" $inpdir/OH.out | awk '{print $NF}')"
Vf=$(echo "($tse - ($mol1e+$mol2e))*627.509474" | bc -l)
printf "%10.5f %12.5f %12.5f %12.5f\n" $mol1e $mol2e $tse $Vf
s3=$(echo "$Vf- ${ref[2]}" | bc -l)
s3a=$(echo "$s3" | sed 's/-//g')

#VR
mol1e="$(grep "Total DFT energy =" $inpdir/O.out | awk '{print $NF}')"
mol2e="$(grep "Total DFT energy =" $inpdir/H2.out | awk '{print $NF}')"
Vr=$(echo "($tse - ($mol1e+$mol2e))*627.509474" | bc -l)
printf "%10.5f %12.5f %12.5f %12.5f\n" $mol1e $mol2e $tse $Vr 
s4=$(echo "$Vr- ${ref[3]}" | bc -l)
s4a=$(echo "$s4" | sed 's/-//g')


echo " "
tse="$(grep "Total DFT energy =" $inpdir/TS3.out | awk '{print $NF}')"
# VF
mol1e="$(grep "Total DFT energy =" $inpdir/H.out | awk '{print $NF}')"
mol2e="$(grep "Total DFT energy =" $inpdir/H2S.out | awk '{print $NF}')"
Vf=$(echo "($tse - ($mol1e+$mol2e))*627.509474" | bc -l)
printf "%10.5f %12.5f %12.5f %12.5f\n" $mol1e $mol2e $tse $Vf
s5=$(echo "$Vf- ${ref[4]}" | bc -l)
s5a=$(echo "$s5" | sed 's/-//g')

#VR
mol1e="$(grep "Total DFT energy =" $inpdir/H2.out | awk '{print $NF}')"
mol2e="$(grep "Total DFT energy =" $inpdir/HS.out | awk '{print $NF}')"
Vr=$(echo "($tse - ($mol1e+$mol2e))*627.509474" | bc -l)
printf "%10.5f %12.5f %12.5f %12.5f\n" $mol1e $mol2e $tse $Vr 
s6=$(echo "$Vr-${ref[5]}" | bc -l)
s6a=$(echo "$s6" | sed 's/-//g')

echo 

ME=$(echo "scale=5; ($s1+$s2+$s3+$s4+$s5+$s6)/6.0" | bc -l)
MAE=$(echo "scale=5; ($s1a+$s2a+$s3a+$s4a+$s5a+$s6a)/6.0" | bc -l)

printf "%-5s %10.5f %5s %10.5f\n" "ME" $ME "MAE" $MAE
