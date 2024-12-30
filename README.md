A set of script for configuring Operating Systems, software and more!

# Quickstart
(First Time only) Install mod-bash (see https://github.com/armystice/mod-bash/tree/main)
```bash
# Update mods and setup Debian x86 Physical server
bash ~/.armystice/mod/mod-bash/mod update mod-bash
bash ~/.armystice/mod/mod-bash/mod update mod-conf
#
# WARNING! The below example script WILL OVERWRITE EXISTING CONFIGURATION so please read through the script.
#          You will need to CHANGE THE EXAMPLE PARAMETERS!
#
# Example: sudo bash ~/.armystice/mod/private-mod-home3/debian/x86-physical.sh ssh_username_goes_here target_chrony_sources_file_name ntp_server sysctl_file
sudo bash ~/.armystice/mod/private-mod-home3/debian/x86-physical.sh exampleuser lan2 129.6.15.28 23-servers.conf
```