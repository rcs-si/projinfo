package Helpers;

use strict;
use warnings;
use Data::Dumper;

# Load CSV files and store their content in arrays
my @user_data = _load_csv("/projectnb/rcsmetrics/pidb/data/projuser.csv", 1); # consider first 3 cols only
my @pi_data = _load_csv("/projectnb/rcsmetrics/pidb/data/pidb.csv", 2);

# Load a CSV file and return an array of arrays
sub parse_csv_line {
    my $line = shift;
    my @fields;
    my $field = '';
    my $inside_quotes = 0;

    foreach my $char (split //, $line) {
        if ($char eq '"' && !$inside_quotes) {
            $inside_quotes = 1;
            next;
        } elsif ($char eq '"' && $inside_quotes) {
            $inside_quotes = 0;
            next;
        }
        if ($char eq ',' && !$inside_quotes) {
            push @fields, $field;
            $field = '';
        } else {
            $field .= $char;
        }
    }
    push @fields, $field;  # push the last field
    return @fields;
}

sub _load_csv {
    my ($filename, $num_columns) = @_;  # Filename and number of columns as arguments
    my @data;  # Array to hold all rows of the file

    open my $fh, '<', $filename or die "Could not open '$filename': $!";
    
    my $header_line = <$fh>;
    chomp $header_line;
    my @headers = split /,/, $header_line;
    s/^"|"$//g for @headers; # Strip quotes from headers right after splitting
    # print "@headers\n\n";
    # return;
    if ($num_columns == 2) {            #pi_data
        while (my $line = <$fh>) {
            chomp $line;
            my @fields = parse_csv_line($line);
            my %row;
            for (my $i = 0; $i < @fields; $i++) {
                $row{$headers[$i]} = $fields[$i] // '';  # Assign fields using their header names
            }
            # print Dumper(\%row);
            push @data, \%row;
        }
    }else {
        while (my $line = <$fh>) {
            chomp $line;
            my @fields = split /,/, $line;
            # Use only the first three fields to construct the row
            my %row = (
                proj => $fields[0] // '', # Using // operator to avoid undefined warnings
                user => $fields[1] // '',
                date => $fields[2] // '',
            );
            # Add only the subset of columns to @data
            push @data, \%row;
        }
    }

    close $fh;  # Close the file handle after reading all lines
    return @data;  # Return the array of data
}



sub file_issues {
    # Check if @user_data and @pi_data arrays are empty
    if (!@user_data || !@pi_data) {
        print "One or both of the data files are empty or could not be read.\n";
        return 1;  # Returns true indicating an issue
    }

    return 0;  # Returns false, indicating no issues
}

sub proj {
    my ($project) = @_;
    # print "Searching for project: $project\n";  # Debugging line
    # my $lines_to_print = 3;  # Number of lines to print
    # my $count = 0;  # Counter for printed lines

    # foreach my $row (@user_data) {
    #     last if $count >= $lines_to_print;  # Stop if we've printed 10 lines
    #     print join(',', @$row), "\n";  # Join the elements of the array ref and print
    #     $count++;  # Increment the counter
    # }
    
    my $project_exists = grep { $_->{'proj'} eq $project } @user_data;

    unless ($project_exists) {
        print "Could not find project. Available projects include:\n";
        print join(', ', map { $_->{'proj'} // 'undefined' } @user_data) . "\n";
        return "Invalid project name";
    }

    my $proj_info = proj_info($project);
    my $proj_users = proj_users($project);

    return "$proj_info\n\n$proj_users";
}

# Retrieve project information from @pi_data
sub proj_info {
    my ($project) = @_;
    my @info_lines;

    my @selected_cols = qw(group login alogin academic allocation dept center college);
    my %new_column_names = (
        group => 'Project',
        login => 'LPI',
        alogin => 'Admin',
        academic => 'academic', # If these fields don't need renaming, put their original names
        allocation => 'SU_Allocation',
        dept => 'dept',
        center => 'center',
        college => 'college'
        # Add any other new column names here as needed
    );

    # Initialize column widths based on the header names
    my %column_widths;
    for my $col (@selected_cols) {
        $column_widths{$col} = length($new_column_names{$col} // $col);
    }

    # Only one loop to process rows and format them
    foreach my $row (@pi_data) {
        next unless $row->{'group'} eq $project; # Skip rows that do not match the project

        my @row_content;
        for my $col (@selected_cols) {
            my $field = $row->{$col} // '';
            my $content_length = length($field);
            $column_widths{$col} = $content_length if $content_length > $column_widths{$col};
            push @row_content, $field; # Save the original content for later use
        }

        # Save the unformatted row for now
        push @info_lines, \@row_content;
    }

    # Now, adjust the headers based on the collected widths
    my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $new_column_names{$_} // $_) } @selected_cols);
    unshift @info_lines, $header_line; # Add headers at the beginning

    # Format the rows with the final column widths
    for my $i (1 .. $#info_lines) { # Start from 1 to skip the header
        $info_lines[$i] = join(' ', map { sprintf("%*s", $column_widths{$selected_cols[$_]}, $info_lines[$i]->[$_]) } 0 .. $#{$info_lines[$i]});
    }

    return join("\n", @info_lines);
}

# List user information for the given project from @user_data
sub proj_users {
    my ($project) = @_;
    my @user_lines;

    # Add the header first
    push @user_lines, "    user     date";

    # Define the width for the 'user' field based on the expected output
    my $user_field_width = 8;  # Adjust this value as needed to align with your data

    foreach my $row (@user_data) {
        if ($row->{'proj'} eq $project) {
            # Right-align 'user' within the specified field width
            # and left-align 'date' after that.
            my $line = sprintf("%${user_field_width}s %-10s", $row->{'user'}, $row->{'date'});
            push @user_lines, $line;
        }
    }

    return join("\n", @user_lines);
}

sub academic() {
    my @info_lines;

    my @selected_cols = qw(group title login alogin dept college);
    push @selected_cols, '#Users';
    my %new_column_names = (
        group => 'Project',
        title => 'title',
        login => 'LPI',
        alogin => 'Admin',
        dept => 'dept',
        college => 'campus'
    );

    my %column_widths;
    for my $col (@selected_cols) {
        $column_widths{$col} = length($new_column_names{$col} // $col);
    }

    # Only one loop to process rows and format them
    foreach my $row (@pi_data) {
        next unless $row->{'status'} eq 'active' && $row->{'academic'} eq 'course'; # Skip rows that do not match the project

        my @row_content;
        for my $col (@selected_cols) {
            if ($col eq '#Users') {
                # Call count_user() for this row's group to get user count
                my $user_count = count_user($row->{'group'}, @user_data);
                push @row_content, $user_count;
                next;
            }

            my $field = $row->{$col} // '';
            my $content_length = length($field);
            $column_widths{$col} = $content_length if $content_length > $column_widths{$col};
            push @row_content, $field; # Save the original content for later use
        }
        
        # Save the unformatted row for now
        push @info_lines, \@row_content;
    }

    # Now, adjust the headers based on the collected widths
    my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $new_column_names{$_} // $_) } @selected_cols);
    unshift @info_lines, $header_line; # Add headers at the beginning

    # Format the rows with the final column widths
    for my $i (1 .. $#info_lines) { # Start from 1 to skip the header
        $info_lines[$i] = join(' ', map { sprintf("%*s", $column_widths{$selected_cols[$_]}, $info_lines[$i]->[$_]) } 0 .. $#{$info_lines[$i]});
    }

    return join("\n", @info_lines, "\n");
}

sub count_user {
    my ($project, @user_data) = @_;
    my $count = 0;

    foreach my $row (@user_data) {
        if ($row->{'proj'} eq $project) {
            $count++;
        }
    }

    return $count;
}

sub user_pis() {
    my ($user) = @_;
    my $user_proj;
    my @info_lines;

    foreach my $row (@user_data) {
        if ($row->{'user'} eq $user) {
            $user_proj = $row->{'proj'};
            last;
        }
    }
    if (!defined($user_proj)){
        return;  # Returns from the function if $user_proj is undefined
    }

    my @selected_cols = qw(group login alogin);
    my %new_column_names = (
        group => 'Project',
        login => 'LPI',
        alogin => 'Admin'
    );

    # Initialize column widths based on the header names
    my %column_widths;
    for my $col (@selected_cols) {
        $column_widths{$col} = length($new_column_names{$col} // $col);
    }

    # Only one loop to process rows and format them
    foreach my $row (@pi_data) {
        next unless $row->{'group'} eq $user_proj; # Skip rows that do not match the project

        my @row_content;
        for my $col (@selected_cols) {
            my $field = $row->{$col} // '';
            my $content_length = length($field);
            $column_widths{$col} = $content_length if $content_length > $column_widths{$col};
            push @row_content, $field; # Save the original content for later use
        }

        # Save the unformatted row for now
        push @info_lines, \@row_content;
    }

    # Now, adjust the headers based on the collected widths
    my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $new_column_names{$_} // $_) } @selected_cols);
    unshift @info_lines, $header_line; # Add headers at the beginning

    # Format the rows with the final column widths
    for my $i (1 .. $#info_lines) { # Start from 1 to skip the header
        $info_lines[$i] = join(' ', map { sprintf("%*s", $column_widths{$selected_cols[$_]}, $info_lines[$i]->[$_]) } 0 .. $#{$info_lines[$i]});
    }

    return join("\n", @info_lines, "\n");
}

sub vuser_pis() {
    my ($user) = @_;
    my $user_proj;
    my @info_lines;

    foreach my $row (@user_data) {
        if ($row->{'user'} eq $user) {
            $user_proj = $row->{'proj'};
            last;
        }
    }
    if (!defined($user_proj)){
        return;  # Returns from the function if $user_proj is undefined
    }

    my @selected_cols = qw(group login alogin academic allocation dept center college);
    my %new_column_names = (
        group => 'Project',
        login => 'LPI',
        alogin => 'Admin',
        allocation => 'SU_Allocation'
    );

    # Initialize column widths based on the header names
    my %column_widths;
    for my $col (@selected_cols) {
        $column_widths{$col} = length($new_column_names{$col} // $col);
    }

    # Only one loop to process rows and format them
    foreach my $row (@pi_data) {
        next unless $row->{'group'} eq $user_proj; # Skip rows that do not match the project

        my @row_content;
        for my $col (@selected_cols) {
            my $field = $row->{$col} // '';
            my $content_length = length($field);
            $column_widths{$col} = $content_length if $content_length > $column_widths{$col};
            push @row_content, $field; # Save the original content for later use
        }

        # Save the unformatted row for now
        push @info_lines, \@row_content;
    }

    # Now, adjust the headers based on the collected widths
    my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $new_column_names{$_} // $_) } @selected_cols);
    unshift @info_lines, $header_line; # Add headers at the beginning

    # Format the rows with the final column widths
    for my $i (1 .. $#info_lines) { # Start from 1 to skip the header
        $info_lines[$i] = join(' ', map { sprintf("%*s", $column_widths{$selected_cols[$_]}, $info_lines[$i]->[$_]) } 0 .. $#{$info_lines[$i]});
    }

    return join("\n", @info_lines, "\n");
}

sub pi_projs() {
    my ($lpi) = @_;
    my @user_projs;

    foreach my $row (@pi_data) {
        if ($row->{'login'} eq $lpi) {
            $row->{'PI/Admin?'} = "PI";
            push @user_projs, $row;
        }
        elsif ($row->{'alogin'} eq $lpi) {
            $row->{'PI/Admin?'} = "Admin";
            push @user_projs, $row;
        }
    }
    
    if (scalar @user_projs == 0) {
        my $user_exists = 0;
        foreach my $user (@user_data) {
            if ($user->{'user'} eq $lpi) {
                $user_exists = 1;
                last;
            }
        }

        if ($user_exists) {
            return "This user is not a PI\n";
        } else {
            return "Invalid user name\n";
        }
    }
    # Selected column names
    my @selected_cols = qw(group title PI/Admin?);
    # Initialize column widths based on the header names and the data
    my %column_widths;
    for my $col (@selected_cols) {
        $column_widths{$col} = length($col);
        foreach my $row (@user_projs) {
            my $field_length = length($row->{$col});
            if ($field_length > $column_widths{$col}) {
                $column_widths{$col} = $field_length;
            }
        }
    }

    # Format the header line, change the "%*s" to "%-*s" to format words start from left.
    my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $_) } @selected_cols);
    
    # Format the rows
    my @formatted_rows;
    foreach my $row (@user_projs) {
        my $formatted_row = join(' ', map { sprintf("%*s", $column_widths{$_}, $row->{$_}) } @selected_cols);
        push @formatted_rows, $formatted_row;
    }

    # Combine header and rows
    return $header_line . "\n" . join("\n", @formatted_rows) . "\n";
}

sub vpi_projs() {
    my ($lpi) = @_;
    my @user_projs;

    foreach my $row (@pi_data) {
        if ($row->{'login'} eq $lpi) {
            $row->{'PI/Admin?'} = "PI";
            $row->{'#Users'} = count_user($row->{'group'}, @user_data);
            push @user_projs, $row;
        }
        elsif ($row->{'alogin'} eq $lpi) {
            $row->{'PI/Admin?'} = "Admin";
            $row->{'#Users'} = count_user($row->{'group'}, @user_data);
            push @user_projs, $row;
        }
    }
    
    if (scalar @user_projs == 0) {
        my $user_exists = 0;
        foreach my $user (@user_data) {
            if ($user->{'user'} eq $lpi) {
                $user_exists = 1;
                last;
            }
        }

        if ($user_exists) {
            return "This user is not a PI\n";
        } else {
            return "Invalid user name\n";
        }
    }
    # Selected column names
    # my @selected_cols = qw(group title PI/Admin? dept campus #Users);
    my @selected_cols = ("group", "title", "PI/Admin?", "dept", "campus", "#Users");
    # Initialize column widths based on the header names and the data
    my %column_widths;
    for my $col (@selected_cols) {
        $column_widths{$col} = length($col);
        foreach my $row (@user_projs) {
            my $field_length = length($row->{$col});
            if ($field_length > $column_widths{$col}) {
                $column_widths{$col} = $field_length;
            }
        }
    }

    # Format the header line, change the "%*s" to "%-*s" to format words start from left.
    my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $_) } @selected_cols);
    
    # Format the rows
    my @formatted_rows;
    foreach my $row (@user_projs) {
        my $formatted_row = join(' ', map { sprintf("%*s", $column_widths{$_}, $row->{$_}) } @selected_cols);
        push @formatted_rows, $formatted_row;
    }

    # Combine header and rows
    return $header_line . "\n" . join("\n", @formatted_rows) . "\n";
}



1; # End of Helpers package
