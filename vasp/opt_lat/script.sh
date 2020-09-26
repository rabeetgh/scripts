#!/bin/bash
#PBS -N Si_latt
#PBS -o latt.out
#PBS -j oe
#PBS -l nodes=1:ppn=16,walltime=2:00:00
#PBS -q test
cd $PBS_O_WORKDIR
gga=PE
rm POSCAR
printf '\n%s\n\n\n' " Sitting POTCAR.."
cat >gen_pot.in <<!
1
Si
1
!
generate-potcar <gen_pot.in >gen_pot.out
rm gen_pot.out gen_pot.in DATA

printf '%s\n\n\n' "Initializing SCF run using PBE.."
#=============Other files for needed to VASP run====#
cat >INCAR <<!
System = Si
ISTART = 0
ISMEAR = 0
SIGMA = 0.1
ENCUT  =  600
!

cat >POSCAR <<!
Si
 5.50
 0.0    0.5     0.5
 0.5    0.0     0.5
 0.5    0.5     0.0
  2
Direct
 -0.125 -0.125 -0.125
  0.125  0.125  0.125
!

cat > KPOINTS <<!
K-Points
0
Monkhorst Pack
16 16 16
0 0 0
!
#=====================================================#


#=============Run VASP===========#
mpirun -machinefile $PBS_NODEFILE  -np 16 vasp_std
#================================#

printf '%s\n\n\n' "1. Optimizing Lattic parameter.."
#=============Other files for needed to VASP run====#
cat >INCAR <<!
System = Si
ISMEAR = 0; SIGMA = 0.1;
ENCUT =  600
IBRION = 2; ISIF=3 ; NSW=15
EDIFF  = 1.0E-08
EDIFFG = -0.01
GGA= $gga
!
#=====================================================#

#=============Run VASP===========#
mpirun -machinefile $PBS_NODEFILE  -np 16 vasp_std 
#================================#


#=============volume of the cell and then the lattice constant from it=========#
uv=$(grep "volume of cell" OUTCAR | tail -1 | awk  '{print $NF}')
aa=$(bc -l <<< "scale=3; e(l(4*$uv)/3)")
echo "Lattice constant, Si(PBE)" $aa >> DATA
#==============================================================================#


