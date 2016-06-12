setBatchMode(true);

imgArray = newArray(nImages); 
for (i=0; i<nImages; i++) { 
   selectImage(i+1); 
   imgArray[i] = getImageID(); 
} 

//now we have a list of all open images, we can work on it: 

for (i=0; i< imgArray.length; i++) { 
   selectImage(imgArray[i]); 
   run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=200 display=Grayscale");
   run("Out [-]");
   run("Out [-]");
   Stack.setChannel(3);
   run("Enhance Contrast", "saturated=0.35");
}
setBatchMode("exit & display");

run("Tile");