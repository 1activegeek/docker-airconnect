# docker-airconnect
AirConnect container for turning Chromecast into Airplay targets  
On DockerHub: https://hub.docker.com/r/web2brain/docker-airconnect  
On GitHub: https://github.com/web2brain/docker-airconnect  

This is a containerized build of the fantastics program by [philippe44](https://github.com/philippe44) called AirConnect. It allows you to be able to use AirPlay to push audio to Chromecast and UPNP based devices. There are some advanced details and information that you should review on his [GitHub Project](https://github.com/philippe44/AirConnect). For the most part this container needs nothing more than to launch it using Host networking. This image is heavily based on the image from [1activegeek](https://github.com/1activegeek), but introduces multi architecture support. Thanks to [ckulka](https://github.com/ckulka/docker-multi-arch-example) for the examples of multi architecture support on docker hub.

The main purpose for building this container over the others out there, is that this will always update to the latest version of the app as pulled from the original GitHub page. Currently there is another popular container that is not updated. This uses runtime scripting to ensure it will always pull the latest version of the binary before running - without intervention by me. It also uses the base image produced by the [LS.io team](https://github.com/linuxserver) to reduce footprint. 

# Running

This can be run using a docker compose file or a standard docker run command.

Sample Docker run config:

`docker run -d --net=host 1activegeek/airconnect`

I've introduced a secondary function as well in case you'd like to run the container with specifc runtime variables appended to the run config. This includes things such as the examples below in the troubleshooting section. It's purpose is more aimed at folks who'd like to use a custom configuration file for example, which requires running with `-x <name of file>` to be able to run this config.

To utilize this, please use the following environment variables when you run the container:
- `AIRCAST_VAR` This will be for variables to send to the aircast runtime used for integration with Chromecast based devices
- `AIRUPNP_VAR` This will be for variables to send to the airupnp runtime used for integration with Sonos and UPnP based devices
  - **If you alter this variable you need to add in `-l 1000:2000` per the devs notes for Sonos/Heos players. If you don't alter the variable, I include this by default in the docker files**

### Runtime Commands

```
Usage: [options]
  -b < address>        network address to bind to
  -c <mp3[:<rate>]|flc[:0..9]|wav>    audio format send to player
  -x <config file>    read config from file (default is ./config.xml)
  -i <config file>    discover players, save <config file> and exit
  -I             auto save config at every network scan
  -l <[rtp][:http][:f]>    RTP and HTTP latency (ms), ':f' forces silence fill
  -r             let timing reference drift (no click)
  -f <logfile>        Write debug to logfile
  -p <pid file>        write PID in file
  -d <log>=<level>    Set logging level, logs: all|raop|main|util|cast, level: error|warn|info|debug|sdebug
  -Z             NOT interactive
  -k             Immediate exit on SIGQUIT and SIGTERM
  -t             License terms
```

# Troubleshooting

If you need to attempt to dig into troubleshooting and see the logs realtime in the container, use the following examples to help dig into diagnosis.

`docker exec -it <name of container> bash`

Once inside the container, you can use standard config options to run the app as outlined by the creator. The app is located in the `/bin` directory. Both the UPNP and Cast versions of the file are being run in this container.

`./aircast --h` - will provide you a list of commands that can be run via the app

`./aircast -d all=debug` - will run the app and output a debug based log in an interactive mode

If you perform any realtime testing, it is suggested to completely restart the container after testing to be sure there are no incompatibilities that arise with running it in daemon mode while also running it interactively. 
