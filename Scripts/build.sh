#!/bin/bash

set -e

DEVICE="iPhone 6"
VERSION="11.3"
DESTINATION="platform=iOS Simulator,name=$DEVICE,OS=$VERSION"
FORMATTER=`bundle exec xcpretty-travis-formatter`
TARGETS=( WebBrowse Noted iTunesMovies )

function build () {
  printf "Building $1...\n"
  set -o pipefail && \
    xcodebuild -workspace '3 Apps in 3 Hours.xcworkspace' \
      -scheme $1 \
      -sdk iphonesimulator \
      -destination "$DESTINATION" \
      clean build | \
      xcpretty -f "$FORMATTER"
  printf "\n"
}

for TARGET in "${TARGETS[@]}"; do
  build $TARGET
done
