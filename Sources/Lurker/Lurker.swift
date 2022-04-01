//
//  Lurker.swift
//  Lurker
//
//  Created by Sam Spencer on 6/20/20.
//  Copyright © 2022 Sam Spencer. All rights reserved.
//

import Foundation
import BackgroundTasks

/// Potential errors that may occur when registering background tasks.
///
public enum LurkerError: Error {
    case tooManyRefreshTasks
    case tooManyProcessTasks
    case failedToRegisterTask
}

/// `Lurker` manages all your app's tasks that need to happen in the background.
///
public final class Lurker {
    
    /// A generic, shared instance of `Lurker`. Useful if you need to maintain
    /// references to registered tasks after launch.
    public static var shared = Lurker()
    
    /// Tasks that have been successfully registered to the system `BGTaskScheduler`.
    public private(set) var tasksRegistered: [Mission] = []
    
    /// Initialize a new `Lurker` instance.
    ///
    public init() {
        
    }
    
    // MARK: - Registering
    
    /// Register multiple tasks with the system `BGTaskScheduler`.
    ///
    /// You must register all background tasks during your application's launch. If
    /// you receive errors when calling this function, check that you have
    /// properly setup your app's background task permissions and that the declared
    /// identifiers in both your `Mission` object and `Info.plist` match.
    ///
    /// - parameter missions: An array of background task objects that conform to the
    ///   `Mission` protocol.
    ///
    /// - throws: A `LurkerError` indicating any issues that may have prevented
    ///   registration from proceeding. These errors should be caught during development
    ///   and resolved prior to release.
    ///
    /// - warning: You must finish registering all handlers *before* you return from
    ///   `appDidFinishLaunchingWithOptions`.
    ///
    /// - note: There can be a total of 1 refresh task and 10 processing tasks scheduled
    ///   at any time. Trying to schedule more tasks returns `false`.
    ///
    public func registerMissions(_ missions: [Mission]) throws {
        let refreshTasks = missions.filter({ $0.style == .brief })
        guard refreshTasks.count <= 1 else {
            print("[Lurker] Too many refresh tasks submitted for registration. Maximum of 1 is allowed by the system.")
            throw LurkerError.tooManyRefreshTasks
        }
        
        let processTasks = missions.filter({ $0.style == .extended })
        guard processTasks.count <= 10 else {
            print("[Lurker] Too many process tasks submitted for registration. Maximum of 10 are allowed by the system.")
            throw LurkerError.tooManyProcessTasks
        }
        
        var successfullyRegistered = true
        
        for mission in missions {
            let registered = registerMission(mission)
            if registered == false {
                successfullyRegistered = false
            }
        }
        
        if successfullyRegistered == false {
            print("[Lurker] Failed to register at least one task with the system.")
            throw LurkerError.failedToRegisterTask
        }
    }
    
    /// Register a task with the system `BGTaskScheduler`.
    ///
    /// - parameter task: A background task object that conforms to the `Mission`
    ///   protocol.
    ///
    /// - returns: `true` if the task was successfully registered, `false` if it could
    ///   not be registrered with the system.
    ///
    @discardableResult public func registerMission(_ task: Mission) -> Bool {
        guard tasksRegistered.contains(where: { $0.identifier == task.identifier }) == false else { return false }
        
        let didRegister = BGTaskScheduler.shared.register(forTaskWithIdentifier: task.identifier, using: nil) { backgroundTask in
            self.handleMission(backgroundProcess: backgroundTask, mission: task)
        }
        
        if didRegister == true {
            tasksRegistered.append(task)
        }
        
        return didRegister
    }
    
    // MARK: - Handling
    
    func handleMission(backgroundProcess: BGTask, mission: Mission) {
        scheduleMission(mission)
        
        let taskQueue = Task {
            let success = await mission.runTask(backgroundProcess)
            backgroundProcess.setTaskCompleted(success: success)
        }
        
        backgroundProcess.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set
            // the task to complete.
            taskQueue.cancel()
        }
    }
    
    // MARK: - Scheduling
    
    /// Schedule all registered background tasks for execution at a later time
    /// determined by the system.
    ///
    public func scheduleAllMissions() {
        for mission in tasksRegistered {
            scheduleMission(mission)
        }
    }
    
    /// Schedules a background task for execution at a later time determined by the
    /// system.
    ///
    /// - parameter task: A background task object conforming to the `Mission` protocol.
    ///
    /// - note: You must first register a task prior to scheduling it. If a task is not
    ///   registered with the system, this action may fail silently. If the task has
    ///   already been scheduled, the existing task will be replaced.
    ///
    public func scheduleMission(_ task: Mission) {
        do {
            switch task.style {
            case .brief:
                let request = BGAppRefreshTaskRequest(identifier: task.identifier)
                request.earliestBeginDate = task.earliestStart()
                try BGTaskScheduler.shared.submit(request)
            case .extended:
                let request = BGProcessingTaskRequest(identifier: task.identifier)
                request.earliestBeginDate = task.earliestStart()
                try BGTaskScheduler.shared.submit(request)
            }
        } catch {
            print("Could not schedule \(task.identifier): \(error)")
        }
    }
    
}
