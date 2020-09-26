#!/bin/bash
#PBS -N atoms
#PBS -o atoms.out
#PBS -j oe
#PBS -l nodes=1:ppn=proc,walltime=2:00:00
#PBS -q sjob
npp=proc
cd $PBS_O_WORKDIR
#nwc=/home/bikashp/Code/nwchem-6.6_tpssloc/bin/LINUX64/nwchem
nwc=/home/bikashp/Code/nwchem-6.6_revtpss/bin/LINUX64/nwchem

