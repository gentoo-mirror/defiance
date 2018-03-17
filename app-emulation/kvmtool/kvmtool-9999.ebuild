# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs linux-info linux-mod

DESCRIPTION="A lightweight tool for hosting KVM guests"
HOMEPAGE="https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/"
EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

function ctarget() {
	CTARGET="${ARCH}"
	use amd64 && CTARGET='x86_64'
	echo $CTARGET
}

CONFIG_CHECK="VIRTIO VIRTIO_PCI
	SERIAL_8250 SERIAL_8250_CONSOLE
	VIRTIO_BLK VIRTIO_NET
	~VIRTIO_BALLOON
	~VIRTIO_CONSOLE
	~HW_RANDOM_VIRTIO
	~FB_VESA
"

pkg_setup() {
	linux-mod_pkg_setup
}

src_prepare() {
	eapply_user
	sed -e 's/^CFLAGS\t:=/CFLAGS := $(CFLAGS)/' \
		-e 's/^LDFLAGS\t:=/LDFLAGS := $(LDFLAGS)/' -i Makefile
}

src_compile() {
	ARCH=$(ctarget) emake
}

src_install() {
	dobin lkvm vm || die
	dodoc README COPYING || die
	doman Documentation/${PN}.1
}