######################################################

Creating a series matrix file:

######################################################
#reading in the phenofile:
pheno <- read.csv(file=c('/home/ayeka/Desktop/TCGAprostate/ImportantFiles/pheno.csv'), header=TRUE, sep='\t')

#read in the genesdirfilenames file:
genesdir <- read.csv(file=c('/home/ayeka/Desktop/TCGAprostate/ImportantFiles/genesdirfilenames.csv'), header=FALSE, sep='\t')

#read in the genesdirfilenamescomplete file:
genesdirfull <- read.csv(file=c('/home/ayeka/Desktop/TCGAprostate/ImportantFiles/genesdirfilenamescomplete.csv'), header=FALSE, sep='\t')


#creating the gene expression matrix:
the_first <-as.character(pheno$bcr_patient_barcode[1])
the_first_tcgasam <- genesdir[grep(the_first, genesdir$V1, ignore.case=TRUE),]
p1 <- as.character(the_first_tcgasam[1])
p2 <- as.character(the_first_tcgasam[2])
path1 <- paste(c('/home/ayeka/Desktop/TCGAprostate/genes/'), p1, sep='')
path2 <- paste(c('/home/ayeka/Desktop/TCGAprostate/genes/'), p2, sep='')
gematrixp1 <- read.table(file=path1, header=TRUE, sep='\t')
gematrixp2 <- read.table(file=path2, header=TRUE, sep='\t')
gematrix <- cbind(gematrixp1,gematrixp2[,2])


for (i in (2:(length(pheno$bcr_patient_barcode)))){
	tcgasam <- genesdir[grep(as.character(pheno$bcr_patient_barcode[i]), genesdir$V1, ignore.case=TRUE),]
	print(tcgasam)
	if(length(tcgasam!=0)){
		for (i in (1:length(tcgasam))){
			p <- as.character(tcgasam[i])
			path <- paste(c('/home/ayeka/Desktop/TCGAprostate/genes/'), p, sep='')
			print(path)
			gematrixpart <- read.table(file=path, header=TRUE, sep='\t')
			gematrix <- cbind(gematrix,gematrixpart[,2])
		}
	}else{ statep1 <- c('There are no RNASeq files for')
		statep2 <- as.character(pheno$bcr_patient_barcode[j])
		statefull <- paste(statep1, statep2)
		print(statefull)
	 }
}

#need to recreate the pheno file because not all patients have a tumor sample and a normal adjacent sample:

tcgasamp <- genesdirfull[grep(as.character(pheno$bcr_patient_barcode[1]), genesdirfull$V1, ignore.case=TRUE),]
print(tcgasamp)

newphenopart1 <- cbind(pheno[1,],tcgasamp[1,])
newphenopart2 <- cbind(pheno[1,],tcgasamp[2,])
newpheno <- rbind(newphenopart1, newphenopart2)


for (j in (2:nrow(pheno))){
	tcgasamp <- genesdirfull[grep(as.character(pheno$bcr_patient_barcode[j]), genesdirfull$V1, ignore.case=TRUE),]
	print(tcgasamp)
	if(length(tcgasamp$V3!=0)){
		for (i in (1:nrow(tcgasamp))){
			newphenopart <- cbind(pheno[j,],tcgasamp[i,])
			newpheno <- rbind(newpheno, newphenopart)
		}
	}else{  statep1 <- c('There are no RNASeq files for')
		statep2 <- as.character(pheno$bcr_patient_barcode[j])
		statefull <- paste(statep1, statep2)
		print(statefull)
	 }
}
rownames(gematrix) <- gematrix[,1]
gematrix[,1] <- NULL
dim(gematrix)
colnames(gematrix) <- newpheno[,1]


###writing non-normalized matrix to file:
write.table(gematrix, file= c('/home/ayeka/Desktop/TCGAprostate/ImportantFiles/seriesmatrix_nonnorm.txt'), sep='\t')

###writing newphenofile to file:
write.table(newpheno, file = c('/home/ayeka/Desktop/TCGAprostate/ImportantFiles/newpheno.txt'), sep='\t')


###################################################
#### I checked both files and they look fine ######
###################################################

log2 transform series matrix:

#############################################

newgematrix <- log2(gematrix)
newgematrix[newgematrix < 0] <- 0.000001

###writing locus mean expression distribution to file:
pdf(file=c('/home/ayeka/Desktop/TCGAprostate/Results/meanexprsdistro.pdf'))
hist(rowMeans(newgematrix), main= 'Locus Mean Expression Distribution')
dev.off()

###writing locus standard deviation distribution to file:
pdf(file=c('/home/ayeka/Desktop/TCGAprostate/Results/sdexprsdistro.pdf'))
hist(apply(newgematrix,1,sd), main= 'Locus Standard Deviation Expression Distribution')
dev.off()

###computing how many loci have mean expression greater than 5 and standard deviation greater than 1:
dim(newgematrix[(rowMeans(newgematrix) >= 5 & apply(newgematrix,1,sd) > 1),])

###writing normalized matrix to file:
write.table(newgematrix, file= c('/home/ayeka/Desktop/TCGAprostate/ImportantFiles/seriesmatrix_norm.txt'), sep='\t')


