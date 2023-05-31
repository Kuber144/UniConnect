# UniConnect
<!-- ![GitHub all releases](https://img.shields.io/github/downloads/Kuber144/UniConnect/total) -->
![GitHub language count](https://img.shields.io/github/languages/count/Kuber144/UniConnect)
![GitHub top language](https://img.shields.io/github/languages/top/Kuber144/UniConnect?color=yellow)
![Bitbucket open issues](https://img.shields.io/bitbucket/issues/Kuber144/UniConnect)
![GitHub forks](https://img.shields.io/github/forks/Kuber144/UniConnect?style=social)
![GitHub Repo stars](https://img.shields.io/github/stars/Kuber144/UniConnect?style=social)
![GitHub Contributers](https://img.shields.io/github/contributors/Kuber144/UniConnect)<br>
#
Created by <br/>
`Rajat Srivastava`<br/>
`Kaushik Mullick`<br/>
`Viraj Jagtap`<br/>
`Kuber Jain`<br/>
`Dhairya Bhadani`<br/>

## Pre-Requisites:
#### For the developers:<br/>
> Flutter Software development Kit (SDK).<br/>
> IDE for development (VS Code, Android Studio, or IntelliJ IDEA).<br/>
> Firebase Connectivity.<br/>
#### For the Users:<br/>
> Android 4.0.3 (Ice Cream Sandwich).<br/>

## Details for Execution:
> Install the .apk file of the application on an android device.<br/>
> On opening the app, the first screen is the login screen, which shows an option to go to the signup screen in case the user does not have an account.<br/>
> Open the signup screen, enter the required details (Email, Username, and password) and click signup. The user must note that the email must belong to the domain of IIITA, as the app is meant for the residents of the Indian Institute of Information Technology, Allahabad only.<br/>
> A mail is sent by firebase authentication to verify the entered email. Go to your inbox, and follow the link to verify the email.<br/>
> After verification, the user is eligible to sign in into the app. On the signup screen, enter email and the password, and sign in to the application.<br/>


## Step By Step Instructions:
Once a user installs the application, they need to sign-up to use the application. For that user needs to provide his desired username, an authentic email of the college domain, and a password. After an account has been created the user can log in to his account whenever required using his email-id and password. Users who have logged in will land on the home page. The home page shows an announcements section at the top of the homepage, in the form of a slideshow of images. <br/>
#### These announcements may include-
Events being held in the college, such as Programming Contests, Hackathons, and other similar events.<br/>
Important announcements, which need to be brought to the attention of the students at short notice. It provides a way to do this without using the formal method of group mailing to all students, which may be considered too formal for certain cases.<br/>

Below the announcements is the section of services where all the services that our application can provide is listed.<br/>
The services include :- <br/>
1) Buy and Sell<br/>
2) Carpool<br/>
3) Food Orders<br/>
4) Lost and Found<br/>
5) Mess Feedback<br/>
6) Share Notes<br/>
7) Home Screen NavBar<br/>
8) Chat<br/>
9) Feedback<br/>
10) Creators Page<br/>
11) Profile Page<br/>
## Buy and Sell:
### Buy Items: 
The Buy Items option shows  the list of all the items that have been listed on the application for sale. Users can search for their desired item and once they find it they can contact the seller to buy the item.<br/>
### List Item : 
If the user wants to sell an item it has to be listed on our application. To upload the details of the item to be sold the list item page has been created. The page provides an option to upload images of the item, describe the item and set an estimated selling price for the item. Once the user has decided upon these things he can list the item on the application by clicking the “List Item” button.<br/>
### My Item : 
This section shows the items that I have listed till date and also provides an option to remove it from the application.<br/>


## Carpool:
Often users need to travel from one location to another ,but do not want to travel alone since it gets costly. To deal with this issue we have added a section of carpool that helps to connect people who are travelling to the same destination on the same day. <br/>

### See Requests : 
The user can see all the car pooling options posted by other users. Once a user finds someone who is travelling to his desired destination, the user can contact the person so that he can request to ride along with the other user.<br/>
### Post Request : 
The user can post as to where he/she is travelling so that others can join as well. To create a post the user needs to fill in the following details - the exact start location, the exact destination, the correct date and time or travel, the mode of transport, and the expected per head charge.<br/>
Once the user has filled in these details he/she can create a post by clicking the “Post” button.<br/>
### My Requests: 
The user can see the requests that he has posted and can also delete the post as and when required.<br/>

The request automatically gets deleted when the date and time of travel has crossed.

## Food Orders:
 The “Food Order” option provides the solution to multiple problems related to food ordering.<br>

### Announcement: 
The announcement page is for posting and viewing offers that the users can avail of on certain orders. The page provides an option to upload their offers. To upload an offer the user needs to fill in the name of the shop which is offering the scheme, the offer link, and the offer description, once the user has uploaded the announcement it will be visible to all other users who can copy the link and use it by long pressing on the announcement post.<br/>
### Bulk Ordering: 
Bulk Ordering provides the facility to order food along with other people so that the overall cost of the order is reduced. One can post what food item a user is willing to order and from which shop. Other people who are interested in ordering the same food from the same shop may join so that they can avail food items.<br/>
### Menu: 
The menu section provides the menu of local restaurants like chillout and Kings. People can go through the menu and can order their desired food from these restaurants by directly calling them via the call feature provided by our application.
## Lost and Found:
The Lost and Found feature of our application allows the users to list items they have lost, or found in and around the campus. This feature can be useful in reducing the incessant mailing done by the parties of both the people, i.e. those who have lost an item, or those who have found one.<br/>
The feature provides the users with three sections, which can be accessed using a bottom navigation bar.
### Lost Items:
This section shows all the items listed to have been lost by the users which they wish to locate.
Each listed post in the section shows the item name, a slideshow of the images uploaded by the use of the lost item and a description of the item.
Users, if they have found the lost item, or have some information regarding it, can contact the user searching for it using the chat feature, or the contact info provided by the user in the description field.
### Found Items:
This section shows all the items listed to have been found by users, who wish to return them to their owners.
Each listed post in the section shows the item name, a slideshow of images uploaded by the founder, and a description of the lost item to help the user search for it.
If a person, who has lost an item finds a post listed for the item they lost in the found section, they can contact the founder using the chat feature, or the contact info given in the description section of the post.
### My Posts:
This Section shows a list of all the posts created by the currently logged in user, which are not otherwise visible in the other two sections.
All the same details are displayed in the posts, i.e. the item name, the pictures, and the description section, along with an additional section to specify the type of the post, lost or found. 
This section can be used by the users to delete their posts from the previous two sections, if the issue of the said lost or found item has been resolved.

## Mess Feedback:
The Mess Feedback section of this application can be used to give feedback for the meals provided during all the three phases of the day, breakfast, lunch and dinner, and can also be used to view the mess menu of their corresponding hostel. To use this feature, a user is required to complete the profile section of their account, and specify the name of their current hostel.
The main screen of this feature is divided in two sections:
### Mess menu: 
This section is present at the top of the main screen, and shows the current menu of the hostel which the user has selected as their residence.
### Mess Feedback:
The feedback section allows the user to post their feedback about the meal served in the current phase.
Each day is divided into three phases, breakfast, lunch and dinner. Users can post feedback for each phase, and read the opinion of other users of the same hostel about the food being provided.
All the feedback belonging to the current phase is automatically deleted after the phase is over.
This section can be useful to obtain the opinion of students regarding the quality of the food being provided, and the points of improvement which need to be taken care of. This feature can be particularly useful for the mess committee members of each hostel to look after the needs and demands of the students.

## Notes Sharing:
This notes sharing feature of this application allows the users to share class notes in pdf file format and other study material to other students. Students can upload their class notes on the app, with specifications about the course and semester of the notes. These uploaded notes can be displayed by the users using an inbuilt pdf viewer, and can also be downloaded using the provided download button. Furthermore, the users can filter the available notes using semester and course information provided by the uploader to narrow down the content according to their requirement.
### Main Screen: 
The main screen of this feature shows all the notes available in the database of the app by default, and on the top of the screen, the filter option is provided. The user can use a floating action button on the main screen to open the upload notes page. 
### Upload Notes Page: 
On the upload notes page, the user can specify the course, and the semester of the notes file, and then select a pdf file from the local directories of their mobile phone device to upload. The upload button is then used to upload the notes file to the database.

## Home Screen NavBar
The NavBar of the application can be accessed by the user by clicking the hamburger menu icon on the left hand side upper corner, or app logo on the right hand side upper corner of the home screen. This NavBar provides the users with some additional features, which are necessary for providing the facilities offered by the application or are plainly for the general convenience of the users. 
These options are as follows:
## Profile: 
The profile button opens the profile page of the user, in which their details are displayed. By default, the username of the user and their college email id are displayed on the user profile page, but an option is provided on the bottom of the page to add other details in the profile. These details include:
### About me: 
A section where users can regularly update their general thoughts and feelings, or can simply introduce themselves to other users by making a short entry.
### Contact Number: 
The contact number of the user, which is verified by a one time password. This can be used by other users to contact, in case it is required for buy and sell, lost and found, food ordering or any other requirement.
### Hostel: 
The hostel specification, which is necessary for giving the mess feedback for the mess corresponding to the user’s residence.
### Pursuing course: 
General info about the user’s degree specification.
### Graduation year: 
General info about the user’s graduation year.<br>

##### The profile page of each user can be accessed by other users to view their info, if the user has created any post on the buy and sell, lost and found, or the food ordering sections.
#### Chat: 
The chat button opens the chat section for the user, which has been explained in detail in a later section of this document.
#### Share: 
The share option lets the users share the app with others using medium such as whatsapp, facebook, mail, telegram and other messenger apps.
#### Feedback: 
The feedback option allows the user to submit a google form regarding their experience of using the app, which can be viewed by the developers.
#### Request a feature:
The users can submit a form to request the developers any feature, or explain any possible concept of a feature  they have, which they find suitable for the premise that the app is based on, and would like to have on the next version of the app.
#### Report a bug: 
The feature enables the user to submit a complaint or a bug report regarding any of the features of the app.
#### Logout and exit: 
Users can logout from their profile, or exit the app respectively using these buttons. 

## Chat
The application provides a chat feature that will help the users to interact among themselves whether it be for food ordering purpose or for buying and selling items or just for fun. 
The chat feature has the functionality of searching the user to whom we desire to chat by their username. Once a user finds the person to whom he/she is willing to chat. The user can send messages that will be updated at real time for both the users providing a seamless chatting experience.
The chat feature has been used in buy and sell to make an interested buyer interact with a seller.
The chat has also been used in the carpool so that people who are willing to travel together can interact among themselves.
The bulk food ordering facility also provides chatting facilities so that people can discuss what to order and from where to order.
LnF uses the chat facility to create a link between the people who have lost their items and who have found them.

## Feedback
The user has a provision to give their experience regarding the application. Besides feedback, the user can also suggest improvements in the application which we may include in the upcoming version of the software. The user can also specifically suggest improvements in a particular feature of the app(Like carpooling, buy-sell, etc). The feedback feature has been implemented by incorporating a Google form in our application.

## Creators Page
The creators page lists the name of all the creators of the application along with their social media links.

## Profile Page
The profile page displays all the available information of the users which can be edited. The details on the user profile include Name, Email, About Me, Contact Number, Hostel Number, Graduation Year, and Profile Picture.
All of this information is modifiable while changing the Email id requires verification.
