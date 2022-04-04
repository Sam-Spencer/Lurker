# Debugging

Unlike the legacy Background Fetch APIs, Background Tasks are not as easy to debug and cannot be tested in the iOS or iPadOS Simulator.

## Overview

After you've setup your background tasks using Lurker, you can debug and test how they behave on a device. 

### Testing a Successful Task

  1. Set a breakpoint inside the ``Lurker/Lurker/scheduleMission(_:)`` function. Set the breakpoint just after Lurker calls `submit()` inside this function.
  2. Then, pass this argument to the debugger:
     ```objective-c
     e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"TASK_IDENTIFIER"]
     ```
  3. Continue execution and wait for the backround task to complete.

### Testing a Terminated Task

  1. Set a breakpoint inside the ``Lurker/Lurker/scheduleMission(_:)`` function. Set the breakpoint just after Lurker calls `submit()` inside this function.
  2. Then, pass this argument to the debugger:
  ```objective-c
  e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"TASK_IDENTIFIER"]
  ```
  3. Continue execution and wait for the backround task to complete.

## Topics

### Scheduling Missions

- ``Lurker/Lurker/scheduleMission(_:)``
