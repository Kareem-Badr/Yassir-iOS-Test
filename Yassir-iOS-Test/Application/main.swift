import UIKit

let appDelegateClass: AnyClass = NSClassFromString("TestsAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
