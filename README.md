GestureExample
==============

This is a demo application that I use to accompany my iOS Gesture Recognizers Intro talk. It lets us walk through how they work and compete for touches.

## How It Works

All the magic happens in `CMNDisplayViewController`. Each of the recognizers are set up in the method `setupGestureRecognizers` and added to the main table view. Each recognizer is also observed with KVO so that the state changes can be updated with `printStateChangeOfGestureRecognizer:`.

I demonstrate using custom gesture recognizers for tracking touches, a bezel swipe, and the `PRNCircleGestureRecognizer` from the iOS Recipies book by Paul Warren and Matt Drance.

## Contact

Questions? Ask!

Jonathan Penn

- http://cocoamanifest.net
- http://github.com/jonathanpenn
- http://twitter.com/jonathanpenn
- http://alpha.app.net/jonathanpenn
- jonathan@cocoamanifest.net

## License

GestureExample is available under the MIT license. See the LICENSE file for more info.

PRNCircleGestureRecognizer is Copyright 2010 Primitive Dog Software.
