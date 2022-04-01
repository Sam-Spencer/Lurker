# ``Lurker``

An abstraction over the system's Background Task API.

## Overview

Create an instance of ``Lurker`` and use it to register background tasks, encapsulated in ``Mission`` objects before your application finishes launching. Then, schedule all registered tasks or individually as needed.

Each ``Mission`` must have an `identifier` matching a declared background task in your app's Info.plist manifest.
