dir = getDirectory("Choose Directory");
dirList = getFileList(dir);
setBatchMode(false);

for (i=0; i<dirList.length; i++) {

	currentDir = dirList[i];
	fileList = getFileList(dir+dirList[i]);
	showProgress(i+1, dirList.length);

	Dialog.create("Parameters");
	Dialog.addString("Imaging interval","3s");
	Dialog.addNumber("# of Channels:",2);
	Dialog.addNumber("Split at frame:",200);
	Dialog.show();
	interval = Dialog.getString();
	ch=Dialog.getNumber();
	splitAt=Dialog.getNumber();
	splitAt=splitAt*ch;

	for (j=0; j<fileList.length; j++) {
	if (endsWith(fileList[j],"/")) {
		continue;
	} else {
 	log(""+dirList[i]+fileList[j]);
 	open(""+dirList[i]+fileList[j]);
 	imageName=getInfo("image.filename");
	imageDir=getInfo("image.directory");
	cellnum=j+1;
	totSlices=nSlices;

 	run("Duplicate...","title=baseline , duplicate range=1-"+splitAt);
	selectWindow(imageName);
	splitAt=splitAt+1;
	run("Duplicate...", "title=treatment , duplicate range="+splitAt+"-"+totSlices);
	selectWindow(imageName);
	close();
	
	outputDirBaseline=imageDir+"Baseline/";
	outputDirTreatment=imageDir+"Treatment/";
	File.makeDirectory(outputDirBaseline);
	File.makeDirectory(outputDirTreatment);
	
	
	selectWindow("baseline");
	splitStack("baseline",outputDirBaseline+"Cell"+cellNum+"_"+interval+"/",ch);
	
	selectWindow("treatment");
	splitStack("treatment",outputDirTreatment+"Cell"+cellNum+"_"+interval+"/",ch);
	}
}

setBatchMode(false);

showMessage("Fin!")

function splitStack(stackName,targetDir,ch) {
	
	run("Stack to Hyperstack...", "order=xyczt(default) channels=" + ch + " slices=1 frames=" + (nSlices/ch) + " display=Grayscale");
	run("Split Channels");
	File.makeDirectory(targetDir);
	for (i=1; i<=ch; i++) {
		selectWindow("C" + i + "-" + stackName);
		sl=nSlices;
		channelDir=targetDir+"/Ch"+i+"/";
		File.makeDirectory(channelDir);
		
		for (j=1; j<=sl; j++) {
			showProgress((j/sl)+(i/ch));
			selectWindow("C" + i + "-" + stackName);
			setSlice(j);
			run("Duplicate...","title="+j);
			saveAs("Tiff",channelDir+j+".tiff");
			close();
		}

		selectWindow("C" + i + "-" + stackName);
		close();
	}
}

