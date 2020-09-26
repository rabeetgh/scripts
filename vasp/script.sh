rm DATA
excf=PE
atom=Si
inp_nk1=16
inp_nk2=16
inp_nk3=16
inp_lat="5.50"
# 1. ============= Lattice Constant =============#

cd opt_lat
sed -i -e "s/exch/$excf/g" script.sh
sed -i -e "s/ilat/$inp_lat/g" script.sh
sed -i -e "s/nk1/$inp_nk1/g" script.sh
sed -i -e "s/nk2/$inp_nk2/g" script.sh
sed -i -e "s/nk3/$inp_nk3/g" script.sh
sed -i -e "s/systm/$atom/g" script.sh

job=$(qsub -V script.sh)
while qstat $job &> /dev/null; do
    sleep 1;
done;
 
uv=$(grep "volume of cell" OUTCAR | tail -1 | awk  '{print $NF}')
aa=$(bc -l <<< "scale=3; e(l(4*$uv)/3)")

cd ../
echo "Lattice constant, $atom($excf)" $aa >> DATA


# 2. ============= Band Structure  =============#
cd bands
sed -i -e "s/exch/$excf/g" script.sh
sed -i -e "s/nk1/$inp_nk1/g" script.sh
sed -i -e "s/nk2/$inp_nk2/g" script.sh
sed -i -e "s/nk3/$inp_nk3/g" script.sh
sed -i -e "s/lat/$aa/g" script.sh
sed -i -e "s/systm/$atom/g" script.sh

 
job=$(qsub -V script.sh)
while qstat $job &> /dev/null; do
    sleep 1;
done;

./gap.sh OUTCAR >> ../DATA

cd ../


# 3. ============= Density of states  =============#
cd dos
sed -i -e "s/exch/$excf/g" script.sh
sed -i -e "s/lat/$aa/g" script.sh
sed -i -e "s/nk1/$inp_nk1/g" script.sh
sed -i -e "s/nk2/$inp_nk2/g" script.sh
sed -i -e "s/nk3/$inp_nk3/g" script.sh
sed -i -e "s/systm/$atom/g" script.sh

 
job=$(qsub -V script.sh)
while qstat $job &> /dev/null; do
    sleep 1;
done;

cd ../

# 4. ============= Phonons ========================#
cd phonons
sed -i -e "s/exch/$excf/g" script.sh
sed -i -e "s/lat/$aa/g" script.sh
sed -i -e "s/nk1/$inp_nk1/g" script.sh
sed -i -e "s/nk2/$inp_nk2/g" script.sh
sed -i -e "s/nk3/$inp_nk3/g" script.sh
sed -i -e "s/systm/$atom/g" script.sh


job=$(qsub -V script.sh)
while qstat $job &> /dev/null; do
    sleep 1;
done;
cd ../

