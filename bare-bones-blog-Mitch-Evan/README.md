# BareBonesBlog—Sample Code for a SwiftUI App That is Backed by Firebase
This repository houses an Xcode project for an iOS app that demonstrates a range of use cases that involve communicating with [Google Firebase](https://firebase.google.com) on the back end. Feel free to use your copy as a basis for your own Firebase-backed iOS apps.

The rest of this document provides the general flow for getting started with a Firebase-backed SwiftUI app. Although there is a wealth of Firebase iOS documentation out there, not all of it has been updated to the way SwiftUI works due to SwiftUI’s relative newness. This document “translates” what is out there to this platform.

## Create a Firebase Project
For this step, the existing documentation is up to date. Go here and follow the steps for creating a Firebase project: https://firebase.google.com/docs/ios/setup

## Create a SwiftUI Project
Well, for this repository, that has been done 😎 Of course you’ll need to do this if you plan to develop another app.

## Add iOS to the Firebase Project
Continue with the official iOS setup document to set up your Firebase project with iOS: https://firebase.google.com/docs/ios/setup
* We do this _after_ creating the SwiftUI project because this step requires your app’s bundle ID. This also means that ideally, you have figured out your app’s name. Changing this later will require that you update the configuration of your Firebase project and potentially repeating some setup steps
* Although Google Analytics is indicated as a recommended addition, adding analytics involves additional configuration that may get in the way for beginners. If you’re just learning, it’s OK to skip it and add it later
* This step also involves adding a Firebase configuration file, _GoogleService-Info.plist_, to your project. Upon initial download, this file will most likely reside in the _Downloads_ folder of your computer. Make sure to _move this file into your repository folder_ before adding it to the project, to ensure that it remains available if you clone to a different location or machine. Per the Firebase documentation, this file “contains unique, but non-secret identifiers” so it’s fairly safe to commit to your repository

## Add Firebase Packages to Your App
We can go back to the official documentation for this one too. Note that there is more than one way, historically, to add packages to Xcode—however the latest and recommended approach is via [Swift Package Manager](https://github.com/firebase/firebase-ios-sdk/blob/master/SwiftPackageManager.md) so make sure to follow that set of steps: https://firebase.google.com/docs/ios/setup
* At this writing, specify `8.10.0` as the minimum version for the Firebase iOS SDK
* FirebaseUI is _separate_ from the base Firebase iOS SDK; to add it, use this URL: https://github.com/firebase/FirebaseUI-iOS.git —specify `12.1.1` as the minimum version to use

These packages have modules from which to choose; there is no single “right answer” here because this is driven by the needs of a particular app. For _this_ starter app, you need the following:
* _FirebaseAuth_ and _FirebaseFirestore_ from the main Firebase SDK
* _FirebaseAuthUI_ and _FirebaseEmailAuthUI_ from the FirebaseUI SDK

_Note:_ The initial package downloads can take a while so make sure to perform this step in an environment with good, stable Internet connectivity.

## Basic Firebase Configuration
Baseline Firebase configuration is documented on the official startup page, but makes reference to a protocol called [`UIApplicationDelegate`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate) which isn’t part of a SwiftUI project by default. The sample code shows how to set this up, and if you need additional details, you can turn to this [Hacking with Swift page](https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-an-appdelegate-to-a-swiftui-app).

The key line of code here is the successful execution of `FirebaseApp.configure()`—so now would be a good time to _build and run your app_ to make sure it does so successfully with all of this new setup. If it runs without a fuss, then no news is good news! But if you do see errors, make sure to revisit the steps that came before this one to make sure that they were all done correctly.

## Set Up Firebase Authentication
Authentication can be tricky when one is still learning things because it can get deep and messy, but at the same time many apps can’t even _do_ anything unless a user is logged in 😱 Here we will take the approach of “getting it done but in an opinionated way” just so we can get past it, then lay out some pointers for how to make things more customized.

For either approach, you first need to activate the authentication mechanisms that you would like your app to support. For this, visit the _Authentication_ section of your Firebase project’s console to enable your desired sign-in approaches. Once you have done that, pick one of the following approaches to give your app a sign-in user interface. This page provides the general flow for what your options are and how you would proceed with them: https://firebase.google.com/docs/auth/where-to-start

### Using FirebaseUI
Fortunately for beginners, Firebase provides a separate library called [_FirebaseUI_](https://github.com/firebase/firebaseui-ios) which provides pre-built user interface components not only for authentication but for a range of other Firebase features. For now though we focus primarily on its authentication components.

* Make sure to add FirebaseUI to your Xcode project as described earlier
* The official documentation for using FirebaseUI authentication components can be found here: https://firebase.google.com/docs/auth/ios/firebaseui
* However, this documentation has not been updated for SwiftUI (yet). The sample code shows an approach for integrating this into SwiftUI through a combination of an observable object wrapper around the FirebaseUI SDK and a [standard technique](https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit) for [wrapping pre-SwiftUI code into a SwiftUI-ready view](https://www.hackingwithswift.com/books/ios-swiftui/wrapping-a-uiviewcontroller-in-a-swiftui-view)

### BYOUI—Talk to the Firebase Authentication SDK Directly
FirebaseUI is great for getting started with a broad base of sign-in options, but ultimately you may want to customize the sign-in experience fully so that it matches the rest of your app’s design. When you get to this point, you will want to invoke the Firebase Authentication SDK directly. In other words, your code interacts with authentication solely through function calls; the user interface is up to you. Once you’re ready to give this a shot, you can use this link to get you started: https://firebase.google.com/docs/auth/ios/start

Note that going the “BYOUI” route will involve additional setup for certain authentication methods. These are all generally spelled out for you in the Firebase iOS authentication documentation, but they can get pretty involved so it may be best to wait until you are more comfortable with things before trying this out.

## Set Up Firestore
Firestore is one of the available database technologies provided by Firebase. It stores data as _documents_ within _collections_ that you determine. By interacting with the Firebase SDK, your iOS app can create, retrieve, update, or delete (CRUD) these documents to your heart’s content. The official Firestore startup documentation can be found here: https://firebase.google.com/docs/firestore/quickstart Highlights or iOS/SwiftUI specifics are given below.

Activating Firestore on the back end is straightforward: go to the Firebase console, click on the _Firestore Database_ section, and create the database.

Less straightforward is setting up the right security rules for your app. To keep things simple (but perhaps not production-ready), we will start out permissive so that we can focus on just getting data in and out. However, as you get more familiar with Firestore, you will want to learn more about security rules so that, if you get to the point where your app is ready for prime time, you can make sure that its underlying Firestore database will be accessible only to the right parties for the right operations. Here’s a good place to start: https://firebase.google.com/docs/firestore/security/get-started

Once your Firebase project has a Firestore database, you can start invoking the Firestore classes, methods, and functions provided by the Firebase iOS SDK.

## Adding More Dependencies Later
As you start using more and more of Firebase’s functionality, you may find yourself needing package products that you did not originally install when you first added the package. _Add Packages…_ won’t quite work this time because Xcode will say that you have already added that package 😅

To add package products after the package itself has already been added, do the following:
1. Click on the top-level project object in the Xcode tree
2. Under _Targets_ you will see your app (the others will be for test suites)
3. Click on the app target and make sure you are on the _General_ tab
4. Scroll down to the _Frameworks, Libraries, and Embedded Content_ section
5. You should see the list of Firebase products that you have added previously
6. Click the <kbd>+</kbd> button to add more products
7. In the dialog that appears, you should see the Firebase package(s) that you have added before
8. Under the package, click on the product(s) that you’d like to add—<kbd>Shift</kbd>- and <kbd>⌘ Command</kbd>-clicking allows you to select more than one
9. Click on _Add_ to finish up
10. You can also use the <kbd>–</kbd> to remove a library that you no longer need



