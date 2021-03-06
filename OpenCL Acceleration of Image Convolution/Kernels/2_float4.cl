__kernel void convolve(
	const __global float4 *input, 
	__global float4 *output,
	__global float4 *filter,
        __local float4 *cached  // Unused
)
{

	int rowOffset = get_global_id(1) * IMAGE_W;
	int my = get_global_id(0) + rowOffset;

	if (
		get_global_id(0) < HALF_FILTER_SIZE || 
		get_global_id(0) > IMAGE_W - HALF_FILTER_SIZE - 1 || 
		get_global_id(1) < HALF_FILTER_SIZE ||
		get_global_id(1) > IMAGE_H - HALF_FILTER_SIZE - 1
	)
	{
		return;
	}
	
	else
	{
		// perform convolution
		int fIndex = 0;
		float4 sum = (float4) 0.0;
		
		for (int r = -HALF_FILTER_SIZE; r <= HALF_FILTER_SIZE; r++)
		{
			int curRow = my + r * IMAGE_W;
			for (int c = -HALF_FILTER_SIZE; c <= HALF_FILTER_SIZE; c++)
			{
				int offset = c;
				
				sum += input[ curRow + offset   ] * filter[ fIndex ]; 
				fIndex++;
	
			}
		}
		output[my] = sum;
	}
}

