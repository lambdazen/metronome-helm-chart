CHART=/tmp/metronome-1.2.7-final.2.tgz

# List the largest files *inside* the package (by uncompressed size)
tar -tzf "$CHART" | while read -r f; do
  # print uncompressed byte size and path
  printf "%10d  %s\n" "$(tar -xOf "$CHART" "$f" | wc -c)" "$f"
done | sort -nr | head -30

