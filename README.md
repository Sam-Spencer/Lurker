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

## Installation
You can install, or integrate, Lurker using [Swift Package Manager](https://github.com/apple/swift-package-manager) or manually. 

### Swift Package Manager
Copy the following URL and then from Xcode choose `File` > `Add Packages...`.

    https://github.com/Sam-Spencer/Lurker.git
    
### Manually
Clone or download the repository and copy the contents of the `Sources` directory into your project.

## Getting Started
Lurker provides stellar documentation to walk you through every step of the way and any questions you may have. But, I've also included a quick reference to get you going here.

### Registering & Scheduling Tasks
Registering and scheduling your tasks can be as short as two lines of code:

  1. Register your "missions" (background tasks).
  2. Schedule them.
  3. All done! 🍾

```swift
func setupLurker() {
    do {
        try Lurker.shared.registerMissions([ProductMission(), ConfigurationMission()])
        Lurker.shared.scheduleAllMissions()
    } catch let error {
        print("Failed to register and schedule background tasks: \(error)")
    }
}
```

> **Important**: Any errors thrown here are likely programmer errors and should be resolved prior to deployment to production.

### Creating a Task
Creating a task is pretty easy. Just create an object that conforms to the `Mission` protocol and implement the necessary properties and functions.

```swift
final class ConfigurationMission: Mission {
    
    // This should match one of your app's predefined task identifier
    var identifier: String {
        return "com.yourApp.backgroundRefresh.configurationTask"
    }
    
    // This can be either "brief" or "extended"
    var style: MissionStyle {
        return .extended
    }
    
    // This is where the magic happens!
    func runTask(_ taskInfo: BGTask) async -> Bool {
        let longTask = Task { _ -> Bool in
            // Perform work here
            return true
        }
        
        taskInfo.expirationHandler = {
            print("Task is expiring")
            longTask.cancel()
        }
        
        let success = await longTask.value
        return success
    }
    
    // Return a date here to delay system task execution
    func earliestStart() -> Date? {
        return nil
    }
    
}
```

> **Tip**: The `Mission` protocol requires [`Sendable` conformance](https://www.avanderlee.com/swift/sendable-protocol-closures/). The easiest way to ensure this is by using either a `struct` or `final class`, depending on your needs. Otherwise you may need to do extra work to conform.

### Documentation
Extensive, beautiful documentation is available by importing the included `.doccarchive` bundle into Xcode. Just open the archive and Xcode will import it into your documentation browser. Documentation includes articles to get you up and running with Background Tasks and information on how to debug these tasks.

![Documentation Screenshot](https://github.com/Sam-Spencer/Lurker/raw/main/hero-documentation.png)

## License
Lurker is available under the MIT license. See LICENSE file for more info.

