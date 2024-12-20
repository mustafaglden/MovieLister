# MovieLister

**MovieLister** This is a simple **iOS Movie Listing Application** built using UIKit. The app fetches and displays popular movies, supports a detailed movie view, and includes features such as search, favorites, and backend image upload.

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)

## Project Overview
LearnConnect is built with a focus on providing a seamless experience for users looking to explore and interact with courses. Users can browse courses, enroll in them, and view details, including videos and feedback from others. Additionally, users can leave feedback, rate courses, and manage their course enrollments through a personalized profile page.

## Features
### 1. **Movie List and Detail Page**
- **Movie List**:
  - Displays popular movies fetched from The Movie Database (TMDB) API.
  - Supports "load more" functionality to fetch additional pages.
- **Movie Detail**:
  - Contains movie poster, name, description, vote count, and a star button for favorites.

### 2. **Optional Features**
- **Display Mode Switch**:  
  Switch between **List View** and **Grid View** for movie display.

### 3. **Search Functionality**:  
- Search for movies within the fetched data using the search bar.

### 3. **Favorites List**
- Mark movies as favorites using the star button.
- A star icon is shown for favorite movies on the movie list page.
- Favorites are stored locally on the device.

### 4. **Image Upload**
- Clicking the star button on the detail page triggers an image upload to the backend.
- A loading indicator is displayed during the upload.
- Images are resized to a minimum of 600px for each dimension and converted to Base64 format before upload.

## Technologies Used
- **Programming Language**: Swift
- **Development Environment**: Xcode
- **Architecture**: MVVM
- **Framework**: UIKit
- **Core Data**: Used for data persistence and managing Movie data.

## Installation
To run this project locally, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/mustafaglden/MovieLister.git
2. **Open the project on xcode**
3. **Build and run the project**
