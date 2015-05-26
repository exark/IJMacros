ImageJ Macros
=============

A set of short scripts for working with primary microscopy data - either analysis or converting it to a form usable in other applications.

3Ch Max Project
---------------

Take a 3-channel interleaved image, deinterleve, max project each channel, and then recombine into a hyperstack

Create Stacked PSF
------------------

Using a single point-spread-function image, generate a stack with enough copies of that image to be used properly to deconvolve something using DeconvolutionLab plugin for ImageJ

EKAR Analysis
-------------

Analysis macro for FRET biosensors. Input is a 3-channel interleaved image of the form FRET channel/donor channel/label channel. Processes image by:

* Simple background subtract from all frames
* Deinterleave
* Contrast correct
* Gaussian blur FRET and donor channels
* Auto-threshold donor channel using mean thresholding. Use as binary mask
* Apply binary mask to both FRET and donor channels
* Calculate ratio image by dividing FRET channel by donor channel
* Prompt user to threshold ratio image to remove black background
* Measure an ROI's mean ratio across the entire movie

Originally authored by Daniel J. Shiwarski, with minor modifications to enhance by me.

Measure Stack
-------------

Simple macro to add "Measure Stack" to Fiji (which lacks the command).

Reslice Stack
-------------

Takes an x-channel stack and produces kymographs along the z/t dimension.

SplitFiles...
-------------

Prepare an image stack for analysis with [cmeAnalysisPackage](https://github.com/exark/cmeAnalysisPackage). Input image is an x-channel interleaved stack. Outputs image split into single frames into the directory structure:

* Treatment
  * ChX
    * 1.tiff
    * 2.tiff
    * ...

Will include a Baseline directory as well for SplitFilesAtTreatment
