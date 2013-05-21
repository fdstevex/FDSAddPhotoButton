FDSAddPhotoButton
=================

A simple iOS Add Photo button, modeled after the photo in the Contacts app.  

The button either displays "add photo", with a dotted line border, or shows the photo in a shadowed photo frame with an edit label.  The user can choose a photo from their device, or use the camera to take a photo.  A delegate callback informs the client app when the user either adds or removes a photo.

![Add Photo](/screenshots/addphoto.png "Add Photo")
![Edit Photo](/screenshots/editphoto.png "Edit Photo")

To use:

* Add the .m and .h files to your project.
* Drop a button in Interface Builder.  Set the class to FDSAddPhotoButton, and the size to roughly square (64 points sqaure is a good size).
* Set the title label for the button to the text you'd like to use (typically, "add photo", but with a newline in between those two words - hold alt and tap Enter while editing to insert the newline).
* Set the parentViewController and addPhotoDelegate properties, either in Interface Builder or in code.
* Respond to the delegate method to handle the user selecting a photo.

Limitations:

* Doesn't let the user move or crop the photo.

Note that if your iPad application runs in Landscape mode, you will run into a crash when the user attempts to view the photo library.  One workaround is described here:

http://stackoverflow.com/questions/12522491/crash-on-presenting-uiimagepickercontroller-under-ios-6-0

