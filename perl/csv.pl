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

#test print user csv
=begin
foreach my $index (keys %user_data) {
    print "Username: $user_data{$index}->{username}\n";
    print "Group: $user_data{$index}->{group}\n";
    print "Date: $user_data{$index}->{date}\n";
    print "\n";
}


#test print pi csv
foreach my $login (keys %pi_data) {
    print "Login: $login\n";
    print "Group: $pi_data{$login}->{group}\n";
    print "Title: $pi_data{$login}->{title}\n";
    print "\n";
}
=cut

=begin
#function to return values given username
sub user_info {
    my ($username, %hash) = @_;
    my %filtered_data;


    #foreach my $username (keys %user_data)
    foreach my $key (keys %hash) {
        #print"$hash{$key}\n";
        #if ($hash{$key}->{username} eq $username) {
        if ($key eq $username) {
            $filtered_data{$key} = $hash{$key};
            #print$key;
        }
    }

    return %filtered_data;
}
=cut


sub user_info {
    my ($username, %hash) = @_;
    my %filtered_data;

    foreach my $key (keys %hash) {
        #print"$hash{$key}\n";
        if ($hash{$key}->{username} eq $username) {
            $filtered_data{$key} = $hash{$key};
            #print$key;
        }
    }

    return %filtered_data;
}


my $input_username = 'ktrn';
my %filtered_result = user_info($input_username, %user_data);

print"$input_username \n";
foreach my $key (keys %filtered_result) {
    #print "Username: $filtered_result{$key}->{username}\n";
    print "Group: $filtered_result{$key}->{group}\n";
    print "Title: $filtered_result{$key}->{date}\n";
    print "\n";
}
