function voipmonField
    set -l cdrFile $argv[1]
    set -l cdrField $argv[2]
    # Get the field index for the column we are after
    set -l fieldLoc (sed -n '2s/;/\n/gp' "$cdrFile"  | grep -nix "$cdrField"  | cut -d':' -f 1)
    # Need to look past the first 3 lines to ignore the SEP, Column names & empty line
    awk -F ';' -v LOC=$fieldLoc 'NR>3 {print $LOC}' $cdrFile | sort | uniq -c | sort
end