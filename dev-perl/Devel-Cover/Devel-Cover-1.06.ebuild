# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="PJCJ"

inherit perl-module

DESCRIPTION="Code coverage metrics for Perl"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-perl/Test-Warn
"
