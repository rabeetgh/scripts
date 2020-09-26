#!/bin/bash
#================= Start table setting for the data ============#
inpdir=nwfunctional
for struct in $inpdir/*.out;
do
mol=$(basename "$struct")
echo $mol
awk '/Converged geometry/,/included internuclear distances/' $inpdir/$mol | awk '/center one/,/included internuclear distances/' | sed '1d; $d'
echo
done
