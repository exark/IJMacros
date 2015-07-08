rename("Original");
	setBatchMode(true);
	run("Duplicate...", "title=[EKAR Analysis] duplicate range=1-nSlices");
	selectWindow("Original")
	close()
	ch=3;
	fr=nSlices/ch;

	run("Stack to Hyperstack...", "order=xyczt(default) channels=ch slices=1 frames=fr display=Grayscale");

	selectWindow("EKAR Analysis")
		run("Split Channels");
	selectWindow("C1-EKAR Analysis");
		close();
	selectWindow("C2-EKAR Analysis");
		rename("EKAR Clover");
		run("Enhance Contrast", "saturated=0.35");
	selectWindow("C3-EKAR Analysis");
		close();

	selectWindow("EKAR Clover");
		run("Duplicate...", "title=[EKAR Clover-1] duplicate range=1-fr");
		selectWindow("EKAR Clover-1");	
		rename("EKAR Clover Mask");	
		run("Gaussian Blur...", "sigma=5 stack");
		run("Convert to Mask", "method=Default background=Dark calculate black");

	selectWindow("EKAR Clover Mask");
		run("Divide...", "value=255 stack");

	imageCalculator("Multiply create 32-bit stack", "EKAR Clover","EKAR Clover Mask");
		selectWindow("Result of EKAR Clover");
		rename("Final Clover Image");

	selectWindow("EKAR Clover")
		close();
	selectWindow("EKAR Clover Mask")
		close();
	setBatchMode("exit and display");