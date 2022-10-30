# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils unpacker

DESCRIPTION="Frontend for ModemManager daemon able to control specific modem functions"
HOMEPAGE="https://linuxonly.ru/page/modem-manager-gui"
SRC_URI="https://geo.mirror.pkgbuild.com/community/os/x86_64/modem-manager-gui-0.0.20-2-x86_64.pkg.tar.zst"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="
    sys-libs/gdbm
    gui-libs/gtk
    app-text/gtkspell
    x11-libs/libnotify
    net-misc/modemmanager
    net-misc/networkmanager"

DEPEND="${RDEPEND}"
BDEPEND="
    app-text/po4a
    dev-util/itstool
"
S=${WORKDIR}

src_install() {
	cp -R "${WORKDIR}/etc/" "${D}/etc/"
	cp -R "${WORKDIR}/usr/" "${D}/usr/"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
