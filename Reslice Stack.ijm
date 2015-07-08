Dialog.create("Parameters");
Dialog.addNumber("# of Channels:",2);
Dialog.addNumber("Width (pixels):",512);
Dialog.addNumber("Height (pixels):",512);
Dialog.show();
ch=Dialog.getNumber();
wdth=Dialog.getNumber();
hght=Dialog.getNumber();

rename("Image")
run("Deinterleave", "how=ch");
setBatchMode(true)
for (i=1; i<=ch; i++) {
	selectWindow("Image #"+ch);
	run("Duplicate...", "title=[Image"+ch+"] duplicate range=1-nSlices");
	selectWindow("Image #"+ch);
	close();
	for (n= 0; n<hght; n++) {
		selectWindow("Image"+ch);
		makeLine(0, n, wdth, n);
		run("Reslice [/]...", "output=1.000 slice_count=1 avoid");
	}
}

run("Images to Stack", "name=Interleaved title=Reslice");

run("Stack to Hyperstack...", "order=xyczt(default) channels="+ch+" slices="+hght+" frames=1 display=Grayscale");
setBatchMode("exit & display")