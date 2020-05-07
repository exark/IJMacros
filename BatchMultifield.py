# @File(label = "Input directory", style = "directory") srcFile
# @String(label = "File extension", value=".tif") ext

# Compare with the original Process_Folder to see how ImageJ 1.x
# GenericDialog use can be converted to @Parameters.

from __future__ import with_statement

import csv
import os

from ij import IJ, ImagePlus
from ij.measure import ResultsTable
from ij.plugin import ChannelSplitter, HyperStackConverter

def run():
  srcDir = srcFile.getAbsolutePath()
  IJ.run("Set Measurements...", "integrated limit redirect=None decimal=3")
  
  for dirName, subdirs, filenames in os.walk(srcDir):
    if len(subdirs)==0:
      finalResults = []
      for filename in filenames:
        # Check for file extension 
        if not filename.endswith(ext):
          continue
        process(srcDir, dirName, filename)
        rt = ResultsTable.getResultsTable()
        colRaw = rt.getColumnIndex("IntDen")
        colRatio = rt.getColumnIndex("RawIntDen")
        finalResults.append(rt.getColumn(colRaw))
        finalResults.append(rt.getColumn(colRatio))
    
      with open(os.path.join(dirName, dirName+'.csv'), 'wb') as csvfile:
        writer = csv.writer(csvfile, delimiter=",")
        for row in zip(*finalResults):
          writer.writerow(row)
 
def process(srcDir, currentDir, fileName):
	# Change these depending on # of channels
	num_ch = 2
	master_ch = 1
	num_baselines_frames = 3
	
	# Setup ImageJ for Macro
	IJ.run("Set Measurements...", "integrated limit redirect=None decimal=3")
	IJ.run("Clear Results")
	
	# Open image and split into subchannels
	original = IJ.openImage(os.path.join(currentDir, fileName))
	original = HyperStackConverter.toHyperStack(original, num_ch, 1,
	                            				original.getNSlices()/num_ch,
	                            				"Grayscale")
	# uncomment following line if you wanna see your original
	#original.show()
	chs = ChannelSplitter.split(original)
	# uncomment following lines if you wanna see your channels
	#for ch in chs:
	#	ch.show()	
	
	original.close()
	
	# Grab master channel so we can analyze
	image = chs[master_ch-1]
	mask = chs[master_ch]
	
	IJ.setThreshold(image, 200, 10000)
	
	# Iterate through slices
	for slice in range(1,image.getNFrames()+1,):
		image.setSlice(slice)
		IJ.run(image, "Select All", "")
		IJ.run(image, "Measure", "")
	
	rt = ResultsTable.getResultsTable()
	
	# this line calculates the baseline
	# janky fucking hack to skip first frame for baseline calculcation
	# remove +1 from below to use all initial frames
	baseline = 0
	for frame in range(num_baselines_frames):
		baseline += rt.getValue("IntDen",frame+1)
	baseline = baseline/num_baselines_frames
	
	for result in range(0,rt.getCounter()):
		cur_intensity = rt.getValue("IntDen",result)
		ratio = cur_intensity/baseline
		rt.setValue("RawIntDen",result,ratio)
	
	rt.show("Results")
	for ch in chs:
		ch.close()
 
run()
