# ``Lurker``

An abstraction over the system's Background Task API.

## Overview

Lurker makes it super easy to isolate, register, and schedule background tasks for your iOS app.

### General Setup

Create an instance of ``Lurker`` and use it to register background tasks, encapsulated in ``Mission`` objects before your application finishes launching. Then, schedule all registered tasks or individually as needed.

Each ``Mission`` must have an `identifier` matching a declared background task in your app's Info.plist manifest.

## Topics

### Getting Started

 - <doc:UsingLurker>
 - <doc:DesigningMissions>
 - <doc:Debugging>

### Classes

 - ``Lurker/Lurker``

### Protocols

 - ``Lurker/Mission``

### Enumerations

 - ``Lurker/MissionStyle``
 - ``Lurker/LurkerError``
