# July 11, 2023

## working notes (from lindsay)

### current status:

using pandas to filter through the csv files:
using argparse to take inputs
currently parsing copied versions of the csv files, so they wont update
i am able to pip install . the package, but im getting this error:
    WARNING: The script function is installed in '/usr4/ugrad/tinglliu/.local/bin' which is not on PATH.
    Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
not sure how to fix this, and i think part of the issue is because i am working on scc?

### questions:

- what exactly is in each csv:
- how can i tell if someone is a admin contact (no in the PI csv?)
- not sure how to turn this into an accessible tool

### discussion:
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

