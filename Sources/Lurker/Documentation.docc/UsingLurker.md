# Using Lurker

Lurker makes it easy to setup, schedule, and manage background tasks in your app. Learn how to get up and running with Lurker once you've configured your app for background tasks.

## Overview

Getting started with Background Tasks takes a little setup, but once you've completed setup there is very little overhead to manage.

### Configuring Capabilities

Navigate to your Xcode project's "Signing & Capabilities" section and add the "Background Modes" capability. Then, enable both `Background fetch` and `Background processing`.

![Xcode project Signing and Capabilities pane.](tutorial-01)

Select "Info" from the project settings pane. Add a new `Array` key to your Info.plist: Permitted background task scheduler identifiers.

Then, add all needed task identifiers to this array. Task identifiers usually begin with your app's bundle ID and have additional identifying information appended. 

![Xcode project Info pane.](tutorial-02)

> Important: You **must** declare all of your task identifiers here, otherwise the system will not allow you to submit them for scheduling.

### Integrate Lurker

Add Lurker to your project and import it into your app's lifecycle object (the `AppDelegate` if using UIKit lifecycles, or your `App` struct if using SwiftUI lifecycles). Then, make a call to the shared Lurker object before your app finishes initializing:

```swift
@main
struct BackgroundRefreshApp: App {

    init() {
        do {
            try Lurker.shared.registerMissions([SecretMission()])
            Lurker.shared.scheduleAllMissions()
        } catch let error {
            print("Failed to register background tasks: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

}
```

> Note: It is important to check for errors thrown from ``Lurker/Lurker/registerMissions(_:)`` during *development*. Errors thrown here should mostly be considered programmer errors which need to be resolved prior to deploying code to production.


### Designing Missions

The most important part of setting up Lurker and your background tasks is designing and developing your Missions. Continue learning about <doc:DesigningMissions>.

## Topics

### Articles

- <doc:DesigningMissions>

### Lurker

- ``Lurker/Lurker``

### Missions

- ``Lurker/MissionStyle``
- ``Lurker/Mission``
