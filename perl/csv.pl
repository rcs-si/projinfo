use strict;
my $hash = "#";
my $user_df = "/projectnb/rcsmetrics/pidb/data/projuser.csv";
my $pi_df = "/projectnb/rcsmetrics/pidb/data/pidb.csv";
my %user_data = ();
my %pi_data = ();
my $csv = 0;
if ($ARGV[0] eq "-csv") {
    $csv =1;
}
my %properties = ();
my $host = "";


my $index = 0;
open(M, $user_df) or die "can't open $user_df: $!";
while (my $line = <M>) {
    chomp $line;
    next if /^$hash/;
    #next if /^\s*$/;

    my ($group, $username, $date) = split(',', $line);

    $user_data{$index}->{username} = $username;    
    $user_data{$index}->{group} = $group;
    $user_data{$index}->{date} = $date;
    $index++;
}
close(M);

my $index = 0;
open(N, $pi_df) or die "can't open $pi_df: $!";
while (my $line = <N>) {
    chomp $line;
    next if /^$hash/;
    #next if /^\s*$/;

my (
        $group, $title, $pi, $login, $email, $dept, $center, $college, $campus,
        $date, $start, $end, $type, $academic, $coursehistory, $status, $aname,
        $alogin, $dataarchive, $quota, $allocation, $last_approved_allocation, $duorequired
    ) = split(',', $line);

    $pi_data{$index}->{login} = $login;
    $pi_data{$index}->{group} = $group;
    $pi_data{$index}->{title} = $title;
    $pi_data{$index}->{pi} = $pi;
    $pi_data{$index}->{email} = $email;
    $pi_data{$index}->{dept} = $dept;
    $pi_data{$index}->{center} = $center;
    $pi_data{$index}->{college} = $college;
    $pi_data{$index}->{campus} = $campus;
    $pi_data{$index}->{date} = $date;
    $pi_data{$index}->{start} = $start;
    $pi_data{$index}->{end} = $end;
    $pi_data{$index}->{type} = $type;
    $pi_data{$index}->{academic} = $academic;
    $pi_data{$index}->{coursehistory} = $coursehistory;
    $pi_data{$index}->{status} = $status;
    $pi_data{$index}->{aname} = $aname;
    $pi_data{$index}->{alogin} = $alogin;
    $pi_data{$index}->{dataarchive} = $dataarchive;
    $pi_data{$index}->{quota} = $quota;
    $pi_data{$index}->{allocation} = $allocation;
    $pi_data{$index}->{last_approved_allocation} = $last_approved_allocation;
    $pi_data{$index}->{duorequired} = $duorequired;

    $index++;
}
close(N);

#test print user csv
=begin
foreach my $index (keys %user_data) {
    print "Username: $user_data{$index}->{username}\n";
    print "Group: $user_data{$index}->{group}\n";
    print "Date: $user_data{$index}->{date}\n";
    print "\n";
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
    my ($username, %hash) = @_;
    my %filtered_data;

    foreach my $key (keys %hash) {
        #print"$hash{$key}\n";
        if ($hash{$key}->{username} eq $username) {
            $filtered_data{$key} = $hash{$key};
            #print$key;
        }
    }

    foreach my $key (keys %filtered_data) {
        #print "Username: $filtered_result{$key}->{username}\n";
        print "Group: $filtered_data{$key}->{group}\n";
        print "Date: $filtered_data{$key}->{date}\n";
        print "\n";
    }


    return %filtered_data;
}

sub academic {
    my $active_string = "active";
    my %filtered_academic;
    foreach my $key (keys %pi_data) {
        my $academic_status = $pi_data{$key}->{academic};
        #print"$academic_status\n";
        if ($academic_status eq "active") {
            print"hi\n";
            $filtered_academic{$key} = $pi_data{$key};
        }
    }

    foreach my $key (keys %filtered_academic) {
        print "Group: $filtered_academic{$key}->{group}\n";
        print "Date: $filtered_academic{$key}->{date}\n";
    }

}

my %academic = academic();












#testing region
=begin
my $input_username = 'tinglliu';
my %filtered_result = user_proj($input_username, %user_data);

print"$input_username \n";
foreach my $key (keys %filtered_result) {
    #print "Username: $filtered_result{$key}->{username}\n";
    print "Group: $filtered_result{$key}->{group}\n";
    print "Data: $filtered_result{$key}->{date}\n";
    print "\n";
}
=cut