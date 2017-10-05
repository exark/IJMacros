# @File(label = "Input directory", style = "directory") srcFile
# @String(label = "File extension", value=".tif") ext

# Compare with the original Process_Folder to see how ImageJ 1.x
# GenericDialog use can be converted to @Parameters.

import csv
import os

from subprocess import call
from ij import IJ, ImagePlus, ImageStack
from ij.measure import ResultsTable

def run():
  srcDir = srcFile.getAbsolutePath()
  
  for dirName, subdirs, filenames in os.walk(srcDir):
    #filter filenames to only include tifs
    filenames = [f for f in filenames if f.endswith(ext)]
    if len(filenames) > 0:
    	stackList = buildStackList(filenames)
    	buildStack(dirName, stackList)
 
def buildStackList(filenames):
	fields = {}
	here = 0
	for f in filenames:
		f_split = (f.rsplit(".",1)[0]).split("_")
		stackname = f_split[0] + "_" + f_split[2] + ".tif"
		if stackname in fields:
			fields[stackname].append(f)
		else:
			fields[stackname] = [f]
	
	return fields

def buildStack(saveDir, stacklist):
	stacks = {}
	for f, s in stacklist.iteritems():
		for name in s:
			curSlice = IJ.openImage(os.path.join(saveDir, name))
			if f not in stacks:
				stack = curSlice.createEmptyStack()
				stack.addSlice(name, curSlice.getProcessor())
				stacks[f] = stack
			else:
				stacks[f].addSlice(name, curSlice.getProcessor())
			call(["/usr/local/bin/rmtrash",os.path.join(saveDir,name)])

	for f in stacks:
		IJ.saveAsTiff(ImagePlus(f, stacks[f]),os.path.join(saveDir,f))
		
run()
