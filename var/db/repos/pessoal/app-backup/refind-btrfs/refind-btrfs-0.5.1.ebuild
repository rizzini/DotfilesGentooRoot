# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Generate rEFInd manual boot stanzas from Btrfs snapshots"

EGIT_REPO_URI="https://github.com/Venom1991/refind-btrfs.git"
#EGIT_SUBMODULES=( '*' )
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-python/injector
	dev-python/pid
	dev-python/antlr4-python3-runtime
	dev-python/python-systemd
	dev-python/tomlkit
	dev-python/transitions
	dev-python/typeguard
	=dev-python/watchdog-2.1.6
	"
DEPEND="${RDEPEND}"
BDEPEND=""

S=${WORKDIR}

src_prepare() {
	default
	mkdir -p "${D}/usr/bin/"
	mkdir -p "${D}/usr/lib/systemd/system/"
	mkdir -p "${D}/etc/"


}
src_compile() {
	cd "${S}/${P}"
	python setup.py build
}
src_install() {
	cd "${S}/${P}"
	python setup.py install --root="${D}/" --optimize=1 --skip-build
	cp "${S}/${P}/src/refind_btrfs/data/refind-btrfs" "${D}/usr/bin/"
	cp "${S}/${P}/src/refind_btrfs/data/refind-btrfs.service" "${D}/usr/lib/systemd/system/"
	cp "${S}/${P}/src/refind_btrfs/data/refind-btrfs.conf-sample" "${D}/etc/refind-btrfs.conf"
	keepdir '/var/lib/refind-btrfs'
}


pkg_postinst() {
	elog "libbtrfsutil needs to be already present in the system site packages (its Python bindings, to be precise)"
	elog "because it cannot be automatically pulled in as a dependency. Chances are that it is available for your"
	elog "distribution of choice. (search for a package named ""btrfs-progs"") but you most probably already have"
	elog "it installed as I suppose you are using Btrfs, after all."
	elog "Alternativally, download it from: https://pkgs.org/download/python3-btrfsutil"
}

