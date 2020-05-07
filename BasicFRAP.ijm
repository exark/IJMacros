run("Set Measurements...", "  mean limit redirect=None decimal=9");
run("Clear Results");
setThreshold(200, 65536);
roiManager("Select", 0);
roiManager("Multi Measure");
String.copyResults;