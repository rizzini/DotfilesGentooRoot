# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit cmake python-any-r1

DESCRIPTION="Friendly Interactive SHell"
HOMEPAGE="http://fishshell.com/"

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}-shell/${PN}-shell.git"
else
	SRC_URI="https://github.com/${PN}-shell/${PN}-shell/releases/download/${MY_PV}/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+doc nls test"

RESTRICT="!test? ( test )"

PATCHES=(
	#"${FILESDIR}/3.3.1-don-t-override-linker.patch"
	"${FILESDIR}/3.3.1-sbin-path-sh-test.patch"
	"${FILESDIR}/3.3.1-drop-some-tests.patch"
)

RDEPEND="
	>=dev-libs/libpcre2-10.32:=[pcre32]
	sys-apps/coreutils
	sys-libs/ncurses:=[unicode(+)]
"

DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		dev-tcltk/expect
		$(python_gen_any_dep '
			dev-python/pexpect[${PYTHON_USEDEP}]
		')
	)
"
# we don't need shpinx dep for release tarballs
[[ ${PV} == 9999 ]] && DEPEND+=" doc? ( dev-python/sphinx )"

S="${WORKDIR}/${MY_P}"

python_check_deps() {
	use test || return 0
	has_version -d "dev-python/pexpect[${PYTHON_USEDEP}]"
}

src_prepare() {
	# workaround for https://github.com/fish-shell/fish-shell/issues/4883
	sed -i 's#${TEST_INSTALL_DIR}/${CMAKE_INSTALL_PREFIX}#${TEST_INSTALL_DIR}#' \
		cmake/Tests.cmake || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR="${EPREFIX}/bin"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DCURSES_NEED_NCURSES=ON
		-DINSTALL_DOCS="$(usex doc)"
		-DWITH_GETTEXT="$(usex nls)"
	)
	# release tarballs ship pre-built docs // -DHAVE_PREBUILT_DOCS=TRUE
	[[ ${PV} == 9999 ]] && mycmakeargs+=( -DBUILD_DOCS="$(usex doc)" )
	cmake_src_configure
}

src_install() {
	cmake_src_install
	keepdir /usr/share/fish/vendor_{completions,conf,functions}.d
}

src_test() {
	# some tests are fragile, sanitize environment
	local -x COLUMNS=80
	local -X LINES=24

	# very fragile, depends on terminal, size, tmux, screen and timing
	rm -v tests/pexpects/terminal.py || die

	cmake_build test
}

