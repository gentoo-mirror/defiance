# Copyright 2012 Defiance Engineering
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MODULE_AUTHOR=BOOK
MODULE_VERSION=1.301
inherit perl-module

DESCRIPTION="Perl interface to Git repositories"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/System-Command"
RDEPEND="${DEPEND}"