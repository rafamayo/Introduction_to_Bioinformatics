# Coding Lab 2: GC Content and Sliding Window Analysis

# HINTS
# Count G and C in sequence with \texttt{seq.count('G') + seq.count('C')}.
# Convert to uppercase to avoid case mismatches.
# When window parameters exceed sequence length, handle gracefully (e.g., skip or report).
# For plotting, positions vs. GC fraction is typical.

def gc_content(seq:str) -> float:
    # returns GC fraction (0.0 - 1.0)
    pass

def gc_sliding(seg:str, window:int, step:int):
    # Return list of (position, gc_fraction) for windows.
    results = []
    for i in range(0, len(seq) - window + 1, step):
        subseq = seq[i:i + window]
        gc = gc_content(subseq)
        results.append((i, gc))
    return results

if __name__== "__main__":
    # Example
    seq = "ATGCCGTAAGC"

    print(gc_content(seq))
    print(gc_sliding(seq, window=4, step=1))
