#!/bin/bash

#bash genomes_runall.sh IDS.txt /home/acobian/CF032_2020 40

#To run do: thisscrit.sh [IDS.txt] [path to main folder] [number of threads to use in the system]

#1) Create a working directory: mkdir CF032_2020
#2) Save this file in the folder CF032_2020
#3) Create a folder for the raw reads, inside your main project folder: mkdir CF032_2020/P00_raw
#4) Put all reads files, including R1 and R1 inside the folder CF032_2020/P00_raw
#5) Create a list with the sample names and save it as IDS.txt, place it in the folder CF032_2020
#6) Open a screes session: screen -DR CF032
#7) Run the command: bash genomes_runall.sh IDS.txt /home/acobian/CF032_2020 40

#mkdir $2/P01_prinseq_output
#1.- Quality filtering pair end : prinseq++
#cat $1 | xargs -t -I{fileID} sh -c "prinseq++ -fastq $2/P00_raw/{fileID}_R1_001.fastq.gz -fastq2 $2/P00_raw/{fileID}_R2_001.fastq.gz -lc_entropy=0.5 -trim_qual_right=15 -trim_qual_left=15
 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 2 -min_len 30 -min_qual_mean 20  -rm_header -out_name $2/P01_prinseq_output/{fileID} -threads $3 -out_format 1"
#prinseq++ -fastq /home/acobian/CF032_2020/P00_raw/AC5204_S63_R1_001.fastq -fastq2 /home/acobian/CF032_2020/P00_raw/AC5204_S63_R2_001.fastq -lc_entropy=0.5 -trim_qual_right=15 -trim_qual_l
eft=15 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 2 -min_len 30 -min_qual_mean 20  -rm_header -out_name /home/acobian/CF032_2020/P01_prinseq_output/AC5204_S63 -threads 40 -o
ut_format 1


#mkdir $2/P02_denovo
#2.- Denovo assembly and comparison to NT
#cat $1 | xargs -I{fileID} sh -c "spades.py -1 $2/P01_prinseq_output/{fileID}_good_out_R1.fasta -2 $2/P01_prinseq_output/{fileID}_good_out_R2.fasta -t $3 --only-assembler -o $2/P02_denovo/
spades_{fileID}"
#cat $1 | xargs -I{fileID} sh -c "perl /home/acobian/bin/removesmalls.pl 900 $2/P02_denovo/spades_{fileID}/contigs.fasta > $2/P02_denovo/more900_contigs_{fileID}.fasta"
#cat $1 | xargs -I{fileID} sh -c "blastn -query $2/P02_denovo/more900_contigs_{fileID}.fasta -db /home/DATABASES/blast/nt/nt -out $2/P02_denovo/vs_NT_more900_contigs_{fileID}.blastn -evalu
e 0.1 -num_threads $3 -max_target_seqs 1 -outfmt '6 qseqid sseqid pident length mismatchgapopen qstart qend sstart send evalue bitscore sskingdoms sscinames'"
#cat $1 | xargs -I{fileID} sh -c "perl /home/acobian/bin/MYSCRIPTS/besthitblast.pl $2/P02_denovo/vs_NT_more900_contigs_{fileID}.blastn > $2/P02_denovo/besthit_vs_NT_more900_contigs_{fileID
}.blastn"


#mkdir $2/P03_subsample_denovo
#3.- Denovo assembly with a small amount of reads, n=100,000
#subsample 100,000 reads
#cat $1 | xargs -I{fileID} sh -c "perl /home/acobian/bin/MYSCRIPTS/random-sample-fasta.pl -i $2/P01_prinseq_output/{fileID}_good_out_R1.fasta -o $2/P03_subsample_denovo/{fileID}_good_out_R
1_subsample_50000.fasta -r -n 50000"
#cat $1 | xargs -I{fileID} sh -c "perl /home/acobian/bin/MYSCRIPTS/random-sample-fasta.pl -i $2/P01_prinseq_output/{fileID}_good_out_R1.fasta -o $2/P03_subsample_denovo/{fileID}_good_out_R
1_subsample_100000.fasta -r -n 100000"

#denovo assemble
#cat $1 | xargs -I{fileID} sh -c "spades.py -s $2/P03_subsample_denovo/{fileID}_good_out_R1_subsample_50000.fasta --only-assembler -t $3 -o $2/P03_subsample_denovo/spades_50000_{fileID}"
#cat $1 | xargs -I{fileID} sh -c "spades.py -s $2/P03_subsample_denovo/{fileID}_good_out_R1_subsample_100000.fasta --only-assembler -t $3 -o $2/P03_subsample_denovo/spades_100000_{fileID}"

#remove smalls
#cat $1 | xargs -I{fileID} sh -c "perl /home/acobian/bin/removesmalls.pl 900 $2/P03_subsample_denovo/spades_50000_{fileID}/contigs.fasta > $2/P03_subsample_denovo/spades50000_more900_conti
gs_{fileID}.fasta"
#cat $1 | xargs -I{fileID} sh -c "perl /home/acobian/bin/removesmalls.pl 900 $2/P03_subsample_denovo/spades_100000_{fileID}/contigs.fasta > $2/P03_subsample_denovo/spades100000_more900_con
tigs_{fileID}.fasta"

#blastN vs NT
#cat $1 | xargs -I{fileID} sh -c "blastn -query $2/P03_subsample_denovo/spades50000_more900_contigs_{fileID}.fasta -db /home/DATABASES/blast/nt/nt -out $2/P03_subsample_denovo/vs_NT_spades
50000_more900_contigs_{fileID}.blastn -evalue 0.1 -num_threads $3 -max_target_seqs 1 -outfmt '6 qseqid sseqid pident length mismatchgapopen qstart qend sstart send evalue bitscore sskingdo
ms sscinames'"
#cat $1 | xargs -I{fileID} sh -c "perl /home/acobian/bin/MYSCRIPTS/besthitblast.pl $2/P03_subsample_denovo/vs_NT_spades50000_more900_contigs_{fileID}.blastn > $2/P03_subsample_denovo/besth
it_vs_NT_spades50000_more900_contigs_{fileID}.blastn"
#cat $1 | xargs -I{fileID} sh -c "blastn -query $2/P03_subsample_denovo/spades100000_more900_contigs_{fileID}.fasta -db /home/DATABASES/blast/nt/nt -out $2/P03_subsample_denovo/vs_NT_spade
s100000_more900_contigs_{fileID}.blastn -evalue 0.1 -num_threads $3 -max_target_seqs 1 -outfmt '6 qseqid sseqid pident length mismatchgapopen qstart qend sstart send evalue bitscore ssking
doms sscinames'"
#cat $1 | xargs -I{fileID} sh -c "perl /home/acobian/bin/MYSCRIPTS/besthitblast.pl $2/P03_subsample_denovo/vs_NT_spades100000_more900_contigs_{fileID}.blastn > $2/P03_subsample_denovo/best
hit_vs_NT_spades100000_more900_contigs_{fileID}.blastn"
