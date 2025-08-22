# ==========================================
# BASIC CLEANING COMMANDS
# ==========================================

# 1. Remove control characters and line breaks within fields
sed 's/[[:cntrl:]]/ /g' input.dat > cleaned.dat

# 2. Remove specific problematic characters (quotes, backslashes)
sed 's/["\\]//g' input.dat > cleaned.dat

# 3. Replace tabs and multiple spaces with single space
sed 's/[[:space:]]\+/ /g' input.dat > cleaned.dat

# ==========================================
# COMPREHENSIVE ONE-LINER SOLUTIONS
# ==========================================

# SOLUTION 1: Basic cleaning (most common issues)
sed -e 's/[[:cntrl:]]/ /g' -e 's/["\\]//g' -e 's/[[:space:]]\+/ /g' input.dat > cleaned.dat

# SOLUTION 2: Aggressive cleaning for CSV/delimited files
sed -e 's/[[:cntrl:]]//g' \
    -e 's/["\u201C\u201D\u2018\u2019]//g' \
    -e 's/[\\]/\//g' \
    -e 's/[[:space:]]\+/ /g' \
    -e 's/^ *//g' \
    -e 's/ *$//g' \
    input.dat > cleaned.dat

# SOLUTION 3: Using tr command (faster for large files)
tr -d '\000-\037\177' < input.dat | tr -s ' ' > cleaned.dat

# ==========================================
# ADVANCED SOLUTIONS WITH AWK
# ==========================================

# AWK solution for CSV files (handles quoted fields better)
awk -F',' '
{
    for(i=1; i<=NF; i++) {
        # Remove control characters
        gsub(/[[:cntrl:]]/, " ", $i)
        # Remove problematic quotes
        gsub(/["'"'"'"]/, "", $i)
        # Replace backslashes
        gsub(/\\/, "/", $i)
        # Clean up spaces
        gsub(/[[:space:]]+/, " ", $i)
        gsub(/^ +| +$/, "", $i)
    }
    print
}' OFS=',' input.dat > cleaned.dat

# ==========================================
# PERL ONE-LINERS (MOST POWERFUL)
# ==========================================

# SOLUTION 4: Comprehensive Perl cleaning
perl -pe '
    s/[\x00-\x1F\x7F]//g;           # Remove control characters
    s/[\r\n\t]/ /g;                 # Replace line breaks/tabs with space
    s/["\u201C\u201D\u2018\u2019]//g; # Remove various quotes
    s/\\/\//g;                      # Replace backslashes with forward slash
    s/\s+/ /g;                      # Replace multiple spaces with single
    s/^\s+|\s+$//g;                 # Trim leading/trailing spaces
' input.dat > cleaned.dat

# SOLUTION 5: Handle specific delimiter issues
perl -pe 's/,(?=(?:[^"]*"[^"]*")*[^"]*$)/ /g' input.dat > cleaned.dat  # Replace commas outside quotes

# ==========================================
# PREPROCESSING PIPELINES
# ==========================================

# Pipeline 1: Step-by-step cleaning
cat input.dat | \
  tr -d '\000-\037\177' | \          # Remove control chars
  sed 's/["\\]//g' | \               # Remove quotes and backslashes
  sed 's/[[:space:]]\+/ /g' | \      # Normalize spaces
  sed 's/^ *//; s/ *$//' \           # Trim spaces
  > cleaned.dat

# Pipeline 2: For pipe-delimited files
cat input.dat | \
  sed 's/|/ /g' | \                  # Replace pipes with spaces
  tr -d '\000-\037\177' | \          # Remove control chars
  sed 's/[[:space:]]\+/|/g' \        # Restore pipe delimiters
  > cleaned.dat

# ==========================================
# BACKUP AND SAFETY COMMANDS
# ==========================================

# Always backup first!
cp input.dat input.dat.backup

# Test on first 10 lines
head -10 input.dat | sed 's/[[:cntrl:]]/ /g'

# Check for specific problematic characters
grep -P '[\x00-\x1F\x7F]' input.dat | head -5    # Find control chars
grep -o '[^[:print:]]' input.dat | sort | uniq   # Find non-printable chars

# ==========================================
# PERFORMANCE OPTIMIZED (LARGE FILES)
# ==========================================

# For very large files (GB+), use mawk instead of awk
mawk '{gsub(/[[:cntrl:]]/, " "); print}' input.dat > cleaned.dat

# Parallel processing with GNU parallel
parallel --pipe --block 100M "sed 's/[[:cntrl:]]/ /g'" < input.dat > cleaned.dat

# ==========================================
# SPECIFIC SOLUTIONS BY FILE TYPE
# ==========================================

# CSV files with embedded commas
sed 's/,\([^"]*\),/,\1 /g' input.dat > cleaned.dat

# Tab-delimited files
sed 's/\t[^[:print:]]*\t/\t \t/g' input.dat > cleaned.dat

# Fixed-width files (preserve positioning)
sed 's/[[:cntrl:]]/ /g' input.dat > cleaned.dat

# ==========================================
# VALIDATION COMMANDS
# ==========================================

# Count lines before/after cleaning
echo "Before: $(wc -l < input.dat) lines"
echo "After:  $(wc -l < cleaned.dat) lines"

# Check for remaining problematic characters
grep -P '[[:cntrl:]]' cleaned.dat || echo "No control characters found"

# Compare field counts (for delimited files)
awk -F',' '{print NF}' input.dat | sort | uniq -c
awk -F',' '{print NF}' cleaned.dat | sort | uniq -c

# ==========================================
# RECOMMENDED QUICK SOLUTION
# ==========================================

# This handles 90% of common issues:
sed -e 's/[[:cntrl:]]/ /g' -e 's/["\\]//g' -e 's/[[:space:]]\+/ /g' input.dat > cleaned.dat

# Or if you prefer Perl (more powerful):
perl -pe 's/[\x00-\x1F\x7F\r\n\t]/ /g; s/["\\\]//g; s/\s+/ /g; s/^\s+|\s+$//g' input.dat > cleaned.dat