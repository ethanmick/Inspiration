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

The code is broken down into a pretty self explanatory way, grouped together in modules of similar functionality.  All the models are kept in the Model folder. These are a hierarchy, as many actions will need to be taken on a StreamItem in general.

The rest of the code is basically the views and controllers.  The entire view setup is in the Stream.storyboard file.  The StreamViewController is the main controller which handles the stream, and the actions to leave or respond to events in the stream.

Two things I will say about the code. 1, I did not focus on the UI heavily. The UI is an amazing aspect of the program to work on, but I was focused on learning and using the Cloudmine SDK and see what neat features it supported. The UI is simply a portal to these parts of the code. Secondly, the pictures used are not optimized. I should use smaller scaled images for the Collection View, and then when they load the picture when they select it, I should load the full image (and add pinch to zoom).  However, I decided these were outside the scope of the project. If you do load too many large images, the app eventually runs out of memory and crashes. I ran the profiler to examine issues, but fixing them was outside the scope.

Please Pardon any bugs you find :)

# The Cloudmine SDK

## What I liked
I loved adding data by just sending the *saveFileWithData* method. It was extremely convenient when adding data and not having to save actual files.

I love the flexibility of the SDK. The saving and loading of objects, for the most part, was extremely straightforward and easy. Didn't matter where in the code it was, and was consistant throughout.

Blocks for callbacks are amazing.

Examples on Cloudmine are super helpful, definitely expand on those.

## What I didn't like

Not sure if I can store extra info with a file? Probably not with the "saveFileWithData" method, but perhaps by sending CMFile's (see Last Thoughts below).

When I saved an object to the Global level, I tried saving the same object to the User level, but Cloudmine didn't like that. I had to create a new object to save to the User. I feel like that should be handled on the server side. Saving the same object in both places should simply work, perhaps make a new object on the server side.

At one point, all of the objects on the server were deleted. I'm not sure how, considering my code does not include any delete calls.

A couple of times I have trouble connecting to the Cloudmine server, not sure why.

## What I wanted to see

I was thinking of using Cloudmine in a previous project, but already had a Core Data structure set up. It would be *amazing* to see the CM SDK interface with Core Data objects. Along the same thought, if Cloudmine also cached objects so they don't need to be redownloaded between app closes (complete shutdowns).

Perhaps use the Security Framework to store usernames and passwords (but just store the token normally). This would enable the framework to securely store the info.

The "User Data" option in the dashboard is greyed out until a user logs in, took me a bit to figure this out. Perhaps if you click user data it prompts you to log in as a user.

# Last Thoughts

I might have been able to use CMFile for storing information with files - what I do now is store information about the Images (there could be extra information in the future), in a separate StreamPicture object. None of the examples showed using CMFile, so I wasn't aware of it until later in the project.

I found the Class Documentation after a bit of hunting around. Under the iOS Library, I would have loved a link in the sidebar to go straight to the class documentation. Also, some methods are not documented.

I'm not sure if files need a unique name or not. It looks like it does... "The name to give the file on CloudMine. This must be unique throughout all instances of your app." But Paul Solt told me that Marc said it didn't need to be. Or something like that. So I created names, but then had to save them in a different object.

## Thanks!

This was a great opportunity to go through and learn the Cloudmine SDK, as well as work on a project for a bit. I really enjoy iOS development, and enjoy the possibility of working at Cloudmine. Regardless, thank you so much!