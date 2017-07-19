# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="JKEENAN"

inherit perl-module

DESCRIPTION="Better than h2xs for creating modules"
SLOT=0
LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
KEYWORDS="arm amd64 amd64-linux x86 x86-linux"

DEPEND=">=dev-perl/File-Save-Home-0.09"
