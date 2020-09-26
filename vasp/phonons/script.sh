rm POSCAR
gga=PE; aa=5.431
printf '\n%s\n\n\n' "Bringing POTCAR.."
cat >gen_pot.in <<!
1
Si
1
!
generate-potcar <gen_pot.in >gen_pot.out
rm gen_pot.out gen_pot.in DATA
#==========================================#

atomsk --create diamond $aa Si VASP
sed -i '1s/.*/Si/' POSCAR

cp POSCAR POSCAR-unitcell


cat > INCAR <<!
     PREC = Accurate
       GGA = $gga
    IBRION = -1
    NELMIN = 5
     ENCUT = 400
     EDIFF = 1.000000e-08
    ISMEAR = 0
     SIGMA = 1.000000e-02
     IALGO = 38
     LREAL = .FALSE.
   ADDGRID = .TRUE.
     LWAVE = .FALSE.
    LCHARG = .FALSE.
!

cat > KPOINTS <<!
Automatic mesh
0
Gamma
     4     4     4
 0.000 0.000 0.000
!

#================ Configure bands here==============#
cat > band.conf <<!
ATOM_NAME = Si
DIM =  2 2 2
PRIMITIVE_AXIS = 0 1/2 1/2    1/2 0 1/2    1/2 1/2 0
BAND = 0.0 0.0 0.0  1/2 1/2 0.0, 0.5 0.5 1.0 0.375 0.375 0.75, 0.375 0.375 0.75 0.0 0.0 0.0, 0.0 0.0 0.0  1/2 1/2 1/2
BAND_POINTS = 100
BAND_CONNECTION = .TRUE.
BAND_LABELS = $\Gamma$ X  K  $\Gamma$ L
!
#===== make a supercell 2x2x2 ======#
#phonopy -d --dim="2 2 2" -c POSCAR-unitcell # DFPT method
phonopy -d --dim="2 2 2" # Finite difference method

#===== copy supercell to poscar=====#
cp POSCAR-001 POSCAR 

#======= run VASP ==================#
mpirun -np 4 vasp_std
#======= Again copy unit cell to POSCAR
cp POSCAR-unitcell POSCAR

#======= Sit the file FORCE_SETS ===#
#phonopy --fc vasprun.xml # DFPT method
phonopy -f vasprun.xml    # Finite difference mehod

#=========Plot bands==============#
# phonopy --dim="2 2 2" -c POSCAR-unitcell band.conf > band.out# DFPT method
phonopy -p -s band.conf > band.out # Finite difference method

#======= Sit the gnuplot file to be plotted for dispersion reion===#
phonopy-bandplot --gnuplot band.yaml > phonon_band.Si
#cp phonon_band.Si /home/kohn/Dropbox/Projects/Phonons/plots/Si/

rm *out

