# ``Lurker/Mission``

### Implementing Your Mission
A `Mission` is an abstract representation of a specific, isolated task that can be run in the background. You must create your own objects which conform to the `Mission` protocol, then register and schedule them with a ``Lurker`` instance.

> Important: `Mission` inherits from the `Sendable` protocol, thus requiring any code written in your concrete object to be thread-safe. To ensure this, any objects conforming to `Mission` should either be `struct` or `final class`.
>
> If you need to specifically opt-out of this behavior, use `@unchecked`. While no documentation is currently available from Apple, you can learn more about `Sendable` [here](https://www.avanderlee.com/swift/sendable-protocol-closures/).

### An Example Implementation

```swift
final class SuperSecretMission: Mission {
    
    var style: MissionStyle {
        return .extended
    }
    
    var identifier: String {
        // The string returned here MUST exactly match a predefined background task ID in
        // your app's Info.plist file.
    
        return "gov.agency.mission.topSecret"
    }
    
    func runTask(_ taskInfo: BGTask) async -> Bool {
        let secretTask = Task { () -> Report in
            return Agent.main.bigProject()
        }
        
        taskInfo.expirationHandler { expiration in
            secretTask.cancel()
        }
        
        let result = await secretTask.value
        if result == .success {
            await Bureau.shared.sendReport(result)
            taskInfo.setTaskCompleted(success: true)
        } else {
            taskInfo.setTaskCompleted(success: false)
        }
    }
    
    func earliestStart() -> Date? {
        // You can always return nil for the default system behavior, or a custom delay.
        return Date(timeIntervalSinceNow: TimeInterval(10 * 60))
    }
    
}
``
