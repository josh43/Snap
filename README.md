# SnapClone

Doxygen was recently added 
Although it is not picking up my descriptions hopefully I'll find out why soon


```
http://snap-jrm43.rhcloud.com/
```

All you should have to do is change the provisioning profile and it should work!

If you have an updated version of XCode and are trying to run ios 10+ it will not run on the simulator however because the simulator does not have a camera 

SnapClone is an iOS app written in Objective-C that mimicks the very popular snapchat
and some of the functionality includes

  - Users can send other users snaps
  - Users can post content to their story
  - Users can draw on their snaps or put a label on them before sending/posting them
  - Users can send video/picture content
  - Recieved read receipts on snap's sent and see by other users
  - Users can add/remove friends





### How it works

* [Node.js] - Server
* [MongoDB] - awesome nosql database
* [Express] - fast node.js network app framework 
* [Objective-C] - language used to write the iOS application
* [REST] - architectural style used for smooth communication
* [OpenShift] - server is deployed using the OpenShift services

### Tools used

* [AppCode] - a great Objective-C IDE that allows for rapid code completion and generation
* [WebStorm] - JavaScript IDE
* [XCode] - Apple's IDE
* [Sublime] - Simple and clean text editor

### Some images

![snapPic](http://snap-jrm43.rhcloud.com/Screen%20Shot%202016-09-22%20at%2011.21.01%20PM.png)
![inceptionPic](http://snap-jrm43.rhcloud.com/Screen%20Shot%202016-09-22%20at%2011.24.27%20PM.png)

### Installation

```sh
git clone https://github.com/josh43/Snap
```
Open the application in XCode and run it
## If you want to run the server from your local machine

    1. git clone https://github.com/josh43/SnapServer
    2. Change the ip address to something like localhost:8080
    3. Make sure you have MongoDB > 2.6
    4. sudo mongod
    5. Start the server
    6. Than in  SnapCloneMainDir/Rest/HTTPHelper.h change the ip to http://localhost:8080
    7. Start the application





   
   [node.js]: <http://nodejs.org>
   [express]: <http://expressjs.com>
   [OpenShift]: <https://www.openshift.com/>
   [Objective-C]: <https://en.wikipedia.org/wiki/Objective-C>
   [AppCode]: <https://www.jetbrains.com/objc/>
   [WebStorm]: <https://www.jetbrains.com/webstorm/>
   [REST]: <https://en.wikipedia.org/wiki/Representational_state_transfer>
   [XCode]: <https://developer.apple.com/xcode/>
   [Sublime]: <https://www.sublimetext.com/>
   [MongoDB]: <https://www.mongodb.com/>
   

