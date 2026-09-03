
# 1. Generate sensor data
import numpy as np
np.random.seed(42)
n=30
sensor_data= np.random.normal(loc=25, scale=2, size=n)
print("Sensor Data:", sensor_data)

# 2. Add some artificial outliers
sensor_data[5] = 40
sensor_data[19] = 2
sensor_data[29] = 55

print("\nSensor Data with Outliers:")
print(sensor_data)


# 3. Rolling statistics
window = 3

rolling_mean = []
rolling_std = []

for i in range(len(sensor_data) - window + 1):

    current_window = sensor_data[i:i + window]

    rolling_mean.append(np.mean(current_window))
    rolling_std.append(np.std(current_window))


rolling_mean = np.array(rolling_mean)
rolling_std = np.array(rolling_std)


print("\nRolling Mean:")
print(rolling_mean)

print("\nRolling Standard Deviation:")
print(rolling_std)


# 4. Calculate overall mean and standard deviation
mean = np.mean(sensor_data)
std = np.std(sensor_data)

print("\nMean:", mean)
print("Standard Deviation:", std)


# 5. Z-score normalization
z_scores = (sensor_data - mean) / std

print("\nZ-Scores:")
print(z_scores)


# 6. Detect outliers
outliers = np.abs(z_scores) > 2

print("\nOutlier Flags:")
print(outliers)


# 7. Show actual outlier values
print("\nOutlier Values:")
print(sensor_data[outliers])