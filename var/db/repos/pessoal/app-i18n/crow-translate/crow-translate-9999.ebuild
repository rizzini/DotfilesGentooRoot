# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils git-r3

DESCRIPTION="A simple translator that allows to translate and say selected text"
HOMEPAGE="https://github.com/crow-translate/crow-translate"

EGIT_REPO_URI="https://github.com/crow-translate/crow-translate.git"
EGIT_SUBMODULES=( '*' )
PROPERTIES+=" live"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	app-text/tesseract
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtmultimedia:5[gstreamer]
	media-libs/gst-plugins-good:1.0"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

src_prepare() {
	default
	mkdir build
	cd build
	cmake ..
}

src_compile() {
	cd build
	make -j4
}

src_install() {
	cd build
	insinto /usr/share/crow-translate/translations/
	doins ./*.qm
	insinto /usr/share/applications/
	doins ../data/io.crow_translate.CrowTranslate.desktop
	dobin crow

}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
