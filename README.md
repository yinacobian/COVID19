# COVID19
Data analysis for Marisa Roja's project of environmental distribution of SARS-Cov-2

## 1. Download sequencing files from ftp server: 

`wget --user user --password password [path to directory on FTP server] .`

## 2. Prepare directories

### 2.1 Create a directory for this project

`mkdir MG_COVID19`

### 2.2 Copy the file run_all.sh to the project directory

`wget ....`

### 2.3 Create a directory for the raw sequencing files

`mkdir MG_COVID19/P00_raw`

### 2.4 Put the sequencing files inide the P00_raw directory

### 2.5 Make a list of IDS 

`ls P00_raw/ | cut -f 1,2,3 -d '_' | sort -n | uniq > IDS.txt`

## 2. Quality filtering:

## 3. FRAP to SARS-CoV-2 genomes:

`perl jmf4.pl /home/acobian/UCSD-download-06172020/FRAP-SARS-CoV-2/DB/SARSCOV2.fna /home/acobian/UCSD-download-06172020/FRAP-SARS-CoV-2/DS /home/acobian/UCSD-download-06172020/FRAP-SARS-CoV-2/results smalt 50000`

## About databases

`
>NC_030888.1 Sclerotium hydrophilum virus 1 isolate ShR#20 putative RNA-dependent RNA polymerase gene, complete cds
>NC_030891.1 Sclerotium hydrophilum virus 1 isolate ShR#77 hypothetical protein genes, complete cds
>NC_025401.1 Sunguru virus isolate Ug#41, complete genome
`

`sed -i 's/#/_/g' viral.fna`
