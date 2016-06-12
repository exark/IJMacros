dir = getDirectory("Choose Directory");
dirList = getFileList(dir);
setBatchMode(true);

for (i=0; i<dirList.length; i++) {
	currentDir = dirList[i];
	fileList = getFileList(dir+dirList[i]);
	showProgress(i+1, dirList.length);

	for (j=0; j<fileList.length; j++) {
	if (endsWith(fileList[j],"/")) {
		continue;
	} else {
 	open(""+dirList[i]+fileList[j]);
    imageName=getInfo("image.filename");
    imageDir=getInfo("image.directory");

    cellNum = j+1;
    interval = "6s";
    ch=2;
    totSlices=nSlices;

    selectWindow(imageName);

    outputDirTreatment=imageDir+"Treatment/";
    File.makeDirectory(outputDirTreatment);
    splitStack(imageName, outputDirTreatment+"Cell"+cellNum+"_"+interval+"/",ch);
	}
	}

}
setBatchMode(false);

function splitStack(stackName,targetDir,ch) {
	selectWindow(stackName);
	sl = (nSlices/ch);
	run("Stack to Hyperstack...", "order=xyczt(default) channels=" + ch + " slices=1 frames=" + sl + " display=Grayscale");
	run("Split Channels");

	File.makeDirectory(targetDir)
	for (k=1; k<=ch; k++) {
		selectWindow("C" + k + "-" + stackName);
		sl = nSlices;
		channelDir=targetDir+"Ch"+k+"/";
		File.makeDirectory(channelDir);
		
		for (l=1; l<=sl; l++) {
			selectWindow("C" + k + "-" + stackName);
			setSlice(l);
			run("Duplicate...","title="+l);
			saveAs("Tiff",channelDir+l+".tiff");
			close();
		}
		
	}
}

