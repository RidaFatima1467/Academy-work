#what is broadcasting in numpy?
"""Broadcasting in NumPy is a feature that allows 
you to perform operations on arrays of different shapes 
 and sizes.it aslo use in perfoming calculations on different shapes of arrays."""

#Difference between .reshape() and .flatten()?
""" .reshape():
it is used to change the shape of array without change in data.
.flatten():
it is used to convert multi_dimensional array into 1D array."""

#axis-0 and axis-1 in mean in np.sum()?
""" axis-0:
it is use to perform function with rows in array.
axis-1:
it is use to perform function or operation with clolumns in array."""

#random array of shape (5,5)?
import numpy as np
array =np.random.random((5,5))
print(array)

#How do uou select all rows where a columnn value>10 in 2D array?
""" 1. by using where function in numpy
    2. and through 0-axis slicing.
"""