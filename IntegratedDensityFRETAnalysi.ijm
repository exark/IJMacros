rename("EKAR Analysis");

// Background Subtract
run("Set Measurements...", "  mean limit redirect=None decimal=3");
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

// Change to hyperstack, split by channels
ch=3;
fr=nSlices/ch;
selectWindow("EKAR Analysis")
	run("Stack to Hyperstack...", "order=xyczt(default) channels=ch slices=1 frames=fr display=Grayscale");
selectWindow("EKAR Analysis")
	run("Split Channels");
selectWindow("C1-EKAR Analysis");
	rename("EKAR M1 Label");
	run("Enhance Contrast", "saturated=0.35");
selectWindow("C2-EKAR Analysis");
	rename("EKAR FRET");
	run("Enhance Contrast", "saturated=0.35");
selectWindow("C3-EKAR Analysis");
	rename("EKAR CFP");
	run("Enhance Contrast", "saturated=0.35");

// Generate cell mask, then filter based on mask.
selectWindow("EKAR FRET");
	run("Duplicate...", "title=[EKAR FRET-1] duplicate range=1-fr");
	selectWindow("EKAR FRET-1");	
	rename("EKAR FRET Mask");	
	run("Gaussian Blur...", "sigma=2 stack");
	run("Convert to Mask", "method=Default background=Dark calculate black");

selectWindow("EKAR FRET Mask");
	run("Divide...", "value=255 stack");

imageCalculator("Multiply create 32-bit stack", "EKAR FRET","EKAR FRET Mask");
		selectWindow("Result of EKAR FRET");
		rename("Masked EKAR FRET");

imageCalculator("Multiply create 32-bit stack", "EKAR CFP","EKAR FRET Mask");
		selectWindow("Result of EKAR CFP");
		rename("Masked EKAR CFP");

keepGoing = true;
currentROI = 2;
setTool("freehand");
run("Set Measurements...", "integrated limit redirect=None decimal=3");
do {
	selectWindow("Masked EKAR FRET");
	setThreshold(100,1000000,"over/under");
	waitForUser("Draw an ROI");
	
	roiManager("Select", currentROI);
	roiManager("Remove Slice Info");

	run("Clear Results");
	result_row = nResults;	
	for (n=1; n<=nSlices; n++) {
		
		selectWindow("Masked EKAR FRET");
		setSlice(n);
		roiManager("Select", currentROI);
		getStatistics(area,mean);
		fretIntDense = (area * mean);
		selectWindow("Masked EKAR CFP");
		setSlice(n);
		roiManager("Select", currentROI);
		getStatistics(area,mean);
		CFPIntDense = (area * mean);

		fretCfpRatio = (fretIntDense / CFPIntDense);

		setResult("FRET",result_row,fretIntDense);
		setResult("CFP",result_row,CFPIntDense);
		setResult("Ratio",result_row,fretCfpRatio);
		result_row = result_row+1;
	}
	updateResults;
	String.copyResults;
	currentROI = currentROI+1;
	keepGoing = getBoolean("Select another ROI?");
} while (keepGoing);
