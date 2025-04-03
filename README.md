# SimpleBonjourExample
An example of irrational Bonjour behavior. 

PLATFORM AND VERSION
iOS
Development environment: Xcode Version 16.2 (16C5032a), macOS 15.3.2 (24D81)
Run-time configuration: iOS 18.3.2, macOS 15.3.2 (24D81)

DESCRIPTION OF PROBLEM
No matter how simple I make the code, I cannot get an iPhone app to consistently 1) ask for permissions to access the local network 2)persist that permission 3) discover advertised bonjour services on that same local network (probably because of 1 and 2.

The advertised Bonjour service can be found when using an iOS simulator (And works perfectly when doing so), but when launching that same iOS app on an iphone, it fails due to nw_browser_fail_on_dns_error_locked [B2] DNSServiceBrowse failed: NoAuth(-65555). I have checked and rechecked that I have the proper Info.plist permissions.

STEPS TO REPRODUCE
1) Open the XCode project.
2) Build the Mac App, click "Start Advertising"
3) Notice in the XCode console that the log messages show that we have started advertising.
4) Enter "dns-sd -B _example._tcp local." into terminal to verify that we are indeed running a Bonjour service named _example._cp
5) Build the iPhone app in an Iphone 16 Pro simulator
6) Let the app install in the simulator and open
7) Immediately observe that both the UI and the Xcode console logs verify that we've discovered the _example._tcp service.
8) Build the iPhone app on a physical iPhone.
9) Open the iPhone app and observe that no Bonjour service is discovered and that the console log logs an error of "nw_browser_fail_on_dns_error_locked [B3] DNSServiceBrowse failed: NoAuth(-65555)".
