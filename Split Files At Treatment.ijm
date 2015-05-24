imageName=getInfo("image.filename");
imageDir=getInfo("image.directory");

Dialog.create("Parameters");
Dialog.addString("Condition","");
Dialog.addString("Cell Number","");
Dialog.addString("Destination Directory",imageDir);
Dialog.addNumber("# of Channels:",2);
Dialog.addNumber("Split at frame:",135);
Dialog.show();
conditionName = Dialog.getString();
cellNum = Dialog.getString();
destDir = Dialog.getString()+"/";
ch=Dialog.getNumber();
splitAt=Dialog.getNumber();
splitAt=splitAt*ch;
totSlices=nSlices;

run("Duplicate...","title=baseline , duplicate range=1-"+splitAt);
saveAs("Tiff",destDir+conditionName+" Cell "+cellNum+" baseline.tiff");
close();
selectWindow(imageName);
splitAt=splitAt+1;
run("Duplicate...", "title=treatment , duplicate range="+splitAt+"-"+totSlices);
saveAs("Tiff",destDir+conditionName+" Cell "+cellNum+" treatment.tiff");
close()
selectWindow(imageName);
close();
