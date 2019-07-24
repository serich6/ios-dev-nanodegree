# Trivia!

Welcome to the Trivia! app, my final project for Udacity's iOS Developer Nano-Degree Program. This app is a simple quiz app that utilizes OpenDB for trivia information, and stores your scores and other metrics to keep track of what you need to study in order to crush your next Pub Trivia night!

OpenDB trivia API can be found [here.](https://opentdb.com/api_config.php)


# How to Run

## Setup XCode
1. Install and run Xcode (version 10.X or higher)
2. Ensure Swift v 4 or higher installed
3. Open the Trivia.xcodeproj in Xcode
4. Select the Trivia scheme next to the play button.
5. Select the device to build on (any device will do, but this was developed with iPhones in mind)
6. Press the play button to build on the selected device.

# App Behavoir

## Play a Game

When the app is launched, you will be taken to a home screen with two buttons. Select **Play** to start a game. Then select any **category** from the list in order to start a round (5 questions each). At any time you can exit the round of trivia by tapping the **Exit** button at the bottom of the screen. At the end of the game, you'll get to see how you did with a screen showing your score for that game.

## View your Stats

From the initial/launch page with the Trivia! logo, press the **My Stats** button. You'll be taken to the stats page and be able to see all of the categories that you have accessed, if not played questions from. You'll also be provided with your best and worst category metrics called out at the top of the page. 

## Review your Weak Spots

From the Stats page, you can review the questions in each category that you have previously played (no cheating!). Tap on the **name of a category** in the table to view the detail. Selecting one the question will bring up the question text, your response, and the correct response for you to review. 

## Game Settings
From the home/landing page, select the **gear icon** in the top right hand corner of the screen. This will take you to the **Game Settings** screen. From here, you can adjust the **Question Difficulty** level to your liking. You can also toggle on or off the **types of questions** you'd like to be given. 

**Note:** Disabling both question types isn't possible, and you'll get a notification to turn one or the other back on!


# Project Requirements

## UserDefaults
The application user UserDefaults to store the information from the Game Settings screen UI. This information is later accessed in the OpenDBClient.swift file in order to modify the API call to get the correct type of questions.



# Core Data
I've used Core Data to store the categories that a player has access, and their associated questions in order to populate the user statistics. The OpenDB API didn't have endpoints for doing any data modification or user interaction that would satisfy this flow, so I settled on storing that information locally.
