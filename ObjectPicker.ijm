//-------USER CONFIGURABLE SETTINGS------
//Window size (ROIs will be 2*w+1 squares
w = 10
//Number of channels
ch = 3

roiManager("reset");
setTool("point");
rename("window");
waitForUser("Add your ROIs");

//generate boxes from points
for (i = 0; i < roiManager("count"); i++) {
	selectWindow("window");
	roiManager("select",i);
	Roi.getBounds(x, y, width, height);
	makeRectangle(x-w, y-w, (2*w+1), (2*w+1));
	roiManager("update");
}

//Create new windows for all your objects from ROIs
for (i = 0; i < roiManager("count"); i++) {
	selectWindow("window");
	roiManager("select",i);
	run("Duplicate...", "duplicate range=1-"+ch);
}

run("Tile");