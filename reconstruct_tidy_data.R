# reconstruct tidy_dataset2 from multiple chunks of it from it
chunk_count = 103 # 100 rows per chunk
tidy_dataset2 <- read.table(file = "chunks/chunk_1.txt", header = TRUE)

for(i in 2:chunk_count){
    tmp <- read.table(file = paste0("chunks/chunk_", as.character(i), ".txt"), header = TRUE)
    names(tmp) <- names(tidy_dataset2)
    tidy_dataset2 <- rbind(tidy_dataset2, tmp)
}

names(tidy_dataset2) <- gsub(pattern = "X1.", replacement = "", x = names(tidy_dataset2))
write.table(tidy_dataset2, file = "reconstructed/tidy_dataset2.txt", row.names = FALSE)
write.table(names(tidy_dataset2), file = "reconstructed/names_tidy_dataset2.txt")