# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MGRAHAM
MODULE_VERSION=1.06
inherit perl-module

DESCRIPTION="Pass control from one run mode to another"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-perl/CGI-Application"
RDEPEND="${DEPEND}"
