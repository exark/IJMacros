sl=nSlices/3;
filename=getInfo("image.filename");
directory=getInfo("image.directory");
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=sl frames=1 display=Grayscale");
run("Z Project...", "projection=[Max Intensity]");
selectWindow(filename);
close();
selectWindow("MAX_"+filename);
run("Save", "save=["+directory+"/MAX_"+filename+"]");