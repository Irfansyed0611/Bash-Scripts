# This script moves all files into folders named after their extensions (e.g., .pdf files go to 'pdf/' directory).

#/usr/bin/env bash


for file in *; do
    if [[ -f "$file" && ! "$file" =~ \.zip$ ]]; then
        ext="${file##*.}"
        ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

        if [[ "$ext" == "$file" ]]; then
            continue
        fi

        mkdir -p "$ext"

        mv "$file" "$ext/"
        echo "Move $file to $ext/"
    fi
done

echo "Files organized completely"
