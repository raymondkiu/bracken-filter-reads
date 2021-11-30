# bracken-filter-reads
This script filters low abundant reads from [Bracken](https://github.com/jenniferlu717/Bracken) outputs directly. It will also remove relative abundance (Sample_frac) columns, taxonomy_id and taxonomic_lvl columns.

## Usage
You will need to specify -n as the lowest threshold for taxa to be removed. E.g. if you set -n 1000, if a specific taxon has less than 1000 reads across all samples, this taxon will be removed.
```
$ ./filter_bracken.sh -h

bracken-filter-reads filters low abundant reads from Bracken outputs

Usage example: bracken-filter-reads -n 1000 -o NEW-OUTPUT BRACKEN-OUTPUT-TABLE

Options:
 -n Lowest threshold for filtering reads (default:1000)
 -o New output name (default: OLDFILENAME-filtered)
 -h Print usage and exit
 -v Print version and exit

Version 0.1 (2021)
Author: Raymond Kiu Raymond.Kiu@quadram.ac.uk
```
