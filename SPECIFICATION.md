  # Core Data #

## Does the app use a managed object model created in the Xcode model editor? ##
~~The app uses a managed object model created in the Xcode Model Editor. A .xcdatamodeld model file is present.~~

## Does the object contain two entities: Pin and Photo? ##
~~The object model contains both Pin and Photo entities.~~

## Does the object model contain a one-to-many relationship between the Pin and Photo entities, with an appropriate inverse? ##
~~The object model contains a one-to-many relationship between the Pin and Photo entities, with an appropriate inverse.~~

# Travel Locations Map View #
## Does the app contain a map view that allows users to drop pins with a touch and hold gesture? ##
~~The app contains a map view that allows users to drop pins with a touch and hold gesture.~~

## Does the app transition to the Photo Album view when an existing pin is tapped? ##
~~When a pin is tapped, the app transitions to the photo album associated with the pin.~~

## When pins are dropped on the map, are they persisted as Pin instances in Core Data? ##
~~When pins are dropped on the map, the pins are persisted as Pin instances in Core Data and the context is saved.~~

# Photo Album View #
##  When a photo album view is opened for a pin that does not yet have any photos, does it begin to download images from Flickr? ##
~~When a Photo Album View is opened for a pin that does not yet have any photos, it initiates a download from Flickr.~~

## Is the code for downloading images from Flickr encapsulated into a class? ##
~~The code for downloading photos is in its own class, separate from the PhotoAlbumViewController.~~

## Are images shown with placeholders in a collection view while they download, and displayed as soon as possible? ##
~~Images display as they are downloaded. They are shown with placeholders in a collection view while they download, and displayed as soon as possible.~~

## Are images stored as Binary Type in the Photo entity with the “Allows External Storage” option active? ##
~~The specifics of storing an image is left to Core Data by activating the “Allows External Storage” option.~~

## Once all images have been downloaded, can the user remove photos from the album by tapping the image in the collection view? ##
Once all images have been downloaded, the user can remove photos from the album by tapping the image in the collection view. Tapping the image removes it from the photo album, the booth in the collection view, and Core Data.

## Does the Photo Album view have a button that allows the user to replace the images in a photo album with a new set of images downloaded from Flickr? ##
The Photo Album view has a button that initiates the download of a new album, replacing the images in the photo album with a new set from Flickr. The new set should contain different images (if available) from the ones previously displayed. One way this can be achieved is by specifying a random value for the page parameter when making the request.

## If the Photo Album view is opened for a pin that already has photos, are they immediately displayed? ##
~~If the Photo Album view is opened for a pin that previously had photos assigned, they are immediately displayed. No new download is needed.~~