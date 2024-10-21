## Week 2 Assignment: Database Searching and Retrieval

### Title: Exploring Biological Databases: NCBI BLAST and Ensembl

**Motivation:**

Understanding how to efficiently search and retrieve biological data from various databases is fundamental in bioinformatics. This assignment will familiarize students with NCBI BLAST and Ensembl, two essential resources for accessing genetic information. The skills developed in this assignment will be foundational for more complex analyses later in the course.

**Goals:**

1. Learn how to use NCBI BLAST for sequence similarity searches.
2. Understand how to navigate the Ensembl database to retrieve gene annotations.
3. Gain practical experience in extracting and interpreting biological data.

**Tasks to Perform:**

1. **NCBI BLAST Search:**
   - **Step 1:** Access the NCBI BLAST website (https://blast.ncbi.nlm.nih.gov/Blast.cgi).
   - **Step 2:** Input the following DNA sequence into the BLASTn tool (Nucleotide BLAST):
```
TCTTATTTTTATTTGTTTACATGTCTTTTCTTATTTTAGTGTCCTTAAAAGGTTGATAATCACTTGCTGA
GTGTGTTTCTCAAACAATTTAATTTCAGGAGCCTACAAGAAAGTACGAGATTTAGTCAACTTGTTGAAGA
GCTATTGAAAATCATTTGTGCTTTTCAGCTTGACACAGGTTTGGAGTGTAAGTGTTGAATATCCCAAGAA
TGACACTCAAGTGCTGTCCATGAAAACTCAGGAAGTTTGCACAATTACTTTCTATGACGTGGTGATAAGA
CCTTTTAGTCTAGGTTAATTTTAGTTCTGTATCTGTAATCTATTTTTAAAAAATTACTCCCACTGGTCTC
ACACC
```
   - **Step 3:** Run the BLAST search and analyze the results. Identify the closest matching sequence and its associated gene.
		- Look at the tabs (Descriptions, Graphic Summary, Alignments, Taxonomy) in the results section and try to find out what information they provide
		- Rerun the query and configure the search to consider only the human (Homo sapiens) genome. Specify the organism to achieve this.
   - **Step 4:** Report the following details:
     - The top matching sequence (Sequence ID) and its alignment score.
     - The gene name and its function.
     - Any relevant annotations or associated diseases.
    
2. **Ensembl Gene Retrieval:**
   - **Step 1:** Access the Ensembl website (http://www.ensembl.org).
   - **Step 2:** Search for the BRCA1 gene using the search bar.
   - **Step 3:** Navigate to the gene's detailed page and explore the following sections:
     - **Gene Summary:** Basic information about the gene.
     - **Location:** Chromosomal location and genomic context.
     - **Transcripts:** Different transcripts and isoforms of the gene.
     - **Variants:** Known variants and their potential impacts.
   - **Step 4:** Retrieve and report the following information:
     - Gene location (chromosome number and base pair range).
     - The number of transcripts and a brief description of their differences.
     - Any notable variants and their associated phenotypes.

