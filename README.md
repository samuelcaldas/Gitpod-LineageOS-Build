# Gitpod LineageOS lineage-17.1 build config
repo init -u https://github.com/LineageOS/android.git -b lineage-17.1 --depth=1 --groups=all,-notdefault,-device,-darwin,-x86,-x86_x64,-mips,-android-emulator,k3gxx
repo sync -d -c --force-sync --no-clone-bundle --no-tags --fail-fast -j$(nproc --all)