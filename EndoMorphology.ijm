roi_count = roiManager("count");
if (roi_count>0) {
	roiManager("Delete");
}
run("Clear Results");

run("Set Measurements...", "area mean redirect=None");
ch = 3;
sl = nSlices/ch;

rename("Original");
run("Stack to Hyperstack...", "order=xyczt(default) channels=ch slices=sl frames=1 display=Grayscale");
run("Split Channels");
selectWindow("C1-Original");
run("Close");
selectWindow("C3-Original");
run("Close");

selectWindow("C2-Original");
rename("Receptor");
run("Enhance Contrast", "saturated=0.35");
run("Z Project...", "projection=[Max Intensity]");
rename("MAX");
selectWindow("Receptor");
run("Z Project...", "projection=[Sum Slices]");
rename("SUM");
run("Enhance Contrast", "saturated=0.35");
selectWindow("Receptor");
//run("Close");

selectWindow("MAX");
run("Subtract Background...", "rolling=50");
selectWindow("MAX");
run("Enhance Contrast", "saturated=0.35");
//waitForUser("Draw background ROI");
//run("Measure");
//BG = getResult("Mean");
//selectWindow("MAX");
//run("Select All");
//run("Subtract...", "value=BG slice");
//run("Clear Results");
selectWindow("MAX");
//setAutoThreshold("Huang dark");
waitForUser("Treshold and stuff");
selectWindow("MAX");
run("Convert to Mask");
run("Erode");
run("Dilate");
run("Analyze Particles...", "include add");

selectWindow("SUM");
count=roiManager("count"); 
array=newArray(count); 
for(i=0; i<count;i++) { 
        array[i] = i; 
} 
roiManager("Select", array); 
roiManager("Measure");

max_intensity = 0;
for (n=0; n<nResults(); n++) {
	if (getResult("Mean",n)>max_intensity) {
		max_intensity = getResult("Mean",n);
	}
	else{}
}

for (x=0; x<nResults(); x++) {
	cur_intensity = getResult("Mean",x);
	ratio = cur_intensity/max_intensity;
	setResult("Ratio",x,ratio);
}
updateResults;
String.copyResults();
run("Tile");