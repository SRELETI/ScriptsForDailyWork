#!/bin/bash

# =========== Print Usage ===========
printUsage()
{
    printf "Usage: "
    printf "dockercleanup [OPTIONS]"
    printf "\n       dockercleanup [-h | --help]"
    printf "\n\nA script to cleanup docker images and non-running containers.\n"
    printf "\nOptions:\n"
    printf "\n-a, --all\t\tDelete all images."
    printf "\n-o, --only-untagged\tDelete only Untagged images."
    printf "\n--delete-cont\t\tDefault is false.Set to 'true' to delete all the non-running containers."
    printf "\n\n"
}

# ===================================
checkExitStatus()
{
  $@ > /dev/null 2>&1
  local status=$?
  return $status
}
# ===================================
runCommand()
{
  $@
  return $?
}
# ===================================
deleteImages()
{
  if [[ $1 ]];then
    runCommand docker rmi -f $1
    printf "Done.\n"
  else
    printf "No images to delete.\n"
  fi
}
# ===================================

# check if docker is installed on the node
checkExitStatus docker --version
if [[ $? -ne 0 ]];
then
  printf "Docker is not installed, please install docker\n"
  exit 1
fi

# check if docker daemon is running on the node
checkExitStatus docker version
if [[ $? -ne 0 ]];
then
  printf "Cannot connect to the Docker daemon. Is the docker daemon running on this host?\n"
  exit 1
fi

# Check if any options are passed.
if [[ $# == 0 ]];
then
  printUsage
  exit 0
fi

# read the options
while [[ $# > 0 ]]
do
  key="$1"
  case $key in
    -h|--help)
      printUsage
      shift
      ;;
    -a|--all)
      DELETE_ALL=true
      shift
      ;;
    -o|--only-untagged)
      DELETE_UNTAGGED=true
      shift
      ;;
    --delete-cont)
      DELETE_CONT=true
      shift
      shift
      ;;
    *)
      printf "Invalid Command\n"
      printUsage
      ;;
  esac
done

# Delete the containers
if [[ "$DELETE_CONT" = true ]];
then
  printf "Deleting stopped containers...\n"
  containers=$(docker ps -q -f status=exited)
  if [[ $containers ]]; then
    runCommand docker rm $containers
    printf "Done.\n"
  else
    printf "No containers to delete.\n"
  fi
fi

# Delete the images. 
if [[ "$DELETE_ALL" = true ]];
then
  printf "Deleting all images...\n"
  image=$(docker images -a -q)
  deleteImages $image
elif [[ "$DELETE_UNTAGGED" = true ]]; then
  printf "Deleting untagged images...\n"
  image=$(docker images --filter "dangling=true" -q)
  deleteImages $image
fi
