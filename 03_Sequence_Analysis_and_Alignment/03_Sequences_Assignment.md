## Week 3 Assignment: Sequence Analysis and Alignment

### Sequence Alignment: Understanding Pairwise Sequence Alignment

**Motivation:**

Sequence alignment is a fundamental technique in bioinformatics used to identify regions of similarity that may indicate functional, structural, or evolutionary relationships between sequences. This assignment will provide hands-on experience with pairwise sequence alignment, using state-of-the-art tools. Mastering these techniques is crucial for interpreting genetic data and understanding biological functions and evolution.

**Goals:**

1. Learn how to perform pairwise sequence alignment using the Needleman-Wunsch and Smith-Waterman algorithms.
2. Interpret alignment results to draw conclusions about sequence similarity and function.

**Tasks to Perform:**

1. **Pairwise Sequence Alignment:**

In this task, you will perform pairwise sequence alignments on two protein sequences using both global (Needleman-Wunsch) and local (Smith-Waterman) alignment algorithms. Analyze the results of each alignment to understand the differences between these approaches and when each is appropriate.

Use the following two sequences when performing pairwise sequence alignment:

 ```
 >Seq1
 MVLSPADKTNVKAAWGKVGAHAGEYGAEALERMFLSFPTTKTYFPHFDLSHGSAQVKGHGKKVALGEYGFFALPSDPERFKHLKSVVASLSTFKVNSDSKYR
 ```

 ```
 >Seq2
 MVHLTPEEKSAVTALWGKVNVDEVGGEALGRLLVVYPWTQRFFESFGDLSTPDAVMGNPKVKAHGKKVLGAFSDGLAHLDDLKGTFAALSELHCDKLHVDPEN
 FRLLGNVLVCVLA
 ```
    
   - **Step 1:** Access the EMBOSS Needle tool (https://www.ebi.ac.uk/jdispatcher/psa/emboss_needle/).
   
   - **Step 2:** Perform global alignment using default settings.

   - **Step 3:** Record the following details:
     - Alignment score
     - Percentage identity, similarity and gaps
     - Key regions of similarity and differences (highlight mismatches and gaps)

   - **Step 4:** Analyze the Results: Based on the alignment score and gaps, discuss the strengths and limitations of using global alignment (Needleman-Wunsch) for these sequences. Consider how the algorithm aligns the entire sequence from end to end and why gaps may be introduced.

   - **Step 5:** Access the \href{https://www.ebi.ac.uk/jdispatcher/psa/emboss_water}{EMBOSS Water tool}.
		
   - **Step 6:** Perform local alignment using default settings.

   - **Step 7:** Record the following results:
     - Alignment score
     - Percentage identity, similarity and gaps
     - Number and distribution of gaps

   - **Step 8:** Analyze the Results: Discuss the differences in alignment score and gap placement compared to the global alignment. Note how the local alignment focuses on regions of high similarity and minimizes gaps in unrelated regions.
	
   - **Step 9:** Comparison and Discussion: Compare the results from both the global and local alignments. Note that at this stage, it’s sufficient to hypothesize about general functional relationships based on the observed similarities (e.g., parts of a protein complex or functional partners), without needing to identify the exact protein type. Address the following questions in your discussion
      - Why does the global alignment have more gaps compared to the local alignment?
      - Which alignment approach (global or local) provided a higher score for conserved regions, and why?
      - In what types of bioinformatics analyses would global alignment be preferred over local alignment, and vice versa?
      - Based on the alignment results, do you think these sequences might have similar or complementary functions? Discuss any patterns you observe in conserved regions versus gaps and mismatches. What might these patterns suggest about their relationship (e.g., could they be parts of the same protein complex, like subunits)?
		
   - **Step 10:** Identify these two sequences using the \href{https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastp&PAGE_TYPE=BlastSearch&BLAST_SPEC=&LINK_LOC=blasttab&LAST_PAGE=blastn}{\texttt{blastp suite}}. As database use the \texttt{Non-redundant protein sequences (nr)}.
      - Why do you think certain regions of the sequences were highly conserved?
      - How might the differences observed impact the function of each subunit within hemoglobin?

2. **Discussion:**
  - Reflect briefly on the importance of sequence alignment in bioinformatics.
  - Interpretation of the biological significance of the alignment results.
  - Any challenges faced during the assignment and how they were overcome.


**Expected Outcomes:**

- Students will be able to perform and interpret pairwise and multiple sequence alignments.
- Students will understand the significance of alignment scores, percentage identity, and similarity.
- Students will be able to identify conserved and variable regions in protein sequences, which are important for understanding functional and evolutionary relationships.

**Tools to Use:**

- **EMBOSS Needle:** For pairwise sequence alignment.
- **Clustal Omega:** For multiple sequence alignment.
- **Web Browsers:** To access the online tools.
