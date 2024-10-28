## Week 3 Assignment: Sequence Analysis and Alignment

### Sequence Alignment: Understanding Pairwise and Multiple Sequence Alignments

**Motivation:**

Sequence alignment is a fundamental technique in bioinformatics used to identify regions of similarity that may indicate functional, structural, or evolutionary relationships between sequences. This assignment will provide hands-on experience with pairwise and multiple sequence alignments, using state-of-the-art tools. Mastering these techniques is crucial for interpreting genetic data and understanding biological functions and evolution.

**Goals:**

1. Learn how to perform pairwise sequence alignment using the Needleman-Wunsch and Smith-Waterman algorithms.
2. Understand the principles of multiple sequence alignment and apply them using Clustal Omega.
3. Interpret alignment results to draw conclusions about sequence similarity and function.

**Tasks to Perform:**

1. **Pairwise Sequence Alignment:**
   - **Step 1:** Access the EMBOSS Needle tool (https://www.ebi.ac.uk/jdispatcher/psa/emboss_needle/).
   - **Step 2:** Use the following two protein sequences for alignment:
     
     - Sequence 1: 
       ```
       MKTLLILTFLCLLATHTDTSATYQTKDALAKDPRIAQDEYTGKFLYLALMGNEYMFKKSSKYGRAVLAKGLVEIVNLLKEKQNKPKSPLK
       ```

     - Sequence 2: 
       ```
       MTTLILTFLCLLATHTDTSATYQTKDAAAKDPRIAQDEYTGKFLYLALMGNAYMFKKSSKYGRAVLAKGLVEIVNLLEEKQNKPKSPL
       ```
   
   - **Step 3:** Perform the alignment using default settings.
   - **Step 4:** Report the following details:
     - Alignment score
     - Percentage identity and similarity
     - Key regions of similarity and differences (highlight mismatches and gaps)
