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
cat $1 | xargs -t -I{fileID} sh -c "prinseq++ -fastq $2/P00_raw/{fileID}_R1_001.fastq.gz -fastq2 $2/P00_raw/{fileID}_R2_001.fastq.gz -lc_entropy=0.5 -trim_qual_right=15 -trim_qual_left=15 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 2 -min_len 30 -min_qual_mean 20  -rm_header -out_name $2/P01_prinseq_output/{fileID} -threads $3 -out_format 1"
#prinseq++ -fastq /home/acobian/CF032_2020/P00_raw/AC5204_S63_R1_001.fastq -fastq2 /home/acobian/CF032_2020/P00_raw/AC5204_S63_R2_001.fastq -lc_entropy=0.5 -trim_qual_right=15 -trim_qual_left=15 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 2 -min_len 30 -min_qual_mean 20  -rm_header -out_name /home/acobian/CF032_2020/P01_prinseq_output/AC5204_S63 -threads 40 -out_format 1

