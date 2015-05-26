Dialog.create("Parameters");
Dialog.addNumber("# of Channels:",2);
Dialog.addNumber("Width (pixels):",512);
Dialog.addNumber("Height (pixels):",512);
Dialog.show();
ch=Dialog.getNumber();
wdth=Dialog.getNumber();
hght=Dialog.getNumber();

rename("Image")
run("Deinterleave", "how=2");
setBatchMode(true)
selectWindow("Image #1");
run("Duplicate...", "title=[Image1] duplicate range=1-nSlices");
selectWindow("Image #1");
close();
selectWindow("Image #2");
run("Duplicate...", "title=[Image2] duplicate range=1-nSlices");
selectWindow("Image #2");
close();

selectWindow("Image1");
selectWindow("Image2");
for (n= 0; n<hght; n++) {
	selectWindow("Image1");
	makeLine(0, n, wdth, n);
	run("Reslice [/]...", "output=1.000 slice_count=1 avoid");
	selectWindow("Image2");
	makeLine(0, n, wdth, n);
	run("Reslice [/]...", "output=1.000 slice_count=1 avoid");
}

run("Images to Stack", "name=Interleaved title=Reslice");

run("Stack to Hyperstack...", "order=xyczt(default) channels="+ch+" slices="+hght+" frames=1 display=Grayscale");
setBatchMode("exit & display")