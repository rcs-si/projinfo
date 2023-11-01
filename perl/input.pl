use strict;
use warnings;

# Check if there are command-line arguments
if (@ARGV) {
    my $first_arg = shift @ARGV;
    print "The first argument is: $first_arg\n";

    # Process other arguments
    foreach my $arg (@ARGV) {
        print "Additional argument: $arg\n";
    }
} else {
    print "No command-line arguments provided.\n";
}