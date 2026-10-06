## Week 1 Assignment: DNA strands and gene orientation

### Finding a gene's orientation from sequence alone

### Motivation

You are given a piece of double-stranded DNA. Chemically, its two strands
are equivalent: nothing in the molecule labels one of them as the "sense"
strand. Your task is to find the gene in it, decide which strand is the
**coding (sense)** strand and which the **template (antisense)** strand,
and only then check your answer against the RNA that the gene actually
produces.

Time: about 60 minutes for Parts A to C, plus 30 minutes for the optional
Part D.

### Background in brief

- RNA polymerase reads the **template strand** 3'→5' and builds the RNA
  5'→3'. The RNA therefore has the same sequence as the **coding
  strand** (with U instead of T).
- Genes lie on **both** strands of a chromosome. "Sense" and "antisense"
  describe a strand's role for one particular gene, not a property of the
  whole molecule.
- A file shows only one strand, 5'→3' (the "top" strand). The bottom
  strand is its **reverse complement**: complement every base
  (A↔T, C↔G) *and* reverse the order.
- An **open reading frame (ORF)** is a stretch that starts with ATG and
  continues codon by codon, without a stop, up to a stop codon (TAA, TAG
  or TGA). A sequence has **six reading frames** in which ORFs can occur
  (see below).

Signals that mark a **bacterial** gene, read on its coding strand, 5'→3':

| Signal | Typical sequence | Where |
|---|---|---|
| -35 box | TTGACA | about 17 nt upstream of the -10 box |
| -10 box | TATAAT | transcription starts 5 to 9 nt after it |
| Shine-Dalgarno box | AGGAGG | 5 to 10 nt before the start codon |
| Start / stop codon | ATG / TAA, TAG, TGA | beginning / end of the ORF |
| Terminator | GC-rich inverted repeat, then a run of T | shortly after the stop codon |

Signals of a **eukaryotic** gene (Part D): TATA box (TATAAA) about 25 to 30
nt before the transcription start; introns that almost always begin with
**GT** and end with **AG**; the polyadenylation signal AATAAA shortly
before the end of the RNA; a poly(A) tail added to the mature mRNA.

### Six reading frames

The genetic code is read in triplets (codons), and nothing in the
sequence marks where a triplet begins. Where you start decides how the
sequence is cut into codons. There are three possibilities: start at
base 1, 2 or 3. (Starting at base 4 gives the same codons as base 1, one
codon later.) Each start gives a different **reading frame**:

```
Frame +1:  ATG GCC TTT GAA      ->  M  A  F  E
Frame +2:   TGG CCT TTG AA      ->  W  P  L
Frame +3:    GGC CTT TGA A      ->  G  L  stop
```

The gene could also lie on the other strand. So take the reverse
complement (`TTCAAAGGCCAT`) and do the same again:

```
Frame -1:  TTC AAA GGC CAT      ->  F  K  G  H
Frame -2:   TCA AAG GCC AT      ->  S  K  A
Frame -3:    CAA AGG CCA T      ->  Q  R  P
```

That makes 3 × 2 = **6 frames**. A real gene is read in only one of
them, but in an unknown piece of DNA you know neither the strand nor the
start, so you have to search all six. That is what an ORF finder does,
and it is your task in A2.

Think of a byte stream of 3-byte words without any alignment marker:
read with the right offset, you get meaningful words; shift by one or two
bytes, and everything after that is nonsense. In a gene, inserting or
deleting one or two bases has exactly this effect (a **frameshift
mutation**). Inserting or deleting three bases only adds or removes one
amino acid.

**ORF or coding sequence?** An ORF is defined by the sequence alone.
Random sequence contains many short ORFs, and most ORFs are never
translated. The **coding sequence (CDS)** is the part of an mRNA that is
actually translated into protein. In other words: an ORF is a
*candidate*; a CDS is a *confirmed* gene. In a eukaryotic gene the CDS
forms one ORF only in the spliced mRNA, because introns interrupt it in
the genomic DNA (Part D).

### Files and tools

| File | When |
|---|---|
| `mystery_dna.fasta` | from the start |
| `transcript.fasta` | only after you have answered A6 |
| `mystery_eukaryote.fasta`, `spliced_mrna.fasta` | Part D |

Write the tools yourself in Python; `strand_skeleton.py` gives you the
function signatures and small tests to start from. You may check your
results with web tools (NCBI ORFfinder, Expasy Translate), but your
answers must come from your own code.

**Coordinates:** count positions 1-based on the top strand. For something
on the bottom strand, give it as "from the higher to the lower number",
e.g. "bottom strand, 500-401" (this is also how NCBI ORFfinder does it).

### Part A: Find the gene without the RNA

**A1.** Write `revcomp(seq)` and `translate(seq)`. Check:
`revcomp("ATGC") == "GCAT"` and `translate("ATGGCCTAA") == "MA*"`.

**A2.** Write an ORF finder for all six frames. List every ORF of at least
30 codons (ATG up to and including the stop codon): strand, frame,
coordinates, length in codons. Then lower the limit to 15 codons and look
at what else appears.

**A3.** Translate the longest ORF and read its first 25 amino acids in the
one-letter code. What do you notice? Does the same ORF contain further
ATGs, and what are they?

**A4.** How likely is an ORF this long by chance? In random sequence,
3 of the 64 codons are stops, so each codon is a non-stop with
probability 61/64. Compute the probability of at least *n* non-stop
codons in a row after an ATG, for your longest and your second-longest
ORF. What do you conclude?

**A5.** Search **both strands** for the bacterial signals in the table.
For every hit, note strand and position. Do the hits lie on the same
strand as the long ORF, in the right order and at plausible distances?
Then look shortly after the stop codon for a terminator. (Hint: a run of
T on one strand is a run of A on the other.)

**A6.** Decide, with reasons: which strand of the given sequence is the
coding strand of this gene, and which is the template strand? Predict
where transcription starts and where it ends.

### Part B: Check with the transcript

Now ask for `transcript.fasta`.

**B1.** Replace U by T and search the transcript on both strands. Where
does it match?

**B2.** Where does it start and end? Compare with your predictions from A6.

**B3.** How long are the untranslated parts before the start codon
(5' UTR) and after the stop codon (3' UTR)?

**B4.** Was A6 right? Which evidence from Part A was the strongest, and
which would have been misleading on its own?

### Part C: Think it over

**C1.** Someone says: "The top strand of this chromosome is the sense
strand." Why is that statement wrong in general?

**C2.** Genome browsers show genes on the "+" or the "−" strand. What do
"+" and "−" mean, and how do they relate to sense and antisense?

**C3.** Why does the ORF-length argument work well for bacteria but much
less well for human genes?

### Part D (optional): A eukaryotic gene with an intron

**D1.** Run your ORF finder on `mystery_eukaryote.fasta`. Is there a long
ORF? What does that tell you?

**D2.** Search both strands for TATAAA and AATAAA.

**D3.** Find `spliced_mrna.fasta` in the genomic sequence. It does not
match in one piece. Find the pieces. What lies between them, and how does
that stretch begin and end? How does the same stretch begin and end when
read on the other strand?

**D4.** Translate the mRNA from its first ATG. Then translate the genomic
DNA from the same ATG *without* removing the intron. What happens, and
why?

**D5.** What is at the end of the mRNA that is not in the genome?

**D6.** Which strand is the coding strand here? Which signals told you,
and which would have told you without the mRNA?

### What to hand in

Your code, and a short lab log with the answers to A1 to C3 (and D1 to D6
if you did Part D), including the coordinates you found.
