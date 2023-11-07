# working notes (from lindsay)
### 11/07/23
    oops ive been slacking on updating this my bad
    working on:
    rewriting everything in perl
    
    notes:
    so much faster !!!
    currently reimplementing functions one-by-one
    havent really thought about parsing in inputs, i read something about a .pm perl module?? not sure 
    
### 08/12/23
    working on:
    adding unit tests
    
    notes:
    "semester" flag updated to "academic"
    added/renamed output columns
    removed indicies from output for clarity

### 08/01/23
    working on:
    user interface: error messages for invalid inputs
    if they put in multiple tags, return the first tag and make a note that the secondary tag is ignored
    for -u: change column names, instead of NaN j return blank
    for -p: get rid of group column, add new column that is blank except to indicate who is lpi/admin contact, indicate whether or not it is academic, display allocation

### 07/23/23
    notes:
    updated semester to properly return all currently active course projects

### 07/20/23:
    notes:
    turned script into an executable
    four available flags
        -project, user login, semester, pi login
    each flag corresponds to one output, multiple inputs return individual outputs for each flag

    questions:
    what input to take for semester, boolean maybe
    can i move the csv files into a folder without messing up paths where i access them
    what happens when the db updates?
        - is there some way to avoid manually update the csv files

### 07/11/23:
    notes:
    using pandas to filter through the csv files:
    using argparse to take inputs
    currently parsing copied versions of the csv files, so they wont update

    questions:
    turning script into executable
    fix prefixes, come up w better names?

## questions:

- what exactly is in each csv:
- how can i tell if someone is a admin contact (no in the PI csv?)
- not sure how to turn this into an accessible tool

## discussion:
Header of `/projectnb/rcsmetrics/pidb/data/pidb.csv`:

- "group" - a name of the SCC project
- "title" - project title
- "pi" - Official name of the Project Investigator
- "login" - PI's login name
- "email"
- "dept"
- "center"
- "college"
- "campus"
- "date"
- "start"
- "end"
- "type",
- "academic",
- "coursehistory"
- "status" - status of the project  ( summary on this )
- "aname" - administrative contact
- "alogin" - administrative contact login
- "dataarchive"
- "quota" - this might be useful
- "allocation" - this might be useful
- "last_approved_allocation"
- "duorequired"

