# How To Start

This project is a custom fork of the official [Seeed-Studio/meta-st-odyssey](https://github.com) repository. 

It has been modified to include build support for the Raspberry Pi 7-inch MIPI DSI Touchscreen Display (including custom kernel drivers, Device Tree updates for `stm32mp157c-odyssey.dts`, and mandatory Kconfig features) along with integrated **Qt6/QML** graphics support.

To bypass compatibility issues with modern host Linux distributions (such as `tar` or `pseudo` errors), the build environment is fully containerized using **Docker**.

## 1. Clone repositories

Run these commands on your host machine to prepare the sources:

```bash
git clone https://github.com/ltaparkrunner/meta-st-odyssey.git -b openstlinux-6.1-yocto-mickledore
git clone https://gerrit.googlesource.com/git-repo
./git-repo/repo init -u https://github.com/STMicroelectronics/oe-manifest.git -b refs/tags/openstlinux-6.1-yocto-mickledore-mpu-v24.06.26
./git-repo/repo sync
git clone git://code.qt.io/yocto/meta-qt6.git layers/meta-qt6 -b 6.5
```

## 2. Enter Docker Environment

Run the pre-configured automation script to build and enter the secure, isolated container:

```bash
chmod +x run-docker.sh
./run-docker.sh
```
*All subsequent steps must be executed **inside** the running Docker container.*

## 3. Set Env

Initialize the OpenSTLinux build configuration environment:

```bash
# Move build dependencies to the root workspace
mv meta-st-odyssey/layers ./layers
mv meta-st-odyssey/git-repo ./git-repo

# Place the meta-st-odyssey layer inside the new layers directory
mv meta-st-odyssey ./layers/

# Initialize the OpenSTLinux build environment
EULA_APPROVED="1" DISTRO=openstlinux-weston MACHINE=stm32mp1 source layers/meta-st/scripts/envsetup.sh
```

### 3.5. Configure Git Identity (Mandatory)

Some recipes (like `openocd-stm32mp-native`) execute `git commit` commands internally during their configuration stage. Since BitBake isolates environment variables within tasks, you **must** append your Git identity directly to the Yocto configuration.

Since text editors like `nano` or `vim` are not pre-installed inside the minimal Docker image, run the following command directly in the container terminal to automatically append your credentials to the configuration file. 

**Make sure to replace the placeholder values with your actual Git credentials before executing the command:**

```bash
cat << 'EOF' >> conf/local.conf

# Export Git Identity for BitBake tasks isolation
export GIT_AUTHOR_NAME = "Your Actual Name"
export GIT_AUTHOR_EMAIL = "your.email@example.com"
export GIT_COMMITTER_NAME = "Your Actual Name"
export GIT_COMMITTER_EMAIL = "your.email@example.com"
EOF
```

*(Alternatively, you can open `conf/local.conf` from your host machine's graphical text editor, since the workspace directory is shared with the container via Docker volumes).*


## 4. Add custom meta-layers

Add the cloned layer extensions into your BitBake configuration:

```bash
bitbake-layers add-layer ../layers/meta-qt6
bitbake-layers add-layer ../layers/meta-st-odyssey
```

## 5. Build project

Compile the full OS distribution containing graphics, drivers, and Qt libraries:

```bash
bitbake st-image-weston
```

## 6. Make bootable SD-Card image

Once the build successfully completes, package the final binary artifacts into a flashable raw disk image:

```bash
cd tmp-glibc/deploy/images/stm32mp1
./scripts/create_sdcard_from_flashlayout.sh flashlayout_st-image-weston/optee/FlashLayout_sdcard_stm32mp157c-odyssey-optee.tsv
```

---

## 💡 Running Qt/QML applications on target hardware

Since this build relies on the **Wayland** compositor (`Weston`), you must explicitly instruct Qt to use the Wayland platform plugin when executing your binaries on the STM32MP1 board.

Run your custom application on the board like this:
```bash
./my_qml_app -platform wayland
```
Alternatively, export the environment variable globally in `/etc/profile` on the board:
```bash
export QT_QPA_PLATFORM=wayland
```

## Hardware and Results

### Connection Diagram
![Connection Diagram](images/connection.jpg)

### Working Screen Examples
![Working Screen 1](images/screen1.jpg)
![Working Screen 2](images/screen2.jpg)

