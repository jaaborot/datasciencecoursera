# load tidy_dataset2 from disk
tidy_dataset2 <- read.table(file = "tidy_dataset2.txt")

# chunkify tidy_dataset2 into rows of 100
chunks <- split(tidy_dataset2, sample(rep(1:ceil(nrows(tidy_dataset2)/100),100)))

# write to disk each chunk of 100 rows with file name chunk_<i>.txt
for(i in 1:length(chunks)){ 
    write.table(chunks[i], file = paste0("chunks/chunk_", as.character(i), ".txt"), row.names = FALSE) 
}