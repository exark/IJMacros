dir = getDirectory("Choose Directory");
dirList = getFileList(dir);

for (i=0; i<dirList.length; i++) {
	currentDir = dirList[i];
	print(currentDir);
	fileList = getFileList(dir+dirList[i]);
	showProgress(i+1, dirList.length);
	setBatchMode(true);
	for (j=0; j<fileList.length; j++) {
	if (endsWith(fileList[j],"/")) {
		continue;
	} else {
 	open(""+dirList[i]+fileList[j]);
    imageName=getInfo("image.filename");
    imageDir=getInfo("image.directory");

    cellNum = j+1;
    interval = "4s";
    ch=1;
    totSlices=nSlices;

    selectWindow(imageName);

    outputDirTreatment=imageDir+"Treatment/";
    File.makeDirectory(outputDirTreatment);
    splitStack(imageName,outputDirTreatment+"Cell"+cellNum+"_"+interval+"/",ch);
	}
	}
}

function splitStack(stackName,targetDir,ch) {
	File.makeDirectory(targetDir)
	for (i=1; i<=ch; i++) {
		selectWindow(stackName);
		sl=nSlices;
		channelDir=targetDir+"/Ch"+i+"/";
		File.makeDirectory(channelDir);
		setBatchMode(true);
		for (j=1; j<=sl; j++) {
			setSlice(j);
			run("Duplicate...","title="+j);
			saveAs("Tiff",channelDir+j+".tiff");
			close();
		}
		setBatchMode(false);
		selectWindow(stackName);
		close();
	}
}

