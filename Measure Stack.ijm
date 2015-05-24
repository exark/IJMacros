run("Set Measurements...", "  mean limit redirect=None decimal=3");

roiManager("Select", 0);
roiManager("Remove Slice Info");

for (n=1; n<=nSlices; n++) {
	setSlice(n);
	roiManager("Select", 0);
	run("Measure");
	run("Next Slice [>]");
}