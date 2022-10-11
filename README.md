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

## Usage 

As of versoin 1.0.0 the usage is streight forward. 
Logfile is stored in user's documents direcotory under the name "logfile.txt". 
Every log will be printed out to stdout with Swift's print function if run under DEBUG envrinment and log into the file.
To log you can use predefined functions with log level (which is then visible in the log output) use:
```
FTLogger.info("Your message or objects to be logged")
FTLogger.fault("An error happened")

FTLogger.log(level: .notice, "Message with notice level")
```
The first logs with info log level and the latter fault. You can also specifiy which level you want to log with general log function.

To get logs from log file, use `FTLogger.getLogs()` in async environment.

## Contributors

Current maintainer and main contributor is [Michal Němec](https://github.com/BajaCali), <michal.nemec@futured.app>.

## License

FTLogKit is available under the MIT license. See the [LICENSE file](LICENSE) for more information.
