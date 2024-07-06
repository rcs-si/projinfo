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

sub user_pis {
    my ($user) = @_;
    my @user_projs;
    my @info_lines;

    # Collect all projects associated with the user
    foreach my $row (@user_data) {
        if ($row->{'user'} eq $user) {
            push @user_projs, $row->{'proj'};
        }
    }

    # Handle case where no projects are found for the user
    return "No projects found for user $user\n" unless @user_projs;

    # Columns to be displayed with their new headings
    my @selected_cols = qw(group login alogin);
    my %new_column_names = (
        group => 'Project',
        login => 'LPI',
        alogin => 'Admin'
    );

    # Initialize column widths to the length of the new headings
    my %column_widths;
    foreach my $col (@selected_cols) {
        $column_widths{$col} = length($new_column_names{$col} // $col);
    }

    # Gather data matching any user projects
    my @filtered_rows;
    foreach my $row (@pi_data) {
        next unless grep { $_ eq $row->{'group'} } @user_projs;
        push @filtered_rows, $row;
    }

    # Sort the filtered rows alphabetically by the project name
    @filtered_rows = sort { $a->{'group'} cmp $b->{'group'} } @filtered_rows;

    # Process the sorted rows
    foreach my $row (@filtered_rows) {
        my @row_content;
        foreach my $col (@selected_cols) {
            my $field = $row->{$col} // '';
            my $content_length = length($field);
            $column_widths{$col} = $content_length if $content_length > $column_widths{$col};
            push @row_content, $field;
        }

        # Store the unformatted row content temporarily
        push @info_lines, \@row_content;
    }

    # Prepare the header with left-aligned column names
    my $header_line = join(' ', map { sprintf("%-*s", $column_widths{$_}, $new_column_names{$_} // $_) } @selected_cols);
    unshift @info_lines, $header_line;  # Add the formatted header at the beginning

    # Format each data row according to final column widths
    for my $i (1 .. $#info_lines) {  # Start from index 1 to skip the header
        $info_lines[$i] = join(' ', map { sprintf("%-*s", $column_widths{$selected_cols[$_]}, $info_lines[$i]->[$_]) } 0 .. $#{$info_lines[$i]});
    }

    # Combine the header and formatted rows into a single string output
    return join("\n", @info_lines, "");  # Add an extra newline for separation
}



# sub vuser_pis() {
#     my ($user) = @_;
#     my $user_proj;
#     my @info_lines;

#     foreach my $row (@user_data) {
#         if ($row->{'user'} eq $user) {
#             $user_proj = $row->{'proj'};
#             last;
#         }
#     }
#     if (!defined($user_proj)){
#         return;  # Returns from the function if $user_proj is undefined
#     }

#     my @selected_cols = qw(group login alogin academic allocation dept center college);
#     my %new_column_names = (
#         group => 'Project',
#         login => 'LPI',
#         alogin => 'Admin',
#         allocation => 'SU_Allocation'
#     );

#     # Initialize column widths based on the header names
#     my %column_widths;
#     for my $col (@selected_cols) {
#         $column_widths{$col} = length($new_column_names{$col} // $col);
#     }

#     # Only one loop to process rows and format them
#     foreach my $row (@pi_data) {
#         next unless $row->{'group'} eq $user_proj; # Skip rows that do not match the project

#         my @row_content;
#         for my $col (@selected_cols) {
#             my $field = $row->{$col} // '';
#             my $content_length = length($field);
#             $column_widths{$col} = $content_length if $content_length > $column_widths{$col};
#             push @row_content, $field; # Save the original content for later use
#         }

#         # Save the unformatted row for now
#         push @info_lines, \@row_content;
#     }

#     # Now, adjust the headers based on the collected widths
#     my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $new_column_names{$_} // $_) } @selected_cols);
#     unshift @info_lines, $header_line; # Add headers at the beginning

#     # Format the rows with the final column widths
#     for my $i (1 .. $#info_lines) { # Start from 1 to skip the header
#         $info_lines[$i] = join(' ', map { sprintf("%*s", $column_widths{$selected_cols[$_]}, $info_lines[$i]->[$_]) } 0 .. $#{$info_lines[$i]});
#     }

#     return join("\n", @info_lines, "\n");
# }
sub vuser_pis {
    my ($user) = @_;
    my @user_projs;
    my @info_lines;

    # Collect all projects associated with the user
    foreach my $row (@user_data) {
        if ($row->{'user'} eq $user) {
            push @user_projs, $row->{'proj'};
        }
    }

    # Exit if user has no projects
    return "No project found for user $user\n" unless @user_projs;

    # Define columns to display and their new names
    my @selected_cols = qw(group login alogin academic allocation dept center college);
    my %new_column_names = (
        group => 'Project',
        login => 'LPI',
        alogin => 'Admin',
        allocation => 'SU_Allocation'
    );

    # Initialize column widths
    my %column_widths;
    for my $col (@selected_cols) {
        $column_widths{$col} = length($new_column_names{$col} // $col);
    }

    # Gather data matching any of the user's projects
    my @filtered_rows;
    foreach my $row (@pi_data) {
        next unless grep { $_ eq $row->{'group'} } @user_projs;
        push @filtered_rows, $row;
    }

    # Sort the filtered rows alphabetically by the project name
    @filtered_rows = sort { $a->{'group'} cmp $b->{'group'} } @filtered_rows;

    # Process the sorted rows
    foreach my $row (@filtered_rows) {
        my @row_content;
        for my $col (@selected_cols) {
            my $field = $row->{$col} // '';
            my $content_length = length($field);
            $column_widths{$col} = $content_length if $content_length > $column_widths{$col};
            push @row_content, $field;  # Save field data
        }
        push @info_lines, \@row_content;  # Save row data
    }

    # Format headers and rows for output
    my $header_line = join(' ', map { sprintf("%-*s", $column_widths{$_}, $new_column_names{$_} // $_) } @selected_cols);
    unshift @info_lines, $header_line;  # Insert header at the beginning

    # Format each data row according to column widths
    for my $i (1 .. $#info_lines) {  # Skip header at index 0
        $info_lines[$i] = join(' ', map { sprintf("%-*s", $column_widths{$selected_cols[$_]}, $info_lines[$i]->[$_]) } 0 .. $#{$info_lines[$i]});
    }

    return join("\n", @info_lines, "");  # Add newline for each row, including final one
}


# sub pi_projs() {
#     my ($lpi) = @_;
#     my @user_projs;

#     foreach my $row (@pi_data) {
#         if ($row->{'login'} eq $lpi) {
#             $row->{'PI/Admin?'} = "PI";
#             push @user_projs, $row;
#         }
#         elsif ($row->{'alogin'} eq $lpi) {
#             $row->{'PI/Admin?'} = "Admin";
#             push @user_projs, $row;
#         }
#     }
    
#     if (scalar @user_projs == 0) {
#         my $user_exists = 0;
#         foreach my $user (@user_data) {
#             if ($user->{'user'} eq $lpi) {
#                 $user_exists = 1;
#                 last;
#             }
#         }

#         if ($user_exists) {
#             return "This user is not a PI\n";
#         } else {
#             return "Invalid user name\n";
#         }
#     }
#     # Selected column names
#     my @selected_cols = qw(group title PI/Admin?);
#     # Initialize column widths based on the header names and the data
#     my %column_widths;
#     for my $col (@selected_cols) {
#         $column_widths{$col} = length($col);
#         foreach my $row (@user_projs) {
#             my $field_length = length($row->{$col});
#             if ($field_length > $column_widths{$col}) {
#                 $column_widths{$col} = $field_length;
#             }
#         }
#     }

#     # Format the header line, change the "%*s" to "%-*s" to format words start from left.
#     my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $_) } @selected_cols);
    
#     # Format the rows
#     my @formatted_rows;
#     foreach my $row (@user_projs) {
#         my $formatted_row = join(' ', map { sprintf("%*s", $column_widths{$_}, $row->{$_}) } @selected_cols);
#         push @formatted_rows, $formatted_row;
#     }

#     # Combine header and rows
#     return $header_line . "\n" . join("\n", @formatted_rows) . "\n";
# }
sub pi_projs {
    my ($lpi) = @_;
    my @user_projs;

    # Check if user exists in the user data
    my $user_exists = grep { $_->{'user'} eq $lpi } @user_data;
    return "Invalid user name\n" unless $user_exists;

    # Populate user projects based on login and admin login
    foreach my $row (@pi_data) {
        if ($row->{'login'} eq $lpi or $row->{'alogin'} eq $lpi) {
            $row->{'PI/Admin?'} = $row->{'login'} eq $lpi ? "PI" : "Admin";
            push @user_projs, $row;
        }
    }
    
    # Check if there are any projects associated with the user
    return "This user is not a PI\n" if scalar @user_projs == 0;

    # Columns to display
    my @selected_cols = qw(group title PI/Admin?);

    # Calculate maximum width for each column
    my %column_widths;
    foreach my $col (@selected_cols) {
        my $max_width = length($col);
        foreach my $row (@user_projs) {
            $max_width = length($row->{$col}) > $max_width ? length($row->{$col}) : $max_width;
        }
        $column_widths{$col} = $max_width;
    }

    # Format the header line to be left-aligned
    my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $_) } @selected_cols);
    
    # Format each row of project data
    my @formatted_rows = map {
        my $row = $_;
        join(' ', map { sprintf("%*s", $column_widths{$_}, $row->{$_}) } @selected_cols)
    } @user_projs;

    # Combine header and rows into a single string to return
    return $header_line . "\n" . join("\n", @formatted_rows) . "\n";
}


sub vpi_projs() {
    my ($lpi) = @_;
    my @user_projs;

    # Check user existence
    my $user_exists = grep { $_->{'user'} eq $lpi } @user_data;

    # If user doesn't exist, skip processing
    return "Invalid user name\n" unless $user_exists;

    # Process projects
    foreach my $row (@pi_data) {
        if ($row->{'login'} eq $lpi or $row->{'alogin'} eq $lpi) {
            $row->{'PI/Admin?'} = $row->{'login'} eq $lpi ? "PI" : "Admin";
            $row->{'#Users'} = count_user($row->{'group'}, @user_data);
            push @user_projs, $row;
        }
    }

    # Handle case with no projects
    return "This user is not a PI\n" if scalar @user_projs == 0;

    # Column headers and width calculation
    my @selected_cols = ("group", "title", "PI/Admin?", "dept", "campus", "#Users");
    my %column_widths = map { $_ => length($_) } @selected_cols;
    foreach my $row (@user_projs) {
        foreach my $col (@selected_cols) {
            my $field_length = length($row->{$col});
            $column_widths{$col} = $field_length if $field_length > $column_widths{$col};
        }
    }

    # Formatting headers and rows
    # Format the header line, change the "%*s" to "%-*s" to format words start from left.
    my $header_line = join(' ', map { sprintf("%*s", $column_widths{$_}, $_) } @selected_cols);
    my @formatted_rows = map {
        my $row = $_;
        join(' ', map { sprintf("%*s", $column_widths{$_}, $row->{$_}) } @selected_cols)
    } @user_projs;

    # Output combined header and rows
    return $header_line . "\n" . join("\n", @formatted_rows) . "\n";
}



1; # End of Helpers package
