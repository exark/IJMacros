roiManager("reset");
run("Clear Results");
Table.create("output");

dir=File.directory;
name=getTitle();
setBatchMode(true);
rename("input");
run("Split Channels");
selectWindow("C3-input");
run("Duplicate...", "title=mask duplicate");
selectWindow("mask");
run("Despeckle");
setOption("BlackBackground", false);
run("Convert to Mask", "method=Huang background=Default calculate black");
selectWindow("mask");
run("Divide...", "value=255 stack");
imageCalculator("Multiply create stack", "C2-input","mask");
selectWindow("Result of C2-input");
setThreshold(10, 65535);
run("Select All");
roiManager("Add");
roiManager("Select", 0);
roiManager("Multi Measure");

nR = nResults;
gfp = newArray(nR);
rfp = newArray(nR);

// Grab the old results
for (i=0; i<nR;i++) {
	gfp[i] = getResult("Mean1", i);
}

selectWindow("output")

for (i=0; i<nR;i++) {
	Table.set("GFP", i,gfp[i]);
}

selectWindow("mask");
imageCalculator("Multiply create stack", "C3-input","mask");
selectWindow("Result of C3-input");
setThreshold(10, 65535);
roiManager("Select", 0);
roiManager("Multi Measure");

// Grab the old results
for (i=0; i<nR;i++) {
	rfp[i] = getResult("Mean1", i);
}

selectWindow("output")

for (i=0; i<nR;i++) {
	Table.set("RFP",i,rfp[i]);
}

Table.update();

selectWindow("Results");
close();

Table.rename("output", "Results");
saveAs("Measurements",dir + name + ".csv");

run("Close All")
setBatchMode(false)
