# Designing Missions

A `Mission` encapsulates a singular background task or piece of work to perform. The `Mission` protocol defines a few parameters that your subclass will need to provide and a function where work can be performed.

## Overview

Begin by creating an object that conforms to the `Mission` protocol. Return a specific `style` and `identifier` which matches your declared ID as well as preferred ``MissionStyle``.

> Tip: Using a `struct` or `final class` will help provide automatic conformance to `Mission`'s required `Sendable` conformance.

Write any code necessary to perform your background task in the ``Mission/runTask(_:)`` implementation.

> Important: Always implement the passed-in `BGTask`'s `expirationHandler` to properly cancel or clean up unfinished tasks and avoid system termination. There is no need, however to call or implement `setTaskCompleted`. This is handled for you by the return value you provide.

Optionally return a `Date` from ``Mission/earliestStart()`` to indicate a delay prior to the system running this task for the first time.

### Example Mission

```swift
import Foundation
import BackgroundTasks
import Lurker

final class SecretMission: Mission {

    var identifier: String {
        return "com.yourApp.backgroundRefresh.secretMission"
    }

    var style: MissionStyle {
        return .brief
    }

    func runTask(_ taskInfo: BGTask) async -> Bool {
        let updateTask = Task { () -> Bool in
            // Perform some task
            return true
        }
        
        taskInfo.expirationHandler = {
            updateTask.cancel()
        }
        
        let success = await updateTask.value
        return success
    }
    
    func earliestStart() -> Date? {
        return nil
    }
    
}

```

### Understanding Mission Styles
There are important differences in Mission Styles and the way that the system handles each. Continue reading about ``MissionStyle``.

### Debugging
Find out how <doc:Debugging> works with Background Tasks.

## Topics

### Missions

- ``Lurker/MissionStyle``
- ``Lurker/Mission``

### Properties

- ``Lurker/Mission/identifier``
- ``Lurker/Mission/style``

### Functions

- ``Lurker/Mission/runTask(_:)``
- ``Lurker/Mission/earliestStart()``

### Debugging

- <doc:Debugging>
