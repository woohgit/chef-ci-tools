#!/bin/bash

if [ ! -d cookbooks ]; then
    echo 'This script must be run from the root of the chef repository'
    exit 1
fi

if [ ! -d junit_reports ]; then
  mkdir -p junit_reports
fi

rm junit_reports/foodcritic-*.xml 2>/dev/null

PATH=${HOME}/bin:${PATH}

if [ -s ${HOME}/.rvm/scripts/rvm ]
then
    . "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

for cbname in `find cookbooks -maxdepth 1 -mindepth 1 -type d | sed -e 's/cookbooks\///'`; do
  echo "------ foodcritic checks: $cbname ------"
  foodcritic --tags '~FC011' --tags '~FC015' --tags="~FC033" --tags="~FC034" --tags "~FC005" $@ cookbooks/$cbname | chef-ci-tools/bin/foodcritic2junit.pl --suite $cbname --out junit_reports/foodcritic-$cbname.xml
done
