# tfm-manifest

### Checkout the project

Option 1: Clean checkout

        west init -m https://github.com/joerchan/tfm-manifest.git tfm
        cd tfm
        west update

Option 2: Use existing checkout

        # If needed create a workspace and move the tfm-manifest repository
        mkdir tfm && mv tfm-manifest/ tfm/.
        cd tfm

        # Initialize the workspace
        west init -l tfm-manifest
        west update

Post checkout commands

        cd mbedtls
        make generated_files
        git apply ../trusted-firmware-m/lib/ext/mbedcrypto/*.patch

### Using your existing TF-M repo

First follow "Checkout the project".

Then

cd tfm-manifest/..
rm -rf trusted-firmware-m
ln -s ~/ncs/modules/tee/tf-m/trusted-firmware-m/


### building and flashing

cd tfm-manifest/hello_world
bash build.sh
bash flash.sh
