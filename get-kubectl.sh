########################################################################################################################
# Downloads kubectl based on version passed
# There are no guards here, but it checks, whetver we get garbage back
#
# This is what the script does
# 1. Downloads kubectl version from google
# 2. Ensures execution bit
# 3. Moves to your local bin folder (part of $PATH)
# 4. Ensures a local backup, and amends the version you downloaded
# 5. Outputs kubectl version
# 
# Feel free to do with it what you want
#
#
#!/bin/bash
current_path_bin=$(realpath "$(pwd)/kubectl")
local_path_bin=$(realpath "/usr/local/bin")

if [ "$#" -ne 1 ]; then
  echo "Please pass a kubectl version"
  exit 1  
fi

echo "Fetching kubectl $1"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$1/bin/linux/amd64/kubectl

file_threshold=5000
file_size=$(du -b $current_path_bin | cut -f1)

echo "HELLO!!! $file_size"

if [ $file_size -lt $file_threshold ]; then
  echo Try a version that exists
  exit 1
fi

echo "Setting execution bit for you"
chmod +x $current_path_bin

echo "Moved to -> $local_path_bin"
sudo cp $current_path_bin $local_path_bin

backup_kubeclient="$current_path_bin-$1"
mv $current_path_bin $backup_kubeclient

echo
echo "Download can be found here $backup_kubeclient"
echo "Here is your new kubectl version (please remember the +/- version compatability)"
echo
echo
kubectl version --short -o yaml
