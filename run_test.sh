#!/bin/sh
set -o errexit -o nounset

# Fix permissions that are not preserved by git
chmod 400 test_data/pitfalls/permissions/400
chmod 700 test_data/pitfalls/permissions

ln_test=test_data/pitfalls/symlinks/ln1.txt

if diff --no-dereference "$ln_test" "$ln_test" 2>/dev/null; then
    DIFF_OPTS="--no-dereference"
fi

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
    rc=0
    diff -ru ${DIFF_OPTS:-} test_data/$name $name || rc=$?
    if [ -n "${DIFF_OPTS:-}" -a $rc -ne 0 ]; then
      # If we have --no-dereference, errors are unexpected.
      echo "ERROR $name and test_date/$name differ. Aborting."
      exit 3
    fi
    echo "    Cleaning up."
    rm -rf $name.ttar $name
}

for i in pitfalls sysfs; do
    test_dir $i
done
