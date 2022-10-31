# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_8 )
inherit git-r3 python-r1 xdg-utils

DESCRIPTION="Emoji Picker for Linux written in GTK3"

EGIT_REPO_URI="https://github.com/tom-james-watson/Emote.git"
EGIT_SUBMODULES=('*')
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	x11-misc/xdotool
	dev-python/python-xlib[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/manimpango[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-libs/keybinder
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S=${WORKDIR}

src_unpack() {
	wget https://aur.archlinux.org/cgit/aur.git/snapshot/emote.tar.gz
	unpack ${S}/${PN}.tar.gz
	git-r3_fetch ${EGIT_REPO_URI}
	git-r3_checkout
}
src_prepare() {
	default
	cp ${S}/${PN}/setup.py ${S}/${P}/
	patch -d ${S}/${P}/ -p1 < ${S}/${PN}/fix-skin-tone-static-path.patch
	mv ${S}/${P}/static ${S}/${P}/emote/
	sed -Ei 's/\$\{SNAP\}//' "${S}/${P}/snap/gui/emote.desktop"
	sed -Ei "s/os\\.environ\\.get\\(\"SNAP_VERSION\", \"dev build\"\\)/\"${PV}\"/" \
    "${S}/${P}/emote/picker.py"
}

src_compile() {
	cd ${S}/${P}/
	EMOTE_VERSION="${PV}" python3.8 setup.py build
}

src_install() {
	cd ${S}/${P}/
	EMOTE_VERSION="${PV}" python3.8 setup.py install --root="${D}/" --optimize=1 --skip-build

	mkdir -p "${D}/usr/share/applications"
	mkdir -p "${D}/etc/xdg/autostart"
	cp "${S}/${P}/snap/gui/emote.desktop" "${D}/usr/share/applications/"
	cp "${S}/${P}/snap/gui/emote.desktop" "${D}/etc/xdg/autostart/"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
