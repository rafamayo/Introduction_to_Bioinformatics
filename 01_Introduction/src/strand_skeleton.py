"""
strand_skeleton.py -- starting point for the exercise
"Which strand is the sense strand?"

Fill in the functions marked TODO. Run this file to test them:
    python strand_skeleton.py
Then use them on mystery_dna.fasta (see the bottom of the file).
"""

STOPS = {"TAA", "TAG", "TGA"}

# The standard genetic code, one-letter amino acids ("*" = stop).
CODE = {
    "TTT": "F", "TTC": "F", "TTA": "L", "TTG": "L", "CTT": "L", "CTC": "L",
    "CTA": "L", "CTG": "L", "ATT": "I", "ATC": "I", "ATA": "I", "ATG": "M",
    "GTT": "V", "GTC": "V", "GTA": "V", "GTG": "V", "TCT": "S", "TCC": "S",
    "TCA": "S", "TCG": "S", "AGT": "S", "AGC": "S", "CCT": "P", "CCC": "P",
    "CCA": "P", "CCG": "P", "ACT": "T", "ACC": "T", "ACA": "T", "ACG": "T",
    "GCT": "A", "GCC": "A", "GCA": "A", "GCG": "A", "TAT": "Y", "TAC": "Y",
    "TAA": "*", "TAG": "*", "TGA": "*", "CAT": "H", "CAC": "H", "CAA": "Q",
    "CAG": "Q", "AAT": "N", "AAC": "N", "AAA": "K", "AAG": "K", "GAT": "D",
    "GAC": "D", "GAA": "E", "GAG": "E", "TGT": "C", "TGC": "C", "TGG": "W",
    "CGT": "R", "CGC": "R", "CGA": "R", "CGG": "R", "AGA": "R", "AGG": "R",
    "GGT": "G", "GGC": "G", "GGA": "G", "GGG": "G",
}


def read_fasta(path):
    """Return the sequence of a one-record FASTA file as an upper-case
    string, with U replaced by T."""
    seq = [line.strip() for line in open(path) if not line.startswith(">")]
    return "".join(seq).upper().replace("U", "T")


def revcomp(seq):
    """Reverse complement of a DNA sequence."""
    raise NotImplementedError("TODO")


def translate(seq):
    """Translate codon by codon from the first base; ignore a trailing
    incomplete codon."""

    # HINTS for translate()
    # - Cut the sequence into consecutive codons, starting at position 0:
    #   bases 0-2, 3-5, 6-8, ... Look each codon up in CODE and join the
    #   amino acids into one string.
    # - Simplest way: let range() step through the start positions in
    #   steps of 3 and take each codon with a slice. Make sure the last
    #   start position still leaves room for a complete codon, so that one
    #   or two leftover bases are ignored.
    # - Do NOT use str.replace(): it finds codons in every reading frame,
    #   not only in yours, and the amino-acid letters it inserts (A, C, G,
    #   T are amino acids too!) can be matched again by later replacements.
    # - The keys of CODE are strings like "ATG". A tuple ('A', 'T', 'G')
    #   is a different key and will not be found.
    # - Optional, for the curious: look up the "grouper" recipe in the
    #   itertools documentation. It cuts a sequence into groups with zip()
    #   and a single iterator passed three times. Try to explain why it
    #   works, and why zip() drops the incomplete last codon by itself.
    raise NotImplementedError("TODO")


def find_orfs(seq, min_codons=30):
    """Return a list of ORFs (ATG ... stop, stop included) of at least
    min_codons codons on both strands and in all three frames.
    Each ORF: a dict with strand ("+" or "-"), frame (1-3),
    start and end (1-based top-strand coordinates; start > end on "-"),
    codons and protein."""
    raise NotImplementedError("TODO")


def find_motif(seq, motif):
    """All occurrences of motif on both strands, as (strand, start, end)
    in top-strand coordinates."""
    raise NotImplementedError("TODO")


if __name__ == "__main__":
    assert revcomp("ATGC") == "GCAT"
    assert revcomp("AACGTT") == "AACGTT"          # a palindrome
    assert translate("ATGGCCTAA") == "MA*"
    assert translate("ATGGCCTA") == "MA"
    toy = "CCATGAAATTTTAGCC"                       # ORF on the top strand
    hits = find_orfs(toy, min_codons=3)
    assert any(o["strand"] == "+" and o["start"] == 3 and o["end"] == 14
               for o in hits), hits
    hits = find_orfs(revcomp(toy), min_codons=3)    # same ORF, other strand
    assert any(o["strand"] == "-" and o["start"] == 14 and o["end"] == 3
               for o in hits), hits
    assert ("+", 3, 5) in find_motif(toy, "ATG")
    print("all tests passed")

    seq = read_fasta("mystery_dna.fasta")
    print(f"sequence length: {len(seq)}")
    for o in find_orfs(seq, 30):
        print(o)
