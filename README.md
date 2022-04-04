<p align="center">
 <img src="https://github.com/Sam-Spencer/Lurker/raw/main/hero-icon.png" width="128" align="center">
 <br/>
 <h1 align="center">Lurker</h1>
 <p align="center">A dead-simple abstraction over the <a href="https://developer.apple.com/documentation/backgroundtasks">iOS BackgroundTask API</a> to make background tasks easy to isolate, maintain and schedule. Designed to be as lightweight and flexible as possible while tightly integrating with the system APIs. <i>And</i> It's built with Swift Concurrency in mind.</p>
</p>
<br/>

## Features

 - [x] Isolates and abstracts background tasks
 - [x] Eliminates boilerplate and extra setup steps
 - [x] Supports Swift Concurrency / async await
 - [x] Low-overhead and full feature set
 - [x] Extensive documentation (available with DocC)
 
## Requirements
This package requires a minimum deployment target of iOS 13.0 and Swift 5.6.

## Getting Started
Extensive, beautiful documentation is available by importing the included `.doccarchive` bundle into Xcode. Just open the archive and Xcode will import it into your documentation browser. Documentation includes articles to get you up and running with Background Tasks and information on how to debug these tasks.

![Documentation Screenshot](https://github.com/Sam-Spencer/Lurker/raw/main/hero-documentation.png)

## Installation
You can install, or integrate, Lurker using [Swift Package Manager](https://github.com/apple/swift-package-manager) or manually. 

### Swift Package Manager
Copy the following URL and then from Xcode choose `File` > `Add Packages...`.

    https://github.com/Sam-Spencer/Lurker.git
    
### Manually
Clone or download the repository and copy the contents of the `Sources` directory into your project.

## License
Lurker is available under the MIT license. See LICENSE file for more info.

