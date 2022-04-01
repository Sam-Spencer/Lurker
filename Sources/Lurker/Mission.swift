//
//  Mission.swift
//  Lurker
//
//  Created by Sam Spencer on 6/20/20.
//  Copyright © 2022 Sam Spencer. All rights reserved.
//

import Foundation
import BackgroundTasks

// MARK: - Types

/// The type of background task to schedule; can be either a brief task or an
/// extended one.
///
public enum MissionStyle {
    /// A processing task that can take minutes to complete.
    ///
    case extended
    /// A short refresh task.
    ///
    case brief
}

// MARK: - Protocols

/// A specific, isolated task that can be run in the background.
///
/// Lurker uses Swift Concurrency and requires that any code you designate for
/// background execution conforms to `Sendable` (and is therefore thread-safe).
///
public protocol Mission: Sendable {
    
    /// The identifier for the background task. The identifier must be included in the
    /// `BGTaskSchedulerPermittedIdentifiers` value in your app's Info.plist.
    ///
    var identifier: String { get }
    
    /// The background task style, `MissionStyle`. Generally, this indicates the nature
    /// of the task and the expected run time.
    ///
    var style: MissionStyle { get }
    
    /// Asynchronous function called by a `Lurker` that gets registered and then
    /// executed later in the background.
    ///
    /// - parameter taskInfo: The system-provided `BGTask` object provided when the
    ///   background task is initiated. Importantly, this includes the
    ///   `expirationHandler`, which you will need to observe in order to avoid
    ///   system-termination.
    ///
    /// - returns: `true` if your code completes execution successfully, or `false` if
    ///   your code is unable to complete with success prior to the passed-in task's
    ///   expiration. For example, you may return `false` if you make a network call that
    ///   does not complete before the `taskInfo`'s `expirationHandler` is called.
    ///
    func runTask(_ taskInfo: BGTask) async -> Bool
    
    /// Specify the earliest allowable time (from now) that the system may schedule this
    /// task. Return `nil` to indicate that the system may begin the task as soon as it
    /// determines is appropriate.
    ///
    /// - returns: The earliest acceptable date for the system to execute this
    ///   background task, or `nil` if the system may execute the task as soon as
    ///   appropriate.
    func earliestStart() -> Date?
    
}
