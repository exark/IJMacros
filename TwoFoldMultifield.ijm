rename("Movie");
run("Clear Results");
for (n=1; n<=nSlices; n++) {
	setSlice(n);
	setThreshold(150, 10000);setThreshold(150, 10000);
	wait(20);
	run("Select All");
	run("Measure");
}

String.resetBuffer();

baseline = (getResult("IntDen",0)+getResult("IntDen",1))/2;
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