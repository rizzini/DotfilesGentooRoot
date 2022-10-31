# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_8 )
inherit git-r3 python-r1 xdg-utils

DESCRIPTION="Binding for Pango, to use with Manim"

EGIT_REPO_URI="https://github.com/ManimCommunity/ManimPango.git"
EGIT_SUBMODULES=('*')
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND=""

src_compile() {
	cd ${S}/${P}/
	python3.8 setup.py build
}

src_install() {
	cd ${S}/${P}/
	python3.8 setup.py install --root="${D}/" --optimize=1 --skip-build
}
