imageName=getInfo("image.filename");
imageDir=getInfo("image.directory");

Dialog.create("Parameters");
Dialog.addString("Cell Number:","1");
Dialog.addString("Imaging interval","3s");
Dialog.addNumber("# of Channels:",2);
Dialog.show();
cellNum = Dialog.getString();
interval = Dialog.getString();
ch=Dialog.getNumber();
totSlices=nSlices;

selectWindow(imageName);

outputDirTreatment=imageDir+"Treatment/";
File.makeDirectory(outputDirTreatment);
splitStack(imageName,outputDirTreatment+"Cell"+cellNum+"_"+interval+"/");

function splitStack(stackName,targetDir) {
	run("Deinterleave", "how="+ch);
	File.makeDirectory(targetDir)
	for (i=1; i<=ch; i++) {
		selectWindow(stackName+" #"+i);
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
		selectWindow(stackName+" #"+i);
		close();
	}
}

