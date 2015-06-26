#!/bin/bash
set -euo pipefail

# Do not fail to parse cookbooks because of the encoding
export LC_CTYPE=en_US.UTF-8

if [ ! -d cookbooks ]; then
    echo 'This script must be run from the root of the chef repository'
    exit 1
fi

if [ ! -d junit_reports ]; then
  mkdir -p junit_reports
fi

PATH=${HOME}/bin:${PATH}
#RSPEC=${RSPEC:-rspec} # figure this out
if [ -s ${HOME}/.rvm/scripts/rvm ]
then
    . "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

for cbname in `find cookbooks -maxdepth 1 -mindepth 1 -type d | sed -e 's/cookbooks\///'`; do
  rm junit_reports/chefspec-${cbname}.xml 2>/dev/null
  echo "------ chefspec checks: $cbname ------"
  rspec $@ cookbooks/${cbname} --format RspecJunitFormatter --out junit_reports/chefspec-${cbname}.xml
done
