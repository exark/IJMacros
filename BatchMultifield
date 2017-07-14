/*
 * Macro template to process multiple images in a folder
 */

input = getDirectory("Input directory");
output = input;

Dialog.create("File type");
Dialog.addString("File suffix: ", ".tif", 5);
Dialog.show();
suffix = Dialog.getString();

run("Set Measurements...", "integrated limit redirect=None decimal=3");

processFolder(input);

function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	open(input + file);
	rename("Movie");
	run("Clear Results");
	for (n=1; n<=nSlices; n++) {
		setSlice(n);
		setThreshold(200, 10000);
		setThreshold(200, 10000);
		wait(20);
		run("Select All");
		run("Measure");
	}
	
	String.resetBuffer();
	
	baseline = (getResult("IntDen",0)+getResult("IntDen",1)+getResult("IntDen",2)+getResult("IntDen",3))/4;
	for (x=0; x<nResults(); x++) {
		cur_intensity = getResult("IntDen",x);
		ratio = cur_intensity/baseline;
		setResult("RawIntDen",x,ratio);
		String.append(cur_intensity + '\t' + ratio + '\n');
	}
	updateResults;
	String.copy(String.buffer);
	
	selectWindow("Movie");
	run("Close");
}
