#!/bin/bash

functional=tpss
basis_sets="ae6 bh6 hb6 ip13 mgbl19 pa8"
work_dir=/home/rabeet/work/nwc/
scripts_dir=/home/rabeet/work/nwc/scripts
jobv=($(./jobs.sh test))

for bset in $basis_sets
do   
 echo
 echo "Processing $bset.."
 if [[ ${bset} == 'ae6' ]]; then
	# For job submission
	sed -e "s/proc/${jobv[0]}/g" ${bset}.sh> $work_dir/$bset/${bset}.sh
	sed -i -e "s/sjob/${jobv[1]}/g" $work_dir/$bset/${bset}.sh
	sed -i -e "s/name/$bset/g" $work_dir/$bset/${bset}.sh
	sed -i -e "s/functional/$functional/g" $work_dir/$bset/${bset}.sh

        # For atoms energy
	sed -e "s/proc/${jobv[0]}/g" atm_${bset}.sh> $work_dir/$bset/atm_${bset}.sh
	sed -i -e "s/sjob/${jobv[1]}/g" $work_dir/$bset/atm_${bset}.sh
	sed -i -e "s/name/$bset/g" $work_dir/$bset/atm_${bset}.sh
	sed -i -e "s/functional/$functional/g" $work_dir/$bset/atm_${bset}.sh

	# For getting data
	sed -e "s/functional/$functional/g" ${bset}_d.sh> $work_dir/$bset/${bset}_d.sh

	cd $work_dir/$bset
        qsub -V atm_${bset}.sh
	qsub -V ${bset}.sh
#	sh ae6_d.sh
        cd $scripts_dir
  else
	# For job submission
	sed -e "s/proc/${jobv[0]}/g" ${bset}.sh> $work_dir/$bset/${bset}.sh
	sed -i -e "s/sjob/${jobv[1]}/g" $work_dir/$bset/${bset}.sh
	sed -i -e "s/name/$bset/g" $work_dir/$bset/${bset}.sh
	sed -i -e "s/functional/$functional/g" $work_dir/$bset/${bset}.sh
      
	# For getting data
	sed -e "s/functional/$functional/g" ${bset}_d.sh> $work_dir/$bset/${bset}_d.sh
        cd $work_dir/$bset
        qsub -V ${bset}.sh
        cd $scripts_dir
  fi
done
