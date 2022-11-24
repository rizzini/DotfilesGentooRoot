# Copyright 1999-2022 Gentoo Authors and Martin V\"ath
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit readme.gentoo-r1 systemd toolchain-funcs

DESCRIPTION="no-ip.com dynamic DNS updater"
HOMEPAGE="http://www.no-ip.com"
SRC_URI="https://www.noip.com/client/linux/noip-duc-linux.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~mips ~ppc ppc64 sparc x86"
IUSE=""
DEPEND=""

S=${WORKDIR}

DOC_CONTENTS="
	Configuration can be done manually via /usr/sbin/noip2 -C or
	by using this ebuild's config option.
"

src_prepare() {
	cp -r noip-2.1.9-1/* .
	local sedarg
	sedarg=(
		-e "s:\(#define CONFIG_FILEPATH\).*:\1 \"/etc\":"
		-e "s:\(#define CONFIG_FILENAME\).*:\1 \"/etc/no-ip2.conf\":"
	)
	sed -i "${sedarg[@]}" noip2.c || die "sed failed"
	default
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		PREFIX=/usr \
		CONFDIR=/etc
}

src_install() {
	dosbin noip2
	dodoc README.FIRST
	newinitd "${FILESDIR}"/noip2.start noip
	systemd_dounit "${FILESDIR}"/noip.service
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}

pkg_config() {
	cd /tmp
	einfo "Answer the following questions."
	noip2 -C || die
}
