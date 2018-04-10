# ttar: a simple archiving utility

`ttar` is a plain text archiving utility in the vein of `tar(1)` and inspired by [ptar](https://github.com/jtvaughan/ptar), but written in bash. It uses Python as a stream editor on platforms where sed cannot work with null bytes (e.g., macOS).

## Use case

`ttar` was created when fixtures files for some platform tests contained file paths that git could not check out on other platforms (Windows is more restrictive regarding permissible characters and path length than Linux).

Putting the files into a `tar` archive solved the immediate problem but meant that changes to the files became difficult to review. It was also easy to accidentally commit the wrong archive because `git diff` did not show anything useful, and neither did `git log -p`.

Using a plain text archive makes it possible to review changes without downloading and extracting the archive. Also, when working on the repo, git diff and git log become useful again, allowing a committer to verify and track changes over time.

## Supported platforms

The code is written in bash, because bash is available out of the box on all major flavors of Linux and on macOS. The feature set used is restricted to bash version 3.2 because that is what Apple is still shipping. The Python code has been tested with Python 2.7.10.

The program also works on Windows if bash is installed. Obviously, it does not solve the Windows limitations (path length limited to 260 characters, character set restrictions, no symbolic links) that prompted the move to an archive format in the first place.

## Supported input and limitations

`ttar` can handle text files regardless of encodings (ASCII, UTF-8, and others), including files containing NUL bytes (U+0000) which in bash (and C, among others) indicate the end of a string, and files not ending with a newline (LF) character.

`ttar` does not preserve ownership, time stamps, or ACLs beyond standard basic permissions.
