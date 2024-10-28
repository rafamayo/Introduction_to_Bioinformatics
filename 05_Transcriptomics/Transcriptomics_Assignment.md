## Week 5 Assignment: Transcriptomics

### Title: RNA-Seq Data Analysis: Alignment, Assembly, and Differential Expression

**Motivation:**

Transcriptomics, the study of RNA transcripts produced by the genome, allows researchers to understand gene expression and regulation. This assignment will provide hands-on experience with RNA-Seq data analysis, including alignment, transcript assembly, and differential expression analysis. Mastering these techniques is crucial for understanding functional genomics and gene expression patterns.

**Goals:**

1. Learn how to align RNA-Seq reads to a reference genome.
2. Gain practical experience in transcript assembly and quantification.
3. Perform differential expression analysis to identify genes with significant changes in expression.

**Tasks to Perform:**

1. **RNA-Seq Data Alignment:**
   
   - **Step 1:** Download a set of RNA-Seq read data (FASTQ files) from a public repository such as the NCBI SRA. Choose a dataset with at least two conditions (e.g., treated vs. untreated samples).
   - **Step 2:** Use HISAT2 to align the RNA-Seq reads to a reference genome (e.g., Homo sapiens or Mus musculus).
   - **Step 3:** Convert the SAM output files to BAM format using SAMtools, then sort and index the BAM files.
   - **Step 4:** Report the following details:
     - Total number of reads aligned
     - Alignment rate
     - Examples of aligned reads (provide screenshots or specific alignment details)

2. **Transcript Assembly and Quantification:**

   - **Step 1:** Use StringTie to assemble transcripts from the aligned RNA-Seq reads.
   - **Step 2:** Generate a transcript abundance file for each sample.
   - **Step 3:** Merge the assembled transcripts from all samples to create a unified transcriptome assembly.
   - **Step 4:** Report the following details:
     - Number of transcripts assembled
     - Examples of assembled transcripts (provide screenshots or specific transcript details)
     - Summary of transcript abundance for each sample

3. **Differential Expression Analysis:**

   - **Step 1:** Use DESeq2 in R to perform differential expression analysis between the conditions.
   - **Step 2:** Identify significantly differentially expressed genes (DEGs) based on adjusted p-value and log2 fold change.
   - **Step 3:** Generate visualizations such as MA plots and heatmaps to represent the DEGs.
   - **Step 4:** Report the following details:
     - Number of significantly differentially expressed genes
     - Top 10 DEGs with their log2 fold change and adjusted p-values
     - Visualizations (MA plots, heatmaps)
    
4. **Discussion:**
  - Reflection on the importance of RNA-Seq data analysis in transcriptomics.
  - Interpretation of the biological significance of the differential expression results.
  - Challenges faced during the assignment and how they were overcome.

**Expected Outcomes:**

- Students will understand the workflow of RNA-Seq data analysis, from alignment to differential expression analysis.
- Students will be able to use HISAT2, StringTie, and DESeq2 tools to analyze RNA-Seq data.
- Students will interpret the results of RNA-Seq data analysis, including identifying and visualizing differentially expressed genes.

**Tools to Use:**

- **HISAT2:** For aligning RNA-Seq reads to the reference genome.
- **SAMtools:** For converting, sorting, and indexing alignment files.
- **StringTie:** For transcript assembly and quantification.
- **DESeq2:** For differential expression analysis.
- **R and RStudio:** For running DESeq2 and generating visualizations.
- **Command Line Interface (CLI):** To run HISAT2, SAMtools, and StringTie tools.
