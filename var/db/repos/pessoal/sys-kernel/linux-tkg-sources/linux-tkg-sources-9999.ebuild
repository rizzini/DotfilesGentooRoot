# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit git-r3


KEYWORDS="~amd64 ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"
SLOT="0"
DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
EGIT_REPO_URI="https://github.com/Frogging-Family/linux-tkg.git"
RESTRICT="strip network-sandbox"

src_unpack() {
   git-r3_fetch ${EGIT_REPO_URI} ${REFS} ${TAG}
   git-r3_checkout ${EGIT_REPO_URI} ${WORKDIR}/${P} ${TAG}
   git clone https://github.com/rizzini/DotfilesGentooHome.git
   cp DotfilesGentooHome/.config/frogminer/linux-tkg.cfg linux-tkg-sources-9999/customization.cfg
   cp -r DotfilesGentooHome/.config/frogminer/linux60-tkg-userpatches linux-tkg-sources-9999/
   sed -i "s|~/.config/modprobed.db|${WORKDIR}/DotfilesGentooHome/.config/modprobed.db|g" linux-tkg-sources-9999/customization.cfg
}


src_install() {
   ./install.sh install

}
