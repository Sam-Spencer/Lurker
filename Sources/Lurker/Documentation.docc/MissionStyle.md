# ``Lurker/MissionStyle``

There are two styles to choose from for background tasks: brief and extended. Each has its own benefits and drawbacks and is designed for a specific purpose. Your custom implementation(s) of ``Mission`` should take these details into account (they also require you to declare the task style ahead of time).

### Brief Tasks
Brief tasks are designed to modularly refresh app data. This is traditionally accomplished by making a single network call to update a local data store or cache. The result is a faster app launch experience with less load time for users after opening your app.

> Important: iOS currently limits the number of scheduled brief tasks to 10. Lurker will verify this for you and `throw` a ``Lurker/LurkerError`` if you exceed this limit when registering tasks.

The example below illustrates a suggested implementation for this type of task using swift concurrency (although its use is not required).

```swift
func runTask(_ taskInfo: BGTask) async -> Bool {
    let fetchTask = Task { () -> AVeryNiceModel in
        let url = URL(string: "https://averyniceRESTapi.com/api/fetch/averynicemodel")!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let model = try JSONDecoder().decode(AVeryNiceModel.self, from: data)
            return model
        } catch {
            return AVeryNiceModel.empty
        }
    }
    
    taskInfo.expirationHandler { expiration in
        fetchTask.cancel()
    }
    
    let result = await fetchTask.value
    if result.status != .empty {
        LocalDataStore.shared.refreshCache(with: result)
        taskInfo.setTaskCompleted(success: true)
    } else {
        taskInfo.setTaskCompleted(success: false)
    }
}
```

> Warning: Brief tasks should last no longer than 30 seconds. Any background process still running after this time may be terminated by the system. Additionally, there is no guarantee that your task will be alotted an entire 30 seconds. Use the `taskInfo` parameter's `expirationHandler` provided by your Mission's ``Mission/runTask(_:)`` function to cancel any unfinished work.

### Extended Tasks
Extended tasks are designed to manage heavy workloads, such as training or updating a machine learning model or cleaning up database files. These tasks are usually scheduled to run when the system determines it will have a minimal impact on battery life and performance (e.g. overnight while charging). 

> Important: iOS currently limits the number of scheduled extended tasks to 1. Lurker will verify this for you and `throw` a  ``Lurker/LurkerError`` if you exceed this limit when registering tasks.

The implementation for an extended task is largely the same as the example shown above. The primary difference is that you are not strictly limited to 30 seconds, as with brief tasks. However, the system may interrupt and end your task if the user begins using their device (so you still need to implement the expiration handler to do any cleanup!).

> Note: Extended tasks require enabling the `processing` UIBackgroundModes capability in your application's entitlements.

## Topics

### Cases

- ``MissionStyle/brief``
- ``MissionStyle/extended``
