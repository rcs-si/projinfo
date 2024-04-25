#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin;
use Getopt::Long qw(GetOptions :config auto_help);
use Pod::Usage;
use Data::Dumper;

# Import helper functions from helpers.pm (make sure this file exists)
require "helpers.pm";

# Initialize command line arguments
my $academic = 0;
my $user;
my $project;
my $lpi;
my $verbose = 0;

# Store the original number of command-line arguments
my $num_args = @ARGV;

# Parsing command line arguments
GetOptions(
    'a|academic' => \$academic, # '-a' or '-academic'
    'u|user=s' => \$user,
    'p|project=s' => \$project,
    'pi|lpi=s' => \$lpi,
    'v|verbose' => \$verbose,
) or die "Error in command line arguments\n";

# Check for file issues, assuming file_issues() is a function in Helpers.pm
if (Helpers::file_issues()) {
    print "The data file is empty\n";
    exit;
}

# No arguments provided, show help
if ($num_args == 0) {
    print "no arguments provided";
    pod2usage(-verbose => 1);
    exit;
}

# Process the academic flag
if ($academic) {
    print Helpers::academic();
    exit;
}

# Initialize a flag to check if the first argument has been processed
my $input1 = 1;

# Process other arguments
if ($project and $input1) {
    # print Helpers::proj($project);
    # $input1 = 0;
    
    my $project_info = Helpers::proj($project);  # Use the correct package name
    if (defined $project_info) {
        print "Project Information for '$project':\n$project_info\n";
    } else {
        print "No information found for project '$project'.\n";
    }
}
if ($user and $input1) {
    if ($verbose) {
        print Helpers::vuser_pis($user);
    } else {
        print Helpers::user_pis($user);
    }
}
if ($lpi and $input1) {
    if ($verbose) {
        print Helpers::vpi_projs($lpi);
    } else {
        print Helpers::pi_projs($lpi);
    }
}


__END__

=head1 NAME

projinfo.pl - Tool to return information about current projects and PIs.

=head1 SYNOPSIS

Usage: tool to return information about current projects and PIs

Options:

    -a, --academic        --academic    No input necessary, shows academic information.

    -u, --user=<name>     --user        User login name to get user-specific information.

    -p, --project=<name>  --project     Project name to get project-specific information.

    -pi, --lpi=<name>     --lpi         PI login name to get PI-specific information.

    -v, --verbose         --v           Add to -u or -p for additional information.

=head1 DESCRIPTION

This script provides information about projects, users, and PIs based on
the provided command-line options.

=cut