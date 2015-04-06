# directory-hash

[![Build Status](https://travis-ci.org/jakutis/directory-hash.svg)](https://travis-ci.org/jakutis/directory-hash)

What is described below is not yet implemented.

See [directory-hash-rust](https://github.com/jakutis/directory-hash-rust) for a more complete implementation.

## Operations

### hash directory > all.file

Lists all paths and their hashes.

### update directory all.file < changed.file > all.file

Checks if files are really existing and changed and adds lines to `all.file`.

### add directory all.file < new.file > all.file

Checks if files are really new and adds lines to `all.file`.

### remove directory all.file < missing.file > all.file

Checks if files are really missing and removes lines in `all.file`.

### changed directory all.file[ path] > changed.file

Path is by default "/".
Checks all hashes in `all.file` and lists paths with changed hashes.

### new directory all.file[ path] > new.file

Path is by default "/".
Lists all paths that are not in `all.file`.

### missing directory all.file[ path] > missing.file

Path is by default "/".
Lists all paths that are not in directory.

### import directory all.file path backup-directory absolute-path > all.file

0. Finds all new, changed and missing paths.
0. Backs up files.
0. Moves new and changed, deletes missing.
0. Lists all paths and their hashes.

## Files

* `all.file`: hash + path
* `changed.file`, `new.file`, `missing.file`: path

## Tips

* have your `all.file` in a git repository
* have this workflow:
  * `mkdir /some/directory /some/directory.writable /some/directory.outgoing /some/directory.incoming`
  * `mount --bind /some/directory.writable /some/directory`
  * `mount -o remount,ro,bind /some/directory`
  * `/some/directory` is a directory for user reads
  * `/some/directory.writable` is *directory*
  * `/some/directory.outgoing` is *backup-directory*
  * `/some/directory.incoming` is a directory for user writes
