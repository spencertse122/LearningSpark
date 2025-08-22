# ==========================================
# CTRL-A DELIMITED FILE CLEANING
# ==========================================

# IMPORTANT: Ctrl-A is \x01 (your delimiter) - DO NOT REMOVE IT!

# 1. Remove problematic control characters (EXCEPT Ctrl-A and newlines)
sed 's/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]/ /g' input.dat > cleaned.dat

# 2. Remove specific problematic characters (quotes, backslashes)
sed 's/["\\]//g' input.dat > cleaned.dat

# 3. Replace tabs and carriage returns (but preserve Ctrl-A and newlines)
sed 's/[\t\r]/ /g' input.dat > cleaned.dat

# ==========================================
# COMPREHENSIVE SOLUTIONS FOR CTRL-A FILES
# ==========================================

# SOLUTION 1: Basic cleaning (preserves Ctrl-A delimiter)
sed -e 's/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]/ /g' \
    -e 's/["\\]//g' \
    -e 's/[\t\r]/ /g' \
    -e 's/  \+/ /g' \
    input.dat > cleaned.dat

# SOLUTION 2: More aggressive cleaning (safe for Ctrl-A delimited)
sed -e 's/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]//g' \
    -e 's/["\u201C\u201D\u2018\u2019]//g' \
    -e 's/[\\]/\//g' \
    -e 's/[\t\r]/ /g' \
    -e 's/  \+/ /g' \
    -e 's/^ *//g' \
    -e 's/ *$//g' \
    input.dat > cleaned.dat

# SOLUTION 3: Using tr command (preserves \x01 delimiter)
tr -d '\000\002-\010\013-\014\016-\037\177' < input.dat > cleaned.dat

# ==========================================
# ADVANCED SOLUTIONS WITH AWK (CTRL-A SAFE)
# ==========================================

# AWK solution for Ctrl-A delimited files
awk -F'\001' '
{
    for(i=1; i<=NF; i++) {
        # Remove control characters EXCEPT \x01 (Ctrl-A)
        gsub(/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]/, " ", $i)
        # Remove problematic quotes
        gsub(/["'"'"'"]/, "", $i)
        # Replace backslashes
        gsub(/\\/, "/", $i)
        # Replace tabs and carriage returns
        gsub(/[\t\r]/, " ", $i)
        # Clean up multiple spaces
        gsub(/  +/, " ", $i)
        gsub(/^ +| +$/, "", $i)
    }
    print
}' OFS='\001' input.dat > cleaned.dat

# ==========================================
# PERL ONE-LINERS (CTRL-A SAFE)
# ==========================================

# SOLUTION 4: Comprehensive Perl cleaning (preserves Ctrl-A)
perl -pe '
    s/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]//g;  # Remove control chars (NOT \x01)
    s/[\r\t]/ /g;                                  # Replace CR/tabs with space
    s/["\u201C\u201D\u2018\u2019]//g;            # Remove various quotes
    s/\\/\//g;                                    # Replace backslashes
    s/  +/ /g;                                    # Replace multiple spaces
    s/^ +| +$//g;                                 # Trim leading/trailing spaces
' input.dat > cleaned.dat

# SOLUTION 5: Handle embedded delimiters (if Ctrl-A appears in data)
perl -pe '
    s/\x01(?=\x01)/\x20/g;                       # Replace double Ctrl-A with space
    s/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]//g; # Remove other control chars
' input.dat > cleaned.dat

# ==========================================
# PREPROCESSING PIPELINES (CTRL-A SAFE)
# ==========================================

# Pipeline 1: Step-by-step cleaning (preserves Ctrl-A)
cat input.dat | \
  tr -d '\000\002-\010\013-\014\016-\037\177' | \  # Remove control chars EXCEPT \x01
  sed 's/["\\]//g' | \                              # Remove quotes and backslashes
  sed 's/[\t\r]/ /g' | \                           # Replace tabs/CR with space
  sed 's/  \+/ /g' | \                             # Normalize spaces
  sed 's/^ *//; s/ *$//' \                         # Trim spaces
  > cleaned.dat

# Pipeline 2: For Ctrl-A delimited with space normalization
cat input.dat | \
  sed 's/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]/ /g' | \  # Clean control chars
  sed 's/["\\]//g' | \                                     # Remove quotes
  sed 's/  \+/ /g' \                                       # Normalize spaces
  > cleaned.dat

# ==========================================
# BACKUP AND SAFETY COMMANDS
# ==========================================

# Always backup first!
cp input.dat input.dat.backup

# Test on first 10 lines
head -10 input.dat | sed 's/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]/ /g'

# Check for Ctrl-A delimiters (should show ^A characters)
head -5 input.dat | cat -A | grep -o '\^A'

# Check field count consistency
head -100 input.dat | awk -F'\001' '{print NF}' | sort | uniq -c

# Find problematic characters (excluding Ctrl-A and newline)
grep -P '[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]' input.dat | head -5

# ==========================================
# PERFORMANCE OPTIMIZED (LARGE FILES)
# ==========================================

# For very large files (GB+), use mawk
mawk -F'\001' '{for(i=1;i<=NF;i++) gsub(/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]/, " ", $i); print}' OFS='\001' input.dat > cleaned.dat

# Parallel processing with GNU parallel
parallel --pipe --block 100M "sed 's/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]/ /g'" < input.dat > cleaned.dat

# ==========================================
# VALIDATION COMMANDS (CTRL-A FILES)
# ==========================================

# Count lines before/after cleaning
echo "Before: $(wc -l < input.dat) lines"
echo "After:  $(wc -l < cleaned.dat) lines"

# Check that Ctrl-A delimiters are preserved
echo "Ctrl-A count before: $(grep -ao \001' input.dat | wc -l)"
echo "Ctrl-A count after:  $(grep -ao \001' cleaned.dat | wc -l)"

# Check for remaining problematic characters (excluding Ctrl-A)
grep -P '[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]' cleaned.dat || echo "No problematic control characters found"

# Compare field counts (for Ctrl-A delimited files)
echo "Field count distribution - Original:"
awk -F'\001' '{print NF}' input.dat | sort | uniq -c | head -5
echo "Field count distribution - Cleaned:"
awk -F'\001' '{print NF}' cleaned.dat | sort | uniq -c | head -5

# ==========================================
# RECOMMENDED QUICK SOLUTIONS FOR CTRL-A
# ==========================================

# RECOMMENDED: This handles 90% of issues while preserving Ctrl-A:
sed -e 's/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]/ /g' -e 's/["\\]//g' -e 's/  \+/ /g' input.dat > cleaned.dat

# ALTERNATIVE: More powerful Perl version (preserves Ctrl-A):
perl -pe 's/[\x00\x02-\x08\x0B-\x0C\x0E-\x1F\x7F]//g; s/[\r\t]/ /g; s/["\\\]//g; s/  +/ /g' input.dat > cleaned.dat

# ==========================================
# SPARK INTEGRATION AFTER CLEANING
# ==========================================

# After cleaning, load into Spark with Ctrl-A delimiter:
# spark.read.option("sep", "\u0001").csv("cleaned.dat")
