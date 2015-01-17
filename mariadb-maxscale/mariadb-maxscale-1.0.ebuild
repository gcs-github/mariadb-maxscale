# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit user eutils git-r3

EGIT_REPO_URI="https://github.com/mariadb-corporation/MaxScale.git"
EGIT_BRANCH="release-1.0GA"
SRC_URI=""

DESCRIPTION="MaxScale is an intelligent mysql proxy"
HOMEPAGE="https://github.com/mariadb-corporation/MaxScale"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
>=sys-devel/gcc-4.6.3
>=sys-libs/glibc-2.16.0
>=dev-util/cmake-2.8.12
dev-db/mariadb[embedded]
virtual/mysql[embedded]"

pkg_setup() {
enewgroup maxscale
enewuser maxscale -1 -1 /opt/maxscale maxscale
}

src_prepare() {
		epatch "${FILESDIR}"/macros.cmake.patch
		epatch "${FILESDIR}"/cmakelist.patch
}

src_compile() {
		mkdir ${S}/build
		cd ${S}/build
		cmake ..
		emake || die
	}

src_install() {

		cd ${S}/build
		emake install DESTDIR="${D}" || die
		chown -R maxscale:maxscale "${D}"
		newinitd "${FILESDIR}/init-server" ${PN}
		newconfd "${FILESDIR}/confd-server" ${PN}

}

pkg_postinst() {
	
		ewarn ""
		ewarn "Before you can start Maxscale, you have to"
		ewarn "create /opt/maxscale/etc/MaxScale.cnf."
		ewarn ""
		ewarn "You can use /opt/maxscale/etc/MaxScale_template.cnf"
		ewarn "as an example."
}
