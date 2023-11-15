use strict;
my $hash = "#";
my $user_df = "/projectnb/rcsmetrics/pidb/data/projuser.csv";
my $pi_df = "/projectnb/rcsmetrics/pidb/data/pidb.csv";
my %pi_data = ();
my $csv = 0;
if ($ARGV[0] eq "-csv") {
    $csv =1;
}
my %properties = ();
my $host = "";

my %user_hash;
my %group_hash;

open(M, $user_df) or die "can't open $user_df: $!";
while (my $line = <M>) {
    chomp $line;
    next if $line =~ /^$hash/;  # Skip lines starting with the specified hash pattern
    next if $line =~ /^\s*$/;   # Skip empty lines

    my ($group, $username, $date) = split(',', $line);

    # For user_hash, store groups and dates in a nested hash
    if (!exists $user_hash{$username}) {
        $user_hash{$username} = {};
    }
    $user_hash{$username}{$group} = $date;

    # For group_hash, store usernames and dates in a nested hash
    if (!exists $group_hash{$group}) {
        $group_hash{$group} = {};
    }
    $group_hash{$group}{$username} = $date;
}
close(M);


open(N, $pi_df) or die "can't open $pi_df: $!";
while (my $line = <N>) {
    chomp $line;
    next if $line =~ /^$hash/;  # Skip lines starting with the specified hash pattern
    next if $line =~ /^\s*$/;   # Skip empty lines

    my (
        $group, $title, $pi, $login, $email, $dept, $center, $college, $campus,
        $date, $start, $end, $type, $academic, $coursehistory, $status, $aname,
        $alogin, $dataarchive, $quota, $allocation, $last_approved_allocation, $duorequired
    ) = split(',', $line);

    # Create a hash for each title and store all data in it
    $pi_data{$title} = {
        group => $group,
        pi => $pi,
        login => $login,
        email => $email,
        dept => $dept,
        center => $center,
        college => $college,
        campus => $campus,
        date => $date,
        start => $start,
        end => $end,
        type => $type,
        academic => $academic,
        coursehistory => $coursehistory,
        status => $status,
        aname => $aname,
        alogin => $alogin,
        dataarchive => $dataarchive,
        quota => $quota,
        allocation => $allocation,
        last_approved_allocation => $last_approved_allocation,
        duorequired => $duorequired
    };
}
close(N);

#test print user csv

foreach my $username (keys %user_hash) {
    print "Username: $username\n";
    foreach my $group (keys %{ $user_hash{$username} }) {
        my $date = $user_hash{$username}{$group};
        print "\tGroup: $group, Date: $date\n";
    }
    print "\n";  # Just for better readability
}

=begin
foreach my $group (keys %group_hash) {
    print "Group: $group\n";
    foreach my $username (keys %{ $group_hash{$group} }) {
        my $date = $group_hash{$group}{$username};
        print "\tUsername: $username, Date: $date\n";
    }
    print "\n";  # Just for better readability
}



#test print pi csv
foreach my $index (keys %pi_data) {
    print "Login: $pi_data{$index}->{login}\n";
    print "Group: $pi_data{$index}->{group}\n";
    print "Title: $pi_data{$index}->{title}\n";
    print "Academic: $pi_data{$index}->{academic}\n";
    #print "Status: $pi_data{$index}->{status}\n";
    print "\n";
}
=cut

sub user_proj { #given username, returns the projects that user is in
    my ($username) = @_;

    foreach my $group (keys %{ $user_hash{$username} }) {
        my $date = $user_hash{$username}{$group};
        print "\tGroup: $group, Date: $date\n";
    }


    return $user_hash{$username}
}

sub project { #given project name, return info
    my ($projname) = @_;
    my %filtered_project;
    foreach my $key (keys %pi_data) {
        if ($pi_data{$key}->{title} eq $projname) {
            $filtered_project{$key} = $pi_data{key};
        }
    }

    foreach my $key (keys %filtered_project) {

    }

}


#'group', 'title', 'login', 'alogin', 'dept', 'campus'

sub academic {
    my $active_string = "\"active\"";
    my %filtered_academic;
    foreach my $key (keys %pi_data) {
        my $academic_status = $pi_data{$key}->{academic};
        if ($academic_status eq $active_string) {
            $filtered_academic{$key} = $pi_data{$key};
        }
    }
=begin
    foreach my $key (keys %filtered_academic) {
        print "Group: $filtered_academic{$key}->{group}\n";
        print "Title: $filtered_academic{$key}->{title}\n";
        print "Login: $filtered_academic{$key}->{login}\n";
        print "ALogin: $filtered_academic{$key}->{alogin}\n";
        print "Dept: $filtered_academic{$key}->{dept}\n";
        print "Campus: $filtered_academic{$key}->{campus}\n";
        print"\n";
    }
=cut
    return %filtered_academic;
}


my %academic = academic();












#testing region

my $input_username = 'tinglliu';
my %filtered_result = user_proj($input_username);

print"$input_username \n";
foreach my $key (keys %filtered_result) {
    #print "Username: $filtered_result{$key}->{username}\n";
    print "Group: $filtered_result{$key}->{group}\n";
    print "Data: $filtered_result{$key}->{date}\n";
    print "\n";
}
