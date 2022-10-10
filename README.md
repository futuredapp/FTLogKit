# FTLogKit

Yet another logging framework for Apple platforms

## When to use FTLogKit

You might want to consider this package for logging when
- you are trying to log into a file and later share the file on runtime,
- you do not want to use system logging.

You do not want to use this package when
- you need to support older system versions,
- you are courious of app crashes (this logger might fail to log all events near the crash).

## Key values of FTLogKit

### Customazibility

This package aim to be highly customizable.
Users of this package must be able to decide for themselves whether to create instances of logger and manage their own or to set up instances on public interface provided by the package.
Users should be able to implement custom loggers themselves via provided protocol.
Users must be able to change how the log record looks like for both custom loggers and default one.

### Speed

Logging should take just minimum time necessary on caller side.

### Using latest technologies

Including `actor`s to keeep file handling out of running thread.

## Contributors

Current maintainer and main contributor is [Michal Němec](https://github.com/BajaCali), <michal.nemec@futured.app>.

## License

FTLogKit is available under the MIT license. See the [LICENSE file](LICENSE) for more information.
