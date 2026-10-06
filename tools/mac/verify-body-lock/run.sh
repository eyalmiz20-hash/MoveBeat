#!/bin/sh
# Runs the body-lock test against the REAL MoveBeat/Program.cs, on the Mac.
#
# WHY THIS EXISTS.  Program.cs only builds on the PC - it targets net48 and references
# Microsoft.Kinect.dll by absolute path into the Kinect SDK - so the C# in this repo has
# never had a test of any kind.  The body-selection rule is the one piece of it whose
# failure is audible (see "the body lock" in Program.cs), and it depends on nothing but
# the array of bodies, so it can be driven on the Mac against a stub of the Kinect API.
#
# WHY IT LIVES HERE AND NOT UNDER MoveBeat/.  MoveBeat.csproj is an SDK-style project, so
# it compiles **/*.cs under MoveBeat/ automatically.  KinectStub.cs there would collide
# with the real Microsoft.Kinect types and TestBodyLock.cs would be a second entry point:
# the PC build would fail, the auto-updater would fail with it, and the capture app would
# stop being rebuilt.  tools/ is outside that glob.  KEEP THESE FILES OUT OF MoveBeat/.
#
# What it does NOT prove: that the Kinect reports what the stub reports.  The stub is a
# model of the sensor's API, not of the sensor - the same stated limit the Max replay
# suites carry.  Only a real body in front of a real sensor settles that.
set -e
here=$(cd "$(dirname "$0")" && pwd)
repo=$(cd "$here/../../.." && pwd)
out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

csc -nologo -target:library -out:"$out/movebeat.dll" \
    "$repo/MoveBeat/Program.cs" "$repo/MoveBeat/OscSender.cs" "$here/KinectStub.cs"
csc -nologo -target:exe -out:"$out/test.exe" \
    -r:"$out/movebeat.dll" "$here/TestBodyLock.cs"
mono "$out/test.exe"
