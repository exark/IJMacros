newImage("mask", "8-bit black", 512, 512, 1);
selectWindow("mask");
run("Select All");
run("Clear");

for (i=0; i < roiManager("count"); i++){
	selectWindow("mask");
	roiManager("select", i)
	Roi.getContainedPoints(xpoints, ypoints);
	for (point=0; point < xpoints.length; point++){
		setPixel(xpoints[point], ypoints[point], (i+1));
	}
}
