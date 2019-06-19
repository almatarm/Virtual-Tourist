# Virtual-Tourist
 This app allows users specify travel locations around the world, and create virtual photo albums for each location. The locations and photo albums will be stored in Core Data.

## Installation
The app does not have any special requirments to run. Just make sure to obtain your API Key and Secret from Flickr and insert into FlickrClient.swift

## Map Screen
The app starts by presenting a map. The map location and zoom level are persisted between runs.

The user can pick a location of interest by tapping and holding on that location. A red pin will show on that location. By tapping the pin, the app will navigate to the album associated with that pin.	 

<img src="https://raw.githubusercontent.com/almatarm/Virtual-Tourist/master/snapshots/Map.png" alt="Map Screen" style="width:250px;"/>


## Photo Album Screen
If the pin does not have photos, e.g. a new pin, then an option will be given to the user to navigate to the **Photos Picker Screen** where he/she can select images to be saved 

* Choosing Yes will take the user to the Photos Picker Page.
* Choosing No will keep the user in the Photo Album Page.	 

<img src="https://raw.githubusercontent.com/almatarm/Virtual-Tourist/master/snapshots/ShouldGetPhotos.png" alt="Should Get Photos" style="width:250px;"/>


## Photo Picker Page Screen
In this screen, the user is presented with a set of images associated with the location of the selected pin.

At the center of the buttom toolbar, the current page and the total number of photo pages are presented. PREVIOUS and NEXT buttons are there to help in navigating between pages.

The user can tap on the image thumbnail to open it in **Photo Detail Screen**.	 

<img src="https://raw.githubusercontent.com/almatarm/Virtual-Tourist/master/snapshots/PhotoPicker.png" alt="Photo Picker" style="width:250px;"/>


## Photo Detail Screen
In this screen the user can view an enlarge image of the selected thumbnail. He or she can then save or delete the enlarged image to local storage.

The Save and Delete button on the buttom toolbar will be enabled or disabled based whether the image is already saved or not. 

<img src="https://raw.githubusercontent.com/almatarm/Virtual-Tourist/master/snapshots/PhotoDetails.png" alt="Photo  Details" style="width:250px;"/>


In **Photo Album Screen**, If the selected pin has saved photo, they will be shown in a grid. 

If the user taps in a saved photo, it will take him to **Photo Detail** Screen where he can view and delete the photo.

On the same screen user can delete the current pin or obtain new photo by tapping on **Get Photos**

<img src="https://raw.githubusercontent.com/almatarm/Virtual-Tourist/master/snapshots/SavedPhoto.png" alt="Saved Photos" style="width:250px;"/>

	
	


 
