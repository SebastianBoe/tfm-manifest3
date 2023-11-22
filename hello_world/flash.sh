#! /bin/bash

srec_cat build_app/tfm_s_ns_signed.bin -binary --offset 0x10000 \
         -o build_app/tfm_s_ns_signed.hex -intel

snrs=$(eval "nrfjprog -i")

if echo "${snrs[@]}" | grep -qw "$1"; then
        snr=$1
else
        if [[ $snrs == "" ]] ; then
                echo "No devices connected! aborting";
                exit 1
        elif [[ $snrs != *$'\n'* ]] ; then
                snr=$snrs;
        else
                select snr in $snrs; do break ; done;
        fi
fi

echo "Programming $snr"

nrfjprog --snr $snr --recover
nrfjprog --snr $snr --halt
nrfjprog --snr $snr --verify --program build_spe/bin/bl2.hex --chiperase
nrfjprog --snr $snr --verify --program build_app/tfm_s_ns_signed.hex --reset
