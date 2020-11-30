//  Homework 1
//  Color to Greyscale Conversion

// A common way to represent color images is known as RGBA - the color
// is specified by how much Red, Grean and Blue is in it.
// The 'A' stands for Alpha and is used for transparency, it will be
// ignored in this homework.

// Each channel Red, Blue, Green and Alpha is represented by one byte.
// Since we are using one byte for each color there are 256 different
// possible values for each color.  This means we use 4 bytes per pixel.

// Greyscale images are represented by a single intensity value per pixel
// which is one byte in size.

// To convert an image from color to grayscale one simple method is to
// set the intensity to the average of the RGB channels.  But we will
// use a more sophisticated method that takes into account how the eye 
// perceives color and weights the channels unequally. 

// The eye responds most strongly to green followed by red and then blue.
// The NTSC (National Television System Committee) recommends the following
// formula for color to greyscale conversion:

// I = .299f * R + .587f * G + .114f * B

// Notice the trailing f's on the numbers which indicate that they are 
// single precision floating point constants and not double precision
// constants.

// You should fill in the kernel as well as set the block and grid sizes
// so that the entire image is processed.

#include "utils.h"
#include "device_launch_parameters.h"

__global__
void rgba_to_greyscale(const uchar4* const rgbaImage,
                       unsigned char* const greyImage,
                       int numRows, int numCols)
{
    
  // The output (greyImage) at each pixel should be the result of
  // applying the formula: output = .299f * R + .587f * G + .114f * B;
  // Note: We will be ignoring the alpha channel for this conversion
 
  // Current Row
  int row = blockIdx.x; 
  
  // Current Column
  int column = threadIdx.x;

  // The current pixel's ID
  int curPixel = row * numCols + column; 

  // The current pixel on the rgba image
  uchar4 rgba = rgbaImage[curPixel];
  
  // The color turned to grey scale, applying the formula
  float channelSum = /*red*/(.299f * rgba.x) + /*green*/(.587f * rgba.y) + /*blue*/(.114f * rgba.z); 
    
  // Change the pixel in the grey image
  greyImage[curPixel] = channelSum; 
    
}

void your_rgba_to_greyscale(const uchar4 * const h_rgbaImage, uchar4 * const d_rgbaImage,
                            unsigned char* const d_greyImage, size_t numRows, size_t numCols)
{
  // Declaring the number of blocks 
  const dim3 blockSize(numRows, 1, 1);
  // Declaring hte number of threads 
  const dim3 gridSize(numCols, 1, 1);  

  rgba_to_greyscale<<<blockSize, gridSize>>>(d_rgbaImage, d_greyImage, numRows, numCols);
  cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());

}
