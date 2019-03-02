//DJ Shiwarski 2014, ZY Weinberg 2017

//This code takes an interleaved multichannel image and calculates a ratio between two channels
//of the image. This is ideal for examining FRET changes over time. This is accomplished by:
// - All frames are background subtracted
// - Splitting initial stack into subchannels
// - A cell mask is created to filter out extraneous background
// - Channels to be ratioed are blurred to cancel out noise and diffusion between frames
// - A ratio image is calculated
// - User is prompted to draw an ROI around the image, and threshold.
// - Mean ratio within that ROI is returned across time dimension

//Before running this, set one ROI that is a small portion of background
//and one ROI that is the entire image

macro 'EKAR Analysis [E]' {
	rename("Original");
	setBatchMode(true);
	run("Duplicate...", "title=[EKAR Analysis] duplicate range=1-nSlices");
	selectWindow("Original")
	close()
	run("Set Measurements...", "  mean limit redirect=None decimal=9");

	//Uses ROIs selected earlier for background subtraction
	roiManager("Select", 0);
	roiManager("Remove Slice Info");
	roiManager("Select", 1);
	roiManager("Remove Slice Info");
		for (n= 1; n<=nSlices; n++) {
			selectWindow("EKAR Analysis");
			setSlice(n);
			roiManager("Select", 0);
			run("Measure");
			BG = getResult("Mean");
			roiManager("Select", 1);
			run("Subtract...", "value=BG slice");
		}
	//=======================================================================
	//assumes three channels, change ch here for different number of channels
	ch=3;
	fr=nSlices/ch;
	//=======================================================================

	selectWindow("EKAR Analysis")
	run("Stack to Hyperstack...", "order=xyczt(default) channels=ch slices=1 frames=fr display=Grayscale");

	//=======================================================================
	//this split assumes channel order is Receptor Label > FRET > CFP. 
	//Move these titles around if channels are in a different order
	selectWindow("EKAR Analysis")
		run("Split Channels");
	selectWindow("C2-EKAR Analysis");
		rename("EKAR CFP");
	selectWindow("C1-EKAR Analysis");
		rename("EKAR FRET");
	selectWindow("C3-EKAR Analysis");
		rename("EKAR M1 Label");
	//=======================================================================

	selectWindow("EKAR FRET");
	//generate mask from cell (we use CFP as it's usually our least noisy channel)
		run("Duplicate...", "title=[Mask] duplicate range=1-fr");
		selectWindow("Mask");		
		run("Gaussian Blur...", "sigma=5 stack");
		run("Convert to Mask", "method=Default background=Dark calculate black");
	//convert mask to 0 or 1 so that we can multiply it into our FRET/CFP ratio and get rid of the background
	selectWindow("Mask");
		run("Divide...", "value=255 stack");

	//Gaussian blur images so as to remove variability due to diffusion
	selectWindow("EKAR FRET");
		run("Duplicate...", "title=[EKAR FRET for Ratio] duplicate range=1-fr");
	selectWindow("EKAR CFP");
		run("Duplicate...", "title=[EKAR CFP for Ratio] duplicate range=1-fr");
	selectWindow("EKAR FRET for Ratio");
		run("Gaussian Blur...", "sigma=2 stack");
	selectWindow("EKAR CFP for Ratio");
		run("Gaussian Blur...", "sigma=2 stack");

	//creates ratio image from FRET/CFP channel
		imageCalculator("Divide create 32-bit stack", "EKAR FRET for Ratio","EKAR CFP for Ratio");
		selectWindow("Result of EKAR FRET for Ratio");
		rename("EKAR FRET/CFP Ratio");

	//apply mask to final FRET image, then change lookup table to be pretty
	imageCalculator("Multiply create 32-bit stack", "EKAR FRET/CFP Ratio","Mask");
		selectWindow("Result of EKAR FRET/CFP Ratio");
		rename("Final FRET/CFP Image");
		run("CubeHelix2");

	//clean up workspace before final step
	selectWindow("Final FRET/CFP Image");	
		run("Clear Results");
	selectWindow("Mask");		
		run("Close");
	selectWindow("EKAR FRET/CFP Ratio");
		run("Close");
	selectWindow("EKAR FRET for Ratio");
		close();
	selectWindow("EKAR CFP for Ratio");
		close();
	run("Tile");
		selectWindow("EKAR M1 Label");
			run("Enhance Contrast", "saturated=0.35");
		selectWindow("EKAR FRET");
			run("Enhance Contrast", "saturated=0.35");
		selectWindow("EKAR CFP");
			run("Enhance Contrast", "saturated=0.35");
		selectWindow("Final FRET/CFP Image");
			run("Enhance Contrast", "saturated=0.1");

	setBatchMode("exit & display");
	run("Tile");
	
	//Loop for processing multiple ROIs (single cells) from an image
	keepGoing = true;
	currentROI = 2;
	setTool("freehand");
	do {
		waitForUser("Draw an ROI");
		run("Clear Results");
		selectWindow("Final FRET/CFP Image");
		roiManager("Select", currentROI);
		roiManager("Remove Slice Info");
		for (n= 1; n<=nSlices; n++) {
			selectWindow("Final FRET/CFP Image");
			setSlice(n);
			setThreshold(0.0200, 100.0000);
			run("Measure");
		}
		String.copyResults;
		currentROI = currentROI+1;
		keepGoing = getBoolean("Select another ROI?");
	} while (keepGoing);
}