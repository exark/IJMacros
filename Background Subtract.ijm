//Uses ROIs selected earlier for background subtraction
	window_name = getTitle();
	selectWindow(window_name);
	roi_idx = roiManager("count");
	roiManager("Select", roi_idx-1);
	roiManager("Remove Slice Info");
	//setBatchMode("hide");
		for (n= 1; n<=nSlices; n++) {
			selectWindow(window_name);
			setSlice(n);
			roiManager("Select", roi_idx-1);
			run("Measure");
			BG = getResult("Mean");
			selectWindow(window_name);
			setSlice(n);
			run("Select All");
			run("Subtract...", "value=BG slice");
		}
	//setBatchMode("exit and display");