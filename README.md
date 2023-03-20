# Gitpod LineageOS lineage-17.1 build config

This project contains the files needed to build a custom ROM of LineageOS lineage-17.1 using Gitpod.

## Description

LineageOS is an open source Android operating system that offers features and customizations beyond standard Android. Gitpod is an online development platform that allows you to create and run projects in a virtualized environment. This project combines the two to make it easy to build a LineageOS lineage-17.1 ROM for the k3gxx device (Samsung Galaxy S5).

## Technologies used

- Markdown
- Docker
- Shell
- Perl
- Roff

## Installation

To use this project, you need to have an account on GitHub and Gitpod. Then follow these steps:

1. Fork this repository to your GitHub.
2. Open the repository in Gitpod by clicking on the "Open with GitHub Desktop" button or using this link: https://gitpod.io/#https://github.com/<your_user>/Gitpod-LineageOS-Build
3. Wait for the environment to be set up by the .gitpod.Dockerfile and .gitpod.yml files.
4. Run the following commands in the terminal:

```bash
repo init -u https://github.com/LineageOS/android.git -b lineage-17.1 --depth=1 --groups=all,-notdefault,-device,-darwin,-x86,-x86_x64,-mips,-android-emulator,k3gxx 
repo sync -d -c --force-sync --no-clone-bundle --no-tags --fail-fast -j$(nproc --all)
```

## Usage

To build a LineageOS lineage-17.1 ROM for the k3gxx device, run the following commands in the terminal:

```bash
source build/envsetup.sh
lunch lineage_k3gxx-userdebug
make bacon -j$(nproc --all)
```

The result will be a zip file in the out/target/product/k3gxx folder.

## License

This project is under Apache 2.0 license.

## Contribution

If you want to contribute to this project, please make a pull request with your changes or suggestions.
