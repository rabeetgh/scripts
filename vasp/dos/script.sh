#!/bin/bash
#PBS -N Si_dos
#PBS -o dos.out
#PBS -j oe
#PBS -l nodes=1:ppn=16,walltime=2:00:00
#PBS -q test
cd $PBS_O_WORKDIR
rm POSCAR
gga=PE
printf '\n%s\n\n\n' " Sitting POTCAR.."
cat >gen_pot.in <<!
1
Si
1
!
generate-potcar <gen_pot.in >gen_pot.out
rm gen_pot.out gen_pot.in DATA
#==========================================#

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
 5.468
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

printf '%s\n\n\n' "1. Meta-GGA scf run.."
#=============Other files for needed to VASP run====#
cat >INCAR <<!
System = Si
ISTART = 0
PREC = medium
ENCUT = 600
EDIFF = 1.0E-08
GGA = $gga
ALGO = A
!
#=====================================================#

#=============Run VASP===========#
mpirun -machinefile $PBS_NODEFILE  -np 16 vasp_std 
#================================#



printf '\n%s\n\n\n' "3. Calcuing dos.."

#=============Setting bands calcuion=============#
cat >INCAR <<!
 System = Si
 ISTART = 0
 PREC = medium
 ICHARG = 2 
 ENCUT = 600
 EDIFF = 1.0E-08
 ALGO = A
 GGA= $gga
 LORBIT = 11
!
#==== Run VASP for bands====#
mpirun -machinefile $PBS_NODEFILE  -np 16 vasp_std 
#===========================#

