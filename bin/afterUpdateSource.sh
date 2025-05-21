#!/bin/bash

echo "Updating configs"

sync_config_vars() {
    file1="$1"
    file2="$2"

    [ -z "$file1" ] || [ -z "$file2" ] && {
        echo "Usage: sync_config_vars <source_file> <target_file>"
        return 1
    }

    vars_in_file2=$(awk '
        {
            line = $0
            sub(/^[ \t]+/, "", line)
            if (line ~ /^#?[ \t]*[A-Za-z_][A-Za-z0-9_]*[ \t]*=/) {
                gsub(/^#?[ \t]*/, "", line)
                split(line, parts, "=")
                name = parts[1]
                gsub(/[ \t]+$/, "", name)
                print name
            }
        }
    ' "$file2" | sort -u)

    vars_set=$(echo "$vars_in_file2" | tr '\n' ' ')

    while IFS= read -r line || [ -n "$line" ]; do
        clean_line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [ -z "$clean_line" ] && continue

        var_name=""
        if echo "$clean_line" | grep -qE '^#?[[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*='; then
            var_name=$(echo "$clean_line" | sed -E 's/^#?[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=.*/\1/')
        fi

        if [ -n "$var_name" ]; then
            echo "$vars_set" | grep -wq "$var_name" || {
                echo "$line" >>"$file2"
                echo ">> Added: $var_name"
            }
        fi
    done <"$file1"
}

for dir in ./pc/*; do
    if [ -f "$dir/configs.sh" ]; then
        sync_config_vars bin/default/configs.sh $dir/configs.sh
    fi
done
