# UniFi Controller Docker Setup with Watchtower

This repository provides a **Docker Compose** setup for running the **UniFi Network Controller** in a Docker container, with **Watchtower** included to automatically update the container daily. The container is configured to run using the host network and persist data on the local filesystem.

## 📝 **What This Setup Does**

- **UniFi Controller**: A Docker container that runs the **UniFi Network Controller** using the `jacobalberty/unifi:latest` image.
- **Watchtower**: A companion service that automatically checks for updates to the `unifi-controller` container every 24 hours and restarts the container with the latest image if an update is found.

## ⚙️ **Ports and Network Considerations**

When using this setup, be aware of the following:

- **Ports in Use**: The **UniFi Controller** container uses several ports that may conflict with other running containers if those ports are already in use. These ports are necessary for proper functionality and include:
    
    - **8080**: Device management communication (TCP)
    - **8443**: Controller UI (HTTPS) (TCP)
    - **3478**: STUN (UDP)
    - **10001**: Device discovery (UDP)
    - **8880**: HTTP redirect (TCP)
    - **6789**: Speed test (TCP)
- **Network Mode**: This setup uses `network_mode: host`, meaning that the container binds directly to the host's network interface. This simplifies networking, but it also means these ports must be available on the host machine. If you have other containers running with conflicting ports, you should adjust the port mapping or consider a different network mode.
    

### **Suggested Testing Environment**

- **Single Host with Docker Installed**: It is recommended to test this setup on a **single host** where Docker is installed, as the container will use the host's network interfaces. You can test this on your local machine or a VM with Docker installed.
    
    If you need to test it in a more complex multi-host environment, consider using **Docker Swarm** or **Kubernetes** to handle networking in a more advanced manner.
    

## 🛠️ **Requirements**

- **Docker**: Make sure Docker is installed on your system. You can follow the [official installation guide](https://docs.docker.com/engine/install/) for your operating system.
- **Docker Compose**: You'll need Docker Compose installed to run the `docker-compose.yml` file. You can install it by following [this guide](https://docs.docker.com/compose/install/).
- **Persistent Storage Directory**: Create a directory on your system where the UniFi Controller data will be stored. This ensures that your configurations and settings are persisted across container restarts. This guide assumes you are using `./unifi/config` relative to your current directory.

## 📂 **Directory Setup**

Ensure you have a local directory structure to store the UniFi controller's configuration data:

```
mkdir -p ./unifi/config
```

This folder will store the UniFi controller's configuration, which is mapped to `/unifi` inside the container.

## 🚀 **Running the Setup**

### 1. Clone the Repository or Copy the `docker-compose.yml`

Clone or copy this repository to your local machine.

```
git clone https://github.com/sohaib1khan/unifi-controller-docker.git
cd unifi-controller-docker
```

Alternatively, just download the `docker-compose.yml` file into a new directory.

### 2. Run Docker Compose

From the directory containing the `docker-compose.yml` file, run the following command to start the UniFi Controller and Watchtower services:

```
docker-compose up -d
```

This will:

- Pull the required Docker images (`jacobalberty/unifi` for the UniFi Controller and `containrrr/watchtower` for automatic updates).
- Create and start the **unifi-controller** container with host networking.
- Start the **watchtower** container to automatically update the UniFi Controller container every 24 hours.

### 3. Access the UniFi Controller

Once the containers are running, you can access the UniFi Controller by opening a browser and navigating to:

```
https://<YOUR_HOST_IP>:8443
```

Replace `<YOUR_HOST_IP>` with the actual IP address of your host machine.

* * *

## 🔄 **Automatic Updates with Watchtower**

The **Watchtower** container will monitor the `unifi-controller` container and automatically check for updates every 24 hours (86400 seconds). When a new version of the UniFi Controller image is available, Watchtower will pull the latest image and restart the UniFi Controller container.

### Watchtower Customization

You can modify the update interval by adjusting the `WATCHTOWER_INTERVAL` environment variable in the `docker-compose.yml` file. The value is in seconds, and the default is set to **86400 seconds (24 hours)**. To check every 12 hours, for example, set `WATCHTOWER_INTERVAL=43200`.

* * *

## 🔄 **Manual Update**

If you prefer to manually update the containers, you can do so with the following commands:

1.  Pull the latest image:

```
docker-compose pull unifi-controller
```

&nbsp; 2. Recreate and restart the containers: 

```
docker-compose up -d
```

This will pull the latest image and restart the UniFi Controller container.

* * *

## ⚠️ **Important Notes**

- Ensure that **no other services** on your system are using the same ports (8080, 8443, 3478, 10001, 8880, 6789). If you have other services using these ports, you may need to adjust port mappings or choose a different network configuration.
    
- If you are running this on a **production server**, ensure that the ports are properly secured and firewalled as needed to avoid exposing sensitive services.
