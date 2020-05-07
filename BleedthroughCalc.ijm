run("Clear Results")
setBatchMode("hide")
roiManager("select",0);
ch1 = newArray(0);
ch2 = newArray(0);
dim = 256;
for (x = 0; x < dim; x++) {
	for (y = 0; y < dim; y++) {
		if (Roi.contains(x, y)) {
			Stack.setChannel(1);
			ch1_val = getPixel(x, y);
			Stack.setChannel(2);
			ch2_val = getPixel(x, y);
			ch1 = Array.concat(ch1,ch1_val);
			ch2 = Array.concat(ch2,ch2_val);
			setResult("ch1", nResults, ch1_val);
			setResult("ch2", nResults-1, ch2_val);
		}
		showProgress(y+(dim*(x-1)),dim*dim);
	}
}
updateResults();
setBatchMode("exit and display")
Plot.create("Bleedthrough","EGFP Values", "pHuji Values");
Plot.add("circle", ch1, ch2)
Plot.setLimitsToFit()
Fit.doFit("Log",ch1, ch2);
Fit.plot();