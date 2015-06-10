#!/bin/bash -x

# Do not fail to parse cookbooks because of the encoding
export LC_CTYPE=en_US.UTF-8

DIR=$(dirname "${BASH_SOURCE[0]}")

if [ ! -d junit_reports ]; then
  mkdir -p junit_reports
fi

rm junit_reports/foodcritic-*.xml 2>/dev/null

PATH=${HOME}/bin:${PATH}

if [ -s ${HOME}/.rvm/scripts/rvm ]
then
    . "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

for cbname in `cat lint.json | jq '.cookbooks_to_test' | jq 'join(" ")' | tr -d '"'`; do
  echo "------ foodcritic checks: $cbname ------"
  foodcritic $@ $cbname | ${DIR}/foodcritic2junit.pl --suite $cbname --out junit_reports/foodcritic-$cbname.xml
done
