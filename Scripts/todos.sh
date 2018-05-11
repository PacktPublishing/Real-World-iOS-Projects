#!/bin/bash

TAGS="TODO:|FIXME:"
ERRORTAG="ERROR:"

/usr/bin/find "${PROJECT_DIR}" \( -name "*.h" -or -name "*.m" -or -name "*.swift" -type f \) -print0 | /usr/bin/xargs -0 egrep --with-filename --line-number --only-matching "($TAGS).*\$|($ERRORTAG).*\$" | /usr/bin/perl -p -e "s/($TAGS)/ warning: \$1/" | perl -p -e "s/($ERRORTAG)/ error: \$1/"
