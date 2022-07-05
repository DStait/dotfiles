function cdtmp
    set -l temp_dir (mktemp -d)
    cd $temp_dir
end
