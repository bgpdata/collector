# Collector

This service provides a high-performance BGP data collector that implements the BGP Monitoring Protocol (BMP) to gather routing information from network devices. Built with C++ and Boost, it efficiently processes and stores BGP updates, peer information, and route monitoring data. The service is designed to work seamlessly with the relay system for comprehensive network data collection.

## Build

```bash
# Create build directory
mkdir build && cd build

# Configure and build
cmake ..
make

# Run the service
./Server/collectord
```
