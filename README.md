# Updated for macOS 14.0 Sonoma

Apple fixed the microphone api bug. MicroMute has been updated to fully work on macOS 14.0 Sonoma.


# MicroMute

Sets a global shortcut (CMD + option + M) to mute or unmute the system microphone on macOS, which works while your app to be muted is out of focus. 

App specific keyboard shortcuts to mute only work while the app is in focus. If you work with multiple displays and want to do something else while in a video call, e. g. take notes in another app, you cannot mute or unmute yourself with the video chat app's keyboard shortcut.

Should work with any Video Chat software like Microsoft Teams, Skype, FaceTime, Slack, Zoom, Webex etc.
Heavily inspired by Pixel Point's [Mute Me](https://github.com/pixel-point/mute-me).


# Minimum Requirements
- Dependency Manager: [Cocoa Pods] (http://cocoapods.org)
- macOS 10.14
- Swift 5
- Xcode 11.2.1


# Development
Always use MicroMute.xcworkspace for this project. Within the project directory:

- install dependencies with `pod install`
- update dependencies with `pod update`


# License
MIT License

Copyright 2023 Hua Duong Tran

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Support
If this project makes your work from home easier, a donation of any amount is appreciated :-)

<a href="https://www.paypal.com/donate?hosted_button_id=CKAK6UZFJ5ULU">
  <img style="width:200px;" src="https://raw.githubusercontent.com/stefan-niedermann/paypal-donate-button/master/paypal-donate-button.png" alt="Donate with PayPal" />
</a>
