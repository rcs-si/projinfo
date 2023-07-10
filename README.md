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
- current status
    works as a python script, working on turning it into a command line tool
    get more detailed instruction from apps team!
