FDSAddPhotoButton
=================

A simple iOS Add Photo button, modeled after the photo in the Contacts app.  

The button either displays "add photo", with a dotted line border, or shows the photo in a shadowed photo frame with an edit label.  A delegate callback informs the client app when the user either adds or removes a photo.

To use:

* Add the .m and .h files to your project.
* Drop a button in Interface Builder.  Set the class to FDSAddPhotoButton, and the size to roughly square (64 points sqaure is a good size).
* Set the parentViewController and addPhotoDelegate properties, either in Interface Builder or in code.

Limitations:

* Doesn't let the user move or crop the photo.
* Doesn't let the user take a photo; they must select a photo from their camera roll.


