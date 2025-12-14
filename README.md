Bash Mini Database Management System (DBMS)

This project is a simple **Database Management System implemented in Bash scripting**.  
It simulates basic database operations using directories and files, providing an interactive command-line interface.

🚀 Features
- Create and drop databases
- List existing databases
- Connect to a database
- Create and drop tables
- Define table schema (column name + data type)
- Insert, select, update, and delete records
- Data stored using plain text files
- Colored and user-friendly CLI menus

🛠️ Technologies Used
- Bash scripting
- Linux file system (directories & files)

📂 Project Structure
.
├── DBMS Bash Scripting Project.sh                 # Main Bash DBMS script
└── Databases/              # Root directory for all databases (auto-created)
    ├── Database1/          # A database (directory)
    │   ├── table1          # Table file
    │   └── table2
    ├── Database2/
    │   └── users

📄 Table File Structure
Each table is stored as a plain text file:
id:int,name:string,age:int        ← Schema (first line)
1,Ahmed,25
2,Sara,30

First line → table schema (column name + data type)
Next lines → table records
Columns are separated by commas ,

▶️ How to Run
1. Give execution permission:
   ```bash
   chmod +x DBMS Bash Scripting Project.sh

2. Run the script:
./DBMS Bash Scripting Project.sh

📋 Notes
Table schemas are stored in the first line of each table file.
Supported data types: int, string
Database and table names must not contain spaces or special characters.

🎯 Purpose
This project is designed for learning and practicing:
Bash scripting
File handling
Menu-driven CLI applications
Basic DBMS concepts
