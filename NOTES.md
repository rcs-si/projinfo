# working notes (from lindsay)
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

