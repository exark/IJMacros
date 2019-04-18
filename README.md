ImageJ Macros
=============

A set of short scripts for working with primary microscopy data - either analysis or converting it to a form usable in other applications.

3Ch Max Project
---------------

Take a 3-channel interleaved image, deinterleve, max project each channel, and then recombine into a hyperstack


Background Subtract
-------------------

Using a user selected ROI, subtracts mean value from that ROI in each frame of a stack from the whole frame. Nice way od dynamically subtracting background that may change over the course of image acquisition

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

Originally authored by Daniel J. Shiwarski, with major modifications to enhance by me.

Measure Stack
-------------

Simple macro to add "Measure Stack" to Fiji (which lacks the command).


Multifield.py
----

Script for processing images collected in Puthenveedu lab's ensemble internalization and recycling assay.

Object Picker
-------------

Run on a stack containing multiple channels, this allows user defined points of interest to be extracted into smaller substacks, windows around the picked objects. These substacks can then be used for further analysis of specific object features.


regist_and_transform_stack.groovy
-------

First attempt at a Groovy script, derived from @bogovicj's [work](https://gist.github.com/bogovicj/d94c35c4bd9ac698e807c6d446d49bdb) to apply a Descriptor-based registration transform to arbitrary images and stacks. Super early work, will eventually be replaced by a python based script to do the same.

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
