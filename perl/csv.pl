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
open(M, $user_df) or die "can't open $user_df: $!";
while (my $line = <M>) {
    chomp $line;
    next if /^$hash/;
    #next if /^\s*$/;

    my ($group, $username, $date) = split(',', $line);

    $user_data{$username}->{group} = $group;
    $user_data{$username}->{date} = $date;
}
close(M);


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

    $pi_data{$login}->{group} = $group;
    $pi_data{$login}->{title} = $title;
    $pi_data{$login}->{pi} = $pi;
    $pi_data{$login}->{email} = $email;
    $pi_data{$login}->{dept} = $dept;
    $pi_data{$login}->{center} = $center;
    $pi_data{$login}->{college} = $college;
    $pi_data{$login}->{campus} = $campus;
    $pi_data{$login}->{date} = $date;
    $pi_data{$login}->{start} = $start;
    $pi_data{$login}->{end} = $end;
    $pi_data{$login}->{type} = $type;
    $pi_data{$login}->{academic} = $academic;
    $pi_data{$login}->{coursehistory} = $coursehistory;
    $pi_data{$login}->{status} = $status;
    $pi_data{$login}->{aname} = $aname;
    $pi_data{$login}->{alogin} = $alogin;
    $pi_data{$login}->{dataarchive} = $dataarchive;
    $pi_data{$login}->{quota} = $quota;
    $pi_data{$login}->{allocation} = $allocation;
    $pi_data{$login}->{last_approved_allocation} = $last_approved_allocation;
    $pi_data{$login}->{duorequired} = $duorequired;
}
close(N);

foreach my $username (keys %user_data) {
    print "Username: $username\n";
    print "Group: $user_data{$username}->{group}\n";
    print "Date: $user_data{$username}->{date}\n";
    print "\n";
}

foreach my $login (keys %pi_data) {
    print "Login: $login\n";
    print "Group: $pi_data{$login}->{group}\n";
    print "Title: $pi_data{$login}->{title}\n";
    print "\n";
}