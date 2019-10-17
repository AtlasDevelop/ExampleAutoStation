#!/bin/sh

root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$root/loadProjectHelper.sh"

init

bundlesPath="$root/bundles"
files=$(ls $bundlesPath)
for filename in $files

do
 echo $filename
 copyDeveloperPlugin $filename
done

echo "load successfull"
