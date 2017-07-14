from ij import IJ
from ij.measure import ResultsTable

# Get current ImagePlus
image = IJ.getImage()
IJ.run("Clear Results")
IJ.setThreshold(200, 10000)

for slice in range(1,image.getNSlices()+1,1):
	image.setSlice(slice)
	IJ.run("Select All")
	IJ.run("Measure")

rt = ResultsTable.getResultsTable()
baseline = (rt.getValue("IntDen",0) + rt.getValue("IntDen",1) + rt.getValue("IntDen",2) + rt.getValue("IntDen",3))/4.0
for result in range(0,rt.getCounter()):
	cur_intensity = rt.getValue("IntDen",result)
	ratio = cur_intensity/baseline
	rt.setValue("RawIntDen",result,ratio)

rt.updateResults()