#!/bin/bash

# Do not fail to parse cookbooks because of the encoding
export LC_CTYPE=en_US.UTF-8

if [ ! -d cookbooks ]; then
    echo 'This script must be run from the root of the chef repository'
    exit 1
fi

if [ ! -d junit_reports ]; then
  mkdir -p junit_reports
fi

rm junit_reports/jsonlint-*.xml 2> /dev/null
if ls nodes/*.json > /dev/null 2>&1; then
  echo "------ jsonlint checks: nodes ------"
  jsonlint -v nodes/*.json 2>&1 | chef-ci-tools/bin/jsonlint2junit.pl --class Nodes --suite Nodes --out junit_reports/jsonlint-nodefiles.xml
fi
if ls roles/*.json > /dev/null 2>&1; then
  echo "------ jsonlint checks: nodes ------"
  jsonlint -v roles/*.json 2>&1 | chef-ci-tools/bin/jsonlint2junit.pl --class Roles --suite Roles --out junit_reports/jsonlint-rolefiles.xml
fi
if ls data_bags/*/*.json > /dev/null 2>&1; then
  echo "------ jsonlint checks: data_bags ------"
  jsonlint -v data_bags/*/*.json 2>&1 | chef-ci-tools/bin/jsonlint2junit.pl --class DataBags --suite DataBags --out junit_reports/jsonlint-databags.xml
fi
