rename("EKAR Analysis");

run("Select All");
roiManager("Add");
run("Deinterleave", "how=3 keep");
setBatchMode(true);
selectWindow("EKAR Analysis #3");
setAutoThreshold("Percentile dark");
setOption("BlackBackground", false);
run("Convert to Mask", "stack");
rename("Cell Mask");
selectWindow("EKAR Analysis #2");
setAutoThreshold("Mean dark");
run("Convert to Mask", "stack");
rename("Nuclear Mask");
imageCalculator("Subtract create stack", "Cell Mask","Nuclear Mask");
selectWindow("Nuclear Mask");
close();
selectWindow("Cell Mask");
close();
selectWindow("Result of Cell Mask");
run("Divide...", "value=255 stack");
selectWindow("EKAR Analysis #1");
rename("YFP");
imageCalculator("Multiply create stack", "YFP","Result of Cell Mask");
selectWindow("Result of Cell Mask");
close();
selectWindow("Result of YFP");
rename("Background Mask");

for (n=1; n<=nSlices; n++) {
	selectWindow("Background Mask");
	setAutoThreshold("Percentile dark");
	run("Set Measurements...", " mean limit redirect=None decimal=3");
	setSlice(n);
	roiManager("Select", 0);
	roiManager("Remove Slice Info");
	run("Measure");
	BG = getResult("Mean");
	if (isNaN(BG)) {
		BG=0;
	}
	selectWindow("YFP");
	setSlice(n);
	roiManager("Select", 0);
	run("Subtract...", "value=BG slice");
}
	
	selectWindow("Background Mask");
	close();
	selectWindow("YFP");
	close();
	
	run("Set Measurements...", "  mean limit redirect=None decimal=3");

	setBatchMode(false);
	n = roiManager("count");
  	for (i=n-1; i>=0; i--) {
		roiManager("select",i);
    	roiManager("delete");
	}
	
	waitForUser("Select background region");
	run("Select All");
	roiManager("Add");
	setBatchMode(true)
	roiManager("Select", 0);
	roiManager("Remove Slice Info");
	roiManager("Select", 1);
	roiManager("Remove Slice Info");

		for (n= 1; n<=nSlices; n++) {
			setSlice(n);
			roiManager("Select", 0);
			run("Measure");
			BG = getResult("Mean");
			roiManager("Select", 1);
			run("Subtract...", "value=BG slice");
			run("Next Slice [>]");
		}

	ch=3;
	fr=nSlices/ch;

	run("Stack to Hyperstack...", "order=xyczt(default) channels=ch slices=1 frames=fr display=Grayscale");

	selectWindow("EKAR Analysis")
		run("Split Channels");
	selectWindow("C1-EKAR Analysis");
		rename("EKAR FRET");
		run("Enhance Contrast", "saturated=0.35");
		setBatchMode("show")
	selectWindow("C2-EKAR Analysis");
		rename("EKAR CFP");
		run("Enhance Contrast", "saturated=0.35");
		setBatchMode("show")
	selectWindow("C3-EKAR Analysis");
		rename("EKAR M1 Label");
		run("Enhance Contrast", "saturated=0.35");
		setBatchMode("show")


	imageCalculator("Divide create 32-bit stack", "EKAR FRET", "EKAR CFP");
		selectWindow("Result of EKAR FRET");
			rename("EKAR FRET/CFP");

	selectWindow("EKAR FRET");

		run("Duplicate...", "title=[EKAR FRET-1] duplicate range=1-fr");
		selectWindow("EKAR FRET-1");	
		rename("EKAR FRET Mask");	
		setAutoThreshold("Mean dark");
		setOption("BlackBackground", false);
		run("Convert to Mask", "method=Default background=Dark calculate black");

	selectWindow("EKAR FRET Mask");
		run("Divide...", "value=255 stack");

	selectWindow("EKAR FRET");
		run("Duplicate...", "title=[EKAR FRET for Ratio] duplicate range=1-fr");
	selectWindow("EKAR CFP");
		run("Duplicate...", "title=[EKAR CFP for Ratio] duplicate range=1-fr");
	selectWindow("EKAR FRET for Ratio");
		run("Gaussian Blur...", "sigma=2 stack");
	selectWindow("EKAR CFP for Ratio");
		run("Gaussian Blur...", "sigma=2 stack");

		imageCalculator("Divide create 32-bit stack", "EKAR FRET for Ratio","EKAR CFP for Ratio");
		selectWindow("Result of EKAR FRET for Ratio");
		rename("EKAR FRET/CFP Ratio");

	imageCalculator("Multiply create 32-bit stack", "EKAR FRET/CFP Ratio","EKAR FRET Mask");
		selectWindow("Result of EKAR FRET/CFP Ratio");
		setBatchMode("show")
		rename("Final FRET/CFP Image");
		run("01 Jet");

	selectWindow("Final FRET/CFP Image");	
		run("Clear Results");

	selectWindow("EKAR FRET Mask");		
		run("Close");
	selectWindow("EKAR FRET/CFP Ratio");
		run("Close");
	selectWindow("EKAR FRET/CFP");
		run("Close");
	selectWindow("EKAR FRET for Ratio");
		close();
	selectWindow("EKAR CFP for Ratio");
		close();

	setBatchMode(false);
	run("Tile");
	selectWindow("Final FRET/CFP Image");
	run("Threshold...");
	waitForUser("Threshold Image, then draw an ROI");
	
	roiManager("Select", 2);
	roiManager("Remove Slice Info");
	
	selectWindow("Final FRET/CFP Image");
	for (n=1; n<=nSlices; n++) {
		selectWindow("Final FRET/CFP Image");
		setSlice(n);
		roiManager("Select", 2);
		run("Measure");
		run("Next Slice [>]");
}
