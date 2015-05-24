imageName=getInfo("image.filename");
imageDir=getInfo("image.directory");

Dialog.create("Parameters");
Dialog.addString("Cell Number:","1");
Dialog.addString("Imaging interval","3s");
Dialog.addNumber("# of Channels:",2);
Dialog.addNumber("Split at frame:",135);
Dialog.show();
cellNum = Dialog.getString();
interval = Dialog.getString();
ch=Dialog.getNumber();
splitAt=Dialog.getNumber();
splitAt=splitAt*2;
IJ.log(splitAt);
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
splitStack("baseline",outputDirBaseline+"Cell"+cellNum+"_"+interval+"/");

selectWindow("treatment");
splitStack("treatment",outputDirTreatment+"Cell"+cellNum+"_"+interval+"/");

function splitStack(stackName,targetDir) {
	run("Deinterleave", "how=2");
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

