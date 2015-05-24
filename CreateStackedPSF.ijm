setBatchMode(true);
for (n= 1; n<=330; n++) {
	run("Duplicate...", "title=[STACKED PSF" + n + "] duplicate range=1");
}
run("Images to Stack", "method=[Copy (center)] name=Stack title=STACKED PSF");
setBatchMode("show")