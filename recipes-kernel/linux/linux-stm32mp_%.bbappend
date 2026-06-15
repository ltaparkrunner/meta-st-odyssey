FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:${THISDIR}/files:"

SRC_URI += "file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0001-fix-stm32mp157c-odyssey-bootup.patch \
            file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0002-fix-change-VCO-from-594MHz-to-750MHz-for-eth-phy.patch \
            file://${LINUX_VERSION}/${LINUX_VERSION}${LINUX_SUBVERSION}/0003-stm32mp157c-odyssey-supports-usb-host.patch \
            file://0001-drivers-drm-stm-add-patches-for-raspberrypi-7-inch-D.patch \
            "

# Пробиваем защиту OpenSTLinux: принудительно пишем опции прямо в файл .config перед компиляцией
do_configure:append() {
    cat <<EOF >> ${B}/.config
CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN=y
CONFIG_REGULATOR_RASPBERRYPI_TOUCHSCREEN_ATTINY=y
CONFIG_DRM_TOSHIBA_TC358762=y
EOF
    # Заставляем систему сборки ядра принять новые параметры
    oe_runmake -C ${S} O=${B} oldconfig
}

