#!/bin/sh
set -o errexit -o nounset

function test_dir {
    local name=$1
    echo "Checking $name."
    echo "  Archive creation."
    echo "    Cleaning up."
    rm -rf $name.ttar $name
    echo "    Creating source directory."
    cp -a test_data/$name $name
    echo "    Creating archive."
    ./ttar -C test_data -c -f $name.ttar $name
    echo "    Comparing to reference archive."
    diff -u test_data/$name.ttar $name.ttar
    echo "    Removing source directory."
    rm -rf $name

    echo "  Restoring archive."
    ./ttar -x -f $name.ttar
    echo "    Comparing to original."
    diff -ru --no-dereference test_data/$name $name
    echo "    Cleaning up."
    rm -rf $name.ttar $name
}

for i in pitfalls sysfs; do
    test_dir $i
done
