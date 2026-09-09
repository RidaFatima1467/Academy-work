#What’s the difference between a list and a tuple?
""" List: 
In list we can change the values and elments, it is changeable.
example: list=[1,2,3,4]
Tuple:
in tuple we cannot change the values and elements, it is unchangeable.
example: tuple=(1,2,3,4) 

"""
#Write a function that returns the square of a number.
""" 
def squre(n):
 return n**2

"""
#What does *args do in a function signature?
"""
*args mean that we can give any number of positional values.
example:
def sum(*args):
    total = 0
    for n in args:
        total += n
    return total
    """
#What’s the output of a basic for loop over range(5)?
""" 
for i in range(5):
 print(i)
 """
#What is a dictionary comprehension?
"""
in comprehension we can create a dictionary in one line of code with the help of loop.
"""
#Build a small command-line program: takes a list of numbers as
# input, returns mean, median, mode, min, max — without using any 
# external library (pure Python only).

list=[]
n = int(input("enter the number of elements: "))
for i in range(n):
    numbers = int(input("enter a number: "))
    list.append(numbers)
print("list of numbers:", list)
print("Max", max(list))
print("Min", min(list))
print("sum", sum(list))
print("len", len(list))
print("mean", sum(list)/len(list))
print("median", (sorted(list)[len(list)//2-1]+sorted(list)[len(list)//2])/2) if len(list)%2==0 else print("median", sorted(list)[len(list)//2])