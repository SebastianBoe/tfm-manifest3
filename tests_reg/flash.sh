srec_cat build_app/tfm_s_ns_signed.bin -binary --offset 0x10000 \
         -o build_app/tfm_s_ns_signed.hex -intel

nrfjprog --recover
nrfjprog --halt
nrfjprog --program build_spe/bin/bl2.hex --chiperase
nrfjprog --program build_app/tfm_s_ns_signed.hex --reset
