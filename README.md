# NanoCMS

### What is NanoCMS:
Piliot is a very simple .application that can read and edit SQLite database files (.db) in a wizard like dialog

### How it works:
1. You drag and drop a .db file onto the app and then you select the action you want to perform on the .db file. (create, read, update or delete)
2. Then you are taken to through a series of selection and user input dialogs.
3. When the action you wanted to perform is complete you are taken back to subsequent menu dialog boxes.
4. You can always move back and forward in the menus with OK and BACK buttons

### How to:
- It will open the last opened .db file, if there is no previous opened .db file or if it doesnt exist anymore then the user will be promted with the options to create a new database file .db or select a pre-existing .db file with a file browser window.
- You can also drag and drop a .db file on to the NanoCMS.app icon and then this database will be opened

### Why applescript:
The choice to use AppleScript as the primary app language was so that the app could be edited by other users very easily. AppleScript requires no requists to learn and is installed on every mac since 1995, Also the means to code in applescript is provided on all Mac´s that you can lay your hands on. So its very accessable and very easy to learn. And requires no external libraries, frequent updates etc. A kid can easily pick up Applscript durning a weekend.

### How can users edit the app:
All libraries used in the NanoCMS app, mainly SQLite libs, String manipulation libs, List and Number libs are contained within the app. If you want to edit the app you will have to download these .scpt files and add theme to you local user script folder in your user folder user/scripts/folder with NanoCMS scpt files

### Opensource (copyrights)
The app is completly free to use and edit as you wish, the only restriction that exists is that you cant sell or distribute the app and its libraries as your own. You may distribute the app withouth profits to other users if its heavily marked and references the Original Auther. Contact me directly for guidelines on this. The .db files it creates is your own and you can do what you wish with.

### Why use NanoCMS when you can use well known CMS systems?
The motivation behind NanoCMS was to make an app that could edit SQLite .db files for websites as well as small database files for simple things like a foosball table score app where you would only need a few tables and a few column and rows. And where you wouldnt need a huge CMS system to mange and create that database. Advance CMS editors can be daunting for even experinced users. The beauty of SQLite is that its that its very simple and selfcontained. and you cant really do so much damage if you make a mistake, just make a copy of your .db file and restore it if the database starts to act funny. The bottom line is that you can manage your own php website and try out quick prototypes of databases with NanoCMS. The second motivation was that you can derive SQLite lib .scpt files from the app and make Custom CMS systems for small apps or however you want to edit your PHP website. Try using an advance CMS system for a simple but obscure case, you cant. NanoCMS can because its so easy to edit the app it self.

Website: [eonist.github.io/NanoCMS](http://eonist.github.io/NanoCMS/)
