# What This Project Is
This is a _research_ project, in which I researched how to use Cloudmine in an application. This was my first work done with the SDK, and as such, some things I learned near the end of the project were not applied throughout.

This iPad app (and just iPad), shows some of what the Cloudmine SDK can handle. It deals with the client side of Cloudmine, and does not delve too deeply into the server side component. There was more than enough to work with for a less than 20 hour project.

## What Did I Build?
The app is tentatively called Inspiration, and was sort of meant for a way to gather pieces of inspiration in one place. More robust than Apple's photo stream, with the ability to save Images, Text, Links, Videos, Websites, anything that _inspires_ you.

This application does not do all of that - that would require much more than 15ish hours. This app handles two different types of content, text and images. It displays these in a stream, using UICollectionView in iOS 6. The user can add new content to the stream. The user can also sign in and view their own stream.

All of hosting of objects and such is using Cloudmine on the backend.

## A Brief Tour of Inspiration

Upon launching the app, you are presented with the app Stream. The stream pulls down text and images from Cloudmine. This is the "Global Stream". The user can do 4 things from this page.

1: Add some text. The bottom left button "+" pop ups an ability to add text. More options can be included in the future here, such as searching the web for snippets. To user taps the "+", then selects the option to add text.  Typing in the text will add it, and upon the view disappearing the text will be saved to cloudmine.

2: Add an image. Using the picture button in the bottom left adds an image to the Stream.

3: Tap an object in the stream. The object can be tapped and it will come into full view. From here, the user can cancel, or save.  Saving the image adds it to the user's stream.

4: Open the profile view by clicking the person in the top right. This allows the user to log in or create an account. After having an account, the user can view their stream. This is their own personal stream.

If you add content from the global stream view, you add it to both the global stream and your personal view (if logged in).  If you add content from your personal stream, it only is added to your personal stream.

## A look at the Code



# The Cloudmine SDK

## What I liked

## What I didn't like

## What I wanted to see

# Last Thoughts



# What I liked

Adding file from data is excellent <3

# What I wanted to see
File issues. I can't store the meta data with the files, so I need to have another object to use with the file. Annoying.

Class Documentation on all the objects in the SDK. Found it (better link?)

Users should/can/maybe store username/password, and not just the token?
(TEST THIS AGAIN)



Caching & Syncing would be hard... but amazing. (Core data integration?)

Not sure what the extra options do. Maybe solves my problems like getting batches?

Not being able to save to global level and user level with the same object doesn't make a ton of sense, at the very least it should just make a new object in the background.

At one point, all of my data was deleted? Not sure how.

Not sure why the "UserData" option on the dashboard was greyed out - I had users. Oh, I had to log in first. That's not clear in the dashboard UI - you should change that so if I click on the User Data, it asks me to login as a user to access their data.

Had some trouble a couple times connecting to the server, not sure why.

Unique Name for files. The documentation says "The unique name of the file to download.". It looks like it needs to be unique.  Remove NSData if it's making things confusing with files.



Please pardon the UI.  View can jerk while loading, images can't be zoomed in, and it looks pretty ugly throughout. That was not the purpose.

Pardon bugs found.

Performace. Images, redownloading, no caching. Ran the profiler.