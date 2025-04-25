# General Aviation Flight Tracker – Class Project

This project is a lightweight tool for tracking general aviation flights using mobile sensor data. The goal is to help flight clubs automate flight logging and billing without relying on analog processes.

## Project Purpose

Flight clubs and schools often use manual logbooks to track flights and calculate billing time. This tool demonstrates a proof of concept for:

- Tracking flight time using mobile phone sensors (GPS, gyroscope, microphone)
- Generating automatic flight logs
- Verify them with the picture of Hobbs.
- Calculating billable time based on engine activity

## Current Features

- Flight event detection using simulated mobile data (engine start, takeoff, landing)
- Auto-generation of structured flight logs (date, duration, aircraft ID)
- Basic billing time calculation based on time in motion
- Designed for mobile-first use cases

## Technologies Used

- Python
- Pandas, NumPy
- Simulated sensor input (GPS, gyro)
- Matplotlib (for data visualization)

## Future Features

- Maintenance tracking (e.g. usage-based reminders)
- Flight analytics dashboard (pilot activity, aircraft utilization)
- User tracking (instructors, renters)
- Mobile app interface
- Integration with scheduling platforms like Flight Circle

## Monetization Plan

This project is the foundation for a SaaS product aimed at flight clubs and schools. The business model would be:
- Free analysis and logbook for pilots. 
- Monthly subscription per aircraft or per user for flight clubs
- Additional charges for advanced features like maintainence logs analysis and complete management. 

## Next Steps

- Improve flight event detection with real sensor data
- Build a simple user interface for reviewing logs
- Test with real club data
- Interview pilots and managers for feedback

## Contact

Kaveesh Passari
https://www.linkedin.com/in/kaveesh-passari-393556200/

