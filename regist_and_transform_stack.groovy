#@Dataset img
#@String(label="affine transform string") affineString
#@UIService ui

// 
// original: https://gist.github.com/bogovicj/d94c35c4bd9ac698e807c6d446d49bdb

import ij.IJ;

import net.imglib2.img.*;
import net.imglib2.realtransform.*;
import net.imglib2.view.*;
import net.imglib2.img.ImagePlusAdapter;
import net.imglib2.interpolation.*;
import net.imglib2.interpolation.randomaccess.NLinearInterpolatorFactory;

//logged_text = IJ.getLog().replaceAll('\n$','');
//affine_string = logged_text.substring(logged_text.lastIndexOf("\n")).trim();

nd = 3
if( affineString.startsWith( "[3,3]" )){
	println( "2" )
	nd = 2
} else if( affineString.startsWith( "[4,4]" )){ 
	println("3")
}

paramString = affineString.replace( "[3,3](AffineTransform", "" ).replaceAll( "\\) .*", "" ).replaceAll( "[\\]\\[\\s]", "" )
paramDouble = []
for ( p in paramString.split(",") ) {
	paramDouble.add( Double.parseDouble( p ));
}

AffineTransform2D transform = new AffineTransform2D();
transform.set( paramDouble as double[] )
interp = new NLinearInterpolatorFactory()

numTimepoints = img.getDepth();
timeDimension = 2;

transformed_stack = []
for (i in (0..<numTimepoints)) {
	volumeAtTimeFrame = Views.hyperSlice( img, timeDimension, i );
	result = Views.interval( 
				Views.raster(
					RealViews.transform(
						Views.interpolate( Views.extendZero( volumeAtTimeFrame ), interp),
						transform )),
				volumeAtTimeFrame);
	transformed_stack.add(result);
}

ui.show(Views.stack(transformed_stack));