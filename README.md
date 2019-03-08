# Find That Park App
### National Parks Service Data in the Command Line

## Description
Find That Park (FTP) is a command line app that allows users to find national parks from across the United States and keep track of their favorites. This app is a collaborative project by Logan Wohlers and Ellen Hatleberg done as part of the Flatiron School's first module as a chance to practice working with API's and Databases. From the Command Line Interface (CLI), a user can search parks by name, state and park category type to learn about the nearly 500 parks managed by the U.S. National Parks Service. A user can also create a new account, see their favorite parks, add a park to their favorites and delete a park from that list. FTP utilizes data from the [National Parks Service API](https://www.nps.gov/subjects/developer/index.htm).

See the following for a video demonstration of the program: https://www.youtube.com/watch?v=6SeHEGRNTlY&feature=youtu.be
​
The FTP App accesses a Sqlite3 Database using ActiveRecord. It implements CRUD (create, read, update, delete) actions and utilizes 5 models, which include User, Favorites, Park, State, and StatePark.
​
## Install Instructions
To download, set up and run Find That Park, follow these steps:
​
### Download Ruby and Rails
From [Rails Installer](http://railsinstaller.org/en), download Ruby and Rails.
​
###Get an NPS API Key
Get a personal API key from the National Parks Service by clicking [here](https://www.nps.gov/subjects/developer/get-started.htm).
​
### Download the App
From the Command Line, download FTP App by typing the following:
​
git clone git@github.com:loganwohlers/module-one-final-project-guidelines-seattle-web-career-021819.git
cd module-one-final-project-guidelines-seattle-web-career-021819.git
​
### Add your personal NPS API Key to the App
This is an important step, the app will NOT run without your API key being added. Your API key will be kept in a secrets.yaml file for security purposes and to follow best practices.
1. Create a new file in the config folder called secrets.yml (Yes, the file must have this name.)
2. Open secrets.ymlexample (also in the config folder) and copy the contents of this file into secrets.yml.
3. In secrets.yml, replace INSERT_YOUR_API_KEY_HERE with your new API key
4. Save
​
### Run the App in the Command Line
Returning to the command line, make sure you are still in the App's directory folder then enter the following:
​
bundle install
rake db:seed
ruby bin/run.rb
​
### User Stories
The following user stories guide how the user will interact with the Project.
​
As a user without an account, I want to:
* enter a park name and see details about that park
* enter a state then see a list of parks that are located within it, select a park and see it's details
* enter a park category and see a list of parks from that category
* request a random park and see details about a new park
​
As a user with an account, I want to:
* access all park information that a user without an account can access
* enter my name to see a list of my favorite parks
* find a park that I like and add it to my favorites
* remove a park from my favorites
​
## Contributors Guide
If you are interested in making a contribution to this project, let us start by saying thank you. As learners, interested in improving our code, we appreciate your feedback.
​
Ways to contribute:
* Reporting Bugs
* Suggesting Enhancements
​
## License
To view the license, click [here](https://github.com/loganwohlers/module-one-final-project-guidelines-seattle-web-career-021819/blob/master/LICENSE.md).

