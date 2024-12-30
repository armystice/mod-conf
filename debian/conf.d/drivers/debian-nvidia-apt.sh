curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/3bf863cc.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1
echo 'deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /' | sudo tee /etc/apt/sources.list.d/nvidia-drivers.list
sudo apt update
sudo apt remove nvidia*
sudo dpkg --add-architecture i386
sudo apt install nvidia-565
sudo apt install nvidia-kernel-dkms nvidia-kernel-source nvidia-open-kernel-source libnvidia-fbc1 vulkan-tools
sudo apt install cuda-drivers
sudo apt install nvidia-driver-libs:i386 libnvidia-egl-xlib1
sudo apt install nvidia-primus-vk-common
sudo apt install libnvidia-encode1
sudo apt install cuda-nvcc-12-6

# Recommended: libnvidia-egl-xlib libnvidia-api1:i386 libnvidia-egl-xlib:i386 libnvidia-ngx1:i386 libnvidia-rtcore:i386 libnvidia-vksc-core:i386 firmware-nvidia-gsp firmware-nvidia-gsp-535.183.01 nvidia-open-kernel-support--v1