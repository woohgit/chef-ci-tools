#!/bin/bash
mkdir -p junit_reports
rm junit_reports/foodcritic-*.xml 2>/dev/null

source /usr/local/rvm/scripts/rvm
rvm use ruby-1.9.3 2>/dev/null

for cbname in `find cookbooks -maxdepth 1 -mindepth 1 -type d | sed -e 's/cookbooks\///'`; do
  echo "------ foodcritic checks: $cbname ------"
  foodcritic $@ cookbooks/$cbname | foodcritic2junit.pl --suite $cbname --out junit_reports/foodcritic-$cbname.xml
done
