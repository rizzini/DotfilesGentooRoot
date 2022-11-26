# Copyright 1999-2022 Gentoo Authors and Martin V\"ath
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker

DESCRIPTION="Guardião Itaú"
HOMEPAGE="http://itau.com.br"
SRC_URI="https://guardiao.itau.com.br/warsaw/warsaw_setup_64.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~mips ~ppc ppc64 sparc x86"
IUSE=""
DEPEND=""

S=${WORKDIR}

src_install() {
 	rm -r usr/share/doc usr/share/man
	cp -r * ${D}/
}


