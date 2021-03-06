# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic multilib pam readme.gentoo-r1 tmpfiles user

DESCRIPTION="an IP routing protocol suite for BGP, IS-IS, LDP, OSPF, PIM, and RIP"
HOMEPAGE="https://frrouting.org/"
SRC_URI="https://github.com/FRRouting/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="bfdd caps datacenter doc eigrpd elibc_glibc fpm ipv6 ldpd multipath nhrpd ospf pbrd pcre pam protobuf realms +readline rpki sharpd ssh snmp static staticd zeromq"

COMMON_DEPEND="
	dev-libs/json-c
	caps? ( sys-libs/libcap )
	nhrpd? ( net-dns/c-ares:0= )
	pam? ( virtual/pam )
	pcre? ( dev-libs/libpcre )
	protobuf? ( dev-libs/protobuf-c:0= )
	readline? (
		sys-libs/readline:0=
		pam? ( sys-libs/pam )
	)
	snmp? ( net-analyzer/net-snmp )
	zeromq? ( net-libs/zeromq )
	!elibc_glibc? ( dev-libs/libpcre )
	rpki? ( >=net-libs/rtrlib-0.5.0 )
"
DEPEND="${COMMON_DEPEND}
	sys-apps/gawk
	sys-devel/libtool:2"
RDEPEND="${COMMON_DEPEND}
	sys-apps/iproute2"
S="${WORKDIR}/${PN}-${P}"

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="Sample configuration files can be found in /usr/share/doc/${PF}/samples
You have to create config files in /etc/frr before
starting one of the daemons.

You can pass additional options to the daemon by setting the EXTRA_OPTS
variable in their respective file in /etc/conf.d"

pkg_setup() {
	enewgroup frr
	enewuser frr -1 -1 /var/empty frr
}

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing

	# do not build PDF docs
	export ac_cv_prog_PDFLATEX=no
	export ac_cv_prog_LATEXMK=no

	econf \
		--enable-exampledir=/usr/share/doc/${PF}/samples \
		--enable-irdp \
		--enable-isisd \
		--enable-pimd \
		--enable-user=frr \
		--enable-group=frr \
		--enable-vty-group=frr \
		--with-pkg-extra-version="-gentoo" \
		--sysconfdir=/etc/frr \
		--localstatedir=/run/frr \
		$(use_enable static) \
		$(use_enable caps capabilities) \
		$(usex snmp '--enable-snmp' '' '' '') \
		$(use_enable !elibc_glibc pcreposix) \
		$(use_enable fpm) \
		$(usex datacenter '--enable-cumulus --enable-datacenter' '' '' '') \
		$(use_enable doc) \
		$(usex multipath $(use_enable multipath) '' '=0' '') \
		$(usex ospf '--disable-ospfd --enable-ospfapi --enable-ospfclient' '--enable-ospfd --enable-ospfapi --enable-ospfclient' '' '') \
		$(use_enable readline vtysh) \
		$(use_with pam libpam) \
		$(use_enable bfdd) \
		$(use_enable nhrpd) \
		$(use_enable eigrpd) \
		$(use_enable ldpd) \
		$(use_enable protobuf) \
		$(use_enable pbrd) \
		$(use_enable realms) \
		$(use_enable sharpd) \
		$(use_enable staticd) \
		$(use_enable rpki) \
		$(use_enable ipv6 ripngd) \
		$(use_enable ipv6 ospf6d) \
		$(use_enable ipv6 rtadv) \
		$(use_enable ssh shell-access) \
		$(use_enable zeromq)
}

src_install() {
	default
	prune_libtool_files
	readme.gentoo_create_doc

	keepdir /etc/frr
	fowners root:frr /etc/frr
	fperms 0770 /etc/frr

	# install zebra as a file, symlink the rest
	newinitd "${FILESDIR}"/frr-services.init.3 zebra

	use readline && use pam && newpamd "${FILESDIR}/frr.pam" frr

	insinto /etc/logrotate.d
	newins redhat/frr.logrotate frr
}

pkg_postinst() {
	# Path for PIDs before first reboot should be created here, bug #558194
	tmpfiles_process frr.conf

	readme.gentoo_print_elog
}
