rename("Original");
run("Deinterleave", "how=3");
selectWindow("Original #2");
run("Duplicate...", "title=mask");
setAutoThreshold("MaxEntropy dark");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Divide...", "value=255");

imageCalculator("Multiply create", "Original #2","mask");
selectWindow("Result of Original #2");
imageCalculator("Multiply create", "Original #1","mask");
selectWindow("Result of Original #1");

max = 16000;
selectWindow("Result of Original #2");
setThreshold(100, max);
waitForUser;
run("Add to Manager");
roiManager("Select", 0);
run("Measure");
roiManager("Deselect");

selectWindow("Result of Original #1");
setThreshold(100, 16000);
roiManager("Select", 0);
run("Measure");

roiManager("Deselect");
roiManager("Delete");
selectWindow("Result of Original #1");
close()
selectWindow("Original #1");
close()
selectWindow("Result of Original #2");
close()
selectWindow("Original #2");
close()
selectWindow("Original #3");
close()
selectWindow("mask");
close()