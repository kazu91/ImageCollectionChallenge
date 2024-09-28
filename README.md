# Image Collection App

## Overview
This application is designed to display a collection of images fetched from a remote source.

## Features
- Displays a grid of images in a 7x10 layout with a 2pt spacing between images.
- Supports horizontal pagination.
- Includes buttons for adding a new image and reloading all images.
- Implements image caching to optimize performance.
- Displays a loading spinner while images are being fetched.


## Usage

 - Press the "+" button to add a new image to the collection.
 - Press the "Reload All" button to remove existing images and load 140 new images.

## API

- Images are fetched from LoremFlickr.

## Performance Optimizations

- Images are cached to reduce redundant network requests and improve scrolling performance.
- Implements activity indicators in cells to show a loading state while images are being downloaded.

## Acknowledgements

- LoremFlickr for the image service.
- Apple Developer Documentation for iOS guidelines and best practices.
