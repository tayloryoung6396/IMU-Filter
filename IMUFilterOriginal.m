close all
% clear all

load 'rpy_9axis.mat' sensorData Fs

accelerometerReadings = sensorData.Acceleration;
gyroscopeReadings = sensorData.AngularVelocity;
% Create an imufilter System object™ with sample rate set to the sample rate of the sensor data. Specify a decimation factor of two to reduce the computational cost of the algorithm.

decim = 2;
fuse = imufilter('SampleRate',Fs,'DecimationFactor',decim);
% Pass the accelerometer readings and gyroscope readings to the imufilter object, fuse, to output an estimate of the sensor body orientation over time. By default, the orientation is output as a vector of quaternions.

q = fuse(accelerometerReadings,gyroscopeReadings);
% Orientation is defined by the angular displacement required to rotate a parent coordinate system to a child coordinate system. Plot the orientation in Euler angles in degrees over time.

% imufilter fusion correctly estimates the change in orientation from an assumed north-facing initial orientation. However, the device's x-axis was pointing southward when recorded. To correctly estimate the orientation relative to the true initial orientation or relative to NED, use ahrsfilter.

time = (0:decim:size(accelerometerReadings,1)-1)/Fs;

figure()
plot(time,eulerd(q,'ZYX','frame'))
title('Orientation Estimate')
legend('Z-axis', 'Y-axis', 'X-axis')
xlabel('Time (s)')
ylabel('Rotation (degrees)')