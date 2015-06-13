# directory-hash

[![Build Status](https://travis-ci.org/jakutis/directory-hash.svg)](https://travis-ci.org/jakutis/directory-hash)

What is described below is not yet implemented.

See [directory-hash-rust](https://github.com/jakutis/directory-hash-rust) for a more complete implementation.

## Operations

### list_errors directory

List all errors encountered while reading the filesystem directory tree.

### hash directory > all.file

Lists all paths and their hashes.

### fix_nonutf8_paths directory replacement

Renames all paths whose string is not a valid utf8 string by replacing invalid utf8 parts with the `replacement` string.

### list_nonutf8_paths directory

Lists all paths whose string is not a valid utf8 string.

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

### duplicate all.file[ path] > duplicate.file

Path is by default "/".
Lists all paths that have identical contents in directory.

### import directory all.file path backup-directory absolute-path > all.file

0. Finds all new, changed and missing paths.
0. Backs up files (actually happens in the next step, to avoid copying).
0. Moves new and changed, deletes missing.
0. Lists all paths and their hashes.

## Files

* `all.file`: hash + path
* `changed.file`, `new.file`, `missing.file`, `duplicate.file`: path

## Tips

* have your `all.file` in a git repository
* have this workflow:
  * `mkdir /some/directory /some/directory.writable /some/directory.outgoing /some/directory.incoming`
  * `mount --bind /some/directory.writable /some/directory`
  * `mount -o remount,ro,bind /some/directory`
  * `/some/directory` is a directory for user reads
  * `/some/directory.writable` is **directory**
  * `/some/directory.outgoing` is **backup-directory**
  * `/some/directory.incoming` is a directory for user writes
