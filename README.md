# ScriptsForDailyWork
Automate Daily works to be more productivity

### 1. Dockercleanup Script:

A script to delete the docker images and stopped docker containers.

#### 1.1 Usage

```
Usage: dockercleanup [OPTIONS]
       dockercleanup [-h | --help]

A script to cleanup docker images and non-running containers.

Options:

-a, --all		Delete all images.
-o, --only-untagged	Delete only Untagged images.
--delete-cont		Default is false.Set to 'true' to delete all the non-running containers.

```

#### 1.2 Setup

* Make the script executable. `chmod +x dockercleanup.sh`
* Copy the script to a path where bash can find it. `cp ./dockercleanup.sh /usr/local/bin/`
* Create a alias. `alias dockercleanup='/usr/local/bin/dockercleanup.sh'`
* Run `dockercleanup` to start using it.
