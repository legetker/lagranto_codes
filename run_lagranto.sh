#!/bin/bash
##### USER SETTINGS #####

# Path to WRF Lagranto caltra folder
set LAGRANTO=/glade/work/lgetker/lagranto_wrf/caltra
set LAGRANTOBASE=$LAGRANTO

# Path to WRF output files: they need to be linked into the working directory
pdir=/glade/work/lgetker/chinook_new/

#create tracevars file
echo "***** Write vars to tracevars file *****"
cat > tracevars << EOF
QVAPOR 1. 0 P
T 1. 0 P
U 1. 0 P
V 1. 0 P
W 1. 0 P
P 1. 0 P
PB 1. 0 P
EOF

end_date=20210622_00
start_date=20210628_21

##### END USER SETTINGS #####

#Link wrf files
echo "***** Link WRF files to working directory *****"
INPUT=${pdir}/wrfout_d01*
for field1 in $INPUT
do
    #echo $field1
    year=${field1:44:4}
    month=${field1:49:2}
    day=${field1:52:2}
    wrftime=${field1:55:2}
    ln -sf $field1 ./P"$year""$month""$day"_"$wrftime"
done

echo "***** Run caltra *****"
/glade/work/lgetker/lagranto_wrf/caltra/caltra.sh $start_date $end_date startf.xy trajectory_21z.xy -j
echo "***** Run trace program *****"
../trace/trace.sh trajectory_21z.xy traj_trace_21z.xy
echo "***** Convert x/y back to lat/lon ****"
../goodies/wrfmap.sh -xy2ll traj_trace_21z.xy traj_trace_21z.ll                      