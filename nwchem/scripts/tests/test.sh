#!/bin/bash
jobv=($(./script.sh single))
job_dir=/home/bikashp/nwchem_run/rabeet/scripts
sed -e "s/proc/${jobv[0]}/g" job.sh > $job_dir/job1.sh
sed -i -e "s/sjob/${jobv[1]}/g" $job_dir/job1.sh
