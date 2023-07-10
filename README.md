# projinfo
A command-line tool that allows a quick info about the project


## email from Charlie

Hi Katia,

Idea for a student intern project for someone learning python.

A command line utility that returns `PI.db` information in a way that is useful for me and Apps Team members. SS&O has a perl utility called “listpi” on acct that does this by parsing `PI.db` directly, but it is not available outside of acct and a is little limited in application. It may be worth asking Apps what types of queries they would like to see.

This utility would basically parse two csvs:

    A CSV version of PI.db is available here: `/projectnb/rcsmetrics/pidb/data/pidb.csv`
    A CSV of project-user membership is here: `/projectnb/rcsmetrics/pidb/data/proj-users.csv`
    I could do more by incorporating quota information, `buyin.db` and `storage.db`, but lets start simple.

And perform basic queries for common questions like:

    Print the LPI and Admin Contact information for projectname Project
    List the projects for which LPI is either the LPI or Admin Contact
    List the projects for which any-username is a member of and that LPI.
    List the academic projects for this semester
    Anything else the Apps Team wants.

## working notes (from lindsay)
current status:

    using pandas to filter through the csv files:
    using argparse to take inputs
    currently parsing copied versions of the csv files, so they wont update
    i am able to pip install . the package, but im getting this error:
        WARNING: The script function is installed in '/usr4/ugrad/tinglliu/.local/bin' which is not on PATH.
        Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
    not sure how to fix this, and i think part of the issue is because i am working on scc?

questions:

    what exactly is in each csv:
    how can i tell if someone is a admin contact (no in the PI csv?)
    not sure how to turn this into an accessible tool
