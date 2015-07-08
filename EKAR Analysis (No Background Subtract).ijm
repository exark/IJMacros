rename("EKAR Analysis");
	rename("Original");
	run("Duplicate...", "title=[EKAR Analysis] duplicate range=1-nSlices");
	selectWindow("Original")
	close()
	run("Set Measurements...", "  mean limit redirect=None decimal=3");

	ch=3;
	fr=nSlices/ch;

	run("Stack to Hyperstack...", "order=xyczt(default) channels=ch slices=1 frames=fr display=Grayscale");

	selectWindow("EKAR Analysis")
		run("Split Channels");
	selectWindow("C1-EKAR Analysis");
		rename("EKAR CFP");
	selectWindow("C2-EKAR Analysis");
		rename("EKAR FRET");
	selectWindow("C3-EKAR Analysis");
		rename("EKAR M1 Label");

	selectWindow("EKAR FRET");

		run("Duplicate...", "title=[EKAR CFP-1] duplicate range=1-fr");
		selectWindow("EKAR CFP-1");
		rename("EKAR FRET Mask");
		run("Gaussian Blur...", "sigma=5 stack");
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
		rename("Final FRET/CFP Image");
		run("01 Jet");

	selectWindow("Final FRET/CFP Image");
		run("Clear Results");
		//setMinAndMax(1.46, 2.49);

	selectWindow("EKAR FRET Mask");
		run("Close");
	selectWindow("EKAR FRET/CFP Ratio");
		run("Close");
	selectWindow("EKAR FRET for Ratio");
		close();
	selectWindow("EKAR CFP for Ratio");
		close();

	run("Tile");
		selectWindow("EKAR FRET");
		selectWindow("EKAR CFP");


	selectWindow("Final FRET/CFP Image");
	run("Threshold...");
	waitForUser("Threshold Image, then draw an ROI");

	roiManager("Select", 0);
	roiManager("Remove Slice Info");

	selectWindow("Final FRET/CFP Image");
	for (n=1; n<=nSlices; n++) {
		selectWindow("Final FRET/CFP Image");
		setSlice(n);
		roiManager("Select", 0);
		run("Measure");
		run("Next Slice [>]");
	}
