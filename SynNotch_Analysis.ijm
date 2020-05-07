rename("image");
run("Stack to Hyperstack...", "order=xyczt(default) channels=4 slices=1 frames=1 display=Grayscale");
selectWindow("image");
Stack.setChannel(4);
run("Enhance Contrast...", "saturated=0.95");
setTool("freehand");
waitForUser("Pick ROIs");

Table.create("output");
run("Clear Results");

nROIs = roiManager("count");
for (i = 0; i < nROIs; i++) {
	roiManager("select", i);
	roiManager("remove slice info");

	roiManager("select", i);
	Stack.setChannel(2);
	run("Measure");

	roiManager("select", i);
	Stack.setChannel(4);
	run("Measure");

	nR = nResults;
	cfp = getResult("Mean", nR-2);
	rfp = getResult("Mean", nR-1);

	selectWindow("output");
	Table.set("CFP", i, cfp);
	Table.set("RFP", i, rfp);
	Table.set("Norm", i, rfp/cfp);
}
selectWindow("Results");
close();
Table.rename("output", "Results");
String.copyResults();
roiManager("reset");