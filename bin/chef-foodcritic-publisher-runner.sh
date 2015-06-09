#!/bin/bash -x

# Do not fail to parse cookbooks because of the encoding
export LC_CTYPE=en_US.UTF-8

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ ! -d junit_reports ]; then
  mkdir -p junit_reports
fi

rm junit_reports/foodcritic-*.xml 2>/dev/null

PATH=${HOME}/bin:${PATH}

if [ -s ${HOME}/.rvm/scripts/rvm ]
then
    . "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

for cbname in `find . -maxdepth 1 -mindepth 1 -not -path '*/\.*' | sed -e 's/.\///'`; do
  echo "------ foodcritic checks: $cbname ------"
  foodcritic $@ $cbname | ${DIR}/foodcritic2junit.pl --suite $cbname --out junit_reports/foodcritic-$cbname.xml
done
