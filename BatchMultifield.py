# @File(label = "Input directory", style = "directory") srcFile
# @String(label = "File extension", value=".tif") ext

# Compare with the original Process_Folder to see how ImageJ 1.x
# GenericDialog use can be converted to @Parameters.

from __future__ import with_statement

import csv
import os

from ij import IJ, ImagePlus
from ij.measure import ResultsTable

def run():
  srcDir = srcFile.getAbsolutePath()
  
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
  image = IJ.openImage(os.path.join(currentDir, fileName))
  IJ.run("Clear Results")
  IJ.setThreshold(image, 200, 10000)
  
  for slice in range(1,image.getNSlices()+1,1):
  	image.setSlice(slice)
  	IJ.run(image, "Select All", "")
  	IJ.run(image, "Measure", "")
  
  rt = ResultsTable.getResultsTable()
  baseline = (rt.getValue("IntDen",0) + rt.getValue("IntDen",1) + rt.getValue("IntDen",2) + rt.getValue("IntDen",3))/4.0
  for result in range(0,rt.getCounter()):
  	cur_intensity = rt.getValue("IntDen",result)
  	ratio = cur_intensity/baseline
  	rt.setValue("RawIntDen",result,ratio)

  rt.updateResults()
  image.close()
 
run()
