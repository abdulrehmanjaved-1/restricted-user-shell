# Create the user postperfect with the specified password
sudo useradd -m postperfect
echo "postperfect:odopproject" | sudo chpasswd

# Install Docker (if not already installed)
sudo apt-get update
sudo apt-get install -y docker.io

# Add the user postperfect to the docker group
sudo usermod -aG docker postperfect

# Create the Docker tests directory
sudo mkdir -p /mnt/oldchunker/docker_tests

# Set the owner of the Docker tests directory to postperfect
sudo chown postperfect:postperfect /mnt/oldchunker/docker_tests

# Set permissions so only postperfect can read, write, and execute in the Docker tests directory
sudo chmod 700 /mnt/oldchunker/docker_tests

# Create the restricted shell script
sudo nano /usr/local/bin/restricted_shell.sh

# Add the following content to the script and save it
#!/bin/bash
cd /mnt/oldchunker/docker_tests
exec /bin/bash --restricted

# Make the script executable
sudo chmod +x /usr/local/bin/restricted_shell.sh

# Modify the user's shell to use the restricted shell script
sudo usermod -s /usr/local/bin/restricted_shell.sh postperfect

# Ensure Docker commands are accessible in restricted shell (optional, ensure /usr/bin/docker is in PATH)
# Create symlinks if necessary
sudo mkdir -p /mnt/oldchunker/docker_tests/bin
sudo ln -s /usr/bin/docker /mnt/oldchunker/docker_tests/bin/docker
echo 'export PATH=/mnt/oldchunker/docker_tests/bin:$PATH' >> /home/postperfect/.bashrc
