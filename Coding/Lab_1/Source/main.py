# Coding Lab 1: Reverse complement of DNA

# HINTS
# Use a dctionary for complementing
# Reverse by slicing
# Be careful with whitespaces and newline characters
# When parsing FASTA, preserve headers and ensure output sequences are uppercase 

def reverse_complement(seq:str) -> str:
    #TODO: implement mapping A - T, C - G and reverse
    pass

def process_fasta(infile:str, outfile:str):
    # Read FASTA, cpute reverse complement, write FASTA
    with open(infile) as inf, open(outfile,"w") as outf:
        # Simple parser
        header = None
        seq_lines = []
        for line in inf:
            if line.startswith(">"):
                if header:
                    rc = reverse_complement("".join(seq_lines))
                    outf.write(header + "\n" + rc + "\n")
                header = line.strip()
                seq_lines = []
            else:
                seq_lines.append(line.strip())
        # last record
        if header:
            rc = reverse_complement("".join(seq_lines))
            outf.write(header + "\n" + rc + "\n")

if __name__== "__main__":
    # Example 1: use reverse_complement directly
    print("Example 1: use reverse_complement directly!")
    
    seq = "GATTACA"

    print("The original sequence:  " + seq)
    print("The reverse complement: " + reverse_complement(seq))

    # Example 2: process a FASTA file
    print("Example 2: process a FASTA file!")
    process_fasta("./example_1.fasta", "./reverse_example_1.fasta")
    process_fasta("./example_2.fasta", "./reverse_example_2.fasta")
    print("Done!")
